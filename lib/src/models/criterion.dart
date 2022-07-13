class Criterion {
  final int id;
  final String name;
  final int minScore;
  final int maxScore;

  Criterion({
    required this.id,
    required this.name,
    required this.minScore,
    required this.maxScore,
  });

  factory Criterion.fromJson(Map<String, dynamic> json) {
    return Criterion(
      id: json['id'],
      name: json['name'],
      minScore: json['min_score'],
      maxScore: json['max_score'],
    );
  }
}
