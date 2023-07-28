import 'package:flutter/material.dart';
import 'package:mock_prj1/constants/dimension_constant.dart';

import '../widgets/login_form.dart';
import '../widgets/register_form.dart';
//màn hình chính của 2 form đăng nhập và đăng ký tài khoản
enum FormType { login, register }

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});

  @override
  _AuthenticationScreenState createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  FormType _currentForm = FormType.login;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GestureDetector(
        onTap: () {
          setState(() {
            _currentForm = _currentForm == FormType.login
                ? FormType.register
                : FormType.login;
          });
        },
        child: SizedBox(
          height: 50,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _currentForm == FormType.login
                ? [
                    const Text('Don\'t have an account?'),
                    const Text(
                      ' Sign up',
                      style: TextStyle(color: Colors.orange),
                    )
                  ]
                : [
                    const Text('Already have an account?'),
                    const Text(
                      ' Sign in',
                      style: TextStyle(color: Colors.orange),
                    )
                  ],
          ),
        ),
      ),
      // appBar: AppBar(
      //   title: Text('Note Management System'),
      // ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(dualFormScreenPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _currentForm == FormType.login
                    ? _buildSignInText()
                    : const Text(
                        'Create account',
                        style: TextStyle(fontSize: 30),
                      ),
                const SizedBox(
                  height: 30,
                ),
                // Text(
                //   _currentForm == FormType.login ? 'Sign In' : 'Sign Up',
                //   style: TextStyle(fontSize: 30, fontFamily: 'RobotoMono'),
                // ),
                _buildForm(),
              ],
            ),
          ),
        ),
      ),
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

  Widget _buildSignInText() {
    return const Column(
      children: [
        Text(
          'Hello!',
          style: TextStyle(fontSize: 58),
        ),
        Text('Sign in to your account')
      ],
    );
  }
}
