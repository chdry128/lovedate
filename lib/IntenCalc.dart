import 'package:flutter/material.dart';
import 'dart:math';

void main() {
  runApp(SexIntensityApp());
}

class SexIntensityApp extends StatelessWidget {
  const SexIntensityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sex Intensity Calculator',
      theme: ThemeData(
        primaryColor: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.purple[50],
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.deepPurple[900]),
        ),
      ),
      home: SexIntensityScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SexIntensityScreen extends StatefulWidget {
  const SexIntensityScreen({super.key});

  @override
  _SexIntensityScreenState createState() => _SexIntensityScreenState();
}

class _SexIntensityScreenState extends State<SexIntensityScreen> {
  final _yourNameController = TextEditingController();
  final _partnerNameController = TextEditingController();
  String _result = '';
  double _intensityPercentage = 0.0;

  void _calculateIntensity() {
    if (_yourNameController.text.isEmpty || _partnerNameController.text.isEmpty) {
      setState(() {
        _result = 'Enter both names, my naughty lover!';
      });
      return;
    }

    // Spicy intensity calculation
    String combinedNames = _yourNameController.text.toLowerCase() +
        _partnerNameController.text.toLowerCase();
    int passionScore = combinedNames.codeUnits.fold(0, (a, b) => a + b);
    Random random = Random();
    setState(() {
      _intensityPercentage = ((passionScore % 80) + 20 + random.nextInt(20)).toDouble();
      _result = _getIntensityMessage(_intensityPercentage);
    });
  }

  String _getIntensityMessage(double percentage) {
    if (percentage > 90) {
      return 'Explosive passion that sets the night on fire! ($percentage%)';
    } else if (percentage > 75) {
      return 'Steamy encounters that leave you breathless! ($percentage%)';
    } else if (percentage > 60) {
      return 'Sultry sparks flying high! ($percentage%)';
    } else {
      return 'A seductive simmer waiting to ignite! ($percentage%)';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.deepPurple[100]!,
              Colors.red[300]!,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header with sexy vibe
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.local_fire_department, color: Colors.red[700], size: 40),
                    SizedBox(width: 10),
                    Text(
                      'Sex Intensity',
                      style: TextStyle(
                        fontSize: 36,
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
                    SizedBox(width: 10),
                    Icon(Icons.local_fire_department, color: Colors.red[700], size: 40),
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
                      TextField(
                        controller: _yourNameController,
                        decoration: InputDecoration(
                          labelText: 'Your Sexy Name',
                          labelStyle: TextStyle(color: Colors.deepPurple[700]),
                          prefixIcon: Icon(Icons.person, color: Colors.redAccent),
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
                      SizedBox(height: 20),
                      TextField(
                        controller: _partnerNameController,
                        decoration: InputDecoration(
                          labelText: "Your Lover's Name",
                          labelStyle: TextStyle(color: Colors.deepPurple[700]),
                          prefixIcon: Icon(Icons.favorite, color: Colors.redAccent),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.deepPurple),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      // Calculate Button
                      ElevatedButton(
                        onPressed: _calculateIntensity,
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
                          'Measure the Heat',
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
                if (_result.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        Text(
                          'Passion Meter',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.deepPurple[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            _result,
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.red[800],
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Intensity Bar
                        SizedBox(
                          width: 300,
                          child: LinearProgressIndicator(
                            value: _intensityPercentage / 100,
                            backgroundColor: Colors.purple[100],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.redAccent,
                            ),
                            minHeight: 12,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ),
                      ],
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
    _yourNameController.dispose();
    _partnerNameController.dispose();
    super.dispose();
  }
}