import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_dead_masked_company.price_comparator/resources/abstract_repository.dart';

class UserRepository extends AbstractRepository 
{
  static Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  static Future<bool> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('user_id', userId);
  }

  static Future<bool> setUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('user_name', userName);
  }
}
