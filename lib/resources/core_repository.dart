import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_dead_masked_company.price_comparator/resources/user_repository.dart';

/// The Core repository
///
/// Used to send and get data from database
abstract class CoreRepository {
  /// Database reference
  static final FirebaseFirestore databaseReference = FirebaseFirestore.instance;

  /// Get the root database reference
  static FirebaseFirestore getRootDatabaseReference() {
    return databaseReference;
  }

  /// Get the database reference
  static CollectionReference getDatabaseReference() {
    return databaseReference.collection('users');
  }

  /// Get all datas from database for current user
  static Future<Map<String, dynamic>> getUserDataFromDatabase() async {
    var userId = await UserRepository.getUserId();

    if (userId.isNotEmpty) {
      var snapshot =
          await CoreRepository.getDatabaseReference().doc('$userId').get();

      return snapshot.data();
    }

    return <String, dynamic>{};
  }
}
