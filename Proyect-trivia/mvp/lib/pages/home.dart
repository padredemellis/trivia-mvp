import 'package:flutter/material.dart';
import 'package:mvp/core/constants/app_color.dart';
import 'package:mvp/core/constants/text_styles.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentCharacterIndex = 0;

  final List<String> characterImages = [
    'assets/images/personaje_2d.png',
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
                  style: TextStyles.level.copyWith(
                    fontSize: 32,
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

                      // Flecha izquierda
                      GestureDetector(
                        onTap: () => changeCharacter(-1),
                        child: Image.asset(
                          'assets/images/flecha_izq.png',
                          height: 100,
                          width: 100,
                        ),
                      ),

                      SizedBox(width: 20),

                      // Personaje
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

                      // Flecha derecha
                      GestureDetector(
                        onTap: () => changeCharacter(1),
                        child: Image.asset(
                          'assets/images/flecha_der.png',
                          height: 100,
                          width: 100,
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
                    ElevatedButton(
                      onPressed: currentCharacterIndex == 1
                          ? null
                          : () {
                              Navigator.pushNamed(context, '/map');
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.backgroundCrema, // crema
                        foregroundColor: AppColor.oscuro, // color del texto
                        padding: EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 20,
                        ),
                      ),
                      child: Text('PLAY', style: TextStyles.grande),
                    ),

                    SizedBox(height: 15),

                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.backgroundCrema, // crema
                        foregroundColor: AppColor.oscuro, // color del texto
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 20,
                        ),
                        textStyle: TextStyles.grande,
                      ),
                      child: Text('SETTINGS', style: TextStyles.grande),
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
