import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/item_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';

/// The PatchManager widget
///
/// ...
class PatchManager extends StatelessWidget {
  static const pubspecFilePath = 'pubspec.yaml';
  static const patchDataVersion = 'patch_data_version';

  @override
  Widget build(BuildContext context) {
    return null;
  }

  static void checkDataVersion() async {
    final prefs = await SharedPreferences.getInstance();
    int currentDataVersion = prefs.getInt('data_version');
    int appDataVersion = await PatchManager.getAppDataVersion();

    if (currentDataVersion != appDataVersion) {
      // reinitPrice();
      //updateStore_1();
      //updateItem_1();
      // updatePrice_1();
    }

    // prefs.setInt('data_version', PatchManager.dataVersion);
  }

  /// Get Application data version from pubspec.yaml
  static Future<int> getAppDataVersion() async {
    String pubspecContent = await rootBundle.loadString(PatchManager.pubspecFilePath);
    Map yaml = loadYaml(pubspecContent);

    return yaml[PatchManager.patchDataVersion];
  }

  static void reinitPrice() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('price_list_amande', [
      "{\"store\":\"lidl\",\"price\":2.4,\"isBio\":true,\"isCan\":true,\"isFreeze\":true,\"isUnavailable\":false,\"isWrap\":true}",
      "{\"store\":\"aldi\",\"price\":4,\"isBio\":true,\"isCan\":true,\"isFreeze\":true,\"isUnavailable\":false}",
      "{\"store\":\"carrefour\",\"price\":4,\"isBio\":true,\"isCan\":false,\"isFreeze\":true,\"isUnavailable\":false}",
      "{\"store\":\"Local&Vous\",\"price\":\"\",\"isBio\":false,\"isCan\":false,\"isFreeze\":false,\"isUnavailable\":true}"
    ]);
    prefs.setStringList('price_list_Caramel', [
      "{\"store\":\"Local&Vous\",\"price\":0.78,\"isBio\":false,\"isCan\":false,\"isFreeze\":true,\"isUnavailable\":false}",
      "{\"store\":\"carrefour\",\"price\":1.04,\"isBio\":false,\"isCan\":false,\"isFreeze\":false,\"isUnavailable\":false}",
      "{\"store\":\"Camion Epicerie Le Gramme\",\"price\":5,\"isBio\":true,\"isCan\":true,\"isFreeze\":true,\"isWrap\":true,\"isUnavailable\":false}",
      "{\"store\":\"lidl\",\"price\":\"\"}",
      "{\"store\":\"aldi\",\"price\":\"\"}"
    ]);
    prefs.setStringList('price_list_Eponge', [
      "{\"store\":\"lidl\",\"price\":4,\"isBio\":false,\"isCan\":false,\"isFreeze\":true,\"isUnavailable\":false}",
      "{\"store\":\"aldi\",\"price\":\"\"}",
      "{\"store\":\"carrefour\",\"price\":1.4,\"isBio\":true,\"isCan\":true,\"isFreeze\":true,\"isUnavailable\":false}",
      "{\"store\":\"Local&Vous\",\"price\":\"\",\"isBio\":true,\"isCan\":false,\"isFreeze\":true,\"isUnavailable\":false}"
    ]);
    prefs.setStringList('price_list_Grenade', [
      "{\"store\":\"Local&Vous\",\"price\":4.2,\"isBio\":false,\"isCan\":false,\"isFreeze\":true,\"isWrap\":false,\"isUnavailable\":false}",
      "{\"store\":\"lidl\",\"price\":\"\"}",
      "{\"store\":\"carrefour\",\"price\":\"\"}",
      "{\"store\":\"Camion Epicerie Le Gramme\",\"price\":\"\"}",
      "{\"store\":\"aldi\",\"price\":\"\"}"
    ]);
    prefs.setStringList('price_list_Miel', [
      "{\"store\":\"aldi\",\"price\":2.3}",
      "{\"store\":\"carrefour\",\"price\":\"\"}",
      "{\"store\":\"lidl\",\"price\":2.2}"
    ]);
    prefs.setStringList('price_list_Test', [
      "{\"store\":\"aldi\",\"price\":1.2,\"isBio\":false,\"isCan\":false,\"isFreeze\":false}",
      "{\"store\":\"lidl\",\"price\":\"\"}",
      "{\"store\":\"carrefour\",\"price\":\"\"}"
    ]);
    prefs.setStringList('price_list_eee', [
      "{\"store\":\"lidl\",\"price\":1.3,\"isBio\":false,\"isCan\":false,\"isFreeze\":false}",
      "{\"store\":\"carrefour\",\"price\":\"\"}",
      "{\"store\":\"aldi\",\"price\":\"\"}"
    ]);
  }

  static void updateStore_1() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> oldList = prefs.getStringList(StoreRepository.key);
    List<String> newList = [];
    oldList.forEach((name) {
      newList.add(jsonEncode({'name': name}));
    });
    prefs.setStringList(StoreRepository.key, newList);
  }

  static void updateItem_1() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> oldList = prefs.getStringList(ItemRepository.key);
    List<String> newList = [];
    oldList.forEach((name) {
      newList.add(jsonEncode({'name': name}));
    });
    prefs.setStringList(ItemRepository.key, newList);
  }

  static void updatePrice_1() async {
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
