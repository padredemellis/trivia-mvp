import 'package:flutter/material.dart';
import 'package:mvp/core/constants/text_styles.dart';
import 'package:auto_size_text/auto_size_text.dart';

class PreguntaWidget extends StatefulWidget {
  final String texto;

  const PreguntaWidget({super.key, required this.texto});

  @override
  State<PreguntaWidget> createState() => _PreguntaWidgetState();
}

class _PreguntaWidgetState extends State<PreguntaWidget> {
  int _charCount = 0;

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
    final animatedText = widget.texto.substring(0, safeCharCount);

    return ClipRect(
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.hardEdge,
        children: [
          AutoSizeText(
            widget.texto,
            style: TextStyles.pregunta.copyWith(color: Colors.transparent),
            textAlign: TextAlign.left,
            softWrap: true,
            wrapWords: true,
            overflow: TextOverflow.ellipsis,
            group: _myGroup,
            maxLines: 7,
            minFontSize: 10,
          ),
          AutoSizeText(
            animatedText,
            style: TextStyles.pregunta,
            textAlign: TextAlign.left,
            softWrap: true,
            wrapWords: true,
            overflow: TextOverflow.ellipsis,
            group: _myGroup,
            maxLines: 7,
            minFontSize: 10,
          ),
        ],
      ),
    );
  }
}
