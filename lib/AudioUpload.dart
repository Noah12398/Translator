import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'package:translator_app/Controller.dart';

class AudioUpload extends StatelessWidget {
  AudioUpload(
      {super.key, required this.title}); // Constructor with required title
  final FocusNode inputFocusNode = FocusNode();
  final String title;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Translator App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Audio Upload'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});
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
        title: Text(
          title,
          style: const TextStyle(
              color: Colors.white), // Set title text color to white
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
                        // Language Dropdown for Translation
                        const SizedBox(height: 16),

                        // TextField for Translated Text
                        TextField(
                          controller: controller.translatedTextController,
                          focusNode: inputFocusNode,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Translated Text",
                            labelStyle: TextStyle(
                                color:
                                    Colors.white), // Set label color to white
                            hintStyle: TextStyle(
                                color: Colors
                                    .white), // Set hint text color to white
                          ),
                          style: const TextStyle(
                              color: Colors.white), // Set text color to white
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
                      const SizedBox(height: 25),
                      DottedBorder(
                        color: Colors.grey,
                        child: Container(
                          height: 100,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(10), // Adjust as needed
                          ),
                          padding: const EdgeInsets.all(
                              3), // Padding to create the border effect
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 73, 72, 72),
                            ),
                            child: Stack(
                              children: [
                                // The DropzoneView
                                DropzoneView(
                                  onCreated: (controller) =>
                                      Get.find<TranslatorController>()
                                          .setDropzoneController(controller),
                                  onDropFile: (file) async {
                                    await Get.find<TranslatorController>()
                                        .audiodropFile(file);
                                  },
                                ),
                                // Text placed on top of DropzoneView
                                Center(
                                  child: Text(
                                    'Drag and Drop Here',
                                    style: TextStyle(
                                      fontSize: 16, // Customize the font size
                                      color: Colors
                                          .white, // Customize the text color
                                      fontWeight: FontWeight
                                          .bold, // Customize the text style
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () async {
                          await Get.find<TranslatorController>().audiodrop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 45, 252, 128),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 5,
                        ),
                        child: const Text(
                          'Upload Audio',
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
