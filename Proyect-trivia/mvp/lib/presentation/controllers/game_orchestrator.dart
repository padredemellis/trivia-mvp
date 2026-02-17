import 'package:flutter/material.dart';
import 'package:mvp/core/di/injection_container.dart' as di;
import 'package:mvp/core/enums/game_state.dart';
import 'package:mvp/domain/engine/game_engine.dart';
import 'package:mvp/domain/engine/game_engine_state.dart';
import 'package:mvp/pages/map.dart';
import 'package:mvp/pages/trivia_screen.dart';
import 'package:mvp/pages/home.dart';

/// Manejador central de la interfaz de usuario.
///
/// Su función es escuchar reactivamente el estado del GameEngine
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

          /// Estado de reposo: El usuario está en la pantalla de inicio.
          case GameState.idle:
            return Home();

          /// Estado de navegación: El usuario está en el mapa de niveles.
          case GameState.navigating:
            return  HomePage();

          /// Estado de juego activo: Se muestra la interfaz de la trivia.
          case GameState.playing:
            final currentQuestion = engine.getCurrentQuestion();
            if (currentQuestion == null) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            return TriviaScreen(
              questionText: currentQuestion.text,
              options: currentQuestion.options,
              lives: state.player.lives,
              category: currentQuestion.category,
              currentNode:
                  "${state.currentQuestionIndex + 1} / ${state.currentQuestions?.length ?? '?'}",
              onOptionSelected: (selectedAnswer) {
                engine.answerQuestion(selectedAnswer);
              },
              onQuit: () {
                engine.resetGame();
              },
            );

          /// Estado de derrota: Se muestra cuando el jugador agota sus vidas.
          case GameState.gameOver:
            return Scaffold(
              backgroundColor: Colors.red[50],
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Juego Terminado ",
                      style: TextStyle(fontSize: 24),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => engine.resetGame(),
                      child: const Text("Intentar de nuevo"),
                    ),
                  ],
                ),
              ),
            );

          /// Estado de éxito: Se muestra al completar todas las preguntas del nodo.
          case GameState.nodeCompleted:
            return Scaffold(
              backgroundColor: Colors.green[50],
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "🎉 ¡Nivel Superado! 🎉",
                      style: TextStyle(fontSize: 24),
                    ),
                    Text("Puntos ganados: ${state.pointsEarned ?? 0}"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      // Vuelve al mapa/menú
                      onPressed: () => engine.goToMap(),
                      child: const Text("Continuar", style:TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
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
