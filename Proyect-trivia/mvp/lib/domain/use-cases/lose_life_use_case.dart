import 'package:mvp/models/player.dart';

/// Reduce las vidas de un jugador cuando responde incorrectamente.
///
/// Valida que las vidas no bajen de 0 (mínimo).

class LoseLifeUseCase {
  /// Reduce las vidas de un jugador cuando responde incorrectamente.
  ///
  /// Parámetros:
  ///  - player: Jugador actual
  ///
  /// Retorna un nuevo Player con una vida menos.
  ///
  /// Valida que las vidas no bajen de 0.
  Player execute(Player player) {
    int newLives = player.lives - 1;
    if (newLives < 0) {
      newLives = 0;
    }
    return player.copyWith(lives: newLives);
  }
}
