import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

class Repository {
  static FirebaseDatabase database = new FirebaseDatabase();
  static DatabaseReference databaseReference = database.reference();
  static DatabaseReference getDatabaseReference() {
    return databaseReference;
  }

  static void sendDataToDatabase(data) async {
    var userId = await Repository.getUserId();

    if (userId != '') {
      Repository.getDatabaseReference()
          .child("users/$userId")
          .set(data)
          .then((_) {
        print('Transaction  committed.');
      });
    }
  }

  // Get data from Firebase DB
  static dynamic getUserDataFromDatabase() async {
    var userId = await Repository.getUserId();

    if (userId != '') {
      DataSnapshot snapshot =
          await Repository.getDatabaseReference().child("users/$userId").once();

      var itemsList = List<String>.from(snapshot.value['items_list']);
      await Repository.setStoresList(List<String>.from(snapshot.value['stores_list']));
      await Repository.setItemsList(itemsList);
      for (var itemName in itemsList) {
        await Repository.setPriceListByItem(
          itemName,
          List<String>.from(snapshot.value['price_list_$itemName'])
        );            
      }
    }
  }

  // Export data to Firebase DB
  static void exportUserDataToDatabase() async {
    var itemsList = await Repository.getItemsList();
    Map<dynamic, dynamic> data = {
      "stores_list": await Repository.getStoresList(),
      "items_list": itemsList,
    };

    for (var itemName in itemsList) {
      data['price_list_$itemName'] =
          await Repository.getPriceListByItem(itemName);
    }
    Repository.sendDataToDatabase(data);
  }

  static Future<List<String>> getPriceListByItem(String name) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('price_list_$name');
  }

  static Future<List<String>> getStoresList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('stores_list');
  }

  static Future<List<String>> getItemsList() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('items_list');
  }

  static Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_id');
  }

  static Future<String> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name');
  }

  static Future<bool> setPriceListByItem(
      String name, List<String> value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setStringList('price_list_$name', value);
  }

  static Future<bool> setStoresList(List<String> storesList) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setStringList('stores_list', storesList);
  }

  static Future<bool> setItemsList(List<String> itemsList) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setStringList('items_list', itemsList);
  }

  static Future<bool> setUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('user_id', userId);
  }

  static Future<bool> setUserName(String userName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString('user_name', userName);
  }

  static Future<bool> removePriceListByItem(String name) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove('price_list_$name');
  }
}
