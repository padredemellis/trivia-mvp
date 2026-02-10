import 'package:mvp/models/question.dart';

/// Verifica si la respuesta del usuario es correcta.
///
/// Compara userAnswer con question.correctAnswer.
///
/// Retorna bool (True o False).

class AnswerQuestionUseCase {
  /// Valida por true o false la respuesta del usuario.
  ///
  /// Parámetros:
  /// - question: es la respuesta correcta.
  /// - userAnswer: es la respuesta que eligió el usuario.
  ///
  /// Retorna True si la respuesta es correcta, False si es incorrecta.
  bool execute(Question question, String userAnswer) {
    if (userAnswer == question.correctAnswer) {
      return true;
    } else {
      return false;
    }
  }
}
