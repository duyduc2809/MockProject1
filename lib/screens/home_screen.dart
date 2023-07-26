import 'package:flutter/material.dart';
import 'package:mock_prj1/constants/dimension_constant.dart';
import 'package:mock_prj1/screens/category_screen.dart';
import 'package:mock_prj1/screens/change_password_screen.dart';
import 'package:mock_prj1/screens/dashboard_screen.dart';
import 'package:mock_prj1/screens/edit_profile_screen.dart';
import 'package:mock_prj1/screens/note_screen.dart';
import 'package:mock_prj1/screens/priority_screen.dart';
import 'package:mock_prj1/screens/status_screen.dart';
import '../helpers/pref_helper.dart';
import '../helpers/sql_account_helper.dart';
import 'authentication_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _currentBody;
  static const _dashboardText = 'Dashboard';
  static const _categoryText = 'Category';
  static const _changePasswordText = 'Change Password';
  static const _editProfileText = 'Edit Profile';
  static const _priorityText = 'Priority';
  static const _statusText = 'Status';
  static const _noteText = 'Note';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentBody = 0;
  }

  Widget _buildBody() {
    switch (_currentBody) {
      case 0:
        return DashboardForm();
      case 1:
        return const CategoryItemScreen();
      case 2:
        return const PriorityItemScreen();
      case 3:
        return const StatusItemScreen();
      case 4:
        return AddNoteScreen();
      case 5:
        return const ChangePassWord();
      case 6:
        return const EditProfile();
      default:
        return const HomePage();
    }
  }

  String _buildAppBarTitle() {
    switch (_currentBody) {
      case 0:
        return _dashboardText;
      case 1:
        return _categoryText;
      case 2:
        return _priorityText;
      case 3:
        return _statusText;
      case 4:
        return _noteText;
      case 5:
        return _changePasswordText;
      case 6:
        return _editProfileText;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildBody(),
      appBar: AppBar(
        title: Text(_buildAppBarTitle()),
      ),
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                color: Colors.black,
                height: 200,
                width: 400,
                child: Padding(
                  padding: const EdgeInsets.all(kMinPadding * 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.orange,
                        child: Icon(Icons.person, color: Colors.black,),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      _getFullName(),
                      Text(
                        '${SQLAccountHelper.currentAccount['email']}',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
              // Image.asset('assets/images/logo.jpg'),

              ListTile(
                title: const Text(
                  _dashboardText,
                ),
                leading: const Icon(Icons.dashboard),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _currentBody = 0;
                  });
                },
              ),
              ListTile(
                title: const Text(_categoryText),
                leading: const Icon(Icons.category),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _currentBody = 1;
                  });
                },
              ),
              ListTile(
                title: const Text(_priorityText),
                leading: const Icon(Icons.low_priority_sharp),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _currentBody = 2;
                  });
                },
              ),
              ListTile(
                title: const Text(_statusText),
                leading: const Icon(Icons.signal_wifi_statusbar_null),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _currentBody = 3;
                  });
                },
              ),
              ListTile(
                title: const Text(_noteText),
                leading: const Icon(Icons.note_add),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _currentBody = 4;
                  });
                },
              ),
              const Text("Account", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
              ListTile(
                title: const Text(_changePasswordText),
                leading: const Icon(Icons.change_circle),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _currentBody = 5;
                  });
                },
              ),
              ListTile(
                title: const Text(_editProfileText),
                leading: const Icon(Icons.edit),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _currentBody = 6;
                  });
                },
              ),
              ListTile(
                title: const Text("Log out"),
                leading: const Icon(Icons.logout),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) {
                    PrefHelper.clearSavedCredentials();
                    return const DualFormScreen();
                  }), (route) => false);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _getFullName() {
    if (SQLAccountHelper.currentAccount['firstName'] != '' &&
        SQLAccountHelper.currentAccount['lastName'] != '') {
      return Text(
          '${SQLAccountHelper.currentAccount['firstName']} ${SQLAccountHelper.currentAccount['lastName']}', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),);
    } else {
      return SizedBox(height: 1,);
    }
  }
}
