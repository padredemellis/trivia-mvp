import 'package:flutter/material.dart';
import 'package:mvp/core/constants/app_color.dart';
import 'package:mvp/core/constants/text_styles.dart';


class RespuestasWidget extends StatelessWidget {
  final String texto;
  final bool esCorrecta;
  final bool mostrarResultado;
  final VoidCallback onTap;

  const RespuestasWidget({
    super.key,
    required this.texto,
    required this.esCorrecta,
    required this.mostrarResultado,
    required this.onTap,
  });

  Color backgroundColor() {
    // Antes de responder
    if (!mostrarResultado) {
      return AppColor.backgroundCrema;
    }

    // Después de responder
    if (esCorrecta) {
      return AppColor.backgroundVerde;
    } else {
      return AppColor.rosa;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor(),
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ), 
          child: Text(texto, style: TextStyles.respuesta
        ),
      ),
      )
    );
  }
}