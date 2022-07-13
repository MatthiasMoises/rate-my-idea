import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './app_user.dart';

class AuthUser {
  final String identifier;
  final String password;

  AuthUser({
    required this.identifier,
    required this.password,
  });

  Future<Map<String, dynamic>> authenticateUser() async {
    final response = await http.post(
      Uri.parse('https://powerful-savannah-90821.herokuapp.com/auth/local'),
      headers: <String, String>{
        'Content-Type': 'application/json; chartset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'identifier': this.identifier,
        'password': this.password,
      }),
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> authenticatedUser = {
        'jwt': jsonDecode(response.body)['jwt'],
        'user': AppUser.fromJson(jsonDecode(response.body)['user']),
      };

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', authenticatedUser['jwt']);
      return authenticatedUser;
    } else {
      throw new Exception('Failed to authenticate user');
    }
  }
}
