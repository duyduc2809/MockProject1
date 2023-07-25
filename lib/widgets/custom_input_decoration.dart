import 'package:flutter/material.dart';

import '../constants/dimension_constant.dart';

class CustomInputDecoration extends InputDecoration {
  CustomInputDecoration({
    String? labelText,
    String? hintText,
     Icon? prefixIcon,
    Widget? suffixIcon,
    bool enabled = true,
  }) : super(
          labelText: labelText,
          hintText: hintText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          enabled: enabled,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kMediumPadding),
          ),
          // Customize the properties below according to your needs
          // focusedBorder: const OutlineInputBorder(
          //   borderSide: BorderSide(color: Colors.blue, width: 2.0),
          // ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kMediumPadding),
            borderSide: BorderSide(color: Colors.grey, width: 1.0),
          ),
          errorBorder:  OutlineInputBorder(
              borderRadius: BorderRadius.circular(kMediumPadding),
            borderSide: BorderSide(color: Colors.red, width: 1.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kMediumPadding),
            borderSide: BorderSide(color: Colors.red, width: 2.0),
          ),
          // labelStyle: const TextStyle(color: Colors.green),
          // hintStyle: const TextStyle(color: Colors.grey),
        );
}
