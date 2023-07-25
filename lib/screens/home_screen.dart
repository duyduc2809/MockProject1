// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:mock_prj1/screens/category_screen.dart';
import 'package:mock_prj1/screens/priority_screen.dart';
import 'package:mock_prj1/screens/status_screen.dart';
import '../helpers/pref_helper.dart';
import '../helpers/sql_account_helper.dart';
import 'authentication_screen.dart';
import 'change_password_screen.dart';
import 'dashboard_screen.dart';
import 'edit_profile_screen.dart';
import 'note_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List pages = [DashboardForm(), const EditProfile(), const ChangePassWord()];
  int currentIndex = 0;

  void onTap(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      drawer: const NavigationDrawer(),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({super.key});

  @override
  Widget build(BuildContext context) => Drawer(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              buildHeader(context),
              buildMenuItems(context),
            ],
          ),
        ),
      );

  Widget buildHeader(BuildContext context) => Container(
        padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
      );

  Widget buildMenuItems(BuildContext context) => Column(
        children: [
          DrawerHeader(child: Image.asset("assets/images/logo.jpg")),
          Text('${SQLAccountHelper.currentAccount['email']}'),
          DrawerListTile(
            title: "Dashboard",
            icon: Icons.dashboard_sharp,
            press: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => DashboardForm()));
            },
          ),
          DrawerListTile(
            title: "Category",
            icon: Icons.category,
            press: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const CategoryItemScreen(),
              ));
            },
          ),
          DrawerListTile(
            title: "Priority",
            icon: Icons.low_priority_sharp,
            press: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const PriorityItemScreen(),
              ));
            },
          ),
          DrawerListTile(
            title: "Status",
            icon: Icons.signal_wifi_statusbar_null,
            press: () {

              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const StatusItemScreen(),
              ));
            },
          ),
          DrawerListTile(
            title: "Note",
            icon: Icons.note_add,
            press: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddNoteScreen()));
            },
          ),
          const Text(
            'Account',
            style: TextStyle(fontSize: 18, color: Colors.black),
          ),
          DrawerListTile(
            title: "Edit profile",
            icon: Icons.edit,
            press: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const EditProfile()));
            },
          ),
          DrawerListTile(
            title: "Change password",
            icon: Icons.change_circle,
            press: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const ChangePassWord()));
            },
          ),
          DrawerListTile(
            title: "Log out",
            icon: Icons.logout,
            press: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) {
                PrefHelper.clearSavedCredentials();
                return const DualFormScreen();
              }), (route) => false);
            },
          ),
        ],
      );
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    required this.title,
    required this.press,
    required this.icon,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        horizontalTitleGap: 0.0,
        leading: Icon(icon),
        title: Text(title),
        onTap: press);
  }
}