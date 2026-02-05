import 'dart:math';

class Node {
  final String title;
  final String tema;

  static const List<String> temas = [
    'Cultura',
    'Ciencias',
    'Actualidad',
    'Hobbies',
  ];

  Node({required int nivel})
    : title = 'Nivel $nivel',
      tema = temas[Random().nextInt(temas.length)];
}