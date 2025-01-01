import 'package:flutter/material.dart';
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
      home:  MyHomePage(title: 'Translator App'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});
  final FocusNode inputFocusNode = FocusNode();

  final String title;
  @override
  Widget build(BuildContext context) {
    TranslatorController controller = Get.put(TranslatorController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: controller.inputTextController,
              focusNode: inputFocusNode,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Enter text to translate"),
              maxLines: 6,
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: () {
                inputFocusNode.requestFocus();
                controller.translateText();
              },
              child: const Text('Translate'),
            ),
            const SizedBox(
              height: 5,
            ),
            TextField(
              controller: controller.translatedTextController,
              focusNode: inputFocusNode,
              decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: controller.translatedTextController.text),
              maxLines: 6,
            )
          ],
        ),
      ),
    );
  }
}
