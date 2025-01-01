import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';

class TranslatorController extends GetxController {
  String inputText = '';
  String translatedText = '';
  TextEditingController inputTextController = TextEditingController();
  TextEditingController translatedTextController = TextEditingController();
  final GoogleTranslator translator =GoogleTranslator();

  Future<void> translateText() async {
  try {
    final translation = await translator.translate(inputTextController.text, to: 'en');
    translatedText = translation.text;
    translatedTextController.text = translatedText;
  } catch (e) {
    print('Error during translation: $e');
  }
}

}
