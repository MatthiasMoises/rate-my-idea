import 'package:flutter/foundation.dart';

import '../utils/constants.dart';
import '../models/criterion.dart';

class Criteria with ChangeNotifier {
  List<Criterion> _criteria = [];

  List<Criterion> get critera {
    return [..._criteria];
  }

  Future<void> fetchCriteria() async {
    try {
      final response = await supabase.from('criteria').select('*').execute();

      if (response.status == 200) {
        List body = response.data;

        _criteria = body.map((item) => Criterion.fromJson(item)).toList();

        notifyListeners();
      } else {
        throw Exception('Failed to load criteria');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<Criterion> getCriterion(int id) async {
    final response =
        await supabase.from('criteria').select('*').eq('id', id).execute();

    if (response.status == 200) {
      return Criterion.fromJson(response.data);
    } else {
      throw new Exception('Failed to load criterion $id');
    }
  }

  Future<void> createCriterion(String name, int minScore, int maxScore) async {
    try {
      final response = await supabase.from('criteria').insert([
        {
          'name': name,
          'min_score': minScore,
          'max_score': maxScore,
          'created_at': DateTime.now().toIso8601String(),
        }
      ]).execute();

      if (response.status == 201) {
        _criteria.add(Criterion.fromJson(response.data[0]));
        notifyListeners();
      } else {
        throw new Exception('Failed to create criterion');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateCriterion(
      int id, String name, int minScore, int maxScore) async {
    try {
      final criterionIndex =
          _criteria.indexWhere((criterion) => criterion.id == id);

      if (criterionIndex >= 0) {
        final response = await supabase
            .from('criteria')
            .update({
              'name': name,
              'min_score': minScore,
              'max_score': maxScore,
              'updated_at': DateTime.now().toIso8601String(),
            })
            .eq('id', id)
            .execute();

        if (response.status == 200) {
          final updatedCriterion = Criterion.fromJson(response.data[0]);
          _criteria[criterionIndex] = updatedCriterion;
          notifyListeners();
        } else {
          throw new Exception('Failed to update criterion $id');
        }
      } else {
        print('No criterion found');
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteCriterion(int id) async {
    try {
      final existingCriterionIndex =
          _criteria.indexWhere((criterion) => criterion.id == id);

      final response =
          await supabase.from('criteria').delete().eq('id', id).execute();

      if (response.status == 200) {
        _criteria.removeAt(existingCriterionIndex);
        notifyListeners();
      } else {
        throw new Exception('Failed to delete criterion $id');
      }
    } catch (e) {
      throw e;
    }
  }
}
