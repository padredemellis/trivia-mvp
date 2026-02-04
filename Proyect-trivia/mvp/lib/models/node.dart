class Node {
  final int id;
  final String category;
  //TODO final int difficult;

  Node({required this.id, required this.category});

  factory Node.fromMap(Map<String, dynamic> map) {
    return Node(id: map["id"] ?? 0, category: map['category'] ?? "");
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'category': category};
  }
}
