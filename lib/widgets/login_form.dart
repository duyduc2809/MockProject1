import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../constants/dimension_constant.dart';
import '../helpers/pref_helper.dart';
import '../helpers/sql_account_helper.dart';
import '../screens/home_screen.dart';
import '../validator.dart';
import 'custom_input_decoration.dart';

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
  late bool _isObscureText;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _loadRememberMeStatus();
    _isObscureText = true;
  }

  //load giá trị của biến _rememberMe, nếu là true thì load tài khoản đã được remember qua hàm PrefHelper.loadSavedCredentials()
  _loadRememberMeStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _rememberMe = prefs.getBool('rememberMe') ?? false;
      if (_rememberMe) {
        PrefHelper.loadSavedCredentials(_emailController, _passwordController);
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
                  labelText: 'Email', hintText: 'name@example.com'),
            ),
            const SizedBox(
              height: spaceBetweenField,
            ),
            TextFormField(
              obscureText: _isObscureText,
              controller: _passwordController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your password';
                }
                return null;
              },
              decoration: CustomInputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: _isObscureText
                      ? const Icon(Icons.visibility_off)
                      : const Icon(Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isObscureText = !_isObscureText;
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
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _login();
                  }
                },
                child: const Text(
                  'Log In',
                )),
            Row(
              children: [
                Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value!;
                      print(value);
                    });
                  },
                ),
                const Text('Remember me')
              ],
            ),
          ],
        ));
  }

  //xử lý login tài khoản, nếu thành công th chuyển sang HomePage đồng thời remove các màn hình trước
  _login() async {
    bool isLoginSuccess = false;
    final account = await SQLAccountHelper.getAccounts();
    for (var acc in account) {
      if (acc['email'] == _emailController.text &&
          acc['password'] == _passwordController.text) {
        isLoginSuccess = true;
        await SQLAccountHelper.setCurrentAccount(_emailController);
        if (_rememberMe == true) {
          await PrefHelper.clearSavedCredentials();
          await PrefHelper.saveCredentials(
              _rememberMe, _emailController, _passwordController);
        }
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
            (route) => false);
      }
    }
    !isLoginSuccess
        ? ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wrong email or password')))
        : null;
  }
}
