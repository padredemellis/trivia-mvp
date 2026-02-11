import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvp/core/constants/firebase_collections.dart';
import 'package:mvp/data/models/game_sessions.dart';

/// Repository para operaciones CRUD de sesiones de juego.
///
/// Maneja la comunicación con Firestore para la colección game_sessions.
class GameSessionRepository {
  /// Instancia de Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Nombre de la colección en Firestore.
  final String _collectionName = FirebaseCollections.gameSessions;

  /// Obtiene una sesión por su ID.
  ///
  /// Retorna [GameSession] si existe, [null] si no existe.
  ///
  /// Lanza excepción si hay error de conexión.
  Future<GameSession?> getSession(String sessionId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_collectionName)
          .doc(sessionId)
          .get();

      if (!doc.exists) return null;

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return GameSession.fromJson(data);
    } catch (e) {
      print('Error in GameSessionRepository.getSession: $e');
      rethrow;
    }
  }

  /// Crea o sobrescribe una sesión.
  ///
  /// Usa el sessionId como document ID.
  Future<void> saveSession(GameSession session) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(session.sessionId)
          .set(session.toJson());
    } catch (e) {
      print('Error in GameSessionRepository.saveSession: $e');
      rethrow;
    }
  }

  /// Actualiza una sesión existente.
  ///
  /// Usa merge: true para actualizar solo campos especificados.
  Future<void> updateSession(GameSession session) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(session.sessionId)
          .set(session.toJson(), SetOptions(merge: true));
    } catch (e) {
      print('Error in GameSessionRepository.updateSession: $e');
      rethrow;
    }
  }

  /// Elimina una sesión.
  Future<void> deleteSession(String sessionId) async {
    try {
      await _firestore.collection(_collectionName).doc(sessionId).delete();
    } catch (e) {
      print('Error in GameSessionRepository.deleteSession: $e');
      rethrow;
    }
  }

  /// Obtiene la sesión activa más reciente de un jugador.
  ///
  /// Retorna [GameSession] más reciente del usuario, [null] si no tiene.
  Future<GameSession?> getActiveSessionForUser(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) return null;

      Map<String, dynamic> data =
          snapshot.docs.first.data() as Map<String, dynamic>;
      return GameSession.fromJson(data);
    } catch (e) {
      print('Error in GameSessionRepository.getActiveSessionForUser: $e');
      rethrow;
    }
  }

  /// Obtiene todas las sesiones de un jugador (historial).
  ///
  /// Retorna lista de [GameSession] ordenada por fecha descendente.
  Future<List<GameSession>> getSessionsForUser(String userId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs
          .map(
            (doc) => GameSession.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      print('Error in GameSessionRepository.getSessionsForUser: $e');
      rethrow;
    }
  }

  /// Elimina sesiones antiguas de un jugador.
  ///
  /// Mantiene solo la sesión más reciente y elimina las demás.
  ///
  /// Útil para limpiar sesiones completadas o abandonadas.
  Future<void> cleanOldSessions(String userId) async {
    try {
      // Obtener todas las sesiones del usuario
      QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .where('userId', isEqualTo: userId)
          .orderBy('updatedAt', descending: true)
          .get();

      // Si tiene más de 1 sesión, eliminar las antiguas
      if (snapshot.docs.length > 1) {
        // Mantener la primera (más reciente), eliminar el resto
        for (int i = 1; i < snapshot.docs.length; i++) {
          await snapshot.docs[i].reference.delete();
        }
      }
    } catch (e) {
      print('Error in GameSessionRepository.cleanOldSessions: $e');
      rethrow;
    }
  }

  /// Obtiene sesiones activas en un nodo específico.
  ///
  /// Útil para estadísticas o análisis.
  Future<List<GameSession>> getSessionsByNode(int nodeId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .where('currentNodeId', isEqualTo: nodeId)
          .get();

      return snapshot.docs
          .map(
            (doc) => GameSession.fromJson(doc.data() as Map<String, dynamic>),
          )
          .toList();
    } catch (e) {
      print('Error in GameSessionRepository.getSessionsByNode: $e');
      rethrow;
    }
  }
}
