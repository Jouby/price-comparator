import 'package:firebase_database/firebase_database.dart';
import 'package:the_dead_masked_company.price_comparator/resources/data_update_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/user_repository.dart';

abstract class AbstractRepository {
  static FirebaseDatabase database = new FirebaseDatabase();
  static DatabaseReference databaseReference = database.reference();
  static DatabaseReference getDatabaseReference() {
    database.setPersistenceEnabled(false);
    databaseReference.keepSynced(false);
    return databaseReference;
  }

  static void sendDataToDatabase(data, {type: '', bool resend: true}) async {
    String userId = await UserRepository.getUserId();

    print('Start resend ????');
    if (resend) {
      print('Start resend');
      DataUpdateRepository.addNewData(data, type);
    }

    if (userId != '') {
      String dbChild = type != '' ? 'users/$userId/$type' : 'users/$userId';
      print('Start Transaction');

      AbstractRepository.getDatabaseReference().child(dbChild).set(data).then((_) {
        print('Transaction  committed.');
        DataUpdateRepository.removeNewData(data, type);
      }).catchError((error) {
        print("Something went wrong: ${error.message}");
      });
    }
  }

  // Get data from Firebase DB
  static dynamic getUserDataFromDatabase() async {
    // var userId = await Repository.getUserId();

    // if (userId != '') {
    //   DataSnapshot snapshot =
    //       await Repository.getDatabaseReference().child("users/$userId").once();

    //   var itemsList = List<String>.from(snapshot.value['items_list']);
    //   await Repository.setStoresList(
    //       List<String>.from(snapshot.value['stores_list']));
    //   await Repository.setItemsList(itemsList);
    //   for (var itemName in itemsList) {
    //     await Repository.setPriceListByItem(itemName,
    //         List<String>.from(snapshot.value['price_list_$itemName']));
    //   }
    // }
  }

  // // Export data to Firebase DB
  // static void exportUserDataToDatabase() async {
  //   var itemsList = await Repository.getItemsList();
  //   Map<dynamic, dynamic> data = {
  //     "stores_list": await Repository.getStoresList(),
  //     "items_list": itemsList,
  //   };

  //   for (var itemName in itemsList) {
  //     data['price_list_$itemName'] =
  //         await Repository.getPriceListByItem(itemName);
  //   }
  //   Repository.sendDataToDatabase(data);
  // }
}
