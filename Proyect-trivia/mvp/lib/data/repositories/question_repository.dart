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
      print("Buscando estas preguntas: $ids");
      if (ids.isEmpty) {
        print("¡OJO! La lista de IDs que llegó está VACÍA");
        return [];
      }

      final query = await _firestoreInstance
          .collection('questions')
          .where(FieldPath.documentId, whereIn: ids)
          .get();

      print("Preguntas encontradas en Firestore: ${query.docs.length}");

      return query.docs.map((doc) {
        print("Mapeando pregunta: ${doc.id}");
        return Question.fromJson(doc.data());
      }).toList();
    } catch (e) {
      print("ERROR BUSCANDO PREGUNTAS: $e");
      return [];
    }
  }
}
