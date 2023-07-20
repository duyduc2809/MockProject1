import 'package:flutter/material.dart';
import 'package:mock_prj1/helpers/SQLAccountHelper.dart';

import '../Validator.dart';

class SignInScreen extends StatefulWidget {
  static const routeName = 'intro_screen';

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final _userNameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        final account = await SQLAccountHelper.getAccounts();
                        account.forEach((acc) {
                          if (acc['email'] == _emailController.text &&
                              acc['password'] == _passwordController.text) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content: Text('Login Successful')));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Wrong username or password')));
                          }
                        });
                      }
                    },
                    child: const Text('Sign in'))
              ],
            )),
      ),
    );
  }
}
