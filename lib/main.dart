import 'package:flutter/material.dart';
import 'Translate_Text.dart';
import 'AudioUpload.dart';
import 'HomePage.dart';
void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:  HomePage(title: 'Translatetext'), // Passing the required argument
    );
  }
}