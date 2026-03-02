import 'package:flutter/material.dart';
import 'package:mvp/data/models/node.dart';
import 'package:mvp/core/constants/constants.dart';
import 'package:mvp/core/constants/text_styles.dart';
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
    final engine = di.sl<GameEngine>();
    final bool isUnlocked = engine.isNodeUnlocked(widget.box.nodeId);
    final bool isCompleted = engine.isNodeCompleted(widget.box.nodeId);

    return MouseRegion(
      onEnter: (_) {
        if (isUnlocked) setState(() => isHovering = true);
      },
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        onTap: isUnlocked ? () => engine.startNode(widget.box.nodeId) : null,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              width: isHovering ? 80 : 70,
              height: isHovering ? 80 : 70,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: isUnlocked
                        ? (isHovering
                            ? Colors.yellow.withOpacity(0.5)
                            : const Color.fromARGB(255, 84, 135, 55)
                                .withOpacity(0.1))
                        : Colors.transparent,
                    spreadRadius: isHovering ? 6 : 3,
                    blurRadius: isHovering ? 40 : 5,
                  ),
                ],
              ),
              child: Opacity(
                opacity: isUnlocked ? 1 : 0.4,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      themeImages[widget.box.category] ??
                          'assets/images/default.png',
                      fit: BoxFit.contain,
                    ),

                    Text(
                      '${widget.box.nodeId}',
                      style: TextStyles.bar.copyWith(
                        shadows: const [
                          Shadow(
                            blurRadius: 6,
                            color: Colors.black,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),

                    if (!isUnlocked)
                      const Icon(Icons.lock, size: 28, color: Colors.white),

                    if (isCompleted)
                      const Icon(
                        Icons.check_circle,
                        color: Colors.amberAccent,
                        size: 30,
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: kDouble5),

            Text(widget.box.category, style: TextStyles.categoria),
          ],
        ),
      ),
    );
  }
}