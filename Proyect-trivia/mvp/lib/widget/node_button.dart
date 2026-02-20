import 'package:flutter/material.dart';
import 'package:mvp/data/models/node.dart';
import 'package:mvp/core/constants/constants.dart';
import 'package:mvp/core/constants/text_styles.dart';
import 'package:mvp/core/constants/app_color.dart';
import 'package:mvp/core/di/injection_container.dart' as di;
import 'package:mvp/domain/engine/game_engine.dart';

class NodeButton extends StatefulWidget {
  const NodeButton({super.key, required this.box});
  final Node box;

  @override
  State<NodeButton> createState() => _NodeButtonState();
}

class _NodeButtonState extends State<NodeButton> {
  bool isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: () {
          final engine = di.sl<GameEngine>();
          engine.startNode(widget.box.nodeId);
        },
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: isHovering ? 80 : 70,
              height: isHovering ? 80 : 70,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: isHovering
                        ? Colors.yellow.withOpacity(0.5)
                        : const Color.fromARGB(255, 106, 169, 70).withOpacity(0.1),
                    spreadRadius: isHovering ? 6 : 3,
                    blurRadius: isHovering ? 40 : 5,
                  ),
                ],
              ),
              child: Image.asset(
                themeImages[widget.box.title] ??
                    'assets/images/default.png',
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: kDouble5),
            Text(
              'Level ${widget.box.nodeId}',
              style: TextStyles.level,
            ),
            Text(
              widget.box.title,
              style: TextStyles.categoria,
            ),
          ],
        ),
      ),
    );
  }
}