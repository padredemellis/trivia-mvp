/// Nombres de las colecciones de Firestore.
///
/// Centraliza todos los nombres de colecciones para evitar typos
/// y facilitar mantenimiento.

class FirebaseCollections {
  FirebaseCollections._();

  /// Colección de jugadores.
  static const String players = 'players';

  /// Colección de sesiones de juego activas.
  static const String gameSessions = 'game_sessions';

  /// Colección de preguntas.
  ///
  /// Contiene todos los tipos de preguntas (multipleChoice, trueFalse, multiSelect).
  /// Usa el campo questionType para diferenciar.
  static const String questions = 'questions';

  /// Colección de nodos del mapa.
  static const String nodes = 'nodes';
}
