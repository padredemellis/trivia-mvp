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
                themeImages[box.title] ?? 'assets/images/default.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[300],
                    child: const Icon(Icons.error, color: Colors.red, size: 30),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: kDouble5),
          Text(
            'Level ${box.nodeId}',
            style: const TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            box.title,
            style: const TextStyle(fontSize: 14.0),
          ),
        ],
      ),
    );
  }
}