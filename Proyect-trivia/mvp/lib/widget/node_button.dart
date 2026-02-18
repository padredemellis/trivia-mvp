import 'package:flutter/material.dart';
import 'package:mvp/data/models/node.dart';
import 'package:mvp/core/constants/constants.dart';
import 'package:mvp/core/constants/text_styles.dart';
import 'package:mvp/core/constants/app_color.dart';
import 'package:mvp/core/di/injection_container.dart' as di;
import 'package:mvp/domain/engine/game_engine.dart';
//import 'package:mvp/pages/quiz.dart';

class NodeButton extends StatelessWidget {
  const NodeButton({super.key, required this.box});
  final Node box;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final engine = di.sl<GameEngine>();
        engine.startNode(box.nodeId);
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
                  color: AppColor.verdeOscuro.withOpacity(0.3),
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
            style: TextStyles.level,
            ),
          Text(
            box.title,
            style: TextStyles.categoria,
          ),
        ],
      ),
    );
  }
}