import 'package:mvp/data/models/game_sessions.dart';
import 'package:mvp/data/repositories/game_session_repository.dart';

/// Actualiza una sesión de juego existente en Firestore.
///
/// OSe usa después de cada respuesta del jugador para persistir el progreso.
///

class UpdateGameSessionUseCase {
  final GameSessionRepository _sessionRepository;

  UpdateGameSessionUseCase(this._sessionRepository);

  /// Guarda la sesión actualizada en Firestore.
  ///
  /// Parámetros:
  /// - session: Sesión de juego ya actualizada
  ///
  /// Este Use Case no modifica la sesión, solo la persiste.
  Future<void> execute(GameSession session) async {
    await _sessionRepository.updateSession(session);
  }
}
