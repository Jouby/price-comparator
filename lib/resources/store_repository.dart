import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/price_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/abstract_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/item_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/price_repository.dart';

class StoreRepository extends AbstractRepository {
  static const key = 'stores_list';

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
    AbstractRepository.sendDataToDatabase(storesList,
        type: StoreRepository.key);
    return prefs.setStringList(StoreRepository.key, jsonStoreList);
  }

  /// Remove [store] in store
  static Future<List<StoreModel>> removeStore(StoreModel store) async {
    List<ItemModel> itemsList = await ItemRepository.getItemsList();
    if (itemsList == null) itemsList = [];

    for (int i = 0; i < itemsList.length; i++) {
      ItemModel item = itemsList[i];
      List<PriceModel> priceItemList =
          await PriceRepository.getPriceListByItem(item.name);

      if (priceItemList != null) {
        for (int i = 0; i < priceItemList.length; i++) {
          if (priceItemList[i].store.name == store.name) {
            priceItemList.removeAt(i);
          }
        }
      }

      PriceRepository.setPriceListByItem(item.name);
    }

    return _storeList;
  }

  // static Future<bool> addStoresList(String store) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   AbstractRepository.sendDataToDatabase(storesList, type: 'stores_list');
  //   return prefs.setStringList('stores_list', storesList);
  // }

}
