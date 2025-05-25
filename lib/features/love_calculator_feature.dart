import 'package:flutter/material.dart';
// Note: I'm assuming 'package:heart_beat/theam.dart' is still a valid import.
// If 'AppTheme' or other specific theme elements are needed, 
// they might need to be passed in or accessed differently if 'theam.dart' itself has dependencies
// that we don't want in this deferred library. For now, keeping it simple.
// If AppTheme is complex or not needed directly by LoveCalculatorScreen, this import might be removable
// or refactorable.
// import 'package:heart_beat/theam.dart'; // Commenting out for now, will add back if needed after checking theme usage

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
    // Accessing theme data directly from Theme.of(context)
    // This avoids a direct dependency on a potentially complex 'theam.dart' file
    // within this deferred library, which is good practice for deferred loading.
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      // appBar: AppBar( // Optional: Add an AppBar if desired for deferred screens
      //   title: Text('Love Calculator'),
      //   backgroundColor: theme.colorScheme.primaryContainer,
      // ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              theme.colorScheme.primaryContainer,
              theme.colorScheme.secondaryContainer,
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
                        color: theme.colorScheme.primary, size: 40),
                    SizedBox(width: 10),
                    Text(
                      'Love Calculator',
                      style: theme.textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.primary,
                            shadows: [
                              Shadow(
                                color: theme.colorScheme.secondary.withOpacity(0.5), // Adjusted opacity
                                offset: Offset(2, 2),
                                blurRadius: 3, // Adjusted blur
                              ),
                            ],
                          ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.favorite,
                        color: theme.colorScheme.primary, size: 40),
                  ],
                ),
                SizedBox(height: 40),

                // Input Fields
                Container(
                  width: 400, // Consider making this responsive
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surface.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: theme.colorScheme.secondary.withOpacity(0.3),
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
                              color: theme.colorScheme.primary),
                          prefixIcon: Icon(Icons.person,
                              color: theme.colorScheme.secondary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: theme.colorScheme.secondary),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(
                                color: theme.colorScheme.primary),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _partnerNameController,
                        decoration: InputDecoration(
                          labelText: "Your Lover's Name",
                          labelStyle: TextStyle(
                              color: theme.colorScheme.primary),
                          prefixIcon: Icon(Icons.favorite,
                              color: theme.colorScheme.secondary),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: theme.colorScheme.secondary),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                                color: theme.colorScheme.primary),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      // Calculate Button
                      ElevatedButton(
                        onPressed: _calculateLove,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
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
                              color: theme.colorScheme.onPrimary),
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
                          style: theme.textTheme.headlineSmall?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surface.withOpacity(0.9),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Text(
                            _result,
                            style: theme.textTheme.titleLarge?.copyWith(
                                  color: theme.colorScheme.primary,
                                  fontStyle: FontStyle.italic,
                                ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 20),
                        // Love Percentage Bar
                        SizedBox(
                          width: 300, // Consider making this responsive
                          child: LinearProgressIndicator(
                            value: _lovePercentage / 100,
                            backgroundColor: theme.colorScheme.secondaryContainer,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              theme.colorScheme.primary,
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
