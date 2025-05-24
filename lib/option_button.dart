import 'package:flutter/cupertino.dart';

class OptionButton extends StatefulWidget {
  final String text;
  final VoidCallback? onTap;
  final Color color;

  const OptionButton({
    super.key,
    required this.text,
    required this.onTap,
    required this.color,
  });

  @override
  State<OptionButton> createState() => _OptionButtonState();
}

class _OptionButtonState extends State<OptionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.identity()
          ..scale(_isPressed ? 0.95 : 1.0),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: widget.color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: widget.color.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: _isPressed
              ? []
              : [
            BoxShadow(
              color: widget.color.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Text(
          widget.text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            color: widget.color.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}