import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/tabs_screen.dart';
import '../screens/about_screen.dart';

class MainDrawer extends StatefulWidget {
  @override
  _MainDrawerState createState() => _MainDrawerState();
}

class _MainDrawerState extends State<MainDrawer> {
  var _userEmail = 'Unknown';

  Widget buildListTile(String title, IconData icon, Function tapHandler) {
    return ListTile(
      leading: Icon(
        icon,
        size: 26,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'RobotoCondensed',
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      onTap: () => tapHandler(),
    );
  }

  Future<void> getCurrentUserEmail() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String userData = prefs.getString('userData') ?? '';
    if (userData != '') {
      final user = json.decode(userData);
      setState(() {
        _userEmail = user['email'].toString();
      });
    }
  }

  @override
  void initState() {
    getCurrentUserEmail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 120,
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerLeft,
            color: Theme.of(context).colorScheme.secondary,
            child: Text(
              // 'Welcome, ${authData.username}! :)',
              'Welcome, $_userEmail! :)',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 24.0,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          buildListTile(
            'Ideas',
            Icons.home,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TabsScreen(title: 'Ideas'),
                ),
              );
            },
          ),
          buildListTile(
            'Placeholder',
            Icons.settings,
            () {
              Navigator.pop(context);
            },
          ),
          buildListTile(
            'About',
            Icons.help,
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AboutScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
