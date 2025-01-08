import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;
import 'RealTimeTranslation.dart';

class TranslatorController extends GetxController {
  String inputText = '';
  String translatedText = '';
  String translatedText5 = '';

  String selectedItem = 'en'; // Target language
  String selectedItem2 = 'en'; // Source language
  String selectedItem5 = 'en'; // Source language
  String selectedItem9 = 'en'; // Source language

  TextEditingController inputTextController = TextEditingController();
  TextEditingController translatedTextController = TextEditingController();
  TextEditingController translatedTextController5 = TextEditingController();
  final GoogleTranslator translator = GoogleTranslator();

  final String baseUrl = "https://api.assemblyai.com/v2";

  Future<String?> transcribeAudio(String audioUrl) async {
    final url = Uri.parse('$baseUrl/transcript');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer '
        },
        body: json.encode({'audio_url': audioUrl}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final transcriptionId = data['id'];

        if (data['status'] == 'queued') {
          return await _pollTranscriptionStatus(transcriptionId);
        } else if (data['status'] == 'completed') {
          print("Completes");
          return data['text'] ?? 'Transcription failed, no text available.';
        } else {
          return 'Transcription not completed yet.';
        }
      } else {
        print('Error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }

  Future<String?> _pollTranscriptionStatus(String transcriptionId) async {
    final url = Uri.parse('$baseUrl/transcript/$transcriptionId');

    while (true) {
      try {
        final response = await http.get(
          url,
          headers: {
            'Authorization': '',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'completed') {
            print("Transcription completed!");
            final translation = await translator.translate(data['text'],
                from: 'en', to: selectedItem9);
            translatedText = translation.text;
            translatedTextController.text = translatedText;
            update();
            return null;
          } else if (data['status'] == 'processing') {
            print("Transcription is still processing...");
          } else if (data['status'] == 'queued') {
            print('Transcription ${data['status']}');
          } else {
            print('Error: ${data['status']}');
          }
        } else {
          print('Error: ${response.body}');
          return null; // Handle API errors here
        }
      } catch (e) {
        print('Exception: $e');
        return null; // Catch any other exceptions
      }

      await Future.delayed(Duration(seconds: 5));
    }
  }

  Future<void> translateText() async {
    if (inputTextController.text.isEmpty) {
      print("Input text is empty");
      Get.snackbar('Error', 'Please enter text to translate.');
      return; // Exit early if there's no text to translate
    }

    if (selectedItem.isEmpty || selectedItem2.isEmpty) {
      print("Language selection is missing or invalid");
      Get.snackbar('Error', 'Please select both source and target languages.');
      return; // Exit early if the language selection is not done
    }

    try {
      final translation = await translator.translate(inputTextController.text,
          from: selectedItem2, to: selectedItem);
      translatedText = translation.text;
      translatedTextController.text = translatedText;
    } catch (e) {
      print('Error during translation: $e');
      Get.snackbar('Error', 'Failed to translate text. Please try again.');
    }
  }

  changelanguage(String newValue) {
    selectedItem = newValue;
    update();
  }

  changelanguage5(String newValue) {
    selectedItem5 = newValue;
    update();
  }
changelanguage9(String newValue) {
    selectedItem9 = newValue;
    update();
  }
  changelanguage2(String newValue) {
    selectedItem2 = newValue;
    update();
  }

  String dropStatus = 'Drag & Drop an Audio File Here';
  late DropzoneViewController dropzoneController;

  void initializeDropzone(DropzoneViewController controller) {
    dropzoneController = controller;
  }

  void setDropzoneController(DropzoneViewController controller) {
    dropzoneController = controller;
  }

  Future<void> audiodropFile(dynamic file) async {
    try {
      final fileName = await dropzoneController.getFilename(file);

      final fileBytes = await dropzoneController.getFileData(file);

      print('File dropped: $fileName');
      _uploadFile(fileName, fileBytes);
    } catch (e) {
      print('Error handling dropped file: $e');
    }
  }

  Future<void> audiodrop() async {
    try {
      final file = await dropzoneController.pickFiles();

      if (file.isEmpty) {
        print('No file selected.');
        update();
        return;
      }

      print('File selected. Uploading...');
      update();

      final fileName = file[0].name;
      final fileBytes = await dropzoneController.getFileData(file[0]);

      final response = await _uploadFile(fileName, fileBytes);

      if (response) {
        print('File uploaded successfully!');
      } else {
        print('Failed to upload file.');
      }
      update();
    } catch (e) {
      print('Error during file selection: $e');
      update();
    }
  }

  Future<bool> _uploadFile(String fileName, Uint8List fileBytes) async {
    try {
      final url = Uri.parse("https://api.assemblyai.com/v2/upload");
      final request = http.MultipartRequest("POST", url)
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Authorization': ''
        })
        ..files.add(
          http.MultipartFile.fromBytes(
            'file',
            fileBytes,
            filename: fileName,
          ),
        );

      final streamedResponse = await request.send();
      if (streamedResponse.statusCode == 200) {
        final response = await http.Response.fromStream(streamedResponse);
        final data = json.decode(response.body);
        final String audioUrl = data["upload_url"];
        transcribeAudio(audioUrl);
        print('File uploaded successfully.');
        return true;
      } else {
        print(
            'Failed to upload file. Status code: ${streamedResponse.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error during file upload: $e');
      return false;
    }
  }

  final SpeechToText _speechToText = SpeechToText();
  bool speechEnabled = false;
  String lastWords = '';

  @override
  void onInit() {
    super.onInit();
    initSpeech();
  }

  void initSpeech() async {
    speechEnabled = await _speechToText.initialize();
    update();
  }

  void startListening() async {
    if (speechEnabled) {
      await _speechToText.listen(onResult: onSpeechResult);
      print("Listening started");
      update(); // Reflect changes in the UI
    } else {
      print("Speech-to-Text is not enabled.");
    }
  }

  // Stop listening for speech
  void stopListening() async {
    if (speechEnabled && _speechToText.isListening) {
      await _speechToText.stop();
      print("Listening stopped");
      update(); // Reflect changes in the UI
    } else {
      print("Speech-to-Text is not listening.");
    }
  }

  // Callback for speech recognition results
  void onSpeechResult(SpeechRecognitionResult result) async {
    lastWords = result.recognizedWords;
    print("Recognized words: ${lastWords}");
    final translation5 =
        await translator.translate(lastWords, from: 'en', to: selectedItem5);
    translatedText5 = translation5.text;
    translatedTextController5.text = translatedText5;
    update(); // Update the UI with recognized words
  }
}
