import 'package:flutter/material.dart';
import 'package:mvp/core/constants/text_styles.dart';
import 'package:mvp/widget/animated_hover_button.dart';
import 'package:mvp/core/constants/app_color.dart';
import 'package:mvp/core/di/injection_container.dart' as di;
import 'package:mvp/domain/engine/game_engine.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentCharacterIndex = 0;

  final List<String> characterImages = [
    'assets/images/skin_zorro.png',
    'assets/images/personaje_bloqueado.png',
  ];

  void changeCharacter(int direction) {
    setState(() {
      currentCharacterIndex =
          (currentCharacterIndex + direction) % characterImages.length;

      if (currentCharacterIndex < 0) {
        currentCharacterIndex = characterImages.length - 1;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              // Título
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Text(
                  'BESTIA TRIVIA',
                  style: TextStyles.categoria.copyWith(
                    fontSize: 50, fontFamily: 'LuckiestGuy', color: AppColor.amarillo,
                    shadows: [
                      Shadow(
                        offset: Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),

              // Personaje con flechas
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),

                      GestureDetector(
                        onTap: () => changeCharacter(-1),
                        child: Image.asset(
                          'assets/images/flecha_izq.png',
                          height: 60,
                          width: 60,
                        ),
                      ),

                      SizedBox(width: 20),

                      Expanded(
                        flex: 3,
                        child: Image.asset(
                          characterImages[currentCharacterIndex],
                          height: 450,
                          width: 450,
                          fit: BoxFit.contain,
                        ),
                      ),

                      SizedBox(width: 20),

                      GestureDetector(
                        onTap: () => changeCharacter(1),
                        child: Image.asset(
                          'assets/images/flecha_der.png',
                          height: 60,
                          width: 60,
                        ),
                      ),

                      Spacer(),
                    ],
                  ),
                ),
              ),
              
              // Botones inferiores
              Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: Column(
                  children: [
                    AnimatedHoverButton(
                      text: 'PLAY',
                      onPressed: currentCharacterIndex == 1
                          ? null
                          : () {
                              final engine = di.sl<GameEngine>();
                              engine.goToMap();
                            },
                    ),

                    const SizedBox(height: 15),

                    AnimatedHoverButton(
                      text: 'SETTINGS',
                      onPressed: () {
                        print("Settings clicked");
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}