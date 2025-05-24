import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A widget that displays a heart rain animation effect
/// Optimized for performance with custom ticker and repaint boundary
class HeartRainEffect extends StatefulWidget {
  /// The number of hearts to display
  final int heartCount;
  
  /// The duration of the animation
  final Duration animationDuration;
  
  /// Whether to automatically start the animation
  final bool autoStart;

  const HeartRainEffect({
    super.key, 
    this.heartCount = 20, 
    this.animationDuration = const Duration(seconds: 2),
    this.autoStart = true,
  });

  @override
  State<HeartRainEffect> createState() => _HeartRainEffectState();
}

class _HeartRainEffectState extends State<HeartRainEffect>
    with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  final List<Heart> _hearts = [];
  bool _isActive = false;
  Size _screenSize = Size.zero;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    
    // Use a ticker instead of animation controller for more efficient updates
    _ticker = createTicker(_onTick);
    
    // Initialize hearts with optimized count
    _initializeHearts();
    
    if (widget.autoStart) {
      _startAnimation();
    }
  }
  
  @override
  void didUpdateWidget(HeartRainEffect oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    // Update heart count if it changed
    if (widget.heartCount != oldWidget.heartCount) {
      _hearts.clear();
      _initializeHearts();
    }
  }

  void _initializeHearts() {
    // Use a more efficient heart count based on platform
    final effectiveCount = kIsWeb ? 
        (widget.heartCount ~/ 1.5).clamp(10, 30) : 
        widget.heartCount.clamp(10, 40);
    
    for (int i = 0; i < effectiveCount; i++) {
      _hearts.add(Heart(_random));
    }
  }

  void _startAnimation() {
    if (!_isActive) {
      _isActive = true;
      _ticker.start();
    }
  }

  void _stopAnimation() {
    if (_isActive) {
      _isActive = false;
      _ticker.stop();
    }
  }

  void _onTick(Duration elapsed) {
    if (!mounted) return;
    
    setState(() {
      for (final heart in _hearts) {
        heart.fall(_screenSize);
      }
    });
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _screenSize = MediaQuery.of(context).size;
    
    return RepaintBoundary(
      child: IgnorePointer(
        child: SizedBox.expand(
          child: Stack(
            children: _hearts.map((heart) {
              return Positioned(
                left: heart.x * _screenSize.width,
                top: heart.y * _screenSize.height,
                child: Opacity(
                  opacity: heart.opacity,
                  child: Transform.rotate(
                    angle: heart.rotation,
                    child: Text(
                      '❤️',
                      style: TextStyle(
                        fontSize: heart.size,
                        color: Colors.red.withOpacity(heart.colorOpacity),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

/// Represents a single heart in the animation
class Heart {
  double x;
  double y;
  double speed;
  double size;
  double rotation;
  double opacity;
  double colorOpacity;
  
  // Constructor with random initialization
  Heart(Random random) :
    x = random.nextDouble(),
    y = random.nextDouble() * -0.5,
    speed = 0.5 + random.nextDouble() * 1.5,
    size = 20 + random.nextDouble() * 30,
    rotation = random.nextDouble() * 6.28,
    opacity = 0.5 + random.nextDouble() * 0.5,
    colorOpacity = 0.7 + random.nextDouble() * 0.3;

  /// Updates the heart position for the falling animation
  void fall(Size screenSize) {
    // Adjust speed based on screen height for consistent experience
    final speedFactor = screenSize.height > 0 ? 
        (screenSize.height / 800) : 1.0;
    
    y += (speed / 60) * speedFactor;
    rotation += 0.02;
    
    // Reset when heart goes off screen
    if (y > 1.5) {
      y = Random().nextDouble() * -0.5;
      x = Random().nextDouble();
    }
  }
}