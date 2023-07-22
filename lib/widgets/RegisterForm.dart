import 'package:flutter/material.dart';
import 'package:mock_prj1/helpers/SQLAccountHelper.dart';

import '../Validator.dart';
import '../classes/Account.dart';
import '../constants/DimensionConstant.dart';
import 'CustomInputDecoration.dart';

class RegisterForm extends StatelessWidget {
  final VoidCallback onSwitchForm;

  RegisterForm({required this.onSwitchForm});

  final _formkey = GlobalKey<FormState>();
  static final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formkey,
        child: Column(
          children: [
            const SizedBox(height: spaceBetweenField,),
            TextFormField(
              controller: _emailController,
              validator: (value) => Validator.emailValidator(value),
              decoration:  CustomInputDecoration(
                  prefixIcon: const Icon(Icons.email), hintText: 'Email'),
            ),
            const SizedBox(height: spaceBetweenField,),
            TextFormField(
              obscureText: true,
              controller: _passwordController,
              validator: (value) => Validator.passwordValidator(value),
              decoration:  CustomInputDecoration(
                  prefixIcon: const Icon(Icons.lock), hintText: 'Password'),
            ),
            const SizedBox(height: spaceBetweenField,),
            TextFormField(
              obscureText: true,
              controller: _confirmPassController,
              validator: (value) => Validator.confirmPasswordValidator(
                  value, _passwordController),
              decoration:  CustomInputDecoration(
                  prefixIcon: const Icon(Icons.lock), hintText: 'Confirm password'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () {
                      if (_formkey.currentState!.validate()) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                'Register successful! Your information: \nEmail: ${_emailController.text}')));
                        _addAccount();
                        _emailController.text = '';
                        _passwordController.text = '';
                      }
                    },
                    child: const Text('Sign up')),
                ElevatedButton(
                    onPressed: onSwitchForm, child: const Text('Sign In'))
              ],
            )
          ],
        ));
  }

  Future<void> _addAccount() async {
    await SQLAccountHelper.createAccount(Account(
      email: _emailController.text,
      password: _passwordController.text,
      firstName: '',
      lastName: '',
    ));
  }
}
