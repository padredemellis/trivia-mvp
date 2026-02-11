import 'package:mvp/core/enums/difficulty.dart';

/// Representa un nodo (nivel) del mapa del juego.
///
/// Se usa para configurar cada nodo del juego.
///
/// Se persiste en Firestore, colección nodes.

class Node {
  /// Identificar nodo (1-30).
  final int nodeId;

  /// Título del nodo.
  final String title;

  /// Configurar la dificultad del nodo.
  final Difficulty difficulty;

  /// Descripción del nodo.
  final String description;

  /// IDs de preguntas disponibles en el nodo.
  final List<String> poolQuestionIds;

  /// Cantidad de preguntas que se mostrarán.
  final int questionsToShow;

  /// Nodo previo requerido para desbloquear este nodo.
  final int? requiredNodeId;

  /// Cantidad de monedas que se otorgan al completar el nodo.
  final int rewardCoins;

  Node({
    // Required (6)
    required this.nodeId,
    required this.title,
    required this.description,
    required this.difficulty,
    required this.poolQuestionIds,
    required this.questionsToShow,
    this.requiredNodeId,
    this.rewardCoins = 0,
  });

  factory Node.fromJson(Map<String, dynamic> json) {
    return Node(
      nodeId: json['nodeId'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      poolQuestionIds: List<String>.from(json['poolQuestionIds'] ?? []),
      questionsToShow: json['questionsToShow'] as int,
      requiredNodeId: json['requiredNodeId'] as int?,
      rewardCoins: json['rewardCoins'] ?? 0,
      difficulty: Difficulty.values.firstWhere(
        (e) => e.name == json['difficulty'],
        orElse: () => Difficulty.easy,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nodeId': nodeId,
      'title': title,
      'description': description,
      'poolQuestionIds': poolQuestionIds,
      'questionsToShow': questionsToShow,
      'requiredNodeId': requiredNodeId,
      'rewardCoins': rewardCoins,
      'difficulty': difficulty.name,
    };
  }
}
