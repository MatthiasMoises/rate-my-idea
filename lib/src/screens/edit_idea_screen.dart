import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/idea.dart';
import '../providers/ideas.dart';
import '../screens/manage_criteria_screen.dart';
import '../widgets/image_upload.dart';

class EditIdeaScreen extends StatefulWidget {
  static const routeName = '/edit-idea';
  final Idea? idea;

  EditIdeaScreen({
    this.idea,
    Key? key,
  }) : super(key: key);

  @override
  _EditIdeaScreenState createState() => _EditIdeaScreenState();
}

class _EditIdeaScreenState extends State<EditIdeaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionFocusNode = FocusNode();
  var _isEdit = false;
  var _isLoading = false;
  var _resultText = '';

  var _editedIdea = Idea(
    id: 0,
    title: '',
    description: '',
    imageName: '',
    criteria: [],
    // ratings: [],
  );

  var _initValues = {
    'title': '',
    'description': '',
    'imageName': '',
    'criteria': [],
    // 'ratings': [],
  };

  @override
  void didChangeDependencies() {
    if (widget.idea?.id != null) {
      _isEdit = true;
      _editedIdea = widget.idea!;
      _initValues = {
        'title': _editedIdea.title,
        'description': _editedIdea.description,
        'imageName': _editedIdea.imageName,
        'criteria': _editedIdea.criteria,
      };
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    }

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
        Provider.of<Ideas>(context, listen: false).createIdea(
          _editedIdea.title,
          _editedIdea.description,
          _editedIdea.imageName,
          userId,
        );
        _resultText = 'Idea created';
      } else {
        Provider.of<Ideas>(context, listen: false).updateIdea(
          _editedIdea.id,
          _editedIdea.title,
          _editedIdea.description,
          _editedIdea.imageName,
        );
        _resultText = 'Idea edited';
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
                  'Delete Idea?',
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
                  _deleteIdea();

                  Navigator.pop(context, 'Idea deleted');
                },
              ),
            ],
          );
        });
  }

  Future<void> _deleteIdea() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Provider.of<Ideas>(context, listen: false).deleteIdea(_editedIdea.id);
    } catch (err) {
      print(err.toString());
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();
  }

  void _navigateToAssignmentScreen(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ManageCriteriaScreen()),
    );

    // _editedIdea.criteria.clear();
    //_editedIdea.criteria.addAll(result);
    // print(_editedIdea.criteria);
    print(result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Idea'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                TextFormField(
                  initialValue: _initValues['title'].toString(),
                  decoration: InputDecoration(labelText: 'Title'),
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_descriptionFocusNode);
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedIdea = Idea(
                      title: value!,
                      description: _editedIdea.description,
                      imageName: _editedIdea.imageName,
                      id: _editedIdea.id,
                    );
                  },
                ),
                TextFormField(
                  initialValue: _initValues['description'].toString(),
                  decoration: InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  keyboardType: TextInputType.multiline,
                  focusNode: _descriptionFocusNode,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    if (value.length < 10) {
                      return 'Should be at least 10 characters long.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _editedIdea = Idea(
                      description: value!,
                      title: _editedIdea.title,
                      imageName: _editedIdea.imageName,
                      id: _editedIdea.id,
                    );
                  },
                ),
                SizedBox(height: 20.0),
                ImageUpload(idea: widget.idea),
                SizedBox(height: 20.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  onPressed: () => _navigateToAssignmentScreen(context),
                  child: const Text('Manage Criteria'),
                ),
                SizedBox(height: 20.0),
                Divider(),
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
                          : const Text('Delete Idea'),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
