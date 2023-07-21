import 'package:flutter/material.dart';
import 'package:mock_prj1/screens/DualFormScreen.dart';
import 'package:mock_prj1/screens/homeScreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DualFormScreen(),
    );
  }
}
