import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator_app/Controller.dart';

class Translatetextno extends StatelessWidget {
  Translatetextno(
      {super.key, required this.title}); // Constructor with required title

  final FocusNode inputFocusNode = FocusNode();
  final String title;
  final List<String> _items = ['en', 'fr', 'es', 'de', 'ur', 'hi'];

  @override
  Widget build(BuildContext context) {
    TranslatorController controller = Get.put(TranslatorController());
    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      appBar: AppBar(
        backgroundColor: Colors.black, // Set AppBar background color to black
        title: const Text(
          'Translate Text',
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
      ),
      body: GetBuilder<TranslatorController>(
        builder: (_) {
          return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left Side - Input Section
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Language Dropdown for Translation
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: DropdownButton<String>(
                                  dropdownColor:
                                      const Color.fromARGB(255, 45, 45, 45),
                                  value: controller.selectedItem2,
                                  hint: const Text(
                                    'Language to be translated',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 255, 255,
                                            255)), // Set text color to white
                                  ),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      controller.changelanguage2(newValue);
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
                              ),
                              const SizedBox(height: 16),

                              // TextField for Input Text
                              TextField(
                                controller: controller.inputTextController,
                                focusNode: inputFocusNode,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Enter text to translate",
                                  labelStyle: TextStyle(
                                      color: Colors
                                          .white), // Set label color to white
                                  hintStyle: TextStyle(
                                      color: Colors
                                          .white), // Set hint text color to white
                                ),
                                style: const TextStyle(
                                    color: Colors
                                        .white), // Set text color to white
                                maxLines: 15,
                              ),
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),

                        // Right Side - Translated Text Section
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Language Dropdown for Translated Text
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: DropdownButton<String>(
                                  value: controller.selectedItem,
                                  dropdownColor:
                                      const Color.fromARGB(255, 45, 45, 45),
                                  hint: const Text(
                                    'Language to translate to',
                                    style: TextStyle(
                                        color: Colors
                                            .white), // Set text color to white
                                  ),
                                  onChanged: (String? newValue) {
                                    if (newValue != null) {
                                      controller.changelanguage(newValue);
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
                              ),
                              const SizedBox(height: 16),

                              // TextField for Translated Text
                              TextField(
                                readOnly: true,
                                controller: controller.translatedTextController,
                                focusNode: inputFocusNode,
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: "Translated Text",
                                  labelStyle: TextStyle(
                                      color: Colors
                                          .white), // Set label color to white
                                  hintStyle: TextStyle(
                                      color: Colors
                                          .white), // Set hint text color to white
                                ),
                                style: const TextStyle(
                                    color: Colors
                                        .white), // Set text color to white
                                maxLines: 15,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        inputFocusNode.requestFocus();
                        controller.translateText();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 45, 252, 128),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16), // Adjust padding
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                        minimumSize: const Size(
                            200, 60), // Set minimum size for the button
                      ),
                      child: const Text(
                        'Translate',
                        style: TextStyle(
                          fontSize: 20, // Increase font size
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ));
        },
      ),
    );
  }
}
