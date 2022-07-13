import 'package:flutter/material.dart';

import '../models/idea.dart';
import '../models/note.dart';
import '../screens/rate_idea_screen.dart';
import '../screens/edit_idea_screen.dart';
import '../screens/edit_note_screen.dart';

void navigateToIdeaActionScreen(
    BuildContext context, String mode, Idea? idea) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => mode == 'rate'
          ? RateIdeaScreen(idea: idea!)
          : (idea != null)
              ? EditIdeaScreen(idea: idea)
              : EditIdeaScreen(),
    ),
  );

  if (result != null) {
    _showResult(context, result);
  }
}

void navigateToNoteActionScreen(BuildContext context, Note? note) async {
  final result = await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) =>
          note != null ? EditNoteScreen(note: note) : EditNoteScreen(),
    ),
  );

  if (result != null) {
    _showResult(context, result);
  }
}

void _showResult(BuildContext context, dynamic result) {
  ScaffoldMessenger.of(context)
    ..removeCurrentSnackBar()
    ..showSnackBar(SnackBar(
      content: Text('$result'),
      backgroundColor: Colors.green,
      behavior: SnackBarBehavior.floating,
    ));
}
