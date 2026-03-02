import 'package:flutter/material.dart';
import 'package:mvp/core/di/injection_container.dart' as di;
import 'package:mvp/core/enums/game_state.dart';
import 'package:mvp/domain/engine/game_engine.dart';
import 'package:mvp/domain/engine/game_engine_state.dart';
import 'package:mvp/pages/map.dart';
import 'package:mvp/pages/home.dart';
import 'package:mvp/pages/trivia_screen.dart';

class GameOrchestrator extends StatelessWidget {
  const GameOrchestrator({super.key});

  @override
  Widget build(BuildContext context) {
    final engine = di.sl<GameEngine>();

    return StreamBuilder<GameEngineState>(
      stream: engine.stateStream,
      initialData: engine.state,
      builder: (context, snapshot) {
        final state = snapshot.data!;

        switch (state.status) {
          case GameState.loading:
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );

          case GameState.idle:
            return Home();

          case GameState.navigating:
            return HomePage();

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
              player: state.player,
              category: currentQuestion.category,
              currentNode:
                  "${state.currentQuestionIndex + 1} / ${state.currentQuestions?.length ?? '?'}",

              selectedCharacter: 'assets/images/skin_fox2.png',

              onOptionSelected: (selectedAnswer) async {
                return await engine.answerQuestion(selectedAnswer);
              },

              onQuit: () {
                engine.resetGame();
              },
            );

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
                      onPressed: () => engine.goToMap(),
                      child: const Text(
                        "Continuar",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ],
                ),
              ),
            );

          default:
            return const Scaffold(
              body: Center(child: Text("Estado no manejado")),
            );
        }
      },
    );
  }
}
