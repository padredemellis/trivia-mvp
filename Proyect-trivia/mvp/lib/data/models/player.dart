import 'package:cloud_firestore/cloud_firestore.dart';

/// Representa un jugador con su progreso en el juego.
///
/// Se usa para persistir datos permanentes del jugador.
///
/// Se persiste en Firestore, colección players.

class Player {
  ///ID del jugador (Firebase Auth).
  final String userId;

  ///Nombre del jugador (opcional, default: "Jugador").
  final String name;

  ///Vidas restantes (default: 3).
  final int lives;

  ///Monedas acumuladas (default: 0).
  final int coins;

  ///Puntos totales (default: 0).
  final int points;

  ///Nodos completados (default: []).
  final List<int> completedNodes;

  ///Nodos desbloqueados (default: [1]).
  final List<int> unlockedNodes;

  ///Fecha de creación.
  final DateTime createdAt;

  ///Última actualización.
  final DateTime updatedAt;

  Player({
    // Required
    required this.userId,

    // Opcionales con default
    this.name = 'Jugador',
    this.lives = 3,
    this.coins = 0,
    this.points = 0,
    this.completedNodes = const [],
    this.unlockedNodes = const [1],

    // Nullable para DateTime
    DateTime? createdAt,
    DateTime? updatedAt,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      userId: json['userId'] as String,
      name: json['name'] ?? 'Jugador',
      lives: json['lives'] ?? 3,
      coins: json['coins'] ?? 0,
      points: json['points'] ?? 0,
      completedNodes: List<int>.from(json['completedNodes'] ?? []),
      unlockedNodes: List<int>.from(json['unlockedNodes'] ?? []),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'lives': lives,
      'coins': coins,
      'points': points,
      'completedNodes': completedNodes,
      'unlockedNodes': unlockedNodes,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  Player copyWith({
    String? userId,
    String? name,
    int? lives,
    int? coins,
    int? points,
    List<int>? completedNodes,
    List<int>? unlockedNodes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Player(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      lives: lives ?? this.lives,
      coins: coins ?? this.coins,
      points: points ?? this.points,
      completedNodes: completedNodes ?? this.completedNodes,
      unlockedNodes: unlockedNodes ?? this.unlockedNodes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
