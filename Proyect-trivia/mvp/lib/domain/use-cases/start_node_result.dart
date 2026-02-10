import 'package:mvp/data/models/game_sessions.dart';
import 'package:mvp/data/models/node.dart';
import 'package:mvp/data/models/question.dart';

/// Esta clase es el resultado de iniciar un nodo.
///
/// Contiene un nodo, una session de juego y las preguntas.
///
/// Agrupa los datos necesarios para mostrar en la UI.

class StartNodeResult {
  final Node node;
  final GameSession session;
  final List<Question> questions;

  StartNodeResult({
    required this.node,
    required this.session,
    required this.questions,
  });
}
