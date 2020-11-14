import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_dead_masked_company.price_comparator/models/price_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/abstract_repository.dart';

class PriceRepository extends AbstractRepository {

    static List<PriceModel> _priceList;

  /// Get price list by item [name] from shared preferences
  static Future<List<PriceModel>> getPriceListByItem(String name) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = prefs.getStringList('price_list_$name') ?? [];
    _priceList = [];

    jsonList.forEach((jsonElement) {
      _priceList.add(PriceModel.fromJson(jsonDecode(jsonElement)));
    });

    return _priceList;
  }

  /// Set price list by item [name]
  static Future<bool> setPriceListByItem(String name) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = [];

    _priceList.forEach((element) {
      jsonList.add(element.toJson());
    });
    AbstractRepository.sendDataToDatabase(_priceList, type: 'price_list_$name');

    return prefs.setStringList('price_list_$name', jsonList);
  }

  static Future<bool> removePriceListByItem(String name) async {
    final prefs = await SharedPreferences.getInstance();
    Future<bool> result = prefs.remove('price_list_$name');
    // AbstractRepository.sendDataToDatabase(prefs.getStringList('price_list_$name'),
    //     type: 'price_list_$name');
    return result;
  }
}
