import 'package:flutter/material.dart';
import 'package:mock_prj1/validator.dart';
import '../classes/account.dart';
import '../helpers/sql_account_helper.dart';
import '../widgets/async_text_form_field.dart';
import '../widgets/custom_input_decoration.dart';
import 'home_screen.dart';
class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _formkey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Form(
            key: _formkey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text('Edit Your Profile'),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _firstNameController,
                  validator: (value) => Validator.nameValidator(value),
                  decoration: CustomInputDecoration(
                    labelText: 'First name',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _lastNameController,
                  validator: (value) => Validator.nameValidator(value),
                  decoration: CustomInputDecoration(
                    labelText: 'Last name',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                AsyncTextFormField(
                  labelText: 'Email',
                  validator: (value) => Validator.isValidEmail(value),
                  validationDebounce: const Duration(milliseconds: 200),
                  controller: _emailController,
                  valueIsEmptyMessage: 'Please enter an email',
                  valueIsInvalidMessage:
                      'Invalid email or email already exists',
                  hintText: 'name@example.com',
                ),
                // TextFormField(
                //   controller: _emailController,
                //   validator: (value) => Validator.emailValidator(value),
                //   decoration: const InputDecoration(
                //     border: OutlineInputBorder(),
                //     labelText: 'Email',
                //   ),
                // ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          if (_formkey.currentState!.validate()) {
                            SQLAccountHelper.updateAccount(Account(
                                email: _emailController.text,
                                id: SQLAccountHelper.currentAccount['id'],
                                password: SQLAccountHelper
                                    .currentAccount['password']));
                            SQLAccountHelper.setCurrentAccount(
                                _emailController);
                            print(SQLAccountHelper.currentAccount['id']);
                          }
                          AsyncTextFormField(
                            labelText: 'Email',
                            validator: (value) => Validator.isValidEmail(value),
                            validationDebounce:
                                const Duration(milliseconds: 200),
                            controller: _emailController,
                            valueIsEmptyMessage: 'Please enter an email',
                            valueIsInvalidMessage:
                                'Invalid email or email already exists',
                            hintText: 'name@example.com',
                          );
                        },
                        child: const Text('Change')),
                    ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const HomePage()));
                        },
                        child: const Text('Home'))
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
