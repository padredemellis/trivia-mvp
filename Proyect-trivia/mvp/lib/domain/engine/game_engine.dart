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

/// Controlador central de la lógica de juego.
///
/// Coordina la interacción entre los Casos de Uso (Use Cases) y el estado
/// de la aplicación, emitiendo actualizaciones a través de un Stream.
class GameEngine {
  /// Stream que emite el estado actualizado del motor de juego.
  final _stateController = StreamController<GameEngineState>.broadcast();

  /// Estado interno actual.
  late GameEngineState _state;

  /// Caso de uso para inicializar un nodo y sus preguntas.
  final StartNodeUseCase _startNodeUC;

  /// Caso de uso para validar la respuesta del jugador.
  final AnswerQuestionUseCase _answerQuestionUC;

  /// Caso de uso para gestionar la reducción de vidas.
  final LoseLifeUseCase _loseLifeUC;

  /// Caso de uso para procesar la finalización exitosa de un nivel.
  final CompleteNodeUseCase _completeNodeUC;

  /// Caso de uso para persistir el progreso de la sesión actual.
  final UpdateGameSessionUseCase _updateSessionUC;

  /// Stream para que la UI escuche los cambios de estado.
  Stream<GameEngineState> get stateStream => _stateController.stream;

  /// Retorna el estado actual del juego.
  GameEngineState get state => _state;

  /// Crea una instancia del GameEngine.
  ///
  /// Requiere el [initialPlayer] y todos los casos de uso necesarios
  /// para ejecutar la lógica de negocio.
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
    _state = GameEngineState.initial(initialPlayer);
    _emit();
  }

  /// Inicia el juego en un nodo específico.
  ///
  /// Obtiene los datos del [nodeId], carga las preguntas y actualiza el
  /// estado a [GameState.playing].
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
      setError("Error al cargar el nodo: $e");
    }
  }

  /// Procesa la respuesta enviada por el usuario.
  ///
  /// Valida la respuesta, actualiza la sesión, resta vidas si es necesario
  /// y determina si el juego debe avanzar, terminar o mostrar Game Over.
  Future<void> answerQuestion(String userAnswer) async {
    if (_state.currentQuestions == null || _state.currentSession == null) {
      return;
    }

    final question = _state.currentQuestions![_state.currentQuestionIndex];

    // Valida si la respuesta es correcta
    final isCorrect = _answerQuestionUC.execute(question, userAnswer);

    // Actualiza datos de la sesión localmente
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

    // Persiste el cambio en la base de datos
    await _updateSessionUC.execute(updatedSession);

    Player currentPlayer = _state.player;

    // Gestión de respuesta incorrecta
    if (!isCorrect) {
      currentPlayer = _loseLifeUC.execute(currentPlayer);
      _update(player: currentPlayer);

      if (currentPlayer.lives <= 0) {
        _update(status: GameState.gameOver);
        return;
      }
    }

    // Determina si es la última pregunta del nodo
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

  /// Finaliza el nodo actual y otorga recompensas.
  ///
  /// Llama al caso de uso para persistir el progreso del jugador
  /// y cambia el estado a [GameState.nodeCompleted].
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

  /// Reinicia el motor de juego al estado inicial.
  ///
  /// Limpia los datos de la sesión actual y el nodo, volviendo a [GameState.idle].
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

  /// Obtiene la pregunta que se debe mostrar actualmente en la UI.
  Question? getCurrentQuestion() {
    if (_state.currentQuestions != null &&
        _state.currentQuestionIndex < _state.currentQuestions!.length) {
      return _state.currentQuestions![_state.currentQuestionIndex];
    }
    return null;
  }

  /// Define un mensaje de error y lo notifica al estado.
  void setError(String message) {
    _update(isLoading: false, errorMessage: message);
  }

  /// Actualiza el estado interno y emite el cambio al Stream.
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

  /// Emite el estado actual al controlador del Stream.
  void _emit() => _stateController.add(_state);

  /// Cierra los recursos del motor de juego.
  void dispose() => _stateController.close();
}
