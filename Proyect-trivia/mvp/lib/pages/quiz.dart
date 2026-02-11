import 'package:mvp/data/models/node.dart';
import 'package:flutter/material.dart';

class QuizPage extends StatelessWidget {
  const QuizPage({super.key, required this.box});
  final Node box;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Quiz ${box.title}')),
      body: const Center(child: Text('This is the Quiz Page')),
    );
  }
}
