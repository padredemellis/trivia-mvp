import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mvp/core/constants/firebase_collections.dart';
import 'package:mvp/core/enums/difficulty.dart';
import 'package:mvp/data/models/node.dart';

/// Repository para operaciones CRUD de nodos.
///
/// Maneja la comunicación con Firestore para la colección nodes.
class NodeRepository {
  /// Instancia de Firestore.
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Nombre de la colección en Firestore.
  final String _collectionName = FirebaseCollections.nodes;

  /// Obtiene un nodo por su ID.
  ///
  /// Retorna [Node] si existe, [null] si no existe.
  ///
  /// Lanza excepción si hay error de conexión.
  Future<Node?> getNode(int nodeId) async {
    try {
      DocumentSnapshot doc = await _firestore
          .collection(_collectionName)
          .doc(nodeId.toString())
          .get();
      print("¿Documento encontrado?: ${doc.exists}");
      if (!doc.exists) return null;

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return Node.fromJson(data);
    } catch (e) {
      print("ERROR DIRECTO DE FIRESTORE: $e");
      rethrow;
    }
  }

  /// Obtiene todos los nodos ordenados por nodeId.
  ///
  /// Retorna lista de [Node] ordenada de 1 a 30.
  Future<List<Node>> getAllNodes() async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .orderBy('nodeId')
          .get();

      return snapshot.docs
          .map((doc) => Node.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error in NodeRepository.getAllNodes: $e');
      rethrow;
    }
  }

  /// Obtiene nodos por dificultad.
  ///
  /// Retorna lista de [Node] de la dificultad especificada.
  Future<List<Node>> getNodesByDifficulty(Difficulty difficulty) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .where('difficulty', isEqualTo: difficulty.name)
          .orderBy('nodeId')
          .get();

      return snapshot.docs
          .map((doc) => Node.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error in NodeRepository.getNodesByDifficulty: $e');
      rethrow;
    }
  }

  /// Obtiene los nodos desbloqueados para un jugador.
  ///
  /// Retorna lista de [Node] basada en los IDs desbloqueados.
  ///
  /// Limitación: Máximo 10 IDs por restricción de Firestore whereIn.
  Future<List<Node>> getUnlockedNodes(List<int> unlockedNodeIds) async {
    try {
      if (unlockedNodeIds.isEmpty) return [];

      if (unlockedNodeIds.length > 10) {
        print(
          'Warning: getUnlockedNodes recibió ${unlockedNodeIds.length} IDs. '
          'Firestore limita whereIn a 10. Tomando solo los primeros 10.',
        );
        unlockedNodeIds = unlockedNodeIds.sublist(0, 10);
      }

      // Convertir int a String para Firestore document IDs
      List<String> stringIds = unlockedNodeIds
          .map((id) => id.toString())
          .toList();

      QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .where(FieldPath.documentId, whereIn: stringIds)
          .orderBy('nodeId')
          .get();

      return snapshot.docs
          .map((doc) => Node.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error in NodeRepository.getUnlockedNodes: $e');
      rethrow;
    }
  }

  /// Obtiene nodos en un rango específico.
  ///
  /// Útil para paginación o cargar secciones del mapa.
  ///
  /// Ejemplo: getNodesInRange(1, 10) retorna nodos 1-10.
  Future<List<Node>> getNodesInRange(int startNodeId, int endNodeId) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection(_collectionName)
          .where('nodeId', isGreaterThanOrEqualTo: startNodeId)
          .where('nodeId', isLessThanOrEqualTo: endNodeId)
          .orderBy('nodeId')
          .get();

      return snapshot.docs
          .map((doc) => Node.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print('Error in NodeRepository.getNodesInRange: $e');
      rethrow;
    }
  }
}
