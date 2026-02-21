import 'package:firebase_auth/firebase_auth.dart';
import 'package:mvp/data/repositories/auth_repository.dart';

/// Caso de uso para el inicio de sesión con Google.
///
///La capa de presentación (UI) solo interactúa
/// con esta clase sin conocer los detalles de Firebase o de Google.

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  /// Ejecuta el caso de uso para iniciar sesión.
  ///
  /// Al utilizar el método especial `call()`, la instancia de esta clase
  /// puede ser invocada como si fuera una función (ej. `await loginUseCase()`).
  ///
  /// Retorna las credenciales del usuario [UserCredential] si tiene éxito,
  /// o [null] si el inicio de sesión falla o es cancelado por el jugador.
  Future<UserCredential?> call() async {
    return await repository.signInWithGoogle();
  }
}
