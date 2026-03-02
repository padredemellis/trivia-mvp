import 'package:mvp/core/enums/difficulty.dart';

class Node {
  final int nodeId;
  final String title;
  final String category;
  final Difficulty difficulty;
  final String description;
  final List<String> poolQuestionIds;
  final int questionsToShow;
  final int? requiredNodeId;
  final int rewardCoins;

  Node({
    required this.nodeId,
    required this.title,
    required this.category,
    required this.description,
    required this.difficulty,
    required this.poolQuestionIds,
    required this.questionsToShow,
    this.requiredNodeId,
    this.rewardCoins = 0,
  });

  factory Node.fromJson(Map<String, dynamic> json) {
    final title = (json['title'] as String?) ?? '';
    final category = (json['category'] as String?) ??
        _inferCategoryFromTitle(title) ??
        'Historia';

    return Node(
      nodeId: json['nodeId'] as int,
      title: title,
      category: category,
      description: (json['description'] as String?) ?? '',
      poolQuestionIds: List<String>.from(json['poolQuestionIds'] ?? []),
      questionsToShow: (json['questionsToShow'] as int?) ?? 0,
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
      'category': category,
      'description': description,
      'poolQuestionIds': poolQuestionIds,
      'questionsToShow': questionsToShow,
      'requiredNodeId': requiredNodeId,
      'rewardCoins': rewardCoins,
      'difficulty': difficulty.name,
    };
  }

  static String? _inferCategoryFromTitle(String title) {
    if (!title.contains(':')) return null;
    return title.split(':').last.trim();
  }
}