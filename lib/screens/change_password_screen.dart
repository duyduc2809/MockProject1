import 'package:flutter/material.dart';
import 'package:mock_prj1/validator.dart';
import 'package:mock_prj1/screens/home_screen.dart';

import '../constants/text_style_constant.dart';


class ChangePassWord extends StatefulWidget {
  const ChangePassWord({super.key});

  @override
  State<ChangePassWord> createState() => _ChangePassWordState();
}

class _ChangePassWordState extends State<ChangePassWord> {
  final _formkey = GlobalKey<FormState>();
  final _currentPassController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmnewPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Form(
              key: _formkey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Text('Change Your Password'),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _currentPassController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter current password',
                      hintStyle: hintTextStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _newPassController,
                    validator: (value) => Validator.passwordValidator(value),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter new password',
                      hintStyle: hintTextStyle,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    controller: _confirmnewPassController,
                    validator: (value) => Validator.confirmPasswordValidator(
                        value, _newPassController),
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter password again',
                        hintStyle: hintTextStyle),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () {}, child: const Text('Change')),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const HomePage()));
                          },
                          child: const Text('Home'))
                    ],
                  ),
                ],
              )),
        ));
  }
}
