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

class _HomeState extends State<Home>
    with SingleTickerProviderStateMixin {

  int currentCharacterIndex = 0;

  late AnimationController _controller;
  late Animation<double> _breathingAnimation;

  final List<String> characterImages = [
    'assets/images/skin_zorro.png',
    'assets/images/personaje_bloqueado.png',
  ];

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _breathingAnimation = Tween<double>(
      begin: 0.98,
      end: 1.02,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
              const SizedBox(height: 20),

              // Titulo
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Text(
                  'BEAST QUIZ',
                  style: TextStyles.categoria.copyWith(
                    fontSize: 55,
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
                        size: 40,
                        onPressed: () => changeCharacter(-1),
                      ),

                      const SizedBox(width: 20),

                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: AnimatedBuilder(
                            animation: _breathingAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _breathingAnimation.value,
                                child: child,
                              );
                            },
                            child: Image.asset(
                              characterImages[currentCharacterIndex],
                              height: 500,
                              width: 500,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 20),

                      AnimatedIconButton(
                        imagePath: 'assets/images/right.png',
                        size: 40,
                        onPressed: () => changeCharacter(1),
                      ),

                      const Spacer(),
                    ],
                  ),
                ),
              ),

              // Descripcion
              Text(
                'Choose your character!',
                style: TextStyles.categoria.copyWith(
                  fontSize: 22,
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
