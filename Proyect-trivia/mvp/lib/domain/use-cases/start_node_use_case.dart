import 'package:mvp/data/models/game_sessions.dart';
import 'package:mvp/data/models/node.dart';
import 'package:mvp/data/models/question.dart';
import 'package:mvp/data/models/player.dart';
import 'package:mvp/domain/use-cases/start_node_result.dart';
import 'package:mvp/data/repositories/game_session_repository.dart';
import 'package:mvp/data/repositories/node_repository.dart';
import 'package:mvp/data/repositories/question_repository.dart';
import 'package:collection/collection.dart';

/// Inicializa un nodo cuando el jugador lo toca en el mapa.
///
/// Obtiene los datos del nodo.
/// Obtiene el pool de preguntas
/// Selecciona 5 preguntas
/// Randomiza las preguntas seleccinadas
///
/// Retorna el nodo actualizado

class StartNodeUseCase {
  final NodeRepository _nodeRepository;
  final QuestionRepository _questionRepository;
  final GameSessionRepository _sessionRepository;

  StartNodeUseCase(
    this._nodeRepository,
    this._questionRepository,
    this._sessionRepository,
  );

  /// Inicializa un nodo y prepara la sesión de juego.
  ///
  /// Parámetros:
  /// - nodeId: ID del nodo a iniciar
  /// - player: Jugador actual
  ///
  /// Retorna [StartNodeResult] con el nodo, sesión creada y preguntas seleccionadas.
  ///
  /// Proceso:
  /// 1. Obtiene el nodo desde Firestore
  /// 2. Valida que el nodo existe
  /// 3. Selecciona 5 preguntas al azar del pool
  /// 4. Obtiene las preguntas completas
  /// 5. Crea una nueva GameSession
  /// 6. Guarda la sesión y limpia sesiones antiguas
  /// 7. Retorna resultado con nodo, sesión y preguntas
  ///
  /// Lanza [Exception] si el nodo no existe.
  Future<StartNodeResult> execute(int nodeId, Player player) async {
    Node? node = await _nodeRepository.getNode(nodeId);

    if (node == null) {
      throw Exception('Node $nodeId not found');
    }
    List<String> selectedIds = node.poolQuestionIds.sample(3);
    List<Question> questions = await _questionRepository.getQuestionsByIds(
      selectedIds,
    );

    GameSession session = GameSession(
      sessionId: player.userId,
      userId: player.userId,
      currentNodeId: nodeId,
      questionsShownIds: selectedIds,
      correctCount: 0,
      incorrectCount: 0,
      answersGiven: {},
      attemptNumber: 0,
      createdAt: DateTime.now(),
      lastUpdated: DateTime.now(),
    );
    await _sessionRepository.saveSession(session);
    await _sessionRepository.cleanOldSessions(player.userId);
    return StartNodeResult(node: node, session: session, questions: questions);
  }
}
