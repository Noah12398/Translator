import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:translator_app/Controller.dart';
import 'AudioUpload.dart';
import 'Translate_Text.dart';
import 'RealTimeTranslation.dart';
class HomePage extends StatelessWidget {
  const HomePage({super.key, required String title}); // Constructor with required title
  
  @override
  Widget build(BuildContext context) {
    TranslatorController controller = Get.put(TranslatorController());
    final List<String> entries = <String>[
      'Text to Text',
      'AudioUpload',
      'Voice Translation'
    ];
    final List<Widget> screens = <Widget>[
      Translatetextno(
        title: 'Translator App',
      ),
      AudioUpload(
        title: 'Translator App',
      ),
       Realtimetranslation()// Uncomment if VoiceTranslation widget is available
    ];

    return Scaffold(
      backgroundColor: Colors.black, // Set background color to black
      appBar: AppBar(
        backgroundColor: Colors.black, // Set AppBar background color to black
        title: const Text(
          'Translator App',
          style: TextStyle(color: Colors.white), // Set AppBar title text color to white
        ),
      ),
      body: ListView.builder(
        itemCount: screens.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // Navigate to the selected screen
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => screens[index],
                ),
              );
            },
            child: Card(
              elevation: 8,
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16), // Rounded corners
              ),
              color: const Color(0xFF1F1F1F), // Dark background color for cards
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entries[index],
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Set text color to white
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "Tap to view details",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey, // Set description text color to grey
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
