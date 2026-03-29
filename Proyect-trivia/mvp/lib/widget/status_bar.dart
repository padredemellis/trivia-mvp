import 'package:flutter/material.dart';
import 'package:mvp/core/constants/text_styles.dart';
import 'package:mvp/core/constants/app_color.dart';
import 'package:mvp/data/models/player.dart';

// EXPLICACIÓN DEL CÓDIGO CORREGIDO:
// 1. Eliminamos el import de inyección de dependencias (di) y el GameEngine.
// ¿Por qué? Porque un simple widget de barra de estado no debería "hablar" 
// directamente con el motor del juego. Su único trabajo es verse bonito
// con la información que le den.

class PlayerStatusBar extends StatelessWidget {
  final Player player; 
  
  // 3. Modificamos el constructor para guardar a ese jugador en nuestra variable.
  const PlayerStatusBar({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.4),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SECCIÓN DE PUNTOS
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 22,
                ),
                const SizedBox(width: 4),
                Text(
                  player.points.toString(),
                  style: TextStyles.bar.copyWith(
                    fontSize: 16,
                    color: AppColor.amarillo,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 10),

            // SECCIÓN DE VIDAS
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 22,
                ),
                const SizedBox(width: 4),
                Text(
                  player.lives.toString(),
                  style: TextStyles.bar.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}