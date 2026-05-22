import 'dart:convert';
import 'dart:developer' as dev;
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../../../core/config/app_config.dart';
import '../../../core/error/exceptions.dart';

const _baseUrl = 'https://generativelanguage.googleapis.com';
const _uploadUrl = '$_baseUrl/upload/v1beta/files';
const _pdfMime = 'application/pdf';

const _pdfAssets = [
  'assets/docs/COMPLEMENTARIA_6_MESES.pdf',
  'assets/docs/MIS_PRIMERAS_COMIDAS.pdf',
  'assets/docs/la_comida_del_bebe_recetas_y_recomendaciones.pdf',
  'assets/docs/libro_recetas_para_bebes.pdf',
  'assets/docs/cocino_para_mi_bebe_y_toda_la_familia.pdf',
];

class GeminiService {
  final Dio _dio;
  final List<String> _keys;
  int _keyIndex = 0;

  GeminiService()
      : _dio = Dio(BaseOptions(receiveTimeout: const Duration(minutes: 5))),
        _keys = AppConfig.geminiApiKeys {
    if (_keys.isEmpty) throw AiException('No Gemini API keys en .env');
  }

  String get _key => _keys[_keyIndex];

  void _rotate() {
    _keyIndex = (_keyIndex + 1) % _keys.length;
    dev.log('[Gemini] Rotando a key $_keyIndex');
  }

  // ─── Upload ───────────────────────────────────────────────────────────────

  Future<List<String>> uploadAllPdfs() async {
    final uris = <String>[];
    for (final asset in _pdfAssets) {
      final displayName = asset.split('/').last;
      dev.log('[Gemini] Subiendo $displayName...');
      final uri = await _uploadPdf(asset, displayName);
      dev.log('[Gemini] Subido: $uri');
      await _waitUntilActive(uri);
      uris.add(uri);
    }
    return uris;
  }

  Future<String> _uploadPdf(String assetPath, String displayName) async {
    final byteData = await rootBundle.load(assetPath);
    final bytes = byteData.buffer.asUint8List();

    // Step 1: initiate resumable upload
    String uploadEndpoint = '';
    for (var attempt = 0; attempt < _keys.length; attempt++) {
      try {
        final initRes = await _dio.post(
          _uploadUrl,
          queryParameters: {'key': _key},
          options: Options(
            headers: {
              'X-Goog-Upload-Protocol': 'resumable',
              'X-Goog-Upload-Command': 'start',
              'X-Goog-Upload-Header-Content-Length': '${bytes.length}',
              'X-Goog-Upload-Header-Content-Type': _pdfMime,
              'Content-Type': 'application/json',
            },
            responseType: ResponseType.bytes,
          ),
          data: jsonEncode({'file': {'display_name': displayName}}),
        );
        uploadEndpoint = initRes.headers.value('x-goog-upload-url') ?? '';
        if (uploadEndpoint.isNotEmpty) break;
      } on DioException catch (e) {
        final status = e.response?.statusCode;
        if (status == 429) {
          _rotate();
          continue;
        }
        throw FileUploadException('Init upload falló ($status): ${e.message}');
      }
    }

    if (uploadEndpoint.isEmpty) throw const QuotaExhaustedException();

    // Step 2: upload raw bytes
    final uploadRes = await _dio.put(
      uploadEndpoint,
      data: bytes,
      options: Options(
        contentType: _pdfMime,
        headers: {
          'Content-Length': '${bytes.length}',
          'X-Goog-Upload-Offset': '0',
          'X-Goog-Upload-Command': 'upload, finalize',
        },
        sendTimeout: const Duration(minutes: 5),
      ),
    );

    final fileData = uploadRes.data as Map<String, dynamic>;
    final fileUri = fileData['file']?['uri'] as String?;
    if (fileUri == null || fileUri.isEmpty) {
      throw FileUploadException('URI vacío en respuesta: $fileData');
    }
    return fileUri;
  }

  // Poll until Gemini marks the file as ACTIVE (PDFs need processing time)
  Future<void> _waitUntilActive(String fileUri) async {
    final filePath = Uri.parse(fileUri).path; // e.g. /v1beta/files/abc123
    final endpoint = '$_baseUrl$filePath';

    for (var i = 0; i < 30; i++) {
      await Future<void>.delayed(const Duration(seconds: 3));
      try {
        final res = await _dio.get(
          endpoint,
          queryParameters: {'key': _key},
        );
        final state = (res.data as Map<String, dynamic>)['state'] as String?;
        dev.log('[Gemini] File state: $state ($fileUri)');
        if (state == 'ACTIVE') return;
        if (state == 'FAILED') throw FileUploadException('File processing FAILED: $fileUri');
      } on DioException catch (e) {
        dev.log('[Gemini] Poll error: ${e.message}');
      }
    }
    throw FileUploadException('Timeout esperando que el archivo quede ACTIVE');
  }

  // ─── Generation ──────────────────────────────────────────────────────────

  Future<String> generateContent(
    String prompt,
    List<String> fileUris,
  ) async {
    for (var attempt = 0; attempt < _keys.length; attempt++) {
      try {
        final model = GenerativeModel(
          model: AppConfig.geminiModel,
          apiKey: _key,
        );

        final parts = <Part>[TextPart(prompt)];
        for (final uri in fileUris) {
          parts.add(FilePart(Uri.parse(uri)));
        }

        dev.log('[Gemini] generateContent con ${fileUris.length} archivos, key $_keyIndex');
        final response = await model.generateContent([Content.multi(parts)]);
        final text = response.text ?? '';
        dev.log('[Gemini] Respuesta (${text.length} chars)');
        return text;
      } on GenerativeAIException catch (e) {
        dev.log('[Gemini] Error: ${e.message}');
        final msg = e.message.toLowerCase();
        final isQuotaError = msg.contains('429') ||
            msg.contains('quota') ||
            msg.contains('rate') ||
            msg.contains('limit') ||
            msg.contains('depleted') ||
            msg.contains('credits') ||
            msg.contains('billing') ||
            msg.contains('retry') ||
            msg.contains('prepay');
        if (isQuotaError) {
          _rotate();
          continue;
        }
        throw AiException(e.message);
      } catch (e) {
        dev.log('[Gemini] Error inesperado: $e');
        throw AiException('Error inesperado: $e');
      }
    }
    throw const QuotaExhaustedException();
  }
}
