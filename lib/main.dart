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
      theme: ThemeData(
        colorScheme: const ColorScheme.light()
            .copyWith(primary: Colors.black, secondary: Colors.orange),
      ),
      // buttonTheme: ButtonTheme(buttonColor: Colors.black),
      // appBarTheme: AppBarTheme(color: Colors.black)),
      debugShowCheckedModeBanner: false,
      home: DualFormScreen(),
    );
  }
}
