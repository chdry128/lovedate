import 'package:flutter/material.dart';
import 'theam.dart';

void main() {
  runApp(ZodicApp());
}

class ZodicApp extends StatelessWidget {
  const ZodicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Zodic Page',
      theme: AppTheme.lightTheme,
      home: ZodicScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ZodicScreen extends StatefulWidget {
  const ZodicScreen({super.key});

  @override
  _ZodicScreenState createState() => _ZodicScreenState();
}

class _ZodicScreenState extends State<ZodicScreen> {
  final _nameController1 = TextEditingController();
  final _nameController2 = TextEditingController();
  DateTime? _selectedDate1;
  DateTime? _selectedDate2;
  String _zodiacSign1 = '';
  String _zodiacSign2 = '';
  String _compatibilityResult = '';
  bool _showCompatibility = false;

  // Function to get zodiac sign based on date
  String _getZodiacSign(DateTime date) {
    int day = date.day;
    int month = date.month;

    if ((month == 3 && day >= 21) || (month == 4 && day <= 19)) {
      return 'Aries';
    } else if ((month == 4 && day >= 20) || (month == 5 && day <= 20)) {
      return 'Taurus';
    } else if ((month == 5 && day >= 21) || (month == 6 && day <= 20)) {
      return 'Gemini';
    } else if ((month == 6 && day >= 21) || (month == 7 && day <= 22)) {
      return 'Cancer';
    } else if ((month == 7 && day >= 23) || (month == 8 && day <= 22)) {
      return 'Leo';
    } else if ((month == 8 && day >= 23) || (month == 9 && day <= 22)) {
      return 'Virgo';
    } else if ((month == 9 && day >= 23) || (month == 10 && day <= 22)) {
      return 'Libra';
    } else if ((month == 10 && day >= 23) || (month == 11 && day <= 21)) {
      return 'Scorpio';
    } else if ((month == 11 && day >= 22) || (month == 12 && day <= 21)) {
      return 'Sagittarius';
    } else if ((month == 12 && day >= 22) || (month == 1 && day <= 19)) {
      return 'Capricorn';
    } else if ((month == 1 && day >= 20) || (month == 2 && day <= 18)) {
      return 'Aquarius';
    } else {
      return 'Pisces';
    }
  }

  // Function to calculate compatibility between two signs
  String _calculateCompatibility(String sign1, String sign2) {
    // Compatibility matrix based on astrological elements
    Map<String, List<String>> compatibilityMap = {
      'Aries': ['Leo', 'Sagittarius', 'Gemini', 'Aquarius'],
      'Taurus': ['Virgo', 'Capricorn', 'Cancer', 'Pisces'],
      'Gemini': ['Libra', 'Aquarius', 'Aries', 'Leo'],
      'Cancer': ['Scorpio', 'Pisces', 'Taurus', 'Virgo'],
      'Leo': ['Aries', 'Sagittarius', 'Gemini', 'Libra'],
      'Virgo': ['Taurus', 'Capricorn', 'Cancer', 'Scorpio'],
      'Libra': ['Gemini', 'Aquarius', 'Leo', 'Sagittarius'],
      'Scorpio': ['Cancer', 'Pisces', 'Virgo', 'Capricorn'],
      'Sagittarius': ['Aries', 'Leo', 'Libra', 'Aquarius'],
      'Capricorn': ['Taurus', 'Virgo', 'Scorpio', 'Pisces'],
      'Aquarius': ['Gemini', 'Libra', 'Aries', 'Sagittarius'],
      'Pisces': ['Cancer', 'Scorpio', 'Taurus', 'Capricorn'],
    };

    if (sign1 == sign2) {
      return "You're both ${sign1}s! This creates a strong understanding but may lack balance.";
    } else if (compatibilityMap[sign1]!.contains(sign2)) {
      return "Great match! $sign1 and $sign2 are highly compatible signs.";
    } else {
      return "Interesting pairing! $sign1 and $sign2 can learn from each other but may need to work on understanding differences.";
    }
  }

  Future<void> _selectDate(BuildContext context, bool isFirstPerson) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        if (isFirstPerson) {
          _selectedDate1 = picked;
          _zodiacSign1 = _getZodiacSign(picked);
        } else {
          _selectedDate2 = picked;
          _zodiacSign2 = _getZodiacSign(picked);
        }
      });
    }
  }

  void _calculateCompatibilityResult() {
    if (_selectedDate1 == null || _selectedDate2 == null) {
      setState(() {
        _compatibilityResult = 'Please select both birth dates!';
        _showCompatibility = true;
      });
      return;
    }

    if (_nameController1.text.isEmpty || _nameController2.text.isEmpty) {
      setState(() {
        _compatibilityResult = 'Please enter both names!';
        _showCompatibility = true;
      });
      return;
    }

    setState(() {
      _compatibilityResult = _calculateCompatibility(_zodiacSign1, _zodiacSign2);
      _showCompatibility = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.deepPurple[100]!, Colors.red[300]!],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.star, color: Colors.yellow[700], size: 40),
                    SizedBox(width: 10),
                    Text(
                      'Zodiac Compatibility',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple[900],
                        shadows: [
                          Shadow(
                            color: Colors.redAccent,
                            offset: Offset(2, 2),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 5),
                    Icon(Icons.star, color: Colors.yellow[700], size: 40),
                  ],
                ),
                SizedBox(height: 40),

                // Input Container
                Container(
                  width: 400,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.redAccent.withOpacity(0.4),
                        spreadRadius: 5,
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Person 1 Input
                      Text(
                        'Your Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[800],
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: _nameController1,
                        decoration: InputDecoration(
                          labelText: 'Your Name',
                          labelStyle: TextStyle(color: Colors.pink[700]),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Colors.redAccent,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.pink),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () => _selectDate(context, true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[400],
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          _selectedDate1 == null
                              ? 'Select Your Birth Date'
                              : 'Birth Date: ${_selectedDate1!.day}/${_selectedDate1!.month}/${_selectedDate1!.year}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      if (_zodiacSign1.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Your Sign: $_zodiacSign1',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      SizedBox(height: 30),

                      // Person 2 Input
                      Text(
                        'Your Partner\'s Details',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.pink[800],
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: _nameController2,
                        decoration: InputDecoration(
                          labelText: 'Partner\'s Name',
                          labelStyle: TextStyle(color: Colors.pink[700]),
                          prefixIcon: Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.deepPurple),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      ElevatedButton(
                        onPressed: () => _selectDate(context, false),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple[400],
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        child: Text(
                          _selectedDate2 == null
                              ? 'Select Partner\'s Birth Date'
                              : 'Birth Date: ${_selectedDate2!.day}/${_selectedDate2!.month}/${_selectedDate2!.year}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      if (_zodiacSign2.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            'Partner\'s Sign: $_zodiacSign2',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.red[800],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      SizedBox(height: 30),

                      // Calculate Button
                      ElevatedButton(
                        onPressed: _calculateCompatibilityResult,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Check Compatibility',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Result Display
                if (_showCompatibility)
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Container(
                      width: 400,
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Compatibility Result',
                            style: TextStyle(
                              fontSize: 24,
                              color: Colors.deepPurple[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 15),
                          if (_zodiacSign1.isNotEmpty && _zodiacSign2.isNotEmpty)
                            Text(
                              '$_zodiacSign1 & $_zodiacSign2',
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.red[800],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          SizedBox(height: 15),
                          Text(
                            _compatibilityResult,
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.deepPurple[800],
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController1.dispose();
    _nameController2.dispose();
    super.dispose();
  }
}