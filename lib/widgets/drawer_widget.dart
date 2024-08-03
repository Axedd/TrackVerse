import 'package:app/main.dart';
import 'package:app/pages/settings_page.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("John Olsen"),
            accountEmail: Text("Member Since: 12 Jan. 2024"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage('https://styles.redditmedia.com/t5_6q5v2f/styles/communityIcon_r5j8626w5ec91.jpeg?format=pjpg&s=4a7c176c8ec7b4794a0248863576bf4884ad1784'),
            ),
            decoration: BoxDecoration(
              color: Colors.green,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: const Text("Home"),
            onTap: () => {
              Navigator.of(context).pop()
            },
          ),
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: const Text("Statistics"),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              )
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: const Text("Settings"),
            onTap: () => {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SettingsPage(),
                ),
              )
            },
          ),
        ],
      ),
    );
  }
}
