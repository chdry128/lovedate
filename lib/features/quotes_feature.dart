import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// import 'package:heart_beat/theam.dart'; // Removed, will use Theme.of(context)

class RomanticQuotesPage extends StatefulWidget {
  const RomanticQuotesPage({super.key});

  @override
  _RomanticQuotesPageState createState() => _RomanticQuotesPageState();
}

class _RomanticQuotesPageState extends State<RomanticQuotesPage> {
  String selectedCategory = 'Romantic';
  String quote = "Tap the button to generate a quote";
  bool isLoading = false;

  Future<void> copyToClipboard() async {
    await Clipboard.setData(ClipboardData(text: quote));
    if (!mounted) return; // Check if the widget is still in the tree
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Quote copied to clipboard!')));
  }

  Future<void> generateQuote() async {
    setState(() {
      isLoading = true;
    });

    try {
      const url = 'https://integrate.api.nvidia.com/v1/chat/completions';
      final apiKey = dotenv.env['NVIDIA_API_KEY'];

      if (apiKey == null) {
        setState(() {
          quote = "API key not found. Please set NVIDIA_API_KEY in .env file.";
          isLoading = false;
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
              "content": "Generate a ${selectedCategory.toLowerCase()} quote for my lover. Make it short and sweet in simple English and dont repeat the same quote ever ."
            }
          ],
          "temperature": 0.5,
          "top_p": 1,
          "max_tokens": 1024,
          "stream": false
        }),
      );

      // print("Response Status Code: ${response.statusCode}"); // For debugging
      // print("Response Body: ${response.body}"); // For debugging

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        if (mounted) {
          setState(() {
            quote =
            data['choices'][0]['message']['content']; 
          });
        }
      } else {
        if (mounted) {
          setState(() {
            quote =
            "Failed to generate a quote. Error Code: ${response.statusCode}";
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          quote = "Error: $e";
        });
      }
      // print("Error: $e"); // For debugging
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context); // Using Theme.of(context)

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Love & Desire Quotes",
          // style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Use AppBar theme
        ),
        // backgroundColor: Colors.redAccent, // Use AppBar theme from main.dart
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedCategory,
              isExpanded: true,
              dropdownColor: theme.cardColor, // Use theme color for dropdown
              style: theme.textTheme.titleMedium, // Use theme text style
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                }
              },
              items:
              ["Romantic", "Sexy", "Naughty"].map<DropdownMenuItem<String>>(
                    (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                },
              ).toList(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration( // Added a subtle border and background
                  color: theme.colorScheme.surface.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: theme.colorScheme.outline.withOpacity(0.3))
                ),
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(
                      quote,
                      style: theme.textTheme.headlineSmall?.copyWith(
                            fontStyle: FontStyle.italic,
                            color: theme.colorScheme.onSurface, // Use theme color
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : generateQuote,
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                textStyle: TextStyle(fontSize: 16)
              ),
              child: isLoading
                  ? SizedBox( // Constrained CircularProgressIndicator
                      width: 24, 
                      height: 24, 
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.onPrimary), // Ensure visibility on button
                      )
                    )
                  : const Text("Generate Quote"),
            ),
            IconButton(
              onPressed: copyToClipboard,
              icon: Icon(Icons.copy,
                  color: theme.colorScheme.primary),
              tooltip: "Copy Quote",
            ),
          ],
        ),
      ),
    );
  }
}
