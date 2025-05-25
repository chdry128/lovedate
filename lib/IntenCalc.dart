import 'package:flutter/material.dart';
import 'dart:math';
import 'package:heart_beat/theam.dart'; // Import AppTheme

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
            colors: [ // Use theme colors for gradient
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
              Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.7),
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
                    Icon(Icons.local_fire_department, color: Theme.of(context).colorScheme.primary, size: 40),
                    SizedBox(width: 10),
                    Text(
                      'Sex Intensity',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        shadows: [
                          Shadow(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.5),
                            offset: Offset(2, 2),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.local_fire_department, color: Theme.of(context).colorScheme.primary, size: 40),
                  ],
                ),
                SizedBox(height: 40),

                // Input Container
                Container(
                  width: 400,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.8), // Use theme surface color
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.3), // Use theme secondary color
                        spreadRadius: 5,
                        blurRadius: 7,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        controller: _yourNameController,
                        decoration: InputDecoration( // Use theme InputDecoration
                          labelText: 'Your Sexy Name',
                          // labelStyle: TextStyle(color: Colors.deepPurple[700]), // Handled by theme
                          prefixIcon: Icon(Icons.person, color: Theme.of(context).colorScheme.secondary), // Use theme secondary color
                          // border: OutlineInputBorder( // Handled by theme
                          //   borderRadius: BorderRadius.circular(15),
                          //   borderSide: BorderSide(color: Colors.redAccent),
                          // ),
                          // focusedBorder: OutlineInputBorder( // Handled by theme
                          //   borderRadius: BorderRadius.circular(15),
                          //   borderSide: BorderSide(color: Colors.deepPurple),
                          // ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _partnerNameController,
                        decoration: InputDecoration( // Use theme InputDecoration
                          labelText: "Your Lover's Name",
                          // labelStyle: TextStyle(color: Colors.deepPurple[700]), // Handled by theme
                          prefixIcon: Icon(Icons.favorite, color: Theme.of(context).colorScheme.secondary), // Use theme secondary color
                          // border: OutlineInputBorder( // Handled by theme
                          //   borderRadius: BorderRadius.circular(20),
                          //   borderSide: BorderSide(color: Colors.redAccent),
                          // ),
                          // focusedBorder: OutlineInputBorder( // Handled by theme
                          //   borderRadius: BorderRadius.circular(20),
                          //   borderSide: BorderSide(color: Colors.deepPurple),
                          // ),
                        ),
                      ),
                      SizedBox(height: 30),

                      // Calculate Button
                      ElevatedButton( // Use theme ElevatedButton
                        onPressed: _calculateIntensity,
                        // style: ElevatedButton.styleFrom( // Handled by theme
                        //   backgroundColor: Colors.redAccent,
                        //   padding: EdgeInsets.symmetric(
                        //     horizontal: 40,
                        //     vertical: 15,
                        //   ),
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(30),
                        //   ),
                        // ),
                        child: Text(
                          'Measure the Heat',
                          // style: TextStyle( // Handled by theme
                          //   fontSize: 18,
                          //   color: Colors.white,
                          //   fontWeight: FontWeight.bold,
                          // ),
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
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith( // Use theme text style
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface.withOpacity(0.8), // Use theme surface color
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            _result,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith( // Use theme text style
                                  color: Theme.of(context).colorScheme.primary,
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
                            backgroundColor: Theme.of(context).colorScheme.secondaryContainer, // Use theme secondary container
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary, // Use theme primary
                            ),
                            minHeight: 12,
                            // borderRadius: BorderRadius.circular(6), // Consider if this is needed or part of global theme
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