import 'package:mvp/data/models/game_sessions.dart';
import 'package:mvp/data/models/node.dart';
import 'package:mvp/data/models/player.dart';
import 'package:mvp/data/repositories/player_repository.dart';
import 'package:mvp/data/repositories/game_session_repository.dart';

/// Procesa la finalización exitosa de un nodo.
///
/// Calcula y aplica recompensas al jugador, actualiza su progreso
/// y elimina la sesión de juego completada.
class CompleteNodeUseCase {
  final PlayerRepository _playerRepository;
  final GameSessionRepository _sessionRepository;

  CompleteNodeUseCase(this._playerRepository, this._sessionRepository);

  /// Completa un nodo y actualiza el jugador con las recompensas.
  ///
  /// Parámetros:
  /// - player: Jugador actual
  /// - session: Sesión de juego completada
  /// - node: Nodo que fue completado
  ///
  /// Retorna [Player] actualizado con recompensas y progreso.
  ///
  /// Proceso:
  /// 1. Calcula recompensas (monedas y puntos)
  /// 2. Actualiza Player sumando coins, points y agregando nodo a completados
  /// 3. Guarda Player en Firestore
  /// 4. Elimina GameSession
  /// 5. Retorna Player actualizado
  Future<Player> execute(Player player, GameSession session, Node node) async {
    int coinsEarned = node.rewardCoins;
    int pointsEarned = session.correctCount * 10;

    List<int> updatedCompletedNodes = [...player.completedNodes, node.nodeId];

    Player updatedPlayer = player.copyWith(
      coins: player.coins + coinsEarned,
      points: player.points + pointsEarned,
      completedNodes: updatedCompletedNodes,
    );

    await _playerRepository.updatePlayer(updatedPlayer);
    await _sessionRepository.deleteSession(session.sessionId);
    return updatedPlayer;
  }
}
