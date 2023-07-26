import 'package:flutter/material.dart';
import 'package:mock_prj1/validator.dart';
import 'package:mock_prj1/screens/home_screen.dart';
import '../constants/dimension_constant.dart';
import '../widgets/custom_input_decoration.dart';
import '../helpers/sql_account_helper.dart';
import '../classes/account.dart';

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

  late bool _isCurrentPassObscure;
  late bool _isNewPassObscure;
  late bool _isConfirmPassObscure;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _isCurrentPassObscure = true;
    _isNewPassObscure = true;
    _isConfirmPassObscure = true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
          key: _formkey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              const Row(
                children: [
                  Icon(
                    Icons.lock_open,
                    size: 40,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Change your password',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  )
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                obscureText: _isCurrentPassObscure,
                controller: _currentPassController,
                validator: (value) =>
                    Validator.confirmCurrentPasswordValidator(value),
                decoration: CustomInputDecoration(
                  labelText: 'Current password',
                  suffixIcon: IconButton(
                    icon: _isCurrentPassObscure
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isCurrentPassObscure = !_isCurrentPassObscure;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: _isNewPassObscure,
                controller: _newPassController,
                validator: (value) => Validator.newPasswordValidator(value),
                decoration: CustomInputDecoration(
                  labelText: 'New password',
                  suffixIcon: IconButton(
                    icon: _isNewPassObscure
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        _isNewPassObscure = !_isNewPassObscure;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                obscureText: _isConfirmPassObscure,
                controller: _confirmnewPassController,
                validator: (value) => Validator.confirmPasswordValidator(
                    value, _newPassController),
                decoration: CustomInputDecoration(
                  labelText: 'Confirm new password',
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
                height: 20,
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kMediumPadding))),
                  onPressed: () {
                    if (_formkey.currentState!.validate()) {
                      SQLAccountHelper.updateAccount(Account(
                          firstName: SQLAccountHelper.currentAccount['firstName'],
                          lastName: SQLAccountHelper.currentAccount['lastName'],
                          id: SQLAccountHelper.currentAccount['id'],
                          email: SQLAccountHelper.currentAccount['email'],
                          password: _newPassController.text));

                      print(SQLAccountHelper.currentAccount['id']);
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Change successful! ')));
                    }
                  },
                  child: const Text('Change')),
              const SizedBox(
                height: spaceBetweenField / 2,
              ),
              OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      minimumSize: const Size.fromHeight(55),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(kMediumPadding))),
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomePage()));
                  },
                  child: const Text('Home')),
            ],
          )),
    ));
  }
}
