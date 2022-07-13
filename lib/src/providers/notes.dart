import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../models/note.dart';

class Notes with ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes {
    return [..._notes];
  }

  Future<void> fetchNotes(String userId) async {
    try {
      final response = await supabase
          .from('notes')
          .select('*')
          .eq('user_id', userId)
          .execute();

      if (response.status == 200) {
        List body = response.data;

        _notes = body.map((item) => Note.fromJson(item)).toList();

        notifyListeners();
      } else {
        throw Exception('Failed to load notes');
      }
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<Note> getNote(int id, String userId) async {
    final response = await supabase
        .from('notes')
        .select('*')
        .eq('id', id)
        .eq('user_id', userId)
        .execute();

    if (response.status == 200) {
      return Note.fromJson(response.data);
    } else {
      throw new Exception('Failed to load note $id');
    }
  }

  Future<void> createNote(String text, String userId) async {
    try {
      final response = await supabase.from('notes').insert([
        {
          'text': text,
          'user_id': userId,
          'created_at': DateTime.now().toIso8601String(),
        }
      ]).execute();

      if (response.status == 201) {
        _notes.add(Note.fromJson(response.data[0]));
        notifyListeners();
      } else {
        throw new Exception(response.error!.message);
      }
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> updateNote(int id, String text) async {
    try {
      final noteIndex = _notes.indexWhere((idea) => idea.id == id);

      if (noteIndex >= 0) {
        final response = await supabase
            .from('notes')
            .update({
              'text': text,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', id)
            .execute();

        if (response.status == 200) {
          final updatedNote = Note.fromJson(response.data[0]);
          _notes[noteIndex] = updatedNote;
          notifyListeners();
        } else {
          throw new Exception('Failed to update note $id');
        }
      } else {
        print('No note found');
      }
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      final existingNoteIndex = _notes.indexWhere((idea) => idea.id == id);

      final response =
          await supabase.from('notes').delete().eq('id', id).execute();

      if (response.status == 200) {
        _notes.removeAt(existingNoteIndex);
        notifyListeners();
      } else {
        throw new Exception('Failed to delete note $id');
      }
    } on Exception catch (e) {
      throw e;
    }
  }
}
