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

    var itemsList =
        List<String>.from(dataFromDB[ItemRepository.key] as Iterable);
    await prefs.setStringList(StoreRepository.key,
        List<String>.from(dataFromDB[StoreRepository.key] as Iterable));
    await prefs.setStringList(ItemRepository.key, itemsList);

    for (var json in itemsList) {
      var item = ItemModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
      var itemName = item.name;
      if (dataFromDB['price_list'][itemName] != null) {
        await prefs.setStringList('price_list_$itemName',
            List<String>.from(dataFromDB['price_list'][itemName] as Iterable));
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
    var itemList = prefs.getStringList(ItemRepository.key);

    var data = {
      StoreRepository.key: prefs.getStringList(StoreRepository.key),
      ItemRepository.key: itemList,
      DataManager.dataVersionNumber: currentDataVersion,
      'price_list': <String, dynamic>{}
    };

    for (var json in itemList) {
      var item = ItemModel.fromJson(jsonDecode(json) as Map<String, dynamic>);
      var itemName = item.name;
      (data['price_list'] as dynamic)[itemName] =
          prefs.getStringList('price_list_$itemName');
    }

    CoreRepository.sendDataToDatabase(data, resend: false);
  }

  void _updateStore_1() async {
    final prefs = await SharedPreferences.getInstance();
    var oldList = prefs.getStringList(StoreRepository.key);
    var newList = <String>[];
    oldList.forEach((name) {
      newList.add(jsonEncode({'name': name}));
    });
    await prefs.setStringList(StoreRepository.key, newList);
  }

  void _updateItem_1() async {
    final prefs = await SharedPreferences.getInstance();
    var oldList = prefs.getStringList(ItemRepository.key);
    var newList = <String>[];
    oldList.forEach((name) {
      newList.add(jsonEncode({'name': name}));
    });
    await prefs.setStringList(ItemRepository.key, newList);
  }

  void _updatePrice_1() async {
    final prefs = await SharedPreferences.getInstance();

    // Get item list
    var jsonItemList = prefs.getStringList(ItemRepository.key);
    var itemList = <ItemModel>[];
    jsonItemList.forEach((jsonElement) {
      itemList.add(
          ItemModel.fromJson(jsonDecode(jsonElement) as Map<String, dynamic>));
    });

    // Update price for each item
    itemList.forEach((item) {
      var name = item.name;
      var oldList = prefs.getStringList('price_list_$name');
      var newList = <String>[];

      if (oldList == null) {
        return;
      }
      oldList.forEach((element) {
        var data = jsonDecode(element) as Map<String, dynamic>;
        newList.add(jsonEncode(<String, dynamic>{
          'item': item.toMap(),
          'store': <String, dynamic>{'name': data['store']},
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
