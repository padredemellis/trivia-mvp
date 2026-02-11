import 'package:flutter/material.dart';
import 'package:mvp/core/di/injection_container.dart' as di;
import 'package:mvp/core/enums/game_state.dart';
import 'package:mvp/domain/engine/game_engine.dart';
import 'package:mvp/domain/engine/game_engine_state.dart';

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
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => engine.startNode(1),
                  child: const Text("Empezar Nivel 1"),
                ),
              ),
            );

          case GameState.playing:
            return const Scaffold(
              body: Center(child: Text("Pantalla de Trivia")),
            );

          case GameState.gameOver:
            return const Scaffold(body: Center(child: Text("Juego Terminado")));

          case GameState.nodeCompleted:
            return const Scaffold(
              body: Center(child: Text("¡Nivel Superado!")),
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
