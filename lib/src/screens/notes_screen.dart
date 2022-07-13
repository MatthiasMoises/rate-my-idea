import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widgets/note_item.dart';
import '../models/note.dart';
import '../providers/notes.dart';

class NotesScreen extends StatefulWidget {
  @override
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  late List<Note> _notes;
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String userData = prefs.getString('userData') ?? '';

      var userId;

      if (userData != '') {
        final user = json.decode(userData);
        userId = user['id'].toString();
      }

      Future.delayed(Duration(milliseconds: 500)).then((_) {
        Provider.of<Notes>(context, listen: false).fetchNotes(userId).then((_) {
          setState(() {
            _isLoading = false;
          });
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    _notes = context.watch<Notes>().notes;

    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : (_notes.length > 0)
            ? ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (ctx, index) {
                  return NoteItem(note: _notes[index]);
                },
              )
            : Center(
                child: Text('You have no notes...'),
              );
  }
}
