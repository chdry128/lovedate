import 'dart:math';
import 'package:flutter/material.dart';

class CosmicBackground extends StatefulWidget {
  final Color color1;
  final Color color2;
  final Color color3;

  const CosmicBackground({
    Key? key,
    required this.color1,
    required this.color2,
    required this.color3,
  }) : super(key: key);

  @override
  State<CosmicBackground> createState() => _CosmicBackgroundState();
}

class _CosmicBackgroundState extends State<CosmicBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<Star> _stars = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Generate stars
    for (int i = 0; i < 100; i++) {
      _stars.add(
        Star(
          x: _random.nextDouble(),
          y: _random.nextDouble(),
          size: _random.nextDouble() * 2 + 0.5,
          opacity: _random.nextDouble() * 0.7 + 0.3,
          blinkDuration: _random.nextDouble() * 3 + 1,
        ),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          painter: CosmicPainter(
            stars: _stars,
            animation: _controller.value,
            color1: widget.color1,
            color2: widget.color2,
            color3: widget.color3,
          ),
          child: child,
        );
      },
      child: Container(),
    );
  }
}

class Star {
  final double x;
  final double y;
  final double size;
  final double opacity;
  final double blinkDuration;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.opacity,
    required this.blinkDuration,
  });
}

class CosmicPainter extends CustomPainter {
  final List<Star> stars;
  final double animation;
  final Color color1;
  final Color color2;
  final Color color3;

  CosmicPainter({
    required this.stars,
    required this.animation,
    required this.color1,
    required this.color2,
    required this.color3,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Draw gradient background
    final Rect rect = Offset.zero & size;
    final Gradient gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [color1, color2, color3],
      stops: const [0.0, 0.5, 1.0],
    );

    final Paint backgroundPaint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, backgroundPaint);

    // Draw stars
    for (var star in stars) {
      final double x = star.x * size.width;
      final double y = star.y * size.height;

      // Calculate blinking effect
      final double blinkPhase =
          (animation * 2 * pi / star.blinkDuration) % (2 * pi);
      final double blinkFactor = (sin(blinkPhase) + 1) / 2;

      final Paint starPaint =
          Paint()
            ..color = Colors.white.withOpacity(star.opacity * blinkFactor)
            ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), star.size, starPaint);

      // Draw glow effect
      final Paint glowPaint =
          Paint()
            ..color = Colors.white.withOpacity(star.opacity * blinkFactor * 0.3)
            ..style = PaintingStyle.fill
            ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);

      canvas.drawCircle(Offset(x, y), star.size * 2, glowPaint);
    }

    // Draw cosmic swirls
    final Paint swirlPaint =
        Paint()
          ..color = Colors.white.withOpacity(0.05)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.0;

    for (int i = 0; i < 3; i++) {
      final double phase = animation * 2 * pi + i * (2 * pi / 3);
      final double centerX = size.width * 0.5;
      final double centerY = size.height * 0.5;
      final double radius = size.width * 0.3 + i * 20;

      final Path path = Path();
      for (double angle = 0; angle < 2 * pi; angle += 0.1) {
        final double r = radius + 20 * sin(angle * 5 + phase);
        final double x = centerX + r * cos(angle);
        final double y = centerY + r * sin(angle);

        if (angle == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }
      }
      path.close();
      canvas.drawPath(path, swirlPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CosmicPainter oldDelegate) {
    return oldDelegate.animation != animation;
  }
}
