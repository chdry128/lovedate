import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/zodiac_model.dart';
import '../services/astrology_service.dart';

class CompatibilityDetails extends StatelessWidget {
  final String sign1;
  final String sign2;
  final String person1;
  final String person2;

  const CompatibilityDetails({
    Key? key,
    required this.sign1,
    required this.sign2,
    required this.person1,
    required this.person2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final detailedCompatibility = AstrologyService.getDetailedCompatibility(
      sign1,
      sign2,
    );
    final zodiacData1 = ZodiacData.signs[sign1];
    final zodiacData2 = ZodiacData.signs[sign2];

    if (zodiacData1 == null || zodiacData2 == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.purpleAccent.withOpacity(0.7),
                  Colors.pinkAccent.withOpacity(0.7),
                ],
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.psychology, color: Colors.white),
                const SizedBox(width: 12),
                Text(
                  "Compatibility Insights",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildInsightSection(
                  "Romance & Attraction",
                  detailedCompatibility['romance'] as String,
                  Icons.favorite,
                  Colors.redAccent,
                ),
                const SizedBox(height: 16),
                _buildInsightSection(
                  "Communication",
                  detailedCompatibility['communication'] as String,
                  Icons.chat_bubble_outline,
                  Colors.blueAccent,
                ),
                const SizedBox(height: 16),
                _buildInsightSection(
                  "Trust & Values",
                  detailedCompatibility['trust'] as String,
                  Icons.handshake,
                  Colors.teal,
                ),
                const SizedBox(height: 16),
                _buildInsightSection(
                  "Long-term Potential",
                  detailedCompatibility['values'] as String,
                  Icons.timeline,
                  Colors.deepPurpleAccent,
                ),
              ],
            ),
          ),

          // Element Compatibility
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Element Compatibility",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildElementCard(
                        person1,
                        sign1,
                        zodiacData1.element,
                        _getElementColor(zodiacData1.element),
                        _getElementIcon(zodiacData1.element),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildElementCard(
                        person2,
                        sign2,
                        zodiacData2.element,
                        _getElementColor(zodiacData2.element),
                        _getElementIcon(zodiacData2.element),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildElementCompatibilityText(
                  zodiacData1.element,
                  zodiacData2.element,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms, delay: 200.ms);
  }

  Widget _buildInsightSection(
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                content,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildElementCard(
    String name,
    String sign,
    String element,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            element,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "$name's $sign",
            style: TextStyle(fontSize: 14, color: Colors.grey[700]),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildElementCompatibilityText(String element1, String element2) {
    String compatibilityText;
    Color textColor;

    if (element1 == element2) {
      compatibilityText =
          "You share the same element ($element1), creating a natural understanding and similar approaches to life.";
      textColor = Colors.green;
    } else if (_areComplementaryElements(element1, element2)) {
      compatibilityText =
          "Your elements ($element1 and $element2) complement each other well, creating a balanced and harmonious relationship.";
      textColor = Colors.blue;
    } else if (_areChallengingElements(element1, element2)) {
      compatibilityText =
          "Your elements ($element1 and $element2) may create some challenges, but these differences can also lead to growth and learning.";
      textColor = Colors.orange;
    } else {
      compatibilityText =
          "Your elements ($element1 and $element2) have a neutral relationship, neither strongly compatible nor challenging.";
      textColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: textColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: textColor.withOpacity(0.3), width: 1),
      ),
      child: Text(
        compatibilityText,
        style: TextStyle(fontSize: 14, color: textColor, height: 1.4),
      ),
    );
  }

  bool _areComplementaryElements(String element1, String element2) {
    return (element1 == 'Fire' && element2 == 'Air') ||
        (element1 == 'Air' && element2 == 'Fire') ||
        (element1 == 'Earth' && element2 == 'Water') ||
        (element1 == 'Water' && element2 == 'Earth');
  }

  bool _areChallengingElements(String element1, String element2) {
    return (element1 == 'Fire' && element2 == 'Water') ||
        (element1 == 'Water' && element2 == 'Fire') ||
        (element1 == 'Earth' && element2 == 'Air') ||
        (element1 == 'Air' && element2 == 'Earth');
  }

  Color _getElementColor(String element) {
    switch (element) {
      case 'Fire':
        return Colors.red;
      case 'Earth':
        return Colors.green;
      case 'Air':
        return Colors.blue;
      case 'Water':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getElementIcon(String element) {
    switch (element) {
      case 'Fire':
        return Icons.local_fire_department;
      case 'Earth':
        return Icons.terrain;
      case 'Air':
        return Icons.air;
      case 'Water':
        return Icons.water_drop;
      default:
        return Icons.question_mark;
    }
  }
}
