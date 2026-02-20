import 'package:flutter/material.dart';

class AnimatedIconButton extends StatefulWidget {
  final String imagePath;
  final VoidCallback? onPressed;
  final double size;

  const AnimatedIconButton({
    super.key,
    required this.imagePath,
    required this.onPressed,
    this.size = 60,
  });

  @override
  State<AnimatedIconButton> createState() => _AnimatedIconButtonState();
}

class _AnimatedIconButtonState extends State<AnimatedIconButton> {
  bool _isHovering = false;
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onPressed?.call();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedScale(
          scale: _isPressed
              ? 0.95
              : _isHovering
                  ? 1.1
                  : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: ClipOval(
            child: Image.asset(
              widget.imagePath,
              width: widget.size,
              height: widget.size,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}