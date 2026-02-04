class Question {
  final String text;
  final List<String> options;
  final String correctAnswer;
  final String category;

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      text: map['text'] ?? '',
      options: List<String>.from(map['options'] ?? []),
      correctAnswer: map['correctAnswer'] ?? '',
      category: map['category'] ?? "",

    );
  }

  Question({
    required this.text,
    required this.options,
    required this.correctAnswer,
    required this.category,
  });



  Map<String, dynamic> toMap() {
    return {'text': text, 'options': options, 'correctAnswer': correctAnswer};
  }
}
