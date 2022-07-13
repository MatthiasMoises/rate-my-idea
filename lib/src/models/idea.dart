import './criterion.dart';

class Idea {
  final int id;
  final String title;
  final String description;
  final String imageName;
  final List<Criterion?> criteria;
  // final List<dynamic> ratings;

  Idea({
    required this.id,
    required this.title,
    required this.description,
    required this.imageName,
    List<Criterion?>? criteria,
    // required this.ratings,
  }) : criteria = criteria ?? [];

  factory Idea.fromJson(Map<String, dynamic> json) {
    return Idea(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      imageName: json['image_name'] ?? '',
      criteria: List<Criterion>.from(
        json['criteria'].map(
          (criterion) => Criterion.fromJson(criterion),
        ),
      ),
      // ratings: json['ratings'],
    );
  }
}
