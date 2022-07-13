import 'package:flutter/material.dart';

import '../utils/navigation_helper.dart';
import '../models/note.dart';

class NoteItem extends StatelessWidget {
  final Note note;

  const NoteItem({required this.note, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(),
        ),
      ),
      padding: const EdgeInsets.all(10.0),
      child: ListTile(
        leading: Text(
          note.id.toString(),
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.orange,
          ),
        ),
        title: Text(note.text),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              child: Icon(Icons.edit),
              onTap: () => navigateToNoteActionScreen(context, note),
            ),
            // Icon(
            //   Icons.delete,
            //   color: Colors.white,
            // ),
          ],
        ),
      ),
    );
  }
}
