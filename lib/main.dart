import 'package:flutter/material.dart';
import 'package:flutter_dropzone/flutter_dropzone.dart';
import 'package:get/get.dart';
import 'Controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Translator App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(title: 'Translator App'),
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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: GetBuilder<TranslatorController>(
        builder: (_) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Drag-and-Drop Area
                Container(
      height: 200,
      width: double.infinity,
      color: Colors.grey[200],
      child: DropzoneView(
        onCreated: (controller) => 
          Get.find<TranslatorController>().setDropzoneController(controller),
        onDrop: (event) async {
          await Get.find<TranslatorController>().audiodrop();
        },
      ),
    ),

    const SizedBox(height: 16),

    // Upload Button
    ElevatedButton(
      onPressed: () async {
        await Get.find<TranslatorController>().audiodrop();
      },
      child: const Text('Upload Audio'),
    ),
                const SizedBox(height: 16),

                // Input and Translation Widgets
                Row(children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: controller.inputTextController,
                      focusNode: inputFocusNode,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Enter text to translate",
                      ),
                      maxLines: 6,
                    ),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    flex: 1,
                    child: DropdownButton<String>(
                      value: controller.selectedItem2,
                      hint: const Text('Language to be translated'),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.changelanguage2(newValue);
                        }
                      },
                      items:
                          _items.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        );
                      }).toList(),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.green),
                      underline: Container(
                        height: 2,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ]),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    inputFocusNode.requestFocus();
                    controller.translateText();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color.fromARGB(255, 56, 196, 239), // Button color
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
                const SizedBox(height: 16),
                Row(children: [
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: controller.translatedTextController,
                      focusNode: inputFocusNode,
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Translated Text"),
                      maxLines: 6,
                    ),
                  ),
                  const SizedBox(width: 50),
                  Expanded(
                    flex: 1,
                    child: DropdownButton<String>(
                      value: controller.selectedItem,
                      hint: const Text('Language to translate to'),
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          controller.changelanguage(newValue);
                        }
                      },
                      items:
                          _items.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: const TextStyle(color: Colors.blue),
                          ),
                        );
                      }).toList(),
                      icon: const Icon(Icons.arrow_drop_down, color: Colors.green),
                      underline: Container(
                        height: 2,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }
}
