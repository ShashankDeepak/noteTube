import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constants/api.dart';

class ChatGptController extends GetxController {
  Future<String> generateText(String prompt) async {
    try {
      Map<String, dynamic> requestBody = {
        "model": "text-davinci-003",
        "prompt": prompt,
        "temperature": 0,
        "max_tokens": 100,
      };

      var url = Uri.parse('https://api.openai.com/v1/completions');

      var response = await http.post(url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $gptApiKey"
          },
          body: json.encode(requestBody));

      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);
        print(
            "////////////////////////////////////////////////////////////////////////");
        return responseJson["choices"][0]["text"];
      } else {
        return "Failed to generate text: ${response.body}";
      }
    } catch (e) {
      return "Failed to generate text: $e";
    }
  }
}
