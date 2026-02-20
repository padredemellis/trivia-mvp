import 'package:flutter/material.dart';
import 'package:mvp/core/constants/text_styles.dart';
import 'package:mvp/widget/animated_hover_button.dart';
import 'package:mvp/core/constants/app_color.dart';
import 'package:mvp/core/di/injection_container.dart' as di;
import 'package:mvp/domain/engine/game_engine.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/fondo.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              SizedBox(height: 30),
              // Titulo
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Text(
                  'BEAST & QUIZ',
                  style: TextStyles.categoria.copyWith(
                    fontSize: 50,
                    fontFamily: 'LuckiestGuy',
                    color: AppColor.amarillo,
                    shadows: [
                      Shadow(
                        offset: const Offset(2.0, 2.0),
                        blurRadius: 3.0,
                        color: Colors.black.withOpacity(0.5),
                      ),
                    ],
                  ),
                ),
              ),

              // Body - Personaje
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),

                      AnimatedIconButton(
                        imagePath: 'assets/images/left.png',
                        size: 50,
                        onPressed: () => changeCharacter(-1),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Image.asset(
                            characterImages[currentCharacterIndex],
                            height: 450,
                            width: 450,
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      AnimatedIconButton(
                        imagePath: 'assets/images/right.png',
                        size: 50,
                        onPressed: () => changeCharacter(1),
                      ),

                      const Spacer(),
                    ],
                  ),
                ),
              ),

              // descripcion
              Text(
                'Choose your character and start the adventure!',
                style: TextStyles.categoria.copyWith(
                  fontSize: 18,
                  color: AppColor.oscuro.withOpacity(0.8),
                ),
              ),

              const SizedBox(height: 30),

              // Botones inferiores
              Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedIconButton(
                      imagePath: 'assets/images/play.png',
                      onPressed: currentCharacterIndex == 1
                          ? null
                          : () {
                              final engine = di.sl<GameEngine>();
                              engine.goToMap();
                            },
                    ),
                      const SizedBox(width: 40),
                    AnimatedIconButton(
                      imagePath: 'assets/images/setting.png',
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
