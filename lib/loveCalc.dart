import 'package:flutter/material.dart';
import 'package:heart_beat/theam.dart';

class LoveCalculatorScreen extends StatefulWidget {
  const LoveCalculatorScreen({super.key});

  @override
  _LoveCalculatorScreenState createState() => _LoveCalculatorScreenState();
}

class _LoveCalculatorScreenState extends State<LoveCalculatorScreen> {
  final _yourNameController = TextEditingController();
  final _partnerNameController = TextEditingController();
  String _result = '';
  double _lovePercentage = 0.0;

  void _calculateLove() {
    if (_yourNameController.text.isEmpty ||
        _partnerNameController.text.isEmpty) {
      setState(() {
        _result = 'Please enter both names, my darling!';
      });
      return;
    }

    // Simple love calculation algorithm
    String combinedNames =
        _yourNameController.text.toLowerCase() +
            _partnerNameController.text.toLowerCase();
    int loveScore = combinedNames.codeUnits.fold(0, (a, b) => a + b);
    setState(() {
      _lovePercentage = (loveScore % 101).toDouble();
      _result = _getLoveMessage(_lovePercentage);
    });
  }

  String _getLoveMessage(double percentage) {
    if (percentage > 80) {
      return 'A passionate flame burns between you! ($percentage%)';
    } else if (percentage > 60) {
      return 'Your hearts beat as one! ($percentage%)';
    } else if (percentage > 40) {
      return 'A spark worth exploring! ($percentage%)';
    } else {
      return 'Love needs some spice! ($percentage%)';
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
              Theme.of(context).colorScheme.primaryContainer,
              Theme.of(context).colorScheme.secondaryContainer,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header with hearts
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite,
                        color: Theme.of(context).colorScheme.primary, size: 40),
                    SizedBox(width: 10),
                    Text(
                      'Love Calculator',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                            shadows: [
                              Shadow(
                                color: Theme.of(context).colorScheme.secondary,
                                offset: Offset(2, 2),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.favorite,
                        color: Theme.of(context).colorScheme.primary, size: 40),
                  ],
                ),
                SizedBox(height: 40),

                // Input Fields
                Container(
                  width: 400,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
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
                          labelText: 'Your Name, Sweetheart',
                          labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                          prefixIcon: Icon(Icons.person,
                              color: Theme.of(context).colorScheme.secondary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _partnerNameController,
                        decoration: InputDecoration(
                          labelText: "Your Lover's Name",
                          labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.primary),
                          prefixIcon: Icon(Icons.favorite,
                              color: Theme.of(context).colorScheme.secondary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.secondary),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      // Calculate Button
                      ElevatedButton(
                        onPressed: _calculateLove,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          padding: EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 15,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          'Calculate Our Love',
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.onPrimary),
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
                          'Love Score',
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            _result,
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontStyle: FontStyle.italic,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Love Percentage Bar
                        SizedBox(
                          width: 300,
                          child: LinearProgressIndicator(
                            value: _lovePercentage / 100,
                            backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary,
                            ),
                            minHeight: 10,
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
