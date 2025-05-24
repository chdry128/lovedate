import 'package:flutter/material.dart';

void main() {
  runApp(LoveCalculatorApp());
}

class LoveCalculatorApp extends StatelessWidget {
  const LoveCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Love Calculator',
      theme: ThemeData(
        primaryColor: Colors.redAccent,
        scaffoldBackgroundColor: Colors.pink[50],
        textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.red[900])),
      ),
      home: LoveCalculatorScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

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
        _result:
        true;
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
            colors: [Colors.pink[100]!, Colors.red[200]!],
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
                    Icon(Icons.favorite, color: Colors.red, size: 40),
                    SizedBox(width: 10),
                    Text(
                      'Love Calculator',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[900],
                        shadows: [
                          Shadow(
                            color: Colors.pinkAccent,
                            offset: Offset(2, 2),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.favorite, color: Colors.red, size: 40),
                  ],
                ),
                SizedBox(height: 40),

                // Input Fields
                Container(
                  width: 400,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.pinkAccent.withOpacity(0.3),
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
                          labelStyle: TextStyle(color: Colors.red[700]),
                          prefixIcon: Icon(Icons.person, color: Colors.pink),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.pink),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _partnerNameController,
                        decoration: InputDecoration(
                          labelText: "Your Lover's Name",
                          labelStyle: TextStyle(color: Colors.red[700]),
                          prefixIcon: Icon(Icons.favorite, color: Colors.pink),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.pink),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(color: Colors.redAccent),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      // Calculate Button
                      ElevatedButton(
                        onPressed: _calculateLove,
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
                          'Calculate Our Love',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      ),
                      //edited this

                      //to here
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
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.red[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.9),
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
                        // Love Percentage Bar
                        SizedBox(
                          width: 300,
                          child: LinearProgressIndicator(
                            value: _lovePercentage / 100,
                            backgroundColor: Colors.pink[100],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.redAccent,
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
