import 'dart:math';

class Node {
  final String title;
  final String tema;

  static const List<String> temas = [
    'Arte y entretenimiento',
    'Ciencias Naturales',
    'Ciencias sociales',
    'Actualidad',
    'Historia'
  ];

  Node({required int nivel})
    : title = 'Nivel $nivel',
      tema = temas[Random().nextInt(temas.length)];
}