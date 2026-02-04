class Player {
  final int score;
  final List<String> completedNodes;
  int id;

  Player({required this.score, required this.completedNodes, required this.id});

factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      score: map['score'] ?? 0,
      completedNodes: List<String>.from(map['completedNodes'] ?? ""),
      id: map['id'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'score': score, 'completedNodes': completedNodes, 'id': id};
  }
}
