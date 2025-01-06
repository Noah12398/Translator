import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:translator/translator.dart';
import 'package:http/http.dart' as http;

class TranslatorController extends GetxController {
  String inputText = '';
  String translatedText = '';
  String selectedItem = 'en'; // Target language
  String selectedItem2 = 'en'; // Source language

  TextEditingController inputTextController = TextEditingController();
  TextEditingController translatedTextController = TextEditingController();

  final GoogleTranslator translator = GoogleTranslator();

  // Base URL for AssemblyAI
  final String baseUrl = "https://api.assemblyai.com/v2";

  // Method to handle audio transcription
  Future<String?> transcribeAudio(String audioUrl) async {
    final url = Uri.parse('$baseUrl/transcript');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ' // Replace with your actual API key
        },
        body: json.encode({'audio_url': audioUrl}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final transcriptionId =
            data['id']; // Assuming the transcription ID is returned in 'id'

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
        return null; // Handle API errors here
      }
    } catch (e) {
      print('Exception: $e');
      return null; // Catch any other exceptions
    }
  }

  Future<String?> _pollTranscriptionStatus(String transcriptionId) async {
    final url = Uri.parse('$baseUrl/transcript/$transcriptionId');

    // Keep checking until the status is 'completed'
    while (true) {
      try {
        final response = await http.get(
          url,
          headers: {
            'Authorization':
                '', // Use the same API key
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['status'] == 'completed') {
            print("Transcription completed!");
            translatedTextController.text = data['text'];
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

      // Wait for a short period before polling again (e.g., 5 seconds)
      await Future.delayed(Duration(seconds: 5));
    }
  }

  // Method to translate the transcribed text
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

  // Language change methods
  changelanguage(String newValue) {
    selectedItem = newValue;
    update();
  }

  changelanguage2(String newValue) {
    selectedItem2 = newValue;
    update();
  }

  String dropStatus = 'Drag & Drop an Audio File Here';
  late DropzoneViewController dropzoneController;

  // Initialize Dropzone
  void initializeDropzone(DropzoneViewController controller) {
    dropzoneController = controller;
  }

  void setDropzoneController(DropzoneViewController controller) {
    dropzoneController = controller;
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

      // Extract file details
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

  /// Method to handle file upload
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
}
