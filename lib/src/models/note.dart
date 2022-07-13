class Note {
  final int id;
  final String text;

  const Note({
    required this.id,
    required this.text,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      text: json['text'],
    );
  }
}
