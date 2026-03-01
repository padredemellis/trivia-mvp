import 'package:flutter/material.dart';

class GameResultDialog {
  static void showGameOverDialog(
    BuildContext context, {
    required VoidCallback onRetry,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "GameOver",
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Transform.scale(
          scale: anim1.value,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: const Color(0xFFFFF4E0), // Color crema/papel
            title: const Text(
              '¡GAME OVER!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.sentiment_very_dissatisfied,
                  color: Colors.red,
                  size: 80,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Te has quedado sin vidas. ¡No te rindas!',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    shape: StadiumBorder(),
                  ),
                  child: const Text(
                    'REINTENTAR',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onRetry();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static void showNodeCompletedDialog(
    BuildContext context, {
    required int pointsEarned,
    required int coinsEarned,
    required VoidCallback onContinue,
  }) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Success",
      pageBuilder: (context, anim1, anim2) => const SizedBox.shrink(),
      transitionBuilder: (context, anim1, anim2, child) {
        return Opacity(
          opacity: anim1.value,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
              side: const BorderSide(color: Color(0xFFA1CF58), width: 3),
            ),
            title: const Text(
              '¡NIVEL COMPLETADO!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF689F38),
                fontWeight: FontWeight.bold,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.stars, color: Colors.orange, size: 80),
                const SizedBox(height: 20),
                _RewardRow(
                  icon: Icons.emoji_events,
                  label: 'Puntos',
                  value: '+$pointsEarned',
                ),
                _RewardRow(
                  icon: Icons.monetization_on,
                  label: 'Monedas',
                  value: '+$coinsEarned',
                ),
              ],
            ),
            actions: [
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFA1CF58),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 12,
                    ),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    'CONTINUAR',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onContinue();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Widget auxiliar para las filas de recompensas
class _RewardRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _RewardRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.black54, size: 20),
          const SizedBox(width: 8),
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.w500)),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent,
            ),
          ),
        ],
      ),
    );
  }
}
