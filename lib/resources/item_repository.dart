import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/abstract_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/price_repository.dart';

class ItemRepository extends AbstractRepository {
  static const key = 'items_list';

  static List<ItemModel> _itemList;

  static Future<List<ItemModel>> getItemsList() async {
    if (_itemList == null) {
      final prefs = await SharedPreferences.getInstance();
      List<String> jsonItemList = prefs.getStringList(ItemRepository.key);
      _itemList = [];

      jsonItemList.forEach((jsonElement) {
        _itemList.add(ItemModel.fromJson(jsonDecode(jsonElement)));
      });
    }

    return _itemList;
  }

  static Future<bool> setItemsList(List<ItemModel> itemsList) async {
    _itemList = itemsList;

    final prefs = await SharedPreferences.getInstance();
    List<String> jsonItemList = [];

    itemsList.forEach((element) {
      jsonItemList.add(element.toJson());
    });

    AbstractRepository.sendDataToDatabase(itemsList, type: ItemRepository.key);

    return prefs.setStringList(ItemRepository.key, jsonItemList);
  }

  static List<ItemModel> removeItem(String name) {
    PriceRepository.removePriceListByItem(name);

    return _itemList;
  }
}
