import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_dead_masked_company.price_comparator/resources/core_repository.dart';

/// The User repository
class UserRepository extends CoreRepository {
  static final UserRepository _singleton = UserRepository._internal();

  factory UserRepository({FirebaseFirestore? databaseReference}) {
    _singleton.setDatabaseReference(databaseReference);
    return _singleton;
  }
  UserRepository._internal();

  /// Get all datas from database for current user
  Future<Map<String, dynamic>?> getUserDataFromDatabase() async {
    var userId = await getUserId();

    if (userId.isNotEmpty) {
      var snapshot = await getDatabaseReference().doc('$userId').get();

      return snapshot.data();
    }

    return <String, dynamic>{};
  }

  /// Get User Name from local storage
  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name') ?? '';
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
