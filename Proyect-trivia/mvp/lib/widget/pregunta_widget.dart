import 'package:flutter/material.dart';
import 'package:mvp/core/constants/text_styles.dart';

class PreguntaWidget extends StatefulWidget {
  final String texto;

  const PreguntaWidget({super.key, required this.texto});

  @override
  State<PreguntaWidget> createState() => _PreguntaWidgetState();
}

class _PreguntaWidgetState extends State<PreguntaWidget> {
  int _charCount = 0;

  @override
  void initState() {
    super.initState();
    _animateText();
  }

  // Detecta cuando la trivia pasa a la siguiente pregunta y reinicia la animación
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
      // Pequeña pausa entre letras
      await Future.delayed(const Duration(milliseconds: 30));
      
      // Si el widget se cierra o el texto cambia, detenemos este bucle
      if (!mounted || widget.texto != originalText) return; 
      
      setState(() => _charCount = i);
    }
  }

  @override
  Widget build(BuildContext context) {
    // EL SEGURO: clamp evita que _charCount sea mayor al texto actual (evita el error rojo)
    final safeCharCount = _charCount.clamp(0, widget.texto.length);
    
    return Text(
      widget.texto.substring(0, safeCharCount),
      style: TextStyles.pregunta,
      textAlign: TextAlign.left,
    );
  }
}