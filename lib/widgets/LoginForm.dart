import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mock_prj1/constants/DimensionConstant.dart';
import 'package:mock_prj1/helpers/PrefHelper.dart';
import '../Validator.dart';
import '../helpers/SQLAccountHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/HomeScreen.dart';
import 'CustomInputDecoration.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onSwitchForm;

  const LoginForm({super.key, required this.onSwitchForm});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMeStatus();
  }

  _loadRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        PrefHelper.loadSavedCredentials(
            _passwordController, _passwordController);
        _login();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(
              height: spaceBetweenField,
            ),
            TextFormField(
              controller: _emailController,
              validator: (value) => Validator.emailValidator(value),
              decoration: CustomInputDecoration(
                  prefixIcon: const Icon(Icons.email), hintText: 'Email'),
            ),
            const SizedBox(
              height: spaceBetweenField,
            ),
            TextFormField(
              obscureText: true,
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              decoration: CustomInputDecoration(
                  prefixIcon: Icon(Icons.lock), hintText: 'Password'),
            ),
            CheckboxListTile(
              title: const Text("Remember me"),
              value: _rememberMe,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value!;
                  print(value);
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        _login();
                      }
                    },
                    child: const Text('Sign in')),
                ElevatedButton(
                    onPressed: () {
                      exit(0);
                    },
                    child: const Text('Exit'))
              ],
            )
          ],
        ));
  }

  _login() async {
    bool isLoginSuccess = false;
    final account = await SQLAccountHelper.getAccounts();
    for (var acc in account) {
      if (acc['email'] == _emailController.text &&
          acc['password'] == _passwordController.text) {
        isLoginSuccess = true;
        SQLAccountHelper.setCurrentAccount(_emailController);
        PrefHelper.saveCredentials(
            _rememberMe, _emailController, _passwordController);
        Navigator.push(this.context,
            MaterialPageRoute(builder: (context) => const HomePage()));
      }
    }
    !isLoginSuccess
        ? ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wrong username or password')))
        : null;
  }
}
