class Setting {
  final int id;
  final String name;
  final String description;
  final bool enabled;

  Setting({
    required this.id,
    required this.name,
    required this.description,
    required this.enabled,
  });

  factory Setting.fromJson(Map<String, dynamic> json) {
    return Setting(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      enabled: json['enabled'],
    );
  }
}
