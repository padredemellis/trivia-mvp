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
  final String selectedCharacter;
  final Function(String) onOptionSelected;
  final VoidCallback onQuit;

  static const Map<String, String> _characterBackgrounds = {
    'assets/images/skin_fox2.png': 'assets/images/background_quiz.png',
    'assets/images/skin_cat.png': 'assets/images/quiz_cat.png',
    'assets/images/rana.png': 'assets/images/skin_frong.png',
    'assets/images/oveja.png': 'assets/images/skin_sheep.png',
  };

  const TriviaScreen({
    super.key,
    required this.questionText,
    required this.options,
    required this.player,
    required this.category,
    required this.currentNode,
    required this.selectedCharacter,
    required this.onOptionSelected,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$category - Nivel $currentNode"),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: onQuit),
        actions: [PlayerStatusBar(player: player)],
        backgroundColor: const Color.fromARGB(255, 145, 183, 85),
      ),
      body: Stack(
        children: [
          // Fondo del personaje
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  _characterBackgrounds[selectedCharacter] ??
                      'assets/images/background_quiz.png',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),

      
          // Caja de texto de la pregunta (Ajustada al globo de diálogo)
          Positioned(
            top: MediaQuery.of(context).size.height * 0.12,
            left: MediaQuery.of(context).size.width * 0.05,
            width: MediaQuery.of(context).size.width * 0.38,
            height: MediaQuery.of(context).size.height * 0.20,

            child: Container(
          
              padding: const EdgeInsets.symmetric(horizontal: 4.0),

              child: Center(child: PreguntaWidget(texto: questionText)),
            ),
          ),

          
          Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.45,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24.0,
                  vertical: 16.0,
                ),
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
