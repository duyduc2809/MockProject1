import 'package:flutter/material.dart';
import 'package:mock_prj1/helpers/SQLAccountHelper.dart';
import 'package:mock_prj1/screens/DualFormScreen.dart';

import '../Validator.dart';
import '../classes/Account.dart';


class ItemsScreen extends StatelessWidget {
  const ItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: _HomePage(),
    );
  }
}

class _HomePage extends StatefulWidget {
  const _HomePage({super.key});

  @override
  State<_HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<_HomePage> {
  List<Map<String, dynamic>> _accounts = [];

  bool _isLoading = true;

  Future<void> _refreshJournals() async {
    final data = await SQLAccountHelper.getAccounts();

    setState(() {
      _accounts = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshJournals();
  }

  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  final _oldPassController = TextEditingController();
  final _emailController = TextEditingController();
  bool _isEmailChanged = true;
  bool _isPasswordChanged = true;

  Future<void> _updateAccount(Map<String, dynamic> account) async {
    await SQLAccountHelper.updateAccount(Account(
      password:
          _isPasswordChanged ? _passwordController.text : account['password'],
      email: _isEmailChanged ? _emailController.text : account['email'],
    ));
    _refreshJournals();
  }

  //
  Future<void> _deleteAccount(int id) async {
    await SQLAccountHelper.deleteAccount(id);

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Successfully deleted an account!')));

    _refreshJournals();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Persist data with SQLite'),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _accounts.length,
              itemBuilder: (context, index) => Card(
                    color: Colors.orange[200],
                    margin: const EdgeInsets.all(7),
                    child: ListTile(
                      title: Text('Email: ${_accounts[index]['email']}'),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                          children: [
                            IconButton(
                                onPressed: () => _showDorm(_accounts[index]),
                                icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () =>
                                    _deleteAccount(_accounts[index]['id']),
                                icon: const Icon(Icons.delete)),
                          ],
                        ),
                      ),
                    ),
                  )),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => DualFormScreen())),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDorm(var account) async {
    final _formkey = GlobalKey<FormState>();
    bool _oldPassStatus = false;
    if (account['email'] != null) {
      final existingAccount =
          _accounts.firstWhere((element) => element['id'] == account['id']);
      _emailController.text = existingAccount['email'];
    }
    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Container(
        padding: EdgeInsets.only(
            top: 15,
            left: 15,
            right: 15,
            bottom: MediaQuery.of(context).viewInsets.bottom + 120),
        child: Form(
          key: _formkey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Change information for ${account['email']}'),
              TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(hintText: 'Email'),
                  validator: (value) {
                    if (value != null) {
                      String? result = Validator.emailValidator(value);
                      if (result == Validator.invalidEmailString) {
                        return result;
                      }
                    } else {
                      _isEmailChanged = true;
                      return null;
                    }
                  }),
              TextFormField(
                controller: _oldPassController,
                decoration: const InputDecoration(hintText: 'Old password'),
                obscureText: true,
                validator: (value) {
                  if (value == '' || value == null) {
                    return null;
                  } else {
                    if (account['password'] != value) {
                      return "Wrong old password";
                    } else {
                      _oldPassStatus = true;
                      return null;
                    }
                  }
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(hintText: 'New password'),
                obscureText: true,
                validator: (value) {
                  if (_oldPassStatus == false &&
                      _passwordController.text != null) {
                    return 'Please enter your old password first!';
                  } else if (_oldPassStatus) {
                    return Validator.passwordValidator(value);
                  }
                },
              ),
              TextFormField(
                controller: _confirmPassController,
                decoration:
                    const InputDecoration(hintText: 'Confirm new password'),
                obscureText: true,
                validator: (value) {
                  if (_oldPassController.text == '' ||
                      _oldPassController.text == null &&
                          _passwordController == null) {
                    return null;
                  } else if (_passwordController.text == null) {
                    return 'Please enter your new password';
                  } else {
                    _isPasswordChanged = true;
                    return Validator.confirmPasswordValidator(
                        value, _passwordController);
                  }
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formkey.currentState!.validate()) {
                    await _updateAccount(account);

                    _oldPassController.text = '';
                    _emailController.text = '';
                    _passwordController.text = '';
                    _confirmPassController.text = '';

                    if (!mounted) return;

                    Navigator.of(context).pop();

                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Information changed successfully!'),
                    ));
                  }
                },
                child: const Text('Update'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
