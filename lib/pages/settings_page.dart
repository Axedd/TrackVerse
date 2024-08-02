import 'package:app/pages/settingsPages/beverage_setting_page.dart';
import 'package:flutter/material.dart';
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'TrackVerse - Settings',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  "Settings",
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
            SizedBox(
              height: 40,
            ),
            Text("Account", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),),
            buildAccountOption(context, "Edit Profile", Icon(Icons.account_circle_rounded), BeverageSettingPage()),
            SizedBox(height: 30,),
            Text("Settings", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),),
            buildAccountOption(context, "Beverages", Icon(Icons.local_drink), BeverageSettingPage()),
            buildAccountOption(context, "Tracker Preferences", Icon(Icons.track_changes), BeverageSettingPage())
          ],
        ),
      ),
    );
  }
}

GestureDetector buildAccountOption(
    BuildContext context, String title, Icon icon, Widget targetPage) {
  return GestureDetector(
    onTap: () => {
      Navigator.push(context, MaterialPageRoute(builder: (context) => targetPage))
    },
    child: Padding(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Column(children: [
        Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              icon,
              SizedBox(width: 10,),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Icon(
            Icons.arrow_forward_ios,
            color: Colors.black,
            size: 17,
          ),
        ],
      ),
      Divider(height: 20, thickness: 1,)
      ],)
    ),
  );
}                   


