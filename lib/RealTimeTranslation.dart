import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translator/translator.dart'; // For translation
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:translator_app/Controller.dart';

class Realtimetranslation extends StatelessWidget {
   Realtimetranslation(
      {super.key}); // 
  final TranslatorController controller5 = Get.put(TranslatorController());
int i=1;
  Realtimetranslation.initSpeech({super.key});
  final List<String> _items = ['en', 'fr', 'es', 'de', 'ur', 'hi'];

  @override
  Widget build(BuildContext context) {
    TranslatorController controller5 = Get.put(TranslatorController());

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Audio Translation',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: GetBuilder<TranslatorController>(
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButton<String>(
                                  value: controller5.selectedItem5,
                                  dropdownColor: const Color.fromARGB(255, 45, 45, 45), // Set the dropdown menu background color to black

                                  hint: const Text(
                                    'Language to translate to',
                                    style: TextStyle(
                                        color: Colors
                                            .white), // Set text color to white
                                  ),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      controller5.changelanguage5(newValue);
                                    }
                                  },
                                  isExpanded: true,
                                  items: _items.map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value,
                                          style: const TextStyle(
                                              color: Colors.blue)),
                                    );
                                  }).toList(),
                                  icon: const Icon(Icons.arrow_drop_down,
                                      color: Colors.green),
                                  underline: Container(
                                      height: 2, color: Colors.transparent),
                                ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: controller5.translatedTextController5,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Translated Text",
                            labelStyle: TextStyle(color: Colors.white),
                            hintStyle: TextStyle(color: Colors.white),
                          ),
                          style: const TextStyle(color: Colors.white),
                          maxLines: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () async {
                          if(i==1){
                          controller5.startListening(); // Start real-time speech recognition
                          i=0;}else{
                            controller5.stopListening();
                            i=1;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:i==1?
                              const Color.fromARGB(255, 45, 252, 128): Colors.red,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        child:  Text(
                          i == 1 ? 'Start Speaking' : 'Stop Speaking',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),                      
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
