import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart';

class AuthFailure implements Exception {
  final String message;
  final String? code;

  AuthFailure(this.message, {this.code});

  @override
  String toString() {
    return code == null ? message : '$message (code: $code)';
  }
}

/// Repositorio encargado de gestionar la autenticación del jugador.
///
/// Abstrae la lógica de inicio de sesión con proveedores externos (Google)
/// y asegura que los datos del usuario se sincronicen correctamente con
/// la colección de usuarios en Firestore.
class AuthRepository {
  /// Instancia de FirebaseAuth para manejar la sesión en el backend.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Instancia de GoogleSignIn para lanzar el flujo interactivo de Google.
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// Inicia el flujo de autenticación con Google.
  ///
  /// Despliega el modal nativo para que el jugador elija su cuenta de Google.
  /// Luego, obtiene las credenciales, inicia sesión en Firebase Auth y
  /// verifica si es necesario crear un documento nuevo en Firestore.
  ///
  /// Retorna un [UserCredential] si el proceso es exitoso, o [null] si el
  /// jugador cancela el flujo o si ocurre un error.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider()
          ..setCustomParameters({'prompt': 'select_account'});

        // Si volvemos de un redirect, Firebase devuelve aquí el resultado.
        final UserCredential redirectResult = await _auth.getRedirectResult();
        if (redirectResult.user != null) {
          return redirectResult;
        }

        try {
          final UserCredential userCredential = await _auth.signInWithPopup(
            googleProvider,
          );

          return userCredential;
        } on FirebaseAuthException catch (e) {
          // Fallback para navegadores que bloquean popup o storage del popup.
          if (e.code == 'popup-blocked' ||
              e.code == 'cancelled-popup-request' ||
              e.code == 'web-storage-unsupported') {
            await _auth.signInWithRedirect(googleProvider);
            return null;
          }
          rethrow;
        }
      } else {
        final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

        if (googleUser == null) {
          return null;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(
          credential,
        );

        return userCredential;
      }
    } on FirebaseAuthException catch (e) {
      print(
        'FirebaseAuthException en signInWithGoogle: ${e.code} ${e.message}',
      );
      throw AuthFailure(
        e.message ?? 'Error de autenticación con Firebase.',
        code: e.code,
      );
    } catch (e) {
      print('Error en AuthRepository.signInWithGoogle: $e');
      final String details = e.toString();
      if (details.contains('auth/unauthorized-domain')) {
        throw AuthFailure(
          'Dominio no autorizado para login web. Agrega bandw-questions.web.app en Firebase Auth > Authorized domains.',
          code: 'unauthorized-domain',
        );
      }

      throw AuthFailure(
        'Ocurrió un error al iniciar sesión con Google en web. Revisa Authorized domains y la configuración de Google Sign-In.',
      );
    }
  }

  /// Cierra la sesión activa del jugador.
  ///
  /// Desconecta tanto la cuenta de Google en el dispositivo como la sesión
  /// de Firebase Auth, obligando a pedir credenciales en el próximo ingreso.
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      print("Error en AuthRepository.signOut: $e");
      rethrow;
    }
  }
}
