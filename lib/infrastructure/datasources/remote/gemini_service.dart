import 'dart:convert';
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
      : _dio = Dio(),
        _keys = AppConfig.geminiApiKeys {
    if (_keys.isEmpty) throw AiException('No Gemini API keys configured in .env');
  }

  String get _key => _keys[_keyIndex];

  void _rotate() => _keyIndex = (_keyIndex + 1) % _keys.length;

  Future<List<String>> uploadAllPdfs() async {
    final uris = <String>[];
    for (final asset in _pdfAssets) {
      final displayName = asset.split('/').last;
      final uri = await _uploadPdf(asset, displayName);
      uris.add(uri);
    }
    return uris;
  }

  Future<String> _uploadPdf(String assetPath, String displayName) async {
    final data = await rootBundle.load(assetPath);
    final bytes = data.buffer.asUint8List();

    // Step 1: initiate resumable upload
    late String uploadEndpoint;
    for (var attempt = 0; attempt < _keys.length; attempt++) {
      try {
        final initRes = await _dio.post(
          _uploadUrl,
          queryParameters: {'key': _key},
          options: Options(
            headers: {
              'X-Goog-Upload-Protocol': 'resumable',
              'X-Goog-Upload-Command': 'start',
              'X-Goog-Upload-Header-Content-Length': bytes.length,
              'X-Goog-Upload-Header-Content-Type': _pdfMime,
              'Content-Type': 'application/json',
            },
            responseType: ResponseType.plain,
          ),
          data: jsonEncode({'file': {'display_name': displayName}}),
        );
        uploadEndpoint = initRes.headers.value('x-goog-upload-url') ?? '';
        break;
      } on DioException catch (e) {
        if (e.response?.statusCode == 429) {
          _rotate();
          continue;
        }
        throw FileUploadException('Init failed: ${e.message}');
      }
    }

    if (uploadEndpoint.isEmpty) throw const QuotaExhaustedException();

    // Step 2: upload bytes
    final uploadRes = await _dio.put(
      uploadEndpoint,
      options: Options(
        headers: {
          'Content-Length': bytes.length,
          'X-Goog-Upload-Offset': 0,
          'X-Goog-Upload-Command': 'upload, finalize',
          'Content-Type': _pdfMime,
        },
      ),
      data: Stream.fromIterable([bytes]),
    );

    final fileUri = uploadRes.data['file']['uri'] as String;
    return fileUri;
  }

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

        final response = await model.generateContent([Content.multi(parts)]);
        return response.text ?? '';
      } on GenerativeAIException catch (e) {
        final msg = e.message.toLowerCase();
        if (msg.contains('429') || msg.contains('quota') || msg.contains('rate')) {
          _rotate();
          continue;
        }
        throw AiException(e.message);
      }
    }
    throw const QuotaExhaustedException();
  }
}
