class Question {
  final String text;
  final List<String> options;
  final String correctAnswer;
  final String category;

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
