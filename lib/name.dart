import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:heart_beat/theam.dart'; // Import AppTheme

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
      final apiKey = dotenv.env['NAME_API_KEY'];

      if (apiKey == null) {
        setState(() {
          _compatibilityResult =
              "API key for name generation not found. Please set NAME_API_KEY in .env file.";
          _isLoading = false;
        });
        return;
      }

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
          gradient: LinearGradient( // Use theme gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.6),
              Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.8),
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
                    Icon(Icons.favorite, color: Theme.of(context).colorScheme.primary, size: 30), // Use theme color
                    SizedBox(width: 10),
                    Text(
                      'Name Compatibility',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith( // Use theme text style
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        shadows: [
                          Shadow(
                            color: Theme.of(context).colorScheme.secondary.withOpacity(0.5), // Use theme color
                            offset: Offset(2, 2),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.favorite, color: Theme.of(context).colorScheme.primary, size: 30), // Use theme color
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
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16), // Use theme onSurface color
                        decoration: InputDecoration( // Use theme InputDecoration
                          labelText: 'Your Name, Sweetheart',
                          prefixIcon: Icon(Icons.person, color: Theme.of(context).colorScheme.secondary), // Use theme secondary color
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        controller: _partnerNameController,
                        style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 16), // Use theme onSurface color
                        decoration: InputDecoration( // Use theme InputDecoration
                          labelText: "Your Lover's Name",
                          prefixIcon: Icon(Icons.favorite, color: Theme.of(context).colorScheme.secondary), // Use theme secondary color
                        ),
                      ),
                      SizedBox(height: 30),

                      // Generate Button
                      ElevatedButton( // Use theme ElevatedButton
                        onPressed: _isLoading ? null : _generateNickname,
                        child: _isLoading
                            ? CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.onPrimary)) // Use theme onPrimary color
                            : Text(
                                'Generate Love Nickname',
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
                          child: Column(
                            children: [
                              Text(
                                _compatibilityResult,
                                style: Theme.of(context).textTheme.titleLarge?.copyWith( // Use theme text style
                                      color: Theme.of(context).colorScheme.primary,
                                      fontStyle: FontStyle.italic,
                                    ),
                                textAlign: TextAlign.center,
                              ),
                              if (_nickname.isNotEmpty) ...[
                                SizedBox(height: 20),
                                Text(
                                  'Your Love Nickname:',
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith( // Use theme text style
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  _nickname,
                                  style: Theme.of(context).textTheme.headlineSmall?.copyWith( // Use theme text style
                                        color: Theme.of(context).colorScheme.secondary, // Use secondary for nickname emphasis
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
                            backgroundColor: Theme.of(context).colorScheme.secondaryContainer, // Use theme secondary container
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Theme.of(context).colorScheme.primary, // Use theme primary
                            ),
                            minHeight: 12,
                            // borderRadius: BorderRadius.circular(6), // Consider if this is part of global theme
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
