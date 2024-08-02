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
          const DrawerHeader(
            child: Text("Drawer Header"),
          ),
          ListTile(
            title: const Text("Home"),
            onTap: () => {
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen()), // Replace with your new page
                (Route<dynamic> route) =>
                    false, // This condition removes all previous routes
              ),
            },
          ),
          ListTile(
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
