import 'dart:math';

class ItemClass {
  final String title;
  final String tema;

  static const List<String> temas = [
    'Arte y entretenimiento',
    'Ciencias Naturales',
    'Ciencias sociales',
    'Actualidad',
    'Historia'
  ];

  ItemClass({required int nivel})
    : title = 'Nivel $nivel',
      tema = temas[Random().nextInt(temas.length)];
}