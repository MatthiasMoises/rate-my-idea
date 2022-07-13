import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:supabase/supabase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../components/auth_required_state.dart';
import '../providers/auth.dart';
import './ideas_screen.dart';
import './notes_screen.dart';
import './settings_screen.dart';
import '../screens/account_screen.dart';
import '../widgets/main_drawer.dart';
import '../widgets/fab_bottom_app_bar.dart';
import '../models/fab_bottom_app_bar_item.dart';
import '../utils/navigation_helper.dart';

class TabsScreen extends StatefulWidget {
  final String title;

  TabsScreen({required this.title});

  @override
  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends AuthRequiredState<TabsScreen> {
  List<Map<String, dynamic>> _pages = [];
  int _selectedPageIndex = 0;

  @override
  void initState() {
    _pages = [
      {
        'page': IdeasScreen(),
        'title': 'Ideas',
      },
      {
        'page': NotesScreen(),
        'title': 'Notes',
      },
      {
        'page': AccountScreen(),
        'title': 'Account',
      },
      {
        'page': SettingsScreen(),
        'title': 'Settings',
      },
    ];

    super.initState();
  }

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  void onAuthenticated(Session session) async {
    final user = session.user;
    if (user != null) {
      final userData = json.encode({
        'id': user.id,
        'email': user.email,
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userData', userData);
    }
  }

  @override
  void onUnauthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    Navigator.of(context).pushReplacementNamed('/login');
  }

  void _signOut(BuildContext context) async {
    await context.read<Auth>().signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userData');
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[_selectedPageIndex]['title']),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: GestureDetector(
              child: const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
              onTap: () => _signOut(context),
            ),
          ),
        ],
      ),
      drawer: MainDrawer(),
      body: _pages[_selectedPageIndex]['page'],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
        onPressed: () {
          if (_selectedPageIndex == 0) {
            navigateToIdeaActionScreen(context, 'edit', null);
          } else if (_selectedPageIndex == 1) {
            navigateToNoteActionScreen(context, null);
          } else {
            return null;
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: FABBottomAppBar(
        notchedShape: CircularNotchedRectangle(),
        onTabSelected: _selectPage,
        color: Colors.grey,
        selectedColor: Colors.red,
        items: [
          FABBottomAppBarItem(
            iconData: Icons.lightbulb,
            text: _pages[0]['title'],
          ),
          FABBottomAppBarItem(
            iconData: Icons.notes,
            text: _pages[1]['title'],
          ),
          FABBottomAppBarItem(
            iconData: Icons.account_circle,
            text: _pages[2]['title'],
          ),
          FABBottomAppBarItem(
            iconData: Icons.settings,
            text: _pages[3]['title'],
          ),
        ],
      ),
    );
  }
}
