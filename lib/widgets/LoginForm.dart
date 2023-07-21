import 'package:flutter/material.dart';
import 'package:mock_prj1/screens/ItemScreen.dart';
import 'package:path/path.dart';
import '../Validator.dart';
import '../helpers/SQLAccountHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  // _loadRememberMeStatus() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _rememberMe = prefs.getBool('rememberMe') ?? false;
  //     if (_rememberMe) {
  //       _loadSavedCredentials();
  //       _login(context as BuildContext);
  //     }
  //   });
  // }
  _loadRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        _loadSavedCredentials();
        _login();
      }
    });
  }

  _loadSavedCredentials() async {
    var user = await SQLAccountHelper.getAccountToSave();
    if (user != null) {
      _emailController.text = user['email'].toString();
      _passwordController.text = user['password'].toString();
    }
  }

  _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('rememberMe', _rememberMe);
    if (_rememberMe) {
      String email = _emailController.text;
      String password = _passwordController.text;
      SQLAccountHelper db = SQLAccountHelper();
      await SQLAccountHelper.saveUser(email, password);
    }
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
                ElevatedButton(onPressed: () {}, child: const Text('Exit'))
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
        _saveCredentials();
        Navigator.push(this.context,
            MaterialPageRoute(builder: (context) => ItemsScreen()));
      } else {
        ScaffoldMessenger.of(this.context).showSnackBar(
            const SnackBar(content: Text('Wrong username or password')));
      }
    });
  }
}
