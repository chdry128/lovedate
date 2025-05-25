import 'package:flutter/material.dart';

class ZodiacSign {
  final String name;
  final String symbol;
  final String element;
  final String ruling;
  final String dateRange;
  final String description;
  final Color color;
  final List<String> traits;
  final List<String> compatibleSigns;

  const ZodiacSign({
    required this.name,
    required this.symbol,
    required this.element,
    required this.ruling,
    required this.dateRange,
    required this.description,
    required this.color,
    required this.traits,
    required this.compatibleSigns,
  });
}

class ZodiacData {
  static const Map<String, ZodiacSign> signs = {
    'Aries': ZodiacSign(
      name: 'Aries',
      symbol: '♈',
      element: 'Fire',
      ruling: 'Mars',
      dateRange: 'March 21 - April 19',
      description:
          'Aries is a passionate, motivated, and confident leader who builds community with their cheerful disposition and relentless determination.',
      color: Color(0xFFE74C3C),
      traits: [
        'Passionate',
        'Motivated',
        'Confident',
        'Determined',
        'Impulsive',
      ],
      compatibleSigns: ['Leo', 'Sagittarius', 'Gemini', 'Aquarius'],
    ),
    'Taurus': ZodiacSign(
      name: 'Taurus',
      symbol: '♉',
      element: 'Earth',
      ruling: 'Venus',
      dateRange: 'April 20 - May 20',
      description:
          'Taurus is a grounded, practical, and reliable individual who values stability and enjoys the pleasures of life.',
      color: Color(0xFF27AE60),
      traits: ['Patient', 'Reliable', 'Devoted', 'Responsible', 'Stubborn'],
      compatibleSigns: ['Virgo', 'Capricorn', 'Cancer', 'Pisces'],
    ),
    'Gemini': ZodiacSign(
      name: 'Gemini',
      symbol: '♊',
      element: 'Air',
      ruling: 'Mercury',
      dateRange: 'May 21 - June 20',
      description:
          'Gemini is a curious, adaptable, and communicative individual who loves to learn and share ideas with others.',
      color: Color(0xFFF1C40F),
      traits: [
        'Gentle',
        'Curious',
        'Adaptable',
        'Quick-witted',
        'Inconsistent',
      ],
      compatibleSigns: ['Libra', 'Aquarius', 'Aries', 'Leo'],
    ),
    'Cancer': ZodiacSign(
      name: 'Cancer',
      symbol: '♋',
      element: 'Water',
      ruling: 'Moon',
      dateRange: 'June 21 - July 22',
      description:
          'Cancer is a deeply intuitive, emotional, and caring individual who values home, family, and security.',
      color: Color(0xFF3498DB),
      traits: ['Intuitive', 'Emotional', 'Loyal', 'Protective', 'Moody'],
      compatibleSigns: ['Scorpio', 'Pisces', 'Taurus', 'Virgo'],
    ),
    'Leo': ZodiacSign(
      name: 'Leo',
      symbol: '♌',
      element: 'Fire',
      ruling: 'Sun',
      dateRange: 'July 23 - August 22',
      description:
          'Leo is a creative, passionate, and generous individual who loves to be in the spotlight and inspire others.',
      color: Color(0xFFD35400),
      traits: [
        'Creative',
        'Passionate',
        'Generous',
        'Warm-hearted',
        'Arrogant',
      ],
      compatibleSigns: ['Aries', 'Sagittarius', 'Gemini', 'Libra'],
    ),
    'Virgo': ZodiacSign(
      name: 'Virgo',
      symbol: '♍',
      element: 'Earth',
      ruling: 'Mercury',
      dateRange: 'August 23 - September 22',
      description:
          'Virgo is a methodical, practical, and analytical individual who pays attention to detail and strives for perfection.',
      color: Color(0xFF8E44AD),
      traits: ['Analytical', 'Practical', 'Diligent', 'Kind', 'Critical'],
      compatibleSigns: ['Taurus', 'Capricorn', 'Cancer', 'Scorpio'],
    ),
    'Libra': ZodiacSign(
      name: 'Libra',
      symbol: '♎',
      element: 'Air',
      ruling: 'Venus',
      dateRange: 'September 23 - October 22',
      description:
          'Libra is a balanced, diplomatic, and social individual who values harmony and fairness in all aspects of life.',
      color: Color(0xFF1ABC9C),
      traits: [
        'Diplomatic',
        'Fair-minded',
        'Social',
        'Cooperative',
        'Indecisive',
      ],
      compatibleSigns: ['Gemini', 'Aquarius', 'Leo', 'Sagittarius'],
    ),
    'Scorpio': ZodiacSign(
      name: 'Scorpio',
      symbol: '♏',
      element: 'Water',
      ruling: 'Pluto, Mars',
      dateRange: 'October 23 - November 21',
      description:
          'Scorpio is a passionate, determined, and decisive individual who researches deeply and has great emotional intelligence.',
      color: Color(0xFF7D3C98),
      traits: ['Resourceful', 'Passionate', 'Brave', 'Stubborn', 'Jealous'],
      compatibleSigns: ['Cancer', 'Pisces', 'Virgo', 'Capricorn'],
    ),
    'Sagittarius': ZodiacSign(
      name: 'Sagittarius',
      symbol: '♐',
      element: 'Fire',
      ruling: 'Jupiter',
      dateRange: 'November 22 - December 21',
      description:
          'Sagittarius is an optimistic, freedom-loving, and philosophical individual who enjoys exploration and adventure.',
      color: Color(0xFFE67E22),
      traits: ['Generous', 'Idealistic', 'Humorous', 'Impatient', 'Promising'],
      compatibleSigns: ['Aries', 'Leo', 'Libra', 'Aquarius'],
    ),
    'Capricorn': ZodiacSign(
      name: 'Capricorn',
      symbol: '♑',
      element: 'Earth',
      ruling: 'Saturn',
      dateRange: 'December 22 - January 19',
      description:
          'Capricorn is a responsible, disciplined, and self-controlled individual who values tradition and works methodically toward goals.',
      color: Color(0xFF34495E),
      traits: [
        'Responsible',
        'Disciplined',
        'Self-controlled',
        'Reserved',
        'Pessimistic',
      ],
      compatibleSigns: ['Taurus', 'Virgo', 'Scorpio', 'Pisces'],
    ),
    'Aquarius': ZodiacSign(
      name: 'Aquarius',
      symbol: '♒',
      element: 'Air',
      ruling: 'Uranus, Saturn',
      dateRange: 'January 20 - February 18',
      description:
          'Aquarius is a progressive, original, and independent individual who is humanitarian and often thinks in terms of groups and society.',
      color: Color(0xFF3498DB),
      traits: [
        'Progressive',
        'Original',
        'Independent',
        'Humanitarian',
        'Aloof',
      ],
      compatibleSigns: ['Gemini', 'Libra', 'Aries', 'Sagittarius'],
    ),
    'Pisces': ZodiacSign(
      name: 'Pisces',
      symbol: '♓',
      element: 'Water',
      ruling: 'Neptune, Jupiter',
      dateRange: 'February 19 - March 20',
      description:
          'Pisces is a compassionate, artistic, and intuitive individual who is deeply empathetic and often has a strong connection to the spiritual realm.',
      color: Color(0xFF2980B9),
      traits: ['Compassionate', 'Artistic', 'Intuitive', 'Gentle', 'Fearful'],
      compatibleSigns: ['Cancer', 'Scorpio', 'Taurus', 'Capricorn'],
    ),
  };

