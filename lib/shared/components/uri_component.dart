import 'dart:convert';
import 'package:http/http.dart' as http;

import '../api/api_key_constant.dart';

Future<String> generateResponse(String prompt) async {
  var url = Uri.parse("https://api.openai.com/v1/chat/completions");

  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiSecretKey',
      },
      body: jsonEncode({
        'model': 'gpt-3.5-turbo',
        "messages": [
          {
            'role': 'user',
            'content': prompt,

          }
        ],
      }),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data['choices'] != null && data['choices'].isNotEmpty) {
        print(data['choices'][0]['message']['content']);
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('No response in the data');
      }
    } else {
      throw Exception('Failed to load response with status code: ${response.statusCode}');
    }
  } catch (e) {
    print('Exception caught: $e');
    return 'Error: $e';
  }
}
