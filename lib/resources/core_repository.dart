import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The Core repository
abstract class CoreRepository {
  /// Database reference
  late FirebaseFirestore databaseReference;

  /// Get the root database reference
  FirebaseFirestore getRootDatabaseReference() {
    return databaseReference;
  }

  /// Get the database reference
  CollectionReference<Map<String, dynamic>> getDatabaseReference() {
    return databaseReference.collection('users');
  }

  void setDatabaseReference(FirebaseFirestore? databaseReference) {
    this.databaseReference = (databaseReference != null)
        ? databaseReference
        : FirebaseFirestore.instance;
  }

  /// Get User ID from local storage
  Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id') ?? '';
  }
}
