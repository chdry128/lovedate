import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

class AiLetterService {
  static const String _apiUrl =
      'https://openrouter.ai/api/v1/chat/completions'; // Replace with actual API URL

  // Check if the device is connected to the internet
  static Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Generate a love letter using the AI API
  static Future<String?> generateLoveLetter({
    required String yourName,
    required String partnerName,
    String? specialMemory,
    String? formattedDate,
    required String tone,
    String? additionalDetails,
  }) async {
    try {
      // Check connectivity first
      if (!await isConnected()) {
        return null; // Return null to indicate offline mode should be used
      }

      // Prepare the prompt with all the details
      final String prompt = _buildPrompt(
        yourName: yourName,
        partnerName: partnerName,
        specialMemory: specialMemory,
        formattedDate: formattedDate,
        tone: tone,
        additionalDetails: additionalDetails,
      );

      // Prepare the request body
      final Map<String, dynamic> requestBody = {
        "model": "openai/gpt-4o",
        "messages": [
          {"role": "user", "content": prompt},
        ],
        "temperature": 0.1,
        "top_p": 0.7,
        "max_tokens": 512,
        "stream": false, // Changed to false for simpler implementation
      };

      // Make the API request
      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer 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', // Replace with actual API key
        },
        body: jsonEncode(requestBody),
      );

      // Check if the request was successful
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        // Extract the generated text from the response
        // Note: Adjust this based on the actual API response structure
        final String generatedText = data['choices'][0]['message']['content'];
        return generatedText;
      } else {
        print('API Error: ${response.statusCode} - ${response.body}');
        return null; // Return null to fall back to offline generation
      }
    } catch (e) {
      print('Exception during API call: $e');
      return null; // Return null to fall back to offline generation
    }
  }

  // Build a prompt for the AI model based on the user's input
  static String _buildPrompt({
    required String yourName,
    required String partnerName,
    String? specialMemory,
    String? formattedDate,
    required String tone,
    String? additionalDetails,
  }) {
    String prompt = '''
Write a heartfelt and $tone love letter from $yourName to $partnerName, expressing deep affection, admiration, and love.
''';

    // Add optional details section only if there are any optional details
    if (specialMemory != null ||
        formattedDate != null ||
        (additionalDetails != null && additionalDetails.isNotEmpty)) {
      prompt += '\nInclude these specific details:\n';

      if (specialMemory != null && specialMemory.isNotEmpty) {
        prompt += '- Special memory: $specialMemory\n';
      }

      if (formattedDate != null && formattedDate.isNotEmpty) {
        prompt += '- Special date: $formattedDate\n';
      }

      if (additionalDetails != null && additionalDetails.isNotEmpty) {
        prompt += '- Additional details: $additionalDetails\n';
      }

      prompt += '''
Make it sincere, $tone, and warm — something that will make them feel truly loved and cherished.
Format the letter with a proper greeting, 2-3 paragraphs of content, and a loving signature from $yourName.
''';

      return prompt;
    }
    // Always return the prompt, even if no optional details were added
    return prompt;
  }
}
