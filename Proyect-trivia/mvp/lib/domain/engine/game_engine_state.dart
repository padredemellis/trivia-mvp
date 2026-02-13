import 'package:mvp/data/models/player.dart';
import 'package:mvp/core/enums/game_state.dart';
import 'package:mvp/data/models/node.dart';
import 'package:mvp/data/models/game_sessions.dart';
import 'package:mvp/data/models/question.dart';

/// Representa el estado inmutable del GameEngine.
///
/// Contiene toda la información necesaria para renderizar la UI del juego.
///
/// Se actualiza mediante copyWith y se emite via Stream para que
/// la UI reaccione a los cambios.
///
/// Campos:
/// - player: Jugador actual con vidas, monedas, progreso
/// - status: Estado actual del juego (idle, playing, nodeCompleted, etc.)
/// - currentNode: Nodo siendo jugado (null si no está en juego)
/// - currentSession: Sesión activa (null si no está en juego)
/// - currentQuestions: Preguntas del nodo actual (null si no está en juego)
/// - currentQuestionIndex: Índice de la pregunta actual (0-based)
/// - isLoading: Indica si está cargando datos
/// - errorMessage: Mensaje de error a mostrar (null si no hay error)
/// - coinsEarned: Monedas ganadas en nodo completado (para mostrar en pantalla)
/// - pointsEarned: Puntos ganados en nodo completado (para mostrar en pantalla)
class GameEngineState {
  final Player player;
  final GameState status;
  final Node? currentNode;
  final GameSession? currentSession;
  final List<Question>? currentQuestions;
  final int currentQuestionIndex;
  final bool isLoading;
  final String? errorMessage;
  final int? coinsEarned;
  final int? pointsEarned;

  const GameEngineState({
    required this.player,
    required this.status,
    this.currentNode,
    this.currentSession,
    this.currentQuestions,
    this.currentQuestionIndex = 0,
    this.isLoading = false,
    this.errorMessage,
    this.coinsEarned,
    this.pointsEarned,
  });

  factory GameEngineState.initial(Player player) {
    return GameEngineState(player: player, status: GameState.idle);
  }

  GameEngineState copyWith({
    Player? player,
    GameState? status,
    Node? currentNode,
    GameSession? currentSession,
    List<Question>? currentQuestions,
    int? currentQuestionIndex,
    bool? isLoading,
    String? errorMessage,
    int? coinsEarned,
    int? pointsEarned,
  }) {
    return GameEngineState(
      player: player ?? this.player,
      status: status ?? this.status,
      currentNode: currentNode ?? this.currentNode,
      currentSession: currentSession ?? this.currentSession,
      currentQuestions: currentQuestions ?? this.currentQuestions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      coinsEarned: coinsEarned ?? this.coinsEarned,
      pointsEarned: pointsEarned ?? this.pointsEarned,
    );
  }
}
