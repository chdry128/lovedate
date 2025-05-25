import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:heart_beat/theam.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Quote copied to clipboard!')));
  }

  // Check if the device is connected to the internet
  Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> generateQuote() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Check connectivity first
      if (!await isConnected()) {
        setState(() {
          quote =
              "No internet connection. Please check your connection and try again.";
          isLoading = false;
        });
        return;
      }

      const url = 'https://openrouter.ai/api/v1/chat/completions';
      // Get the API key from dotenv, or use a fallback if it's not available
      final apiKey =
          dotenv.env['OPENROUTER_API_KEY'] ??
          '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';

      print("Using API Key: $apiKey");

      if (apiKey.isEmpty) {
        setState(() {
          quote = "API key is empty. Please check your configuration.";
          isLoading = false;
        });
        return;
      }

      // Build the prompt based on the selected category
      final String prompt =
          "Generate a ${selectedCategory.toLowerCase()} quote for my lover. Make it short and sweet in simple English. It should be poetic, meaningful, and express deep affection.";

      // Make the API request
      var response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          "model": "openai/gpt-4o",
          "messages": [
            {"role": "user", "content": prompt},
          ],
          "temperature": 0.7,
          "top_p": 0.7,
          "max_tokens": 150,
          "stream": false,
        }),
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          quote = data['choices'][0]['message']['content'].trim();
        });
      } else {
        setState(() {
          quote =
              "Failed to generate a quote. Error Code: ${response.statusCode}";
        });
      }
    } catch (e) {
      setState(() {
        quote = "Error: $e";
      });
      print("Error: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.pink[50], // Removed hardcoded color
      appBar: AppBar(
        title: Text(
          "Love & Desire Quotes",
          // style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold), // Use AppBar theme
        ),
        // backgroundColor: Colors.redAccent, // Use AppBar theme
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
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedCategory = newValue;
                  });
                }
              },
              items:
                  [
                    "Romantic",
                    "Passionate",
                    "Sweet",
                    "Poetic",
                    "Heartfelt",
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(
                      quote,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontStyle: FontStyle.italic),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : generateQuote,
              child:
                  isLoading
                      ? CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Theme.of(context).colorScheme.primary,
                        ),
                      )
                      : const Text("Generate Quote"),
            ),
            IconButton(
              onPressed: copyToClipboard,
              icon: Icon(
                Icons.copy,
                color: Theme.of(context).colorScheme.primary,
              ),
              tooltip: "Copy Quote",
            ),
          ],
        ),
      ),
    );
  }
}
