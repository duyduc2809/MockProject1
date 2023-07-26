import 'package:flutter/material.dart';
import 'package:mock_prj1/helpers/sql_account_helper.dart';

import '../validator.dart';
import '../classes/account.dart';
import '../constants/dimension_constant.dart';
import 'custom_input_decoration.dart';
import 'custom_text_form_field.dart';

class RegisterForm extends StatefulWidget {
  final VoidCallback onSwitchForm;

  RegisterForm({required this.onSwitchForm});

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formkey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();

  final _emailController = TextEditingController();

  late bool _isPassObscure;
  late bool _isConfirmPassObscure;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isPassObscure = true;
    _isConfirmPassObscure = true;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formkey,
        child: Column(
          children: [
            const SizedBox(
              height: spaceBetweenField,
            ),
            AsyncTextFormField(
              labelText: 'Email',
              validator: (value) => Validator.isValidEmail(value),
              validationDebounce: const Duration(milliseconds: 200),
              controller: _emailController,
              valueIsEmptyMessage: 'Please enter an email',
              valueIsInvalidMessage: 'Invalid email or email already exists',
              hintText: 'name@example.com',
            ),
            const SizedBox(
              height: spaceBetweenField,
            ),
            TextFormField(
              obscureText: _isPassObscure,
              controller: _passwordController,
              validator: (value) => Validator.passwordValidator(value),
              decoration: CustomInputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: _isPassObscure
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isPassObscure = !_isPassObscure;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: spaceBetweenField,
            ),
            TextFormField(
              obscureText: _isConfirmPassObscure,
              controller: _confirmPassController,
              validator: (value) => Validator.confirmPasswordValidator(
                  value, _passwordController),
              decoration: CustomInputDecoration(
                labelText: 'Confirm password',
                suffixIcon: IconButton(
                  icon: _isConfirmPassObscure
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isConfirmPassObscure = !_isConfirmPassObscure;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(
              height: spaceBetweenField,
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(55),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(kMediumPadding))),
                onPressed: () {
                  if (_formkey.currentState!.validate()) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                            'Register successful! Your information: \nEmail: ${_emailController.text}')));
                    _addAccount();
                    _passwordController.text = '';
                    _confirmPassController.text = '';
                  }
                },
                child: const Text('Sign Up')),
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
