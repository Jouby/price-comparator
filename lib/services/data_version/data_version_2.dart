import 'dart:convert';
import 'package:the_dead_masked_company.price_comparator/services/data_version/data_version_interface.dart';
import 'package:the_dead_masked_company.price_comparator/resources/core_repository.dart';
import 'package:the_dead_masked_company.price_comparator/services/data_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/item_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';

/// The Data Version 1
/// 
/// For more details, see DataManager
class DataVersion2 implements DataVersionInterface {
  @override
  void loadData(Map<dynamic, dynamic> dataFromDB) async {
    final prefs = await SharedPreferences.getInstance();

    var itemsList = List<String>.from(dataFromDB[ItemRepository.key]);
    prefs.setStringList(StoreRepository.key,
        List<String>.from(dataFromDB[StoreRepository.key]));
    prefs.setStringList(ItemRepository.key, itemsList);

    for (String json in itemsList) {
      ItemModel item = ItemModel.fromJson(jsonDecode(json));
      String itemName = item.name;
      if (dataFromDB['price_list'][itemName] != null) {
        prefs.setStringList(
          'price_list_$itemName',
          List<String>.from(dataFromDB['price_list'][itemName])
        );
      }
    }
  }

  @override
  void upgradeData() async {
    _updateStore_1();
    _updateItem_1();
    _updatePrice_1();
  }

  @override
  void sendData(int currentDataVersion) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> itemList = prefs.getStringList(ItemRepository.key);

    Map<String, dynamic> data = {
      StoreRepository.key: prefs.getStringList(StoreRepository.key),
      ItemRepository.key: itemList,
      DataManager.dataVersionNumber: currentDataVersion,
      'price_list': Map<String, dynamic>()
    };

    for (String json in itemList) {
      ItemModel item = ItemModel.fromJson(jsonDecode(json));
      String itemName = item.name;
      data['price_list'][itemName] =
          prefs.getStringList('price_list_$itemName');
    }

    CoreRepository.sendDataToDatabase(data, resend: false);
  }

  void _updateStore_1() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> oldList = prefs.getStringList(StoreRepository.key);
    List<String> newList = [];
    oldList.forEach((name) {
      newList.add(jsonEncode({'name': name}));
    });
    prefs.setStringList(StoreRepository.key, newList);
  }

  void _updateItem_1() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> oldList = prefs.getStringList(ItemRepository.key);
    List<String> newList = [];
    oldList.forEach((name) {
      newList.add(jsonEncode({'name': name}));
    });
    prefs.setStringList(ItemRepository.key, newList);
  }

  void _updatePrice_1() async {
    final prefs = await SharedPreferences.getInstance();

    // Get item list
    List<String> jsonItemList = prefs.getStringList(ItemRepository.key);
    List<ItemModel> itemList = [];
    jsonItemList.forEach((jsonElement) {
      itemList.add(ItemModel.fromJson(jsonDecode(jsonElement)));
    });

    // Update price for each item
    itemList.forEach((item) {
      String name = item.name;
      List<String> oldList = prefs.getStringList('price_list_$name');
      List<String> newList = [];

      if (oldList == null) {
        return;
      }
      oldList.forEach((element) {
        Map<String, dynamic> data = jsonDecode(element);
        newList.add(jsonEncode({
          'item': item.toMap(),
          'store': {'name': data['store']},
          'value':
              data['price'] != '' || data['price'] != null ? data['price'] : 0,
          'options': {
            'isBio': data['isBio'] == true,
            'isCan': data['isCan'] == true,
            'isFreeze': data['isFreeze'] == true,
            'isUnavailable': data['isUnavailable'] == true,
            'isWrap': data['isWrap'] == true,
          },
        }));
      });
      prefs.setStringList('price_list_$name', newList);
    });
  }
}
