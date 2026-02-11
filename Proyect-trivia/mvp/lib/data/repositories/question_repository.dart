import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
/// Repository para operaciones CRUD de preguntas.
///
/// Maneja la comunicación con Firestore para la colección questions.
class QuestionRepository {
  final FirebaseFirestore _firestoreInstance = FirebaseFirestore.instance;
  final String _collection = "Questions";

  Future<Map<String, dynamic>?> getRandomQuestion() async {
    try {
      QuerySnapshot snapshot = await _firestoreInstance.collection(_collection).get();
      if (snapshot.docs.isEmpty) {
        return null;
      }

      final random = Random();
      final randomQuestion = snapshot.docs[random.nextInt(snapshot.docs.length)];
      Map<String, dynamic> question = randomQuestion.data() as Map<String, dynamic>;
      question['id'] = randomQuestion.id;

      return question;
    } catch (e) {
      throw Exception('Error while fetching question: $e');
    }
  }
}
