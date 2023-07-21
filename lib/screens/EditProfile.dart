import 'package:flutter/material.dart';
import 'package:mock_prj1/Validator.dart';
import 'package:mock_prj1/constants/TextStyleConstant.dart';
import '../classes/Account.dart';

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
                const Text('Edit Your Profie'),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _firstNameController,
                  validator: (value) => Validator.nameValidator(value),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'First name',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _lastNameController,
                  validator: (value) => Validator.nameValidator(value),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Last name',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _emailController,
                  validator: (value) => Validator.emailValidator(value),
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        onPressed: () {}, child: const Text('Change')),
                    ElevatedButton(onPressed: () {}, child: const Text('Home'))
                  ],
                ),
              ],
            )),
      ),
    );
  }
}
