
import 'package:flutter/cupertino.dart';
import 'package:healthy/chatbot/Models.dart';

class MProvider with ChangeNotifier {

  String currentModel = "gpt-3.5-turbo-0613";

  String get getCurrentModel {
    return currentModel;
  }

  void setCurrentModel(String newModel) {
    currentModel = newModel;
    notifyListeners();
  }

  List<Models> modelsList = [];

  List<Models> get getModelsList {
    return modelsList;
  }


}
