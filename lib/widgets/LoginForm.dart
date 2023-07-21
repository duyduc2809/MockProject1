import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mock_prj1/helpers/PrefHelper.dart';
import '../Validator.dart';
import '../helpers/SQLAccountHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/HomeScreen.dart';

class LoginForm extends StatefulWidget {
  final VoidCallback onSwitchForm;

  LoginForm({required this.onSwitchForm});

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
            TextFormField(
              controller: _emailController,
              validator: (value) => Validator.emailValidator(value),
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email), hintText: 'Email'),
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
              decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock), hintText: 'Password'),
            ),
            CheckboxListTile(
              title: Text("Remember me"),
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
    final account = await SQLAccountHelper.getAccounts();
    account.forEach((acc) {
      if (acc['email'] == _emailController.text &&
          acc['password'] == _passwordController.text) {
        SQLAccountHelper.setCurrentAccount(_emailController);
        PrefHelper.saveCredentials(
            _rememberMe, _emailController, _passwordController);
        Navigator.push(
            this.context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        ScaffoldMessenger.of(this.context).showSnackBar(
            const SnackBar(content: Text('Wrong username or password')));
      }
    });
  }
}
