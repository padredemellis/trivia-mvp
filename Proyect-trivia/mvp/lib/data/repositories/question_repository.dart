import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'package:mvp/data/models/question.dart';

/// Repository para operaciones CRUD de preguntas.
///
/// Maneja la comunicación con Firestore para la colección questions.
class QuestionRepository {
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  final String _collection = "Questions";

  Future<Map<String, dynamic>?> getRandomQuestion() async {
    try {
      QuerySnapshot snapshot = await _firestoreInstance
          .collection(_collection)
          .get();
      if (snapshot.docs.isEmpty) {
        return null;
      }

      final random = Random();
      final randomQuestion =
          snapshot.docs[random.nextInt(snapshot.docs.length)];
      Map<String, dynamic> question =
          randomQuestion.data() as Map<String, dynamic>;
      question['id'] = randomQuestion.id;

      return question;
    } catch (e) {
      throw Exception('Error while fetching question: $e');
    }
  }

  /// Obtiene múltiples preguntas por sus IDs.
  ///
  /// Retorna lista de [Question] (puede estar vacía si ninguno existe).
  ///
  /// Limitación: Máximo 10 IDs por restricción de Firestore whereIn.
  Future<List<Question>> getQuestionsByIds(List<String> ids) async {
    try {
      if (ids.isEmpty) return [];

      if (ids.length > 10) {
        print(
          'Warning: getQuestionsByIds recibió ${ids.length} IDs. '
          'Firestore limita whereIn a 10. Tomando solo los primeros 10.',
        );
        ids = ids.sublist(0, 10);
      }

      QuerySnapshot snapshot = await _firestoreInstance
          .collection(_collection)
          .where(FieldPath.documentId, whereIn: ids)
          .get();

      return snapshot.docs
          .map((doc) => Question.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error in QuestionRepository.getQuestionsByIds: $e');
      rethrow;
    }
  }
}
