import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';
import '../providers/notes.dart';

class EditNoteScreen extends StatefulWidget {
  static const routeName = '/edit-note';
  final Note? note;

  EditNoteScreen({
    this.note,
    Key? key,
  }) : super(key: key);

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  var _isEdit = false;
  var _isLoading = false;
  var _resultText = '';

  var _editedNote = Note(
    id: 0,
    text: '',
  );

  var _initValues = {
    'text': '',
  };

  @override
  void didChangeDependencies() {
    if (widget.note?.id != null) {
      _isEdit = true;
      _editedNote = widget.note!;
      _initValues = {
        'text': _editedNote.text,
      };
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) return;

    _formKey.currentState!.save();

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

    try {
      if (!_isEdit) {
        Provider.of<Notes>(context, listen: false).createNote(
          _editedNote.text,
          userId,
        );
        _resultText = 'Note created';
      } else {
        Provider.of<Notes>(context, listen: false).updateNote(
          _editedNote.id,
          _editedNote.text,
        );
        _resultText = 'Note edited';
      }
    } catch (err) {
      print(err.toString());
    }

    setState(() {
      _isLoading = false;
    });
    Navigator.pop(context, _resultText);
  }

  void _showDeleteDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Row(
              children: <Widget>[
                Icon(
                  Icons.warning,
                  color: Colors.grey,
                ),
                SizedBox(width: 15),
                Text(
                  'Delete Note?',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            content: Text('Once deleted this entry cannot be restored.'),
            actions: <Widget>[
              TextButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  _deleteNote();

                  Navigator.pop(context, 'Note deleted');
                },
              ),
            ],
          );
        });
  }

  Future<void> _deleteNote() async {
    setState(() {
      _isLoading = true;
    });
    try {
      Provider.of<Notes>(context, listen: false).deleteNote(_editedNote.id);
    } catch (err) {
      print(err.toString());
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Container(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextFormField(
                initialValue: _initValues['text'].toString(),
                decoration: InputDecoration(labelText: 'Text'),
                textInputAction: TextInputAction.next,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a text';
                  }
                  return null;
                },
                onSaved: (value) {
                  _editedNote = Note(
                    text: value!,
                    id: _editedNote.id,
                  );
                },
              ),
              SizedBox(height: 20.0),
              if (_isEdit)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    onPressed:
                        _isLoading ? null : () => _showDeleteDialog(context),
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : const Text('Delete Note'),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
