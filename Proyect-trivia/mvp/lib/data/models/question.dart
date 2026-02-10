import 'package:mvp/core/enums/question_type.dart';

/// Representa una pregunta de opción múltiple del juego.
///
/// Se usa para configurar las preguntas en el juego
///
/// Se persiste en Firestore, colección questions

class Question {
  /// Identificador de pregunta única.
  final String questionId;

  /// Texto de la pregunta mostrado al usuario.
  final String text;

  /// Tipo de pregunta (multipleChoice, trueFalse o multiSelect).
  final QuestionType questionType;

  /// Opciones de respuesta disponibles.
  final List<String> options;

  /// Respuesta correcta de la pregunta.
  final String correctAnswer;

  /// Categoría de la pregunta (ej: Geografía, Historia).
  final String category;

  Question({
    required this.questionId,
    required this.text,
    required this.questionType,
    required this.options,
    required this.category,
    required this.correctAnswer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      questionId: json['questionId'] as String,
      text: json['text'] as String,
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] as String,
      category: json['category'] as String,
      questionType: QuestionType.values.firstWhere(
        (e) => e.name == json['questionType'],
        orElse: () => QuestionType.multipleChoice,
      ),
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'questionId': questionId,
      'text': text,
      'options': options,
      'correctAnswer': correctAnswer,
      'category': category,
      'questionType': questionType.name,
    };
  }
}
