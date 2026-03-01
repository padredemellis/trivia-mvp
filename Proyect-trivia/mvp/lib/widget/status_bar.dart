import 'package:flutter/material.dart';
import 'package:mvp/core/constants/text_styles.dart';
import 'package:mvp/core/constants/app_color.dart';
import 'package:mvp/core/di/injection_container.dart' as di;
import 'package:mvp/data/models/player.dart';
import 'package:mvp/domain/engine/game_engine.dart';

class PlayerStatusBar extends StatelessWidget {
  const PlayerStatusBar({super.key, required Player player});

  @override
  Widget build(BuildContext context) {
    final engine = di.sl<GameEngine>();

    return StreamBuilder(
      stream: engine.stateStream,
      builder: (context, snapshot) {
        final player = engine.state.player;

        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 12,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.4),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // puntos
                Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.amber,
                      size: 26,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      player.points.toString(),
                      style: TextStyles.bar.copyWith(
                        fontSize: 18,
                        color: AppColor.amarillo,
                      ),
                    ),
                  ],
                ),

                // vidas
                Row(
                  children: [
                    const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 26,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      player.lives.toString(),
                      style: TextStyles.bar.copyWith(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
