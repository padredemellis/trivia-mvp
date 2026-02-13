import 'package:flutter/material.dart';
import 'package:mvp/core/di/injection_container.dart' as di;
import 'package:mvp/core/enums/game_state.dart';
import 'package:mvp/domain/engine/game_engine.dart';
import 'package:mvp/domain/engine/game_engine_state.dart';

/// Manejador central de la interfaz de usuario.
///
/// Su función es escuchar reactivamente el estado del [GameEngine]
/// y determinar qué pantalla debe mostrarse en cada momento.
///
/// Este componente actúa como el punto de entrada principal de la navegación
/// basada en estados del juego.
class GameOrchestrator extends StatelessWidget {
  const GameOrchestrator({super.key});

  @override
  Widget build(BuildContext context) {
    /// Obtiene la instancia única del motor de juego desde el Service Locator.
    final engine = di.sl<GameEngine>();

    /// Escucha el flujo de estados emitidos por el motor.
    /// [initialData] asegura que la UI tenga un estado válido desde el primer frame.
    return StreamBuilder<GameEngineState>(
      stream: engine.stateStream,
      initialData: engine.state,
      builder: (context, snapshot) {
        /// Obtenemos los datos del estado actual. 
        /// Usamos el operador [!] porque initialData garantiza que no sea nulo.
        final state = snapshot.data!;

        /// Selector lógico de pantallas basado en el enum [GameState].
        switch (state.status) {
          
          /// Estado de carga: Se muestra mientras se obtienen datos de Firebase.
          case GameState.loading:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );

          /// Estado de reposo o navegación: El usuario está en el mapa de niveles.
          case GameState.idle:
          case GameState.navigating:
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => engine.startNode(1),
                  child: const Text("Empezar Nivel 1"),
                ),
              ),
            );

          /// Estado de juego activo: Se muestra la interfaz de la trivia.
          case GameState.playing:
            return const Scaffold(
              body: Center(child: Text("Pantalla de Trivia")),
            );

          /// Estado de derrota: Se muestra cuando el jugador agota sus vidas.
          case GameState.gameOver:
            return const Scaffold(
              body: Center(child: Text("Juego Terminado")));

          /// Estado de éxito: Se muestra al completar todas las preguntas del nodo.
          case GameState.nodeCompleted:
            return const Scaffold(
              body: Center(child: Text("¡Nivel Superado!")),
            );

          /// Caso por defecto para manejar estados no contemplados explícitamente.
          default:
            return const Scaffold(
              body: Center(child: Text("Estado no manejado")),
            );
        }
      },
    );
  }
}