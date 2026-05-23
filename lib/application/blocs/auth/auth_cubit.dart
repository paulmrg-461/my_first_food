import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FirebaseAuth _auth;
  final FlutterSecureStorage _secureStorage;
  static const _keyEmail = 'auth_email';

  AuthCubit({
    required FirebaseAuth firebaseAuth,
    required this._secureStorage,
  })  : _auth = firebaseAuth,
        super(const AuthInitial()) {
    _auth.authStateChanges().listen((user) {
      if (user != null) {
        _secureStorage.write(key: _keyEmail, value: user.email);
        emit(AuthAuthenticated(user));
      } else {
        _secureStorage.delete(key: _keyEmail);
        emit(const AuthUnauthenticated());
      }
    });
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    emit(const AuthLoading());
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      emit(AuthError(_mapError(e.code)));
    } catch (e) {
      emit(const AuthError('Error inesperado al iniciar sesión'));
    }
  }

  Future<void> signOut() async {
    await _secureStorage.delete(key: _keyEmail);
    await _auth.signOut();
  }

  String _mapError(String code) {
    return switch (code) {
      'invalid-email' => 'El correo electrónico no es válido',
      'user-disabled' => 'Esta cuenta ha sido deshabilitada',
      'user-not-found' => 'No existe cuenta con este correo',
      'wrong-password' => 'Contraseña incorrecta',
      'invalid-credential' => 'Correo o contraseña incorrectos',
      'too-many-requests' => 'Demasiados intentos. Intenta más tarde',
      'network-request-failed' => 'Error de conexión. Revisa tu internet',
      _ => 'Error al iniciar sesión',
    };
  }
}
