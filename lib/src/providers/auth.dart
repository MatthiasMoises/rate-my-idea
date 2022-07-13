import 'package:flutter/material.dart';

import 'package:supabase/supabase.dart';

import '../utils/constants.dart';

class Auth with ChangeNotifier {
  String _token = '';
  String _userId = '';
  String _username = '';

  bool get isAuth {
    return token != '';
  }

  String get token {
    return _token;
  }

  String get userId {
    return _userId;
  }

  String get username {
    return _username;
  }

  Future<GotrueSessionResponse> _authenticate(
      String email, String password) async {
    try {
      final response = await supabase.auth.signIn(
        email: email,
        password: password,
      );

      return response;

      // if (response.error == null) {

      //   final responseData = json.decode(response.body);

      //   _token = responseData['jwt'];
      //   _userId = responseData['user']['id'].toString();
      //   _username = responseData['user']['username'];

      //   // Map<String, dynamic> authenticatedUser = {
      //   //   'jwt': jsonDecode(response.body)['jwt'],
      //   //   'user': AppUser.fromJson(jsonDecode(response.body)['user']),
      //   // };

      //   final userData = json.encode({
      //     'token': _token,
      //     'userId': _userId,
      //     'username': _username,
      //   });

      //   SharedPreferences prefs = await SharedPreferences.getInstance();
      //   await prefs.setString('userData', userData);
      //   notifyListeners();
      // } else {
      //   throw new Exception('${response.error}');
      // }
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<void> signup(String email, String password) async {
    try {
      await supabase.auth.signUp(email, password);
    } on Exception catch (e) {
      throw e;
    }
  }

  Future<GotrueSessionResponse> login(String email, String password) async {
    return _authenticate(email, password);
  }

  Future<void> signOut() async {
    await supabase.auth.signOut();
  }
}
