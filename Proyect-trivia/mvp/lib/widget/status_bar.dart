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
  // 2. Aquí recibimos al jugador con la información ACTUALIZADA que nos manda TriviaScreen.
  final Player player; 
  
  // 3. Modificamos el constructor para guardar a ese jugador en nuestra variable.
  const PlayerStatusBar({super.key, required this.player});

  @override
  Widget build(BuildContext context) {
    // 4. Eliminamos por completo el StreamBuilder y la consulta al engine.
    // Usaremos directamente la variable 'player' de la línea 15.

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
            // SECCIÓN DE PUNTOS
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                  size: 26,
                ),
                const SizedBox(width: 6),
                Text(
                  // 5. Imprimimos los puntos usando el jugador que recibimos
                  player.points.toString(),
                  style: TextStyles.bar.copyWith(
                    fontSize: 18,
                    color: AppColor.amarillo,
                  ),
                ),
              ],
            ),

            // SECCIÓN DE VIDAS
            Row(
              children: [
                const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 26,
                ),
                const SizedBox(width: 6),
                Text(
                  // 6. Imprimimos las vidas usando el jugador que recibimos
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
  }
}