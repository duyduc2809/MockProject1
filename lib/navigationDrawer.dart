import 'package:flutter/material.dart';
import '../screens/dashbordScreen.dart';

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
          DrawerHeader(child: Image.asset("assets/images/logo.png")),
          DrawerListTile(
            title: "Dashbord",
            icon: Icons.dashboard_sharp,
            press: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>  DashboardForm()));
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
