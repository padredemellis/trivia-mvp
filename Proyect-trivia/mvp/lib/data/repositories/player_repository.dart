import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvp/core/constants/firebase_collections.dart';
import 'package:mvp/data/models/player.dart';

/// Repository para operaciones CRUD de jugadores.
///
/// Maneja la comunicación con Firestore para la colección players.
class PlayerRepository {
  /// Instancia de Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Nombre de la colección en Firestore.
  final String _collectionName = FirebaseCollections.players;

  /// Obtiene un jugador por su userId.
  ///
  /// Retorna [Player] si existe, [null] si no existe.
  ///
  /// Lanza excepción si hay error de conexión.
  Future<Player?> getPlayer(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_collectionName)
          .doc(userId)
          .get();

      if (!doc.exists) return null;

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Player.fromJson(data);
    } catch (e) {
      print('Error in PlayerRepository.getPlayer: $e');
      rethrow;
    }
  }

  /// Crea o sobrescribe un jugador.
  ///
  /// Usa el userId del jugador como document ID.
  Future<void> savePlayer(Player player) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(player.userId)
          .set(player.toJson());
    } catch (e) {
      print('Error in PlayerRepository.savePlayer: $e');
      rethrow;
    }
  }

  /// Actualiza un jugador existente.
  ///
  /// Usa merge: true para actualizar solo campos especificados.
  Future<void> updatePlayer(Player player) async {
    try {
      await _firestore
          .collection(_collectionName)
          .doc(player.userId)
          .set(player.toJson(), SetOptions(merge: true));
    } catch (e) {
      print('Error in PlayerRepository.updatePlayer: $e');
      rethrow;
    }
  }

  /// Elimina un jugador.
  Future<void> deletePlayer(String userId) async {
    try {
      await _firestore.collection(_collectionName).doc(userId).delete();
    } catch (e) {
      print('Error in PlayerRepository.deletePlayer: $e');
      rethrow;
    }
  }

  /// Verifica si existe un jugador.
  ///
  /// Retorna [true] si existe, [false] si no.
  Future<bool> playerExists(String userId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_collectionName)
          .doc(userId)
          .get();

      return doc.exists;
    } catch (e) {
      print('Error in PlayerRepository.playerExists: $e');
      rethrow;
    }
  }

  /// Obtiene los top jugadores ordenados por puntos.
  ///
  /// Retorna lista de [Player] ordenada descendentemente por points.
  ///
  /// [limit] define cuántos jugadores retornar (default: 10).
  Future<List<Player>> getTopPlayers({int limit = 10}) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .orderBy('points', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs
          .map((doc) => Player.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error in PlayerRepository.getTopPlayers: $e');
      rethrow;
    }
  }

  /// Actualiza solo las vidas de un jugador.
  ///
  /// Método optimizado para actualizar solo el campo lives.
  Future<void> updateLives(String userId, int newLives) async {
    try {
      await _firestore.collection(_collectionName).doc(userId).update({
        'lives': newLives,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      print('Error in PlayerRepository.updateLives: $e');
      rethrow;
    }
  }

  /// Actualiza solo las monedas de un jugador.
  ///
  /// Método optimizado para actualizar solo el campo coins.
  Future<void> updateCoins(String userId, int newCoins) async {
    try {
      await _firestore.collection(_collectionName).doc(userId).update({
        'coins': newCoins,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      print('Error in PlayerRepository.updateCoins: $e');
      rethrow;
    }
  }

  /// Actualiza solo los puntos de un jugador.
  ///
  /// Método optimizado para actualizar solo el campo points.
  Future<void> updatePoints(String userId, int newPoints) async {
    try {
      await _firestore.collection(_collectionName).doc(userId).update({
        'points': newPoints,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      print('Error in PlayerRepository.updatePoints: $e');
      rethrow;
    }
  }
}
