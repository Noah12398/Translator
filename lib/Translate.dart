import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator_app/Controller.dart';

class Translatetext extends StatelessWidget {
  Translatetext(String s, translate, Type text, {super.key, required this.title});
  final FocusNode inputFocusNode = FocusNode();
  final String title;
  final List<String> _items = ['en', 'fr', 'es', 'de', 'ur', 'hi'];
  @override
  Widget build(BuildContext context) {
        TranslatorController controller = Get.put(TranslatorController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Set AppBar background color to black
        title: const Text('Translate Text'),
      ),
      body: GetBuilder<TranslatorController>(
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 16),
                // Center - Input TextField, Translate Button, Dropdown
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      DropdownButton<String>(
                        value: controller.selectedItem2,
                        hint: const Text('Language to be translated'),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            controller.changelanguage2(newValue);
                          }
                        },
                        items: _items
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(color: Colors.blue),
                            ),
                          );
                        }).toList(),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.green),
                        underline: Container(
                          height: 2,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: controller.inputTextController,
                        focusNode: inputFocusNode,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Enter text to translate",
                        ),
                        maxLines: 6,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          inputFocusNode.requestFocus();
                          controller.translateText();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 56, 196, 239),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Translate',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                // Right Side - Translated Text and Dropdown
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      DropdownButton<String>(
                        value: controller.selectedItem,
                        hint: const Text('Language to translate to'),
                        onChanged: (String? newValue) {
                          if (newValue != null) {
                            controller.changelanguage(newValue);
                          }
                        },
                        items: _items
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(color: Colors.blue),
                            ),
                          );
                        }).toList(),
                        icon: const Icon(Icons.arrow_drop_down,
                            color: Colors.green),
                        underline: Container(
                          height: 2,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: controller.translatedTextController,
                        focusNode: inputFocusNode,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Translated Text",
                        ),
                        maxLines: 6,
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
