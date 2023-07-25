import 'package:flutter/material.dart';
import 'screens/authentication_screen.dart';

import 'screens/note_screen.dart';

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
      home: const DualFormScreen(),
    );
  }
}
