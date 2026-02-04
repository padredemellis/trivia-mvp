class Node {
  final int id;
  final int category;
  final String topic;

  Node({required this.id, required this.category, required this.topic});

  factory Node.fromMap(Map<String, dynamic> map) {
    return Node(
      id: map["id"] ?? 0,
      category: map['category'] ?? 0,
      topic: map['topic'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'category': category, 'topic': topic};
  }
}
