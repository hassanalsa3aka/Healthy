import 'package:flutter/cupertino.dart';
import 'package:healthy/chatbot/Api.dart';
import 'package:healthy/chatbot/mchat.dart';



class ChatProvider with ChangeNotifier {
  List<Mchat> chatList = [];
  List<Mchat> get getChatList {
    return chatList;
  }

  void addUserMessage({required String msg}) {
    chatList.add(Mchat(msg: msg, chatIndex: 0));
    notifyListeners();
  }

  Future<void> sendMessageAndGetAnswers(
      {required String msg, required String chosenModelId}) async {
    if (chosenModelId.toLowerCase().startsWith("gpt")) {
      chatList.addAll(await Api.sendMessageGPT(
        message: msg,
        modelId: chosenModelId,
      ));
    } else {
      chatList.addAll(await Api.sendMessage(
        message: msg,
        modelId: chosenModelId,
      ));
    }
    notifyListeners();
  }
}