  // Get sun sign based on day and month
  static String getSunSign(int day, int month) {
    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) return 'Aries';
    if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) return 'Taurus';
    if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) return 'Gemini';
    if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) return 'Cancer';
    if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) return 'Leo';
    if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) return 'Virgo';
    if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) return 'Libra';
    if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return 'Scorpio';
    }
    if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return 'Sagittarius';
    }
    if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return 'Capricorn';
    }
    if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return 'Aquarius';
    }
    return 'Pisces';
  }

  // Calculate compatibility score between two signs
  static CompatibilityResult calculateCompatibility(
    String sign1,
    String sign2,
  ) {
    // Base score
    int score = 0;

    // Element compatibility
    final String element1 = signs[sign1]?.element ?? '';
    final String element2 = signs[sign2]?.element ?? '';

    // Same element is highly compatible
    if (element1 == element2) {
      score += 30;
    }
    // Complementary elements
    else if ((element1 == 'Fire' && element2 == 'Air') ||
        (element1 == 'Air' && element2 == 'Fire') ||
        (element1 == 'Earth' && element2 == 'Water') ||
        (element1 == 'Water' && element2 == 'Earth')) {
      score += 25;
    }
    // Challenging elements
    else if ((element1 == 'Fire' && element2 == 'Water') ||
        (element1 == 'Water' && element2 == 'Fire') ||
        (element1 == 'Earth' && element2 == 'Air') ||
        (element1 == 'Air' && element2 == 'Earth')) {
      score += 10;
    }
    // Neutral elements
    else {
      score += 15;
    }

    // Direct compatibility from the list
    if (signs[sign1]?.compatibleSigns.contains(sign2) ?? false) {
      score += 40;
    }

    // Opposite signs often have attraction (opposites attract)
    final Map<String, String> opposites = {
      'Aries': 'Libra',
      'Taurus': 'Scorpio',
      'Gemini': 'Sagittarius',
      'Cancer': 'Capricorn',
      'Leo': 'Aquarius',
      'Virgo': 'Pisces',
    };

    if (opposites[sign1] == sign2 || opposites[sign2] == sign1) {
      score += 20;
    }

    // Cap the score at 100
    score = score > 100 ? 100 : score;

    // Generate message based on score
    String message;
    String details;

    if (score >= 80) {
      message = "Cosmic Soulmates";
      details =
          "The stars have aligned perfectly for you two! Your connection is rare and powerful, with natural harmony and understanding. You balance each other beautifully and can build something truly special together.";
    } else if (score >= 60) {
      message = "Stellar Connection";
      details =
          "You share a strong natural compatibility that makes your relationship flow with ease. While you'll have occasional challenges, your connection has great potential for long-term harmony and growth.";
    } else if (score >= 40) {
      message = "Promising Potential";
      details =
          "Your signs indicate a relationship with good potential that will require some effort and understanding. Your differences can either complement or challenge each other - communication will be key.";
    } else {
      message = "Cosmic Challenge";
      details =
          "The stars suggest you may face more challenges in understanding each other's fundamental nature. This doesn't mean a relationship won't work, but it will require patience, communication, and compromise.";
    }

    return CompatibilityResult(
      score: score,
      message: message,
      details: details,
      sign1: sign1,
      sign2: sign2,
    );
  }
}

class CompatibilityResult {
  final int score;
  final String message;
  final String details;
  final String sign1;
  final String sign2;

  CompatibilityResult({
    required this.score,
    required this.message,
    required this.details,
    required this.sign1,
    required this.sign2,
  });
}
