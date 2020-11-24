import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/price_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/core_repository.dart';

// The Price repository
class PriceRepository {
  /// Price list
  static List<PriceModel> _priceList;

  /// Get price list by [item] from local storage
  static Future<List<PriceModel>> getPriceListByItem(ItemModel item) async {
    var name = item.name;
    final prefs = await SharedPreferences.getInstance();
    var jsonList = prefs.getStringList('price_list_$name') ?? [];
    _priceList = <PriceModel>[];

    jsonList.forEach((jsonElement) {
      _priceList.add(
          PriceModel.fromJson(jsonDecode(jsonElement) as Map<String, dynamic>));
    });

    return _priceList;
  }

  /// Set price list by [item] to local storage
  static Future<bool> setPriceListByItem(ItemModel item) async {
    var name = item.name;
    final prefs = await SharedPreferences.getInstance();
    var jsonList = <String>[];

    _priceList.forEach((element) {
      jsonList.add(element.toJson());
    });
    CoreRepository.sendDataToDatabase(jsonList, type: 'price_list/$name');
    return prefs.setStringList('price_list_$name', jsonList);
  }

  /// Remove prices by [item] to local storage
  static Future<bool> removePriceListByItem(ItemModel item) async {
    final prefs = await SharedPreferences.getInstance();
    var name = item.name;
    var result = prefs.remove('price_list_$name');
    CoreRepository.sendDataToDatabase(prefs.getStringList('price_list_$name'),
        type: 'price_list/$name');
    return result;
  }
}
