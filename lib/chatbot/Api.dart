import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:healthy/chatbot/mchat.dart';
import 'package:http/http.dart' as http;

class Api {


  // Send Message using ChatGPT API
  static Future<List<Mchat>> sendMessageGPT(
      {required String message, required String modelId}) async {
    try {
      log("modelId $modelId");
      var response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          'Authorization': 'Bearer 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',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "messages": [
              {
                "role": "user",
                "content": message,
              }
            ]
          },
        ),
      );


      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['error'] != null) {

        throw HttpException(jsonResponse['error']["message"]);
      }
      List<Mchat> chatList = [];
      if (jsonResponse["choices"].length > 0) {

        chatList = List.generate(
          jsonResponse["choices"].length,
              (index) => Mchat(
            msg: jsonResponse["choices"][index]["message"]["content"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }

  // Send Message fct
  static Future<List<Mchat>> sendMessage(
      {required String message, required String modelId}) async {
    try {
      log("modelId $modelId");
      var response = await http.post(
        Uri.parse("https://api.openai.com/v1/completions"),
        headers: {
          'Authorization': 'Bearer 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',
          "Content-Type": "application/json"
        },
        body: jsonEncode(
          {
            "model": modelId,
            "prompt": message,
          },
        ),
      );



      Map jsonResponse = json.decode(utf8.decode(response.bodyBytes));
      if (jsonResponse['error'] != null) {

        throw HttpException(jsonResponse['error']["message"]);
      }
      List<Mchat> chatList = [];
      if (jsonResponse["choices"].length > 0) {

        chatList = List.generate(
          jsonResponse["choices"].length,
              (index) => Mchat(
            msg: jsonResponse["choices"][index]["text"],
            chatIndex: 1,
          ),
        );
      }
      return chatList;
    } catch (error) {
      log("error $error");
      rethrow;
    }
  }
}
