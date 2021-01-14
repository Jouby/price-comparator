import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

/// The User repository
class UserRepository {
  static final UserRepository _singleton = UserRepository._internal();

  factory UserRepository() {
    return _singleton;
  }
  UserRepository._internal();

  /// Get User ID from local storage
  Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id') ?? '';
  }

  /// Get User Name from local storage
  Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  /// Set User ID to local storage
  Future<bool> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('user_id', userId);
  }

  /// Set User Name to local storage
  Future<bool> setUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('user_name', userName);
  }

  /// Dispose user data
  void dispose() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('user_name');
  }
}
