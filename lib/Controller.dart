import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';

class TranslatorController extends GetxController {
  String inputText = '';
  String translatedText = '';

  String selectedItem = 'en';
  String selectedItem2 = 'en';
  TextEditingController inputTextController = TextEditingController();
  TextEditingController translatedTextController = TextEditingController();
  final GoogleTranslator translator = GoogleTranslator();

  Future<void> translateText() async {
    try {
      final translation =
          await translator.translate(inputTextController.text,from: selectedItem2 ,to: selectedItem);
      translatedText = translation.text;
      translatedTextController.text = translatedText;
    } catch (e) {
      print('Error during translation: $e');
    }
  }

  changelanguage(String newValue) {
    selectedItem = newValue;
    update();
  }
  changelanguage2(String newValue) {
    selectedItem2 = newValue;
    update();
  }
}
