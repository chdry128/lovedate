import 'package:flutter/material.dart';
import 'dart:math';

class LetterBackground extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;

  LetterBackground({required this.primaryColor, required this.secondaryColor});

  @override
  void paint(Canvas canvas, Size size) {
    // Background
    final Paint backgroundPaint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // Decorative border
    final Paint borderPaint =
        Paint()
          ..color = primaryColor.withOpacity(0.2)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2;

    final double borderPadding = 15;
    final Rect borderRect = Rect.fromLTWH(
      borderPadding,
      borderPadding,
      size.width - (borderPadding * 2),
      size.height - (borderPadding * 2),
    );

    canvas.drawRect(borderRect, borderPaint);

    // Corner decorations
    _drawCornerDecoration(
      canvas,
      Offset(borderPadding, borderPadding),
      0,
      size,
    );
    _drawCornerDecoration(
      canvas,
      Offset(size.width - borderPadding, borderPadding),
      pi / 2,
      size,
    );
    _drawCornerDecoration(
      canvas,
      Offset(size.width - borderPadding, size.height - borderPadding),
      pi,
      size,
    );
    _drawCornerDecoration(
      canvas,

      Offset(borderPadding, size.height - borderPadding),

      3 * pi / 2,
      size,
    );

    // Heart patterns
    final random = Random(42); // Fixed seed for consistent pattern

    for (int i = 0; i < 10; i++) {
      final double x = random.nextDouble() * size.width;
      final double y = random.nextDouble() * size.height;
      final double heartSize = random.nextDouble() * 10 + 5;
      final double opacity = random.nextDouble() * 0.1 + 0.05;

      _drawHeart(
        canvas,
        Offset(x, y),
        heartSize,
        secondaryColor.withOpacity(opacity),
      );
    }
  }

  void _drawCornerDecoration(
    Canvas canvas,
    Offset center,
    double rotation,
    Size size,
  ) {
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotation);

    final Paint decorPaint =
        Paint()
          ..color = primaryColor.withOpacity(0.3)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.5;

    final Path path = Path();
    final double decorSize = 20;

    // Draw a decorative corner flourish
    path.moveTo(0, -decorSize);
    path.quadraticBezierTo(decorSize * 0.5, -decorSize * 0.5, decorSize, 0);

    canvas.drawPath(path, decorPaint);
    canvas.restore();
  }

  void _drawHeart(Canvas canvas, Offset center, double size, Color color) {
    final Paint heartPaint =
        Paint()
          ..color = color
          ..style = PaintingStyle.fill;

    final Path path = Path();
    path.moveTo(center.dx, center.dy + size * 0.3);
    path.cubicTo(
      center.dx,
      center.dy,
      center.dx - size,
      center.dy - size * 0.5,
      center.dx - size * 0.5,
      center.dy - size,
    );
    path.cubicTo(
      center.dx - size * 0.25,
      center.dy - size * 1.25,
      center.dx + size * 0.25,
      center.dy - size * 1.25,
      center.dx + size * 0.5,
      center.dy - size,
    );
    path.cubicTo(
      center.dx + size,
      center.dy - size * 0.5,
      center.dx,
      center.dy,
      center.dx,
      center.dy + size * 0.3,
    );

    canvas.drawPath(path, heartPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
