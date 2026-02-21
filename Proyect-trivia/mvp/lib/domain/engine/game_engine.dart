import 'dart:async';
import 'package:mvp/core/enums/game_state.dart';
import 'package:mvp/data/models/player.dart';
import 'package:mvp/domain/engine/game_engine_state.dart';
import 'package:mvp/data/models/game_sessions.dart';
import 'package:mvp/data/models/question.dart';
import 'package:mvp/data/models/node.dart';
import 'package:mvp/domain/use-cases/answer_question_use_case.dart';
import 'package:mvp/domain/use-cases/complete_node_use_case.dart';
import 'package:mvp/domain/use-cases/lose_life_use_case.dart';
import 'package:mvp/domain/use-cases/start_node_use_case.dart';
import 'package:mvp/domain/use-cases/update_game_session_use_case.dart';

/// GameEngine
///
/// Orquestador central de la lógica del juego.
///
/// Responsabilidades principales:
/// - Gestionar el estado global del juego.
/// - Coordinar los casos de uso del dominio.
/// - Emitir cambios de estado de forma reactiva mediante Streams.
/// - Controlar el flujo del juego (inicio de nodo, preguntas, game over, recompensas).
///
/// Este diseño sigue principios de Clean Architecture:
/// - El engine no implementa lógica de negocio directamente.
/// - Delegación de reglas a Use Cases.
/// - Estado inmutable mediante `copyWith`.
class GameEngine {
  /// StreamController que emite cambios del estado del juego.
  ///
  /// Se utiliza `.broadcast()` para permitir múltiples oyentes (UI, logs, tests).
  final _stateController = StreamController<GameEngineState>.broadcast();

  /// Estado actual del GameEngine.
  ///
  /// Se inicializa en el constructor y se actualiza mediante `_update`.
  late GameEngineState _state;

  /// Caso de uso para iniciar un nodo del juego.
  final StartNodeUseCase _startNodeUC;

  /// Caso de uso para validar respuestas del usuario.
  final AnswerQuestionUseCase _answerQuestionUC;

  /// Caso de uso para gestionar la pérdida de vidas del jugador.
  final LoseLifeUseCase _loseLifeUC;

  /// Caso de uso para completar un nodo y calcular recompensas.
  final CompleteNodeUseCase _completeNodeUC;

  /// Caso de uso para actualizar la sesión de juego en persistencia.
  final UpdateGameSessionUseCase _updateSessionUC;

  /// Stream público del estado del juego.
  ///
  /// La UI se suscribe a este stream para reaccionar a cambios del engine.
  Stream<GameEngineState> get stateStream => _stateController.stream;

  /// Estado actual del juego (solo lectura).
  GameEngineState get state => _state;

  /// Constructor del GameEngine.
  ///
  /// Recibe las dependencias mediante inyección (Dependency Injection),
  /// lo que permite desacoplar el engine de implementaciones concretas
  /// y facilita el testeo.
  GameEngine({
    required Player initialPlayer,
    required StartNodeUseCase startNodeUC,
    required AnswerQuestionUseCase answerQuestionUC,
    required LoseLifeUseCase loseLifeUC,
    required CompleteNodeUseCase completeNodeUC,
    required UpdateGameSessionUseCase updateSessionUC,
  }) : _startNodeUC = startNodeUC,
       _answerQuestionUC = answerQuestionUC,
       _loseLifeUC = loseLifeUC,
       _completeNodeUC = completeNodeUC,
       _updateSessionUC = updateSessionUC {
    /// Inicializa el estado del juego con un jugador inicial.
    _state = GameEngineState.initial(initialPlayer);

    /// Emite el estado inicial hacia los observadores.
    _emit();
  }

  /// Inicia un nodo del juego.
  ///
  ///
  /// 1. Activa estado de carga.
  /// 2. Ejecuta el caso de uso StartNodeUseCase.
  /// 3. Actualiza el estado con nodo, sesión y preguntas.
  /// 4. Cambia el estado a `playing`.
  Future<void> startNode(int nodeId) async {
    _update(isLoading: true, errorMessage: null);

    try {
      final result = await _startNodeUC.execute(nodeId, _state.player);

      _update(
        status: GameState.playing,
        currentNode: result.node,
        currentSession: result.session,
        currentQuestions: result.questions,
        currentQuestionIndex: 0,
        isLoading: false,
        coinsEarned: null,
        pointsEarned: null,
      );
    } catch (e) {
      print("EL ERROR REAL ES: $e");
      setError("Error al cargar el nodo: $e");
    }
  }

