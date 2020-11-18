import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/price_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/core_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/item_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/price_repository.dart';

/// The Store repository
class StoreRepository {
  /// Store list key index
  static const key = 'stores_list';

  /// Store list
  static List<StoreModel> _storeList;

  /// Get store list from shared preferences
  static Future<List<StoreModel>> getStoresList() async {
    if (_storeList == null) {
      final prefs = await SharedPreferences.getInstance();
      List<String> jsonStoreList = prefs.getStringList(StoreRepository.key);
      _storeList = [];

      jsonStoreList.forEach((jsonElement) {
        _storeList.add(StoreModel.fromJson(jsonDecode(jsonElement)));
      });
    }

    return _storeList;
  }

  /// Set [storesList] on shared preferences
  static Future<bool> setStoresList(List<StoreModel> storesList) async {
    _storeList = storesList;

    List<String> jsonStoreList = [];
    storesList.forEach((element) {
      jsonStoreList.add(element.toJson());
    });
    final prefs = await SharedPreferences.getInstance();
    CoreRepository.sendDataToDatabase(jsonStoreList, type: StoreRepository.key);
    return prefs.setStringList(StoreRepository.key, jsonStoreList);
  }

  /// Remove [store] in store
  static Future<List<StoreModel>> removeStore(StoreModel store) async {
    List<ItemModel> itemsList = await ItemRepository.getItemList();
    if (itemsList == null) itemsList = [];

    for (int i = 0; i < itemsList.length; i++) {
      ItemModel item = itemsList[i];
      List<PriceModel> priceItemList =
          await PriceRepository.getPriceListByItem(item);

      if (priceItemList != null) {
        for (int i = 0; i < priceItemList.length; i++) {
          if (priceItemList[i].store.name == store.name) {
            priceItemList.removeAt(i);
          }
        }
      }

      PriceRepository.setPriceListByItem(item);
    }

    return _storeList;
  }
}
