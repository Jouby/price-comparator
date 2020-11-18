import 'package:firebase_database/firebase_database.dart';
import 'package:the_dead_masked_company.price_comparator/resources/data_update_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/user_repository.dart';

/// The Core repository
/// 
/// Used to send and get data from database
abstract class CoreRepository {
  /// Database
  static FirebaseDatabase database = new FirebaseDatabase();
  /// Database reference
  static DatabaseReference databaseReference = database.reference();

  /// Get the database reference
  static DatabaseReference getDatabaseReference() {
    database.setPersistenceEnabled(false);
    databaseReference.keepSynced(false);
    return databaseReference;
  }

  /// Send [data] to database
  /// 
  /// A [type] is the key index on database. By default the value is empty so it's replace all current user's data.
  /// The parameter [resend] is used to saved data in data pending queue.
  static void sendDataToDatabase(dynamic data, {type: '', bool resend: true}) async {
    String userId = await UserRepository.getUserId();

    if (resend) {
      DataUpdateRepository.addToDataQueue(data, type);
    }

    if (userId != '') {
      String dbChild = type != '' ? 'users/$userId/$type' : 'users/$userId';
      print('Start Transaction');

      CoreRepository.getDatabaseReference()
          .child(dbChild)
          .set(data)
          .then((_) {
        print('Transaction  committed.');
        DataUpdateRepository.removeFromDataQueue(data, type);
      }).catchError((error) {
        print("Something went wrong: ${error.toString()}");
      });
    }
  }

  /// Get all datas from database for current user
  static Future<Map<dynamic, dynamic>> getUserDataFromDatabase() async {
    var userId = await UserRepository.getUserId();

    if (userId != '') {
      DataSnapshot snapshot = await CoreRepository.getDatabaseReference()
          .child("users/$userId")
          .once();

      return snapshot.value;
    }

    return {};
  }
}