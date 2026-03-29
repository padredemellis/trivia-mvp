import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mvp/data/models/answer_feedback.dart';
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

  final Future<AnswerFeedback?> Function(String) onOptionSelected;

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
    Future<void> handleOptionTap(String userAnswer) async {
      final feedback = await onOptionSelected(userAnswer);

      if (!context.mounted || feedback == null) return;

      final text = feedback.isCorrect
          ? "Respuesta correcta, ¡sigue así!"
          : 'Respuesta equivocada. La respuesta correcta era: "${feedback.correctAnswer}"';

      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: feedback.isCorrect ? Colors.green : Colors.red,
          duration: const Duration(seconds: 2),
          content: Text(text),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFE4F0D6),
      appBar: AppBar(
        title: Text("$category - Nivel $currentNode"),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: onQuit),
        actions: [PlayerStatusBar(player: player)],
        backgroundColor: const Color.fromARGB(255, 145, 183, 85),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideWeb = kIsWeb && constraints.maxWidth >= 900;
          const desktopMobileScale = 0.46;
          final safeBottom = MediaQuery.of(context).padding.bottom;

          final sceneWidth = isWideWeb
              ? (constraints.maxWidth * desktopMobileScale)
                    .clamp(420.0, 620.0)
                    .toDouble()
              : constraints.maxWidth;
          final sceneHeight = constraints.maxHeight;

          final questionTop = sceneHeight * 0.12;
          final questionLeft = sceneWidth * 0.05;
          final questionWidth = sceneWidth * 0.38;
          final questionHeight = sceneHeight * 0.20;
          final questionInnerPadding = EdgeInsets.fromLTRB(
            sceneWidth * 0.02,
            sceneHeight * 0.012,
            sceneWidth * 0.05,
            sceneHeight * 0.006,
          );

          final scene = SizedBox(
            width: sceneWidth,
            height: sceneHeight,
            child: Stack(
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
                  top: questionTop,
                  left: questionLeft,
                  width: questionWidth,
                  height: questionHeight,
                  child: Padding(
                    padding: questionInnerPadding,
                    child: SizedBox.expand(
                      child: PreguntaWidget(texto: questionText),
                    ),
                  ),
                ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(24, 12, 24, 14 + safeBottom + 10),
                    child: LayoutBuilder(
                      builder: (context, _) {
                        final optionCount = options.isEmpty ? 1 : options.length;
                        final availableHeight =
                            (sceneHeight * 0.34).clamp(210.0, 340.0).toDouble();
                        final spacing = 7.0;
                        final buttonHeight = ((availableHeight -
                                    (optionCount - 1) * spacing) /
                                optionCount)
                            .clamp(46.0, 62.0)
                            .toDouble();

                        return SizedBox(
                          width: double.infinity,
                          height: availableHeight,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: List.generate(options.length, (index) {
                              final isLast = index == options.length - 1;
                              return Padding(
                                padding: EdgeInsets.only(
                                  bottom: isLast ? 0 : spacing,
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: buttonHeight,
                                  child: RespuestasWidget(
                                    texto: options[index],
                                    esCorrecta: false,
                                    mostrarResultado: false,
                                    onTap: () => handleOptionTap(options[index]),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );

          return Align(
            alignment: Alignment.topCenter,
            child: isWideWeb
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Container(
                      width: sceneWidth,
                      height: sceneHeight - 20,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: const Color(0x33111111), width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 20,
                            offset: Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: scene,
                      ),
                    ),
                  )
                : scene,
          );
        },
      ),
    );
  }
}