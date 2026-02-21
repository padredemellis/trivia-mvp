import 'package:flutter/material.dart';
import 'package:mvp/widget/pregunta_widget.dart';
import 'package:mvp/widget/respuesta_widget.dart';

class TriviaScreen extends StatelessWidget {
  final String questionText;
  final List<String> options;
  final int lives;
  final String category;
  final String currentNode;
  final Function(String) onOptionSelected;
  final VoidCallback onQuit;

  const TriviaScreen({
    super.key,
    required this.questionText,
    required this.options,
    required this.lives,
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red),
                const SizedBox(width: 5),
                Text(
                  "$lives",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
        backgroundColor: const Color(0xFFA1CF58),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/mockup.png'),
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
                child: PreguntaWidget(texto: questionText),
              ),
            ),
          ),

          // Opciones abajo
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: ListView.builder(
                itemCount: options.length,
                itemBuilder: (context, index) {
                  return RespuestasWidget(
                    texto: options[index],
                    esCorrecta: false,
                    mostrarResultado: false,
                    onTap: () => onOptionSelected(options[index]),
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
