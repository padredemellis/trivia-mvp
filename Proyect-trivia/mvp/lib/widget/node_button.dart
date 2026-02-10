import 'package:flutter/material.dart';
import 'package:mvp/models/node.dart';
import 'package:mvp/core/constants/constants.dart';
import 'package:mvp/pages/quiz.dart';

class NodeButton extends StatelessWidget {
  const NodeButton({super.key, required this.box});
  final Node box;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => QuizPage(box: box)),
        );
      },
      child: Column(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 2,
                  blurRadius: 5,
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                themeImages[box.title] ?? 'images/default.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(height: kDouble5),
          Text(
            box.title,
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(box.title, style: const TextStyle(fontSize: 14.0)),
        ],
      ),
    );
  }
}
