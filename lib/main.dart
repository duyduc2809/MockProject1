import 'package:flutter/material.dart';
import 'package:mock_prj1/constants/color_constant.dart';
import 'screens/authentication_screen.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return MaterialApp(
      theme: ThemeData(
        colorScheme: const ColorScheme.light().copyWith(
            primary: ColorPalette.primaryColor,
            secondary: ColorPalette.secondaryColor),
      ),
      // buttonTheme: ButtonTheme(buttonColor: Colors.black),
      // appBarTheme: AppBarTheme(color: Colors.black)),
      debugShowCheckedModeBanner: false,
      home: const AuthenticationScreen(),
    );
  }
}
