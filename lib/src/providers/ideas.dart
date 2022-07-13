import 'dart:io';

import 'package:flutter/material.dart';

import '../utils/constants.dart';
import '../models/idea.dart';

class Ideas with ChangeNotifier {
  List<Idea> _ideas = [];
  File? _uploadedImage;
  String _uploadedImageName = '';

  List<Idea> get ideas {
    return [..._ideas];
  }

  File? get uploadedImage {
    return _uploadedImage;
  }

  String get uploadedImagePath {
    return _uploadedImageName;
  }

  bool get hasIdeas => _ideas.length > 0;

  Future<void> fetchIdeas() async {
    try {
      final response = await supabase
          .from('ideas')
          .select('*, criteria(id, name, min_score, max_score)')
          .execute();

      if (response.status == 200) {
        List body = response.data;

        _ideas = body.map((item) => Idea.fromJson(item)).toList();

        notifyListeners();
      } else {
        throw Exception('Failed to load ideas');
      }
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<Idea> getIdea(int id) async {
    final response =
        await supabase.from('ideas').select('*').eq('id', id).execute();

    if (response.status == 200) {
      return Idea.fromJson(response.data);
    } else {
      throw new Exception('Failed to load idea $id');
    }
  }

  Future<void> createIdea(
      String title, String description, String imageName, String userId) async {
    try {
      var newImageName;

      if (_uploadedImage != null && _uploadedImageName != '') {
        final uploadResponse = await supabase.storage
            .from('uploaded-images')
            .upload('ideas/$_uploadedImageName', _uploadedImage!);

        if (uploadResponse.hasError) {
          throw uploadResponse.error!.message;
        } else {
          // newImageName = uploadResponse.data;
          newImageName = _uploadedImageName;
        }
      }

      final response = await supabase.from('ideas').insert([
        {
          'title': title,
          'description': description,
          'image_name': newImageName ?? imageName,
          'user_id': userId,
          'created_at': DateTime.now().toIso8601String(),
        }
      ]).execute();

      if (response.status == 201) {
        _ideas.add(Idea.fromJson(response.data[0]));
        _uploadedImage = null;
        _uploadedImageName = '';
        notifyListeners();
      } else {
        throw new Exception(response.error!.message);
      }
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> updateIdea(
      int id, String title, String description, String imageName) async {
    try {
      final ideaIndex = _ideas.indexWhere((idea) => idea.id == id);

      if (ideaIndex >= 0) {
        var newImageName;

        if (_uploadedImage != null && _uploadedImageName != '') {
          final uploadResponse = await supabase.storage
              .from('uploaded-images')
              .upload('ideas/$_uploadedImageName', _uploadedImage!);

          if (uploadResponse.hasError) {
            throw uploadResponse.error!.message;
          } else {
            // newImageName = uploadResponse.data;
            newImageName = _uploadedImageName;
          }
        }

        final response = await supabase
            .from('ideas')
            .update({
              'title': title,
              'description': description,
              'image_name': newImageName ?? imageName,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', id)
            .execute();

        if (response.status == 200) {
          final updatedIdea = Idea.fromJson(response.data[0]);
          _ideas[ideaIndex] = updatedIdea;
          notifyListeners();
        } else {
          throw new Exception('Failed to update idea $id');
        }
      } else {
        print('No idea found');
      }
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> deleteIdea(int id) async {
    try {
      final existingIdeaIndex = _ideas.indexWhere((idea) => idea.id == id);

      final response =
          await supabase.from('ideas').delete().eq('id', id).execute();

      if (response.status == 200) {
        _ideas.removeAt(existingIdeaIndex);
        notifyListeners();
      } else {
        throw new Exception('Failed to delete idea $id');
      }
    } on Exception catch (e) {
      throw e;
    }
  }

  void setUploadedImageInformation(File file, String fileName) {
    _uploadedImage = file;
    _uploadedImageName = fileName;
    notifyListeners();
  }
}
