import 'package:flutter/material.dart';
import 'package:mvp/core/constants/text_styles.dart';
import 'package:mvp/widget/animated_hover_button.dart';
import 'package:mvp/core/constants/app_color.dart';
import 'package:mvp/core/di/injection_container.dart' as di;
import 'package:mvp/data/repositories/player_repository.dart';
import 'package:mvp/data/models/player.dart';
import 'package:mvp/domain/engine/game_engine.dart';
import 'package:mvp/domain/use-cases/login_use_case.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int currentCharacterIndex = 0;
  bool _isLoading = false; // Variable de estado para el login

  late AnimationController _controller;
  late Animation<double> _breathingAnimation;

  final List<String> characterImages = [
    'assets/images/skin_fox2.png',
    'assets/images/skin_cat.png',
    'assets/images/rana.png',
    'assets/images/oveja.png',
    'assets/images/block.png',
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
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
            image: AssetImage('assets/images/Background_forest.png'),
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
                    // Renderizado condicional del botón PLAY
                    _isLoading
                        ? const SizedBox(
                            width: 60,
                            height: 60,
                            child: CircularProgressIndicator(
                              color: AppColor.amarillo,
                              strokeWidth: 4,
                            ),
                          )
                        : AnimatedIconButton(
                            imagePath: 'assets/images/play2.png',
                            onPressed: currentCharacterIndex == 4
                                ? null
                                : () async {
                                    setState(() {
                                      _isLoading = true;
                                    });

                                    final loginUseCase = di.sl<LoginUseCase>();
                                    final userCredential = await loginUseCase();

                                    if (mounted) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                    }

                                    if (userCredential != null &&
                                        userCredential.user != null) {
                                      final engine = di.sl<GameEngine>();
                                      final playerRepo = di.sl<PlayerRepository>();
                                      final uid = userCredential.user!.uid;

                                      // 1. Buscamos al jugador en Firestore
                                      Player? myPlayer = await playerRepo.getPlayer(uid);

                                      print("🔥 [HOME] LEYENDO FIRESTORE. Vidas encontradas: ${myPlayer?.lives}");

                                      if (myPlayer != null) {
                                        await di.sl<PlayerRepository>().updatePlayer(myPlayer);
                                      }

                                      if (myPlayer != null) {
                                        // 2. Evaluamos si el jugador perdió todas las vidas
                                        if (myPlayer.lives <= 0) {
                                          
                                          // 3. Reiniciamos las vidas en RAM usando copyWith
                                          final playerReseteado = myPlayer.copyWith(lives: 3);
                                          
                                          // 4. Persistimos el reinicio en Firestore usando tu método optimizado
                                          await playerRepo.updateLives(uid, 3);
                                          
                                          // 5. Inyectamos al jugador curado en el motor
                                          engine.setAuthenticatedPlayer(playerReseteado);
                                        } else {
                                          // 6. Si tiene 1, 2 o 3 vidas, inyectamos el jugador tal cual para respetar tu persistencia
                                          engine.setAuthenticatedPlayer(myPlayer);
                                        }
                                      } else {
                                        // 7. Si es un jugador nuevo
                                        final newPlayer = Player(
                                          userId: uid,
                                          name: userCredential.user!.displayName ?? 'Jugador Nuevo',
                                          // lives: 3 viene por defecto en el constructor de player.dart
                                        );
                                        
                                        // 8. Guardamos al jugador nuevo en Firestore
                                        await playerRepo.savePlayer(newPlayer);
                                        
                                        engine.setAuthenticatedPlayer(newPlayer);
                                      }

                                      // 9. Navegamos al mapa
                                      engine.goToMap();
                                    } else {
                                      if (mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                              'No se pudo iniciar sesión. Intenta de nuevo.',
                                            ),
                                            backgroundColor: Colors.red,
                                          ),
                                        );
                                      }
                                    }
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