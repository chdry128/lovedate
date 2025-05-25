import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'letter_background.dart';

class LetterPreview extends StatelessWidget {
  final String yourName;
  final String partnerName;
  final String tone;
  final bool isVisible;

  const LetterPreview({
    Key? key,
    required this.yourName,
    required this.partnerName,
    required this.tone,
    this.isVisible = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Don't build if not visible or names are empty
    if (!isVisible || yourName.isEmpty || partnerName.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Preview",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                children: [
                  // Background
                  Positioned.fill(
                    child: CustomPaint(
                      painter: LetterBackground(
                        primaryColor: _getToneColor(tone),
                        secondaryColor: Colors.purple,
                      ),
                    ),
                  ),

                  // Preview content
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getOpeningLine(partnerName, tone),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Expanded(
                          child: Text(
                            _getPreviewText(yourName, partnerName, tone),
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black87,
                              height: 1.4,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.fade,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Fade effect at bottom
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 40,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withOpacity(0),
                            Colors.white.withOpacity(0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  String _getOpeningLine(String partnerName, String tone) {
    switch (tone) {
      case 'Romantic':
        return "My dearest $partnerName,";
      case 'Playful':
        return "Hey there, gorgeous $partnerName!";
      case 'Poetic':
        return "To $partnerName, the poetry in my prose,";
      case 'Passionate':
        return "To my flame, my passion, my $partnerName,";
      case 'Sweet':
        return "Sweet $partnerName,";
      case 'Nostalgic':
        return "To $partnerName, my journey through time,";
      case 'Heartfelt':
        return "From the depths of my heart to you, $partnerName,";
      default:
        return "Dear $partnerName,";
    }
  }

  String _getPreviewText(String yourName, String partnerName, String tone) {
    switch (tone) {
      case 'Romantic':
        return "As I write these words, my heart overflows with love for you. Every moment we share is a treasure I hold close to my heart...";
      case 'Playful':
        return "Just thinking about you puts this silly smile on my face! Remember that time we... well, you know what I'm talking about! 😉";
      case 'Poetic':
        return "In the garden of my heart, you planted seeds of joy. They have blossomed into the most beautiful flowers, nourished by your love...";
      case 'Passionate':
        return "The fire you ignite in me burns brighter with each passing day. I crave your touch, your smile, your very presence...";
      case 'Sweet':
        return "You're the sweetest part of my day, every day! Just thinking about your smile makes everything better. You mean the world to me...";
      case 'Nostalgic':
        return "Looking back on our journey together, I'm filled with such wonderful memories. Remember when we first met? I knew then that you were special...";
      case 'Heartfelt':
        return "There aren't enough words to express how deeply you've touched my life. Your kindness, your strength, your beautiful spirit...";
      default:
        return "I wanted to take a moment to tell you how much you mean to me. Your presence in my life has made everything brighter...";
    }
  }

  Color _getToneColor(String tone) {
    switch (tone) {
      case 'Romantic':
        return Colors.pink;
      case 'Playful':
        return Colors.orange;
      case 'Poetic':
        return Colors.purple;
      case 'Passionate':
        return Colors.red;
      case 'Sweet':
        return Colors.pink.shade300;
      case 'Nostalgic':
        return Colors.indigo;
      case 'Heartfelt':
        return Colors.deepPurple;
      default:
        return Colors.blue;
    }
  }
}
