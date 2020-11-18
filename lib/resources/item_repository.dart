import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/core_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/price_repository.dart';

/// The Item repository
class ItemRepository {
  /// Item list key index
  static const key = 'items_list';

  /// Item list
  static List<ItemModel> _itemList;

  /// Get item list from local storage
  static Future<List<ItemModel>> getItemList() async {
    if (_itemList == null) {
      final prefs = await SharedPreferences.getInstance();
      List<String> jsonItemList = prefs.getStringList(ItemRepository.key) ?? [];
      _itemList = [];

      jsonItemList.forEach((jsonElement) {
        _itemList.add(ItemModel.fromJson(jsonDecode(jsonElement)));
      });
    }

    return _itemList;
  }

  /// Set [itemsList] to local storage
  static Future<bool> setItemList(List<ItemModel> itemsList) async {
    _itemList = itemsList;

    final prefs = await SharedPreferences.getInstance();
    List<String> jsonItemList = [];

    itemsList.forEach((element) {
      jsonItemList.add(element.toJson());
    });

    CoreRepository.sendDataToDatabase(jsonItemList, type: ItemRepository.key);

    return prefs.setStringList(ItemRepository.key, jsonItemList);
  }

  /// Remove [item] to local storage
  static List<ItemModel> removeItem(ItemModel item) {
    PriceRepository.removePriceListByItem(item);

    return _itemList;
  }
}
