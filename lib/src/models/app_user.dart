class AppUser {
  final int id;
  final String username;
  final String email;
  // final String password;
  final bool confirmed;
  final bool blocked;

  const AppUser({
    required this.id,
    required this.username,
    required this.email,
    // required this.password,
    required this.confirmed,
    required this.blocked,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      confirmed: json['confirmed'],
      blocked: json['blocked'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'confirmed': confirmed,
        'blocked': blocked,
      };
}
