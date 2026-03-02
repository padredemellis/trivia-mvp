import 'package:flutter/material.dart';
import 'package:mvp/core/constants/text_styles.dart';
// 1. Importamos la nueva herramienta
import 'package:auto_size_text/auto_size_text.dart';

class PreguntaWidget extends StatefulWidget {
  final String texto;

  const PreguntaWidget({super.key, required this.texto});

  @override
  State<PreguntaWidget> createState() => _PreguntaWidgetState();
}

class _PreguntaWidgetState extends State<PreguntaWidget> {
  int _charCount = 0;

  // 2. Creamos un grupo para sincronizar los tamaños
  final AutoSizeGroup _myGroup = AutoSizeGroup();

  @override
  void initState() {
    super.initState();
    _animateText();
  }

  @override
  void didUpdateWidget(covariant PreguntaWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.texto != widget.texto) {
      setState(() {
        _charCount = 0;
      });
      _animateText();
    }
  }

  Future<void> _animateText() async {
    final originalText = widget.texto;
    for (int i = 0; i <= originalText.length; i++) {
      await Future.delayed(const Duration(milliseconds: 30));
      if (!mounted || widget.texto != originalText) return;
      setState(() => _charCount = i);
    }
  }

  @override
  Widget build(BuildContext context) {
    final safeCharCount = _charCount.clamp(0, widget.texto.length);

    return Stack(
      children: [
        // 1. El molde invisible (Texto Completo)
        AutoSizeText(
          widget.texto,
          style: TextStyles.pregunta.copyWith(color: Colors.transparent),
          group: _myGroup,
          maxLines: 7, // 👈 Aumentamos los renglones permitidos
          minFontSize: 10, // 👈 Tamaño mínimo de letra permitido
        ),

        // 2. El texto visible (Animación)
        AutoSizeText(
          widget.texto.substring(0, safeCharCount),
          style: TextStyles.pregunta,
          textAlign: TextAlign.left,
          group: _myGroup,
          maxLines: 7, // 👈 Debe ser exactamente igual al molde
          minFontSize: 10, // 👈 Debe ser exactamente igual al molde
        ),
      ],
    );
  }
}
