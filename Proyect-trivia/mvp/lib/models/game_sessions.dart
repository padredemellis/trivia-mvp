import 'package:cloud_firestore/cloud_firestore.dart';

/// Representa una sesión de juego en progreso.
///
/// Se usa para persistir progreso y permitir continuar partidas
///
/// Se persiste en Firestore, colección game_sessions

class GameSession {
  /// Identificador único de la sesión.
  final String sessionId;

  /// ID del jugador que está jugando esta sesión.
  final String userId;

  /// Nodo actual que el jugador está intentando (1-30).
  final int currentNodeId;

  /// Respuestas correctas en este intento.
  final int correctCount;

  /// Respuestas incorrectas en este intento.
  final int incorrectCount;

  /// IDs de preguntas ya mostradas en este intento.
  final List<String> questionsShownIds;

  /// Historial global (questionId → correcta/incorrecta).
  final Map<String, bool> answersGiven;

  /// Número de intento del nodo (1, 2, 3...).
  final int attemptNumber;

  /// Fecha de creación de la sesión.
  final DateTime createdAt;

  /// Última actualización.
  final DateTime lastUpdated;

  GameSession({
    required this.sessionId,
    required this.userId,
    required this.currentNodeId,
    required this.attemptNumber,
    this.correctCount = 0,
    this.incorrectCount = 0,
    this.questionsShownIds = const [],
    this.answersGiven = const {},
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) : createdAt = createdAt ?? DateTime.now(),
       lastUpdated = lastUpdated ?? DateTime.now();

  factory GameSession.fromJson(Map<String, dynamic> json) {
    return GameSession(
      sessionId: json['sessionId'] as String,
      userId: json['userId'] as String,
      currentNodeId: json['currentNodeId'] as int,
      attemptNumber: json['attemptNumber'] as int,
      correctCount: json['correctCount'] as int,
      incorrectCount: json['incorrectCount'] as int,
      questionsShownIds: List<String>.from(json['questionsShownIds'] ?? []),
      answersGiven: Map<String, bool>.from(json['answersGiven'] ?? {}),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      lastUpdated: (json['lastUpdated'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sessionId': sessionId,
      'userId': userId,
      'currentNodeId': currentNodeId,
      'correctCount': correctCount,
      'incorrectCount': incorrectCount,
      'attemptNumber': attemptNumber,
      'questionsShownIds': questionsShownIds,
      'answersGiven': answersGiven,
      'createdAt': Timestamp.fromDate(createdAt),
      'lastUpdated': Timestamp.fromDate(lastUpdated),
    };
  }
}
