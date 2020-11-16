import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

/// The User repository
class UserRepository
{
  /// Get User ID from local storage
  static Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  /// Get User Name from local storage
  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  /// Set User ID to local storage
  static Future<bool> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('user_id', userId);
  }

  /// Set User Name to local storage
  static Future<bool> setUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('user_name', userName);
  }
}
