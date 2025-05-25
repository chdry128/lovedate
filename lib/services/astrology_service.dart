import 'dart:math';
import 'package:intl/intl.dart';

class AstrologyService {
  // This is a simplified version for demonstration
  // In a real app, you would use an API or more complex calculations

  // Get moon sign based on date and time
  // This is a simplified algorithm - in a real app, use an astrology API
  static String getMoonSign(DateTime birthDateTime) {
    // Moon moves through zodiac approximately every 2.5 days
    // This is a simplified calculation for demonstration
    final int dayOfYear = int.parse(DateFormat('D').format(birthDateTime));
    final int hour = birthDateTime.hour;

    // Create a more complex but still deterministic calculation
    final int moonPosition = (dayOfYear * 12 + hour * 2) % 360;

    // Each sign takes up 30 degrees
    final int signIndex = moonPosition ~/ 30;

    final List<String> signs = [
      'Aries',
      'Taurus',
      'Gemini',
      'Cancer',
      'Leo',
      'Virgo',
      'Libra',
      'Scorpio',
      'Sagittarius',
      'Capricorn',
      'Aquarius',
      'Pisces',
    ];

    return signs[signIndex];
  }

  // Get rising sign (ascendant) based on birth date, time and location
  // This is a simplified algorithm - in a real app, use an astrology API
  static String getRisingSign(
    DateTime birthDateTime,
    double latitude,
    double longitude,
  ) {
    // Rising sign changes approximately every 2 hours
    // This is a simplified calculation for demonstration

    // Calculate a value based on time of day (0-23 hours)
    final int hourOfDay = birthDateTime.hour;
    final int minuteOfHour = birthDateTime.minute;

    // Calculate minutes since midnight
    final int minutesSinceMidnight = hourOfDay * 60 + minuteOfHour;

    // Each sign rises for approximately 2 hours (120 minutes)
    // 24 hours = 1440 minutes, divided by 12 signs = 120 minutes per sign

    // Adjust for location (simplified)
    // Longitude affects local time: each 15 degrees = 1 hour
    final double hourAdjustment = longitude / 15.0;
    final int adjustedMinutes =
        (minutesSinceMidnight + (hourAdjustment * 60).round()) % 1440;

    // Latitude affects which signs are visible and for how long (simplified)
    // This is a very basic adjustment - real calculations are much more complex
    final double latitudeAdjustment =
        cos(latitude * pi / 180) * 30; // Simplified adjustment
    final int signIndex =
        (((adjustedMinutes / 120) + latitudeAdjustment.round()) % 12).toInt();

    final List<String> signs = [
      'Aries',
      'Taurus',
      'Gemini',
      'Cancer',
      'Leo',
      'Virgo',
      'Libra',
      'Scorpio',
      'Sagittarius',
      'Capricorn',
      'Aquarius',
      'Pisces',
    ];

    return signs[signIndex.floor()];
  }

  // Get a more detailed compatibility analysis
  static Map<String, dynamic> getDetailedCompatibility(
    String sign1,
    String sign2,
  ) {
    // In a real app, this would contain much more detailed information
    // about specific aspects of compatibility between signs

    final Map<String, Map<String, String>> compatibilityDetails = {
      'Aries-Leo': {
        'romance':
            'Your passionate natures create an exciting and dynamic romance.',
        'communication':
            'You understand each other\'s direct communication style.',
        'trust': 'You both value honesty and straightforwardness.',
        'values': 'You share a love of adventure and taking initiative.',
      },
      'Taurus-Virgo': {
        'romance':
            'You create a stable, sensual connection built on mutual respect.',
        'communication':
            'You both appreciate practical, thoughtful conversations.',
        'trust': 'Your reliable natures foster deep trust over time.',
        'values':
            'You share appreciation for quality, stability and hard work.',
      },
      // Add more combinations as needed
    };

    // Try both orders of the pair
    String key = '$sign1-$sign2';
    if (!compatibilityDetails.containsKey(key)) {
      key = '$sign2-$sign1';
    }

    // Return default values if specific combination not found
    if (!compatibilityDetails.containsKey(key)) {
      return {
        'romance': 'Your romantic connection has unique qualities to discover.',
        'communication':
            'Learning each other\'s communication style will be key.',
        'trust':
            'Building trust will come through consistent actions over time.',
        'values':
            'Explore your shared values while respecting your differences.',
      };
    }

    return compatibilityDetails[key]!;
  }
}
