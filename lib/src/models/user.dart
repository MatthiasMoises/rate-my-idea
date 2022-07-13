class User {
  final String email;
  final String phone;
  final String provider;
  final DateTime created;
  final DateTime lastSignIn;
  final String uid;

  User({
    required this.email,
    required this.phone,
    required this.provider,
    required this.created,
    required this.lastSignIn,
    required this.uid,
  });
}
