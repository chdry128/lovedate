import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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

  Future<void> generateQuote() async {
    setState(() {
      isLoading = true;
    });

    try {
      const url = 'https://integrate.api.nvidia.com/v1/chat/completions';
      const apiKey = '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';

      // Updated headers and request body format
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

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        setState(() {
          quote =
          data['choices'][0]['message']['content']; // Adjust based on actual API response
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
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: const Text(
          "Love & Desire Quotes",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.redAccent,
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
                child: Center(
                  child: SingleChildScrollView(
                    child: Text(
                      quote,
                      style: const TextStyle(
                        fontSize: 22,
                        fontStyle: FontStyle.italic,
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
              child:
              isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Generate Quote"),
            ),
            IconButton(
              onPressed: copyToClipboard,
              icon: const Icon(Icons.copy),
              tooltip: "Copy Quote",
            ),
          ],
        ),
      ),
    );
  }
}
