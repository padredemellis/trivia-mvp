import 'package:flutter/material.dart';

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
            image: AssetImage('assets/images/leaf_background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: <Widget>[
              // Título en la parte superior
              Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Text(
                  'Ditsy & Friends',
                  style: TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.pink,
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

              // Espacio flexible antes del personaje con botones de cambio
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Spacer(),

                      // Botón flecha izquierda
                      GestureDetector(
                        onTap: () => changeCharacter(-1),
                        child: Image.asset(
                          'assets/images/flecha_cambio_de_personaje_izquierda.png',
                          height: 40,
                          width: 40,
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

                      // Botón flecha derecha
                      GestureDetector(
                        onTap: () => changeCharacter(1),
                        child: Image.asset(
                          'assets/images/flecha_cambio_de_personaje_derecha.png',
                          height: 40,
                          width: 40,
                        ),
                      ),

                      Spacer(),
                    ],
                  ),
                ),
              ),

              // Botones en la parte inferior
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                        textStyle: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text('PLAY'),
                    ),
                    SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                        textStyle: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text('SETTINGS'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ); // Scaffold
  }
}
