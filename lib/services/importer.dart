import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/price_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/item_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/price_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';

/// The Importer widget
///
/// This widget is used to import data from JSON file
/// Currently it's just a dev tool
class Importer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return null;
  }

  /// Run the importer to read in JSON file and write in Firestore database
  static Future<void> run(BuildContext context) async {
    var data = await DefaultAssetBundle.of(context).loadString(
        'assets/price-comparator-8dea8-p5BcCXgRF9gLwLD0zMsaC0RnbFI2-export.json');

    var jsonResult = json.decode(data) as Map<String, dynamic>;

    for (var name in jsonResult['items_list'] as List<dynamic>) {
      await ItemRepository().add(ItemModel(name.toString()));
    }
    jsonResult.remove('items_list');

    for (var name in jsonResult['stores_list'] as List<dynamic>) {
      await StoreRepository.add(StoreModel(name.toString()));
    }
    jsonResult.remove('stores_list');

    jsonResult.forEach((key, dynamic values) {
      var item = ItemModel(key.substring(11));

      for (var value in values as List<dynamic>) {
        var priceValue = json.decode(value.toString()) as Map<String, dynamic>;
        if (priceValue['price'] != '') {
          var store = StoreModel(priceValue['store'].toString());
          var price = PriceModel(item, store,
              value: priceValue['price'] as num,
              options: {
                'isBio': priceValue['isBio'].toString() == 'true',
                'isCan': priceValue['isCan'].toString() == 'true',
                'isFreeze': priceValue['isFreeze'].toString() == 'true',
                'isWrap': priceValue['isWrap'].toString() == 'true',
                'isUnavailable':
                    priceValue['isUnavailable'].toString() == 'true',
              });
          PriceRepository.add(price);
        }
      }
    });
  }
}
