import 'package:flutter/material.dart';

/// Interfaz de la pantalla de trivia activa.
///
/// Uso:
/// El GameOrchestrator instancia esta pantalla cuando el estado del motor es GameState.playing.
/// Es una pantalla pasiva: recibe datos del motor y notifica acciones del usuario.
///
/// Componentes para el Front-end:
/// - questionText: Título o cuerpo de la pregunta.
/// - options: Lista de botones para las respuestas.
/// - lives: Indicador de salud/intentos restantes.
/// - currentNode: Indicador de progreso (ej: "Pregunta 1 de 5").
/// - category: Tema del nodo actual para aplicar estilos o íconos.
class TriviaScreen extends StatelessWidget {
  /// El texto de la pregunta que el jugador debe responder.
  final String questionText;

  /// Lista de strings con las opciones de respuesta disponibles.
  final List<String> options;

  /// Cantidad de vidas actuales del jugador (para mostrar corazones/energía).
  final int lives;

  /// Etiqueta de progreso actual del nivel (ej: "3 / 5").
  final String currentNode;

  /// Nombre de la categoría de la pregunta (Historia, Geografía, etc.).
  final String category;

  /// Callback que se dispara cuando el usuario selecciona una opción.
  /// Envía el String de la respuesta elegida al GameEngine.
  final Function(String) onOptionSelected;

  /// Callback para gestionar la salida del juego (botón de cerrar/atrás).
  final VoidCallback onQuit;

  const TriviaScreen({
    super.key,
    required this.questionText,
    required this.options,
    required this.lives,
    required this.currentNode,
    required this.category,
    required this.onOptionSelected,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    // Sofi y Nacho: Todo listo para que hagan su magia con el diseño.
    // Devolvemos este Scaffold básico para que la app sea funcional durante el desarrollo.
    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onQuit,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            currentNode,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              questionText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22),
            ),
          ),
          const SizedBox(height: 40),
          // Aquí es donde deben mapear las 'options' a botones de la UI.
          ...options.map((option) => ElevatedButton(
                onPressed: () => onOptionSelected(option),
                child: Text(option),
              )),
          const Spacer(),
          Text("Vidas: $lives"),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}