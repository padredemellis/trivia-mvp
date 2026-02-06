import 'package:mvp/models/node.dart';
import 'package:mvp/core/constants.dart';
import 'package:flutter/material.dart';
import 'package:mvp/pages/quiz.dart';
import 'package:mvp/pages/quiz.dart';

class CardWidget extends StatelessWidget {
  const CardWidget({super.key, required this.box});
  final Node box;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => QuizPage(box: box)));
      },
      child: Card(
        child: Container(
          padding: EdgeInsets.all(kDouble5),
          width: double.infinity,
          child: Column(
            children: [
              SizedBox(height: kDouble5),
              SizedBox(
                width: 120,
                height: 120,
                child: Image.asset(
                  themeImages[box.tema] ?? 'images/default.png',
                  fit: BoxFit.contain,
                ),
              ),
              SizedBox(height: kDouble5),
              Text(
                box.title,
                style: const TextStyle(
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(box.tema, style: const TextStyle(fontSize: 14.0)),
            ],
          ),
        ),
      ),
    );
  }
}
