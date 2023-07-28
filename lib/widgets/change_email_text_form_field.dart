import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/dimension_constant.dart';

class ChangeEmailTextFormField extends StatefulWidget {
  final Future<bool> Function(String) validator;
  final Duration validationDebounce;
  final TextEditingController controller;
  final String hintText;
  final String isValidatingMessage;
  final String valueIsEmptyMessage;
  final String valueIsInvalidMessage;
  final Icon? prefixIcon;
  final String labelText;
  final bool? isCheckEmpty;
  final String? currentEmail;
  const ChangeEmailTextFormField(
      {Key? key,
        required this.validator,
        required this.validationDebounce,
        required this.controller,
        this.isValidatingMessage = "",
        this.valueIsEmptyMessage = '',
        this.valueIsInvalidMessage = '',
        this.hintText = '',
        this.prefixIcon,
        this.labelText = '', this.isCheckEmpty = true, this.currentEmail})
      : super(key: key);

  @override
  _ChangeEmailTextFormFieldState createState() => _ChangeEmailTextFormFieldState();
}

class _ChangeEmailTextFormFieldState extends State<ChangeEmailTextFormField> {
  Timer? _debounce;
  var isValidating = false;
  var isValid = false;
  var isDirty = false;
  var isWaiting = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (value) {
        if (value == widget.currentEmail) {
          isValid = true;
          return null;
        }
        if (isValidating) {
          // return widget.isValidatingMessage;
          return null;
        }
        if (widget.isCheckEmpty == true) {

          if (value?.isEmpty ?? false) {
            return widget.valueIsEmptyMessage;
          }
        }
        if (!isWaiting && !isValid) {
          return widget.valueIsInvalidMessage;
        }
        return null;
      },
      onChanged: (text) async {
        isDirty = true;
        if (text.isEmpty) {
          setState(() {
            isValid = false;
            print('is empty');
          });
          cancelTimer();
          return;
        }
        isWaiting = true;
        cancelTimer();
        _debounce = Timer(widget.validationDebounce, () async {
          isWaiting = false;
          isValid = await validate(text);

          isValidating = false;
          setState(() {});
        });
      },
      // textAlign: TextAlign.start,
      controller: widget.controller,
      maxLines: 1,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          labelText: widget.labelText,
          suffix: Container(
              alignment: Alignment.center,
              width: 15,
              height: 15,
              child: Container(child: _getSuffixIcon())),
          hintText: widget.hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(kMediumPadding),
          ),
          prefixIcon: widget.prefixIcon),
    );
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void cancelTimer() {
    if (_debounce?.isActive ?? false) {
      _debounce?.cancel();
    }
  }

  Future<bool> validate(String text) async {
    setState(() {
      isValidating = true;
    });
    if (text == widget.currentEmail) {
      return true;
    }
    final isValid = await widget.validator(text);

    isValidating = false;
    return isValid;
  }

  Widget _getSuffixIcon() {
    if (isValidating) {
      return const CircularProgressIndicator(
        strokeWidth: 2.0,
        valueColor: AlwaysStoppedAnimation(Colors.black),
      );
    } else {
      if (!isValid && isDirty) {
        return const Icon(
          Icons.cancel,
          color: Colors.red,
          size: 15,
        );
      } else if (isValid) {
        return const Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 15,
        );
      } else {
        return Container();
      }
    }
  }
}
