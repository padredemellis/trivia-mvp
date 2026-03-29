import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
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
    if (!mostrarResultado) {
      return AppColor.backgroundCrema;
    }
    if (esCorrecta) {
      return AppColor.backgroundVerde;
    } else {
      return AppColor.rosa;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor(),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          minimumSize: const Size(double.infinity, 56),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
        child: AutoSizeText(
          texto,
          style: TextStyles.respuesta,
          textAlign: TextAlign.center,
          maxLines: 2,
          minFontSize: 12,
          stepGranularity: 1,
          wrapWords: true,
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }
}
