import 'package:flutter/material.dart';

void main() {
  runApp(const TriviaApp());
}

class TriviaApp extends StatelessWidget {
  const TriviaApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trivia Start',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.green)),
      home: Text('This is a trivia game'),
    );
  }
}
