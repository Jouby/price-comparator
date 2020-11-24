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
      var jsonItemList = prefs.getStringList(ItemRepository.key) ?? [];
      _itemList = [];

      jsonItemList.forEach((jsonElement) {
        _itemList.add(ItemModel.fromJson(
            jsonDecode(jsonElement) as Map<String, dynamic>));
      });
    }

    return _itemList;
  }

  /// Set [itemsList] to local storage
  static Future<bool> _saveItemList() async {
    final prefs = await SharedPreferences.getInstance();
    var jsonItemList = <String>[];

    _itemList.forEach((element) {
      jsonItemList.add(element.toJson());
    });

    CoreRepository.sendDataToDatabase(jsonItemList, type: ItemRepository.key);

    return prefs.setStringList(ItemRepository.key, jsonItemList);
  }

  /// Set displayed item list
  static Future<List<ItemModel>> setItemList(List<ItemModel> list) async {
    _itemList = List.from(list);
    await _saveItemList();

    return _itemList;
  }

  /// Remove [item] to local storage
  static List<ItemModel> removeItem(ItemModel item) {
    PriceRepository.removePriceListByItem(item);

    return _itemList;
  }
}
