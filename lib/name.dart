import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NameCompatibilityPage extends StatefulWidget {
  const NameCompatibilityPage({super.key});

  @override
  _NameCompatibilityPageState createState() => _NameCompatibilityPageState();
}

class _NameCompatibilityPageState extends State<NameCompatibilityPage> {
  final _yourNameController = TextEditingController();
  final _partnerNameController = TextEditingController();
  String _compatibilityResult = '';
  String _nickname = '';
  double _compatibilityPercentage = 0.0;
  bool _isLoading = false;

  Future<void> _generateNickname() async {
    if (_yourNameController.text.isEmpty || _partnerNameController.text.isEmpty) {
      setState(() {
        _compatibilityResult = 'Please enter both names, my darling!';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      const url = 'https://integrate.api.nvidia.com/v1/chat/completions';
      const apiKey = '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';

      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "model": "baichuan-inc/baichuan2-13b-chat",
          "messages": [
            {
              "role": "user",
              "content": "Generate a cute and romantic nickname for a couple where one person's name is ${_yourNameController.text} and the other's name is ${_partnerNameController.text}. The nickname should be a creative combination of their names, like 'Virushka' for Virat and Anushka. Make it short, sweet, and romantic. Return only the nickname without any explanation."
            }
          ],
          "temperature": 0.7,
          "top_p": 1,
          "max_tokens": 1024,
          "stream": false
        }),
      );

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        String generatedNickname = data['choices'][0]['message']['content'].trim();
        
        // Calculate compatibility based on name lengths and character matches
        String name1 = _yourNameController.text.toLowerCase();
        String name2 = _partnerNameController.text.toLowerCase();
        int commonChars = name1.split('').where((char) => name2.contains(char)).length;
        int totalChars = name1.length + name2.length;
        double compatibility = (commonChars / totalChars) * 100;
        
        setState(() {
          _nickname = generatedNickname;
          _compatibilityPercentage = compatibility;
          _compatibilityResult = _getCompatibilityMessage(compatibility);
        });
      } else {
        setState(() {
          _compatibilityResult = 'Failed to generate nickname. Please try again.';
        });
      }
    } catch (e) {
      setState(() {
        _compatibilityResult = 'Error: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  String _getCompatibilityMessage(double percentage) {
    if (percentage > 80) {
      return 'Your names are perfectly matched! A love story written in the stars!';
    } else if (percentage > 60) {
      return 'Beautiful compatibility! Your names dance together in harmony!';
    } else if (percentage > 40) {
      return 'Interesting combination! Your names create a unique melody!';
    } else {
      return 'Your names are like puzzle pieces - different but meant to fit together!';
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
                // Header with hearts
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.favorite, color: Colors.red[700], size: 30),
                    SizedBox(width: 10),
                    Text(
                      'Name Compatibility',
                      style: TextStyle(
                        fontSize: 30,
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
                    Icon(Icons.favorite, color: Colors.red[700], size: 30),
                  ],
                ),
                SizedBox(height: 40),

                // Input Container
                Container(
                  width: 400,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity( 0.5),
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
                        style: TextStyle(color: Colors.deepPurple[900], fontSize: 16),
                        decoration: InputDecoration(
                          labelText: 'Your Name, Sweetheart',
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
                        style: TextStyle(color: Colors.deepPurple[900], fontSize: 16),
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

                      // Generate Button
                      ElevatedButton(
                        onPressed: _isLoading ? null : _generateNickname,
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
                        child: _isLoading
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'Generate Love Nickname',
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
                if (_compatibilityResult.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Column(
                      children: [
                        Text(
                          'Love Compatibility',
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
                          child: Column(
                            children: [
                              Text(
                                _compatibilityResult,
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.red[800],
                                  fontStyle: FontStyle.italic,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              if (_nickname.isNotEmpty) ...[
                                SizedBox(height: 20),
                                Text(
                                  'Your Love Nickname:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.deepPurple[800],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  _nickname,
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.redAccent,
                                    fontWeight: FontWeight.bold,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        // Compatibility Bar
                        SizedBox(
                          width: 300,
                          child: LinearProgressIndicator(
                            value: _compatibilityPercentage / 100,
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