  /// Cambia el estado a 'navigating' para mostrar el mapa de niveles.
  void goToMap() {
    _update(status: GameState.navigating);
  }

  /// Procesa la respuesta del usuario a una pregunta.
  ///
  /// Flujo:
  /// - Valida la respuesta mediante AnswerQuestionUseCase.
  /// - Actualiza la sesión de juego.
  /// - Persiste los cambios.
  /// - Gestiona pérdida de vidas y Game Over.
  /// - Avanza a la siguiente pregunta o finaliza el nodo.
  Future<void> answerQuestion(String userAnswer) async {
    if (_state.currentQuestions == null || _state.currentSession == null)
      return;

    final question = _state.currentQuestions![_state.currentQuestionIndex];

    final isCorrect = _answerQuestionUC.execute(question, userAnswer);

    var updatedSession = _state.currentSession!.copyWith(
      correctCount: isCorrect
          ? _state.currentSession!.correctCount + 1
          : _state.currentSession!.correctCount,
      incorrectCount: !isCorrect
          ? _state.currentSession!.incorrectCount + 1
          : _state.currentSession!.incorrectCount,
      lastUpdated: DateTime.now(),
    );

    updatedSession.answersGiven[question.questionId] = isCorrect;

    await _updateSessionUC.execute(updatedSession);

    Player currentPlayer = _state.player;
    if (!isCorrect) {
      currentPlayer = _loseLifeUC.execute(currentPlayer);
      _update(player: currentPlayer);

      if (currentPlayer.lives <= 0) {
        _update(status: GameState.gameOver);
        return;
      }
    }

    final isLastQuestion =
        _state.currentQuestionIndex == _state.currentQuestions!.length - 1;

    if (isLastQuestion) {
      _finishNode(updatedSession);
    } else {
      _update(
        currentSession: updatedSession,
        currentQuestionIndex: _state.currentQuestionIndex + 1,
      );
    }
  }

  /// Finaliza un nodo del juego.
  ///
  /// Calcula recompensas y actualiza el jugador.
  Future<void> _finishNode(GameSession session) async {
    _update(isLoading: true);

    try {
      final updatedPlayer = await _completeNodeUC.execute(
        _state.player,
        session,
        _state.currentNode!,
      );

      _update(
        player: updatedPlayer,
        status: GameState.nodeCompleted,
        coinsEarned: _state.currentNode!.rewardCoins,
        pointsEarned: session.correctCount * 10,
        isLoading: false,
      );
    } catch (e) {
      setError("Error al completar el nodo: $e");
    }
  }

  /// Reinicia el estado del juego a su estado inicial.
  void resetGame() {
    _update(
      status: GameState.idle,
      currentNode: null,
      currentSession: null,
      currentQuestions: null,
      currentQuestionIndex: 0,
      coinsEarned: null,
      pointsEarned: null,
      isLoading: false,
      errorMessage: null,
    );
  }

  /// Obtiene la pregunta actual del nodo.
  Question? getCurrentQuestion() {
    if (_state.currentQuestions != null &&
        _state.currentQuestionIndex < _state.currentQuestions!.length) {
      return _state.currentQuestions![_state.currentQuestionIndex];
    }
    return null;
  }

  /// Registra un error en el estado del engine.
  void setError(String message) {
    _update(isLoading: false, errorMessage: message);
  }

  /// Actualiza el estado del GameEngine.
  ///
  /// Centraliza todas las modificaciones del estado y utiliza `copyWith`
  /// para mantener la inmutabilidad.
  void _update({
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
    _state = _state.copyWith(
      player: player,
      status: status,
      currentNode: currentNode,
      currentSession: currentSession,
      currentQuestions: currentQuestions,
      currentQuestionIndex: currentQuestionIndex,
      isLoading: isLoading,
      errorMessage: errorMessage,
      coinsEarned: coinsEarned,
      pointsEarned: pointsEarned,
    );
    _emit();
  }

  bool isNodeCompleted(int nodeId) {
    return _state.player.completedNodes.contains(nodeId);
  }

  bool isNodeUnlocked(int nodeId) {
    if (nodeId == 1) return true;

    return _state.player.completedNodes.contains(nodeId - 1);
  }

  /// Emite el estado actual a través del Stream.
  void _emit() => _stateController.add(_state);

  /// Libera recursos del StreamController.
  void dispose() => _stateController.close();
}
