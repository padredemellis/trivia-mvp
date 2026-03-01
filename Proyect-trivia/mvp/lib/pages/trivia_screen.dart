import 'package:flutter/material.dart';
import 'package:mvp/widget/pregunta_widget.dart';
import 'package:mvp/widget/respuesta_widget.dart';
import 'package:mvp/widget/status_bar.dart';

import 'package:mvp/data/models/player.dart';

class TriviaScreen extends StatelessWidget {
  final String questionText;
  final List<String> options;
  final Player player;
  final String category;
  final String currentNode;
  final Function(String) onOptionSelected;
  final VoidCallback onQuit;

  const TriviaScreen({
    super.key,
    required this.questionText,
    required this.options,
    required this.player,
    required this.category,
    required this.currentNode,
    required this.onOptionSelected,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$category - Nivel $currentNode"),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: onQuit),
        actions: [
         PlayerStatusBar(player: player),
        ],
        backgroundColor: const Color.fromARGB(255, 145, 183, 85),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background_quiz.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // Pregunta en cuadrante superior izquierdo
          Positioned(
            top: 0,
            left: 0,
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.5,
              height: MediaQuery.of(context).size.height * 0.5,
              child: Padding(
                padding: const EdgeInsets.only(left: 70.0, top: 35.0),
                child: Container(
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: PreguntaWidget(texto: questionText),
                  ),
                ),
              ),
            ),
          ),

          // Opciones abajo
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: RespuestasWidget(
                        texto: options[index],
                        esCorrecta: false,
                        mostrarResultado: false,
                        onTap: () => onOptionSelected(options[index]),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
      ],
      ),
    );
  }
}
