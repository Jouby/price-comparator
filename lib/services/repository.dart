import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class Repository {
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

  static Future<bool> setPriceListByItem(String name, List<String> value) async {
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

  static Future<bool> removePriceListByItem(String name) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.remove('price_list_$name');
  }
}
