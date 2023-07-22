import 'package:flutter/material.dart';

class CustomInputDecoration extends InputDecoration {
  CustomInputDecoration({
    String? labelText,
    required String hintText,
    required Icon prefixIcon,
    Icon? suffixIcon,
    bool enabled = true,
  }) : super(
    labelText: labelText,
    hintText: hintText,
    prefixIcon: prefixIcon,
    suffixIcon: suffixIcon,
    enabled: enabled,
    border: const OutlineInputBorder(),
    // Customize the properties below according to your needs
    focusedBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.blue, width: 2.0),
    ),
    enabledBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.grey, width: 1.0),
    ),
    errorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 1.0),
    ),
    focusedErrorBorder: const OutlineInputBorder(
      borderSide: BorderSide(color: Colors.red, width: 2.0),
    ),
    labelStyle: const TextStyle(color: Colors.green),
    hintStyle: const TextStyle(color: Colors.grey),
  );
}
