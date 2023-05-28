import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../constants/api.dart';

class ChatGptController extends GetxController {
  Future<String> generateText(String prompt) async {
    try {
      var url = Uri.parse('https://simple-chatgpt-api.p.rapidapi.com/ask');

      var headers = {
        'content-type': 'application/json',
        'X-RapidAPI-Key': gptApiKey,
        'X-RapidAPI-Host': 'simple-chatgpt-api.p.rapidapi.com'
      };

      var data = {'question': prompt};
      var response =
          await http.post(url, headers: headers, body: json.encode(data));

      if (response.statusCode == 200) {
        var responseJson = json.decode(response.body);

        return responseJson["answer"];
      } else {
        return "Failed to generate text: ${response.body}";
      }
    } catch (e) {
      return "Failed to generate text: $e";
    }
  }
}
