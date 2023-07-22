import 'package:flutter/material.dart';
import 'package:mock_prj1/constants/DimensionConstant.dart';

import '../widgets/LoginForm.dart';
import '../widgets/RegisterForm.dart';

enum FormType { login, register }

class DualFormScreen extends StatefulWidget {
  @override
  _DualFormScreenState createState() => _DualFormScreenState();
}

class _DualFormScreenState extends State<DualFormScreen> {
  FormType _currentForm = FormType.login;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Note Management System'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_currentForm == FormType.login ? 'Sign In' : 'Sign Up', style: TextStyle(fontSize: 30),) ,
            _buildForm(),
          ],
        ),
      ),
      floatingActionButton: _currentForm == FormType.login ? FloatingActionButton(
        onPressed: () {
          setState(() {
            _currentForm = _currentForm == FormType.login ? FormType.register : FormType.login;
          });
        },
        child: Icon(_currentForm == FormType.login ? Icons.person_add : Icons.login),
      ) : null
    );
  }

  Widget _buildForm() {
    if (_currentForm == FormType.login) {
      return LoginForm(onSwitchForm: _switchToRegisterForm);
    } else {
      return RegisterForm(onSwitchForm: _switchToLoginForm);
    }
  }

  void _switchToRegisterForm() {
    setState(() {
      _currentForm = FormType.register;
    });
  }

  void _switchToLoginForm() {
    setState(() {
      _currentForm = FormType.login;
    });
  }
}
