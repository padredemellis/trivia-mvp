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
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: onQuit,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red),
                const SizedBox(width: 5),
                Text("$lives", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        ],
        backgroundColor: const Color(0xFFA1CF58),
      ),
      body: Stack(
        children: [
          // Fondo del equipo de front-end
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/fondo_quiz1.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              const SizedBox(height: 40),
              // Área de la pregunta animada
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: PreguntaWidget(texto: questionText),
                ),
              ),
              // Listado de opciones dinámicas
              Expanded(
                flex: 3,
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    return RespuestasWidget(
                      texto: options[index],
                      esCorrecta: false, // El motor maneja la validación
                      mostrarResultado: false,
                      onTap: () => onOptionSelected(options[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}