import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/price_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/core_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/item_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/user_repository.dart';

// The Price repository
class PriceRepository {
  /// Price key index
  static const key = 'prices';

  /// Price list
  static final Map<String, List<PriceModel>> _priceList = {};

  /// Get prices by [item]
  static Future<List<PriceModel>> getAllByItem(ItemModel item) async {
    if (_priceList[item.id] == null) {
      /// Get all datas from database for current user

      var userId = await UserRepository.getUserId();
      _priceList[item.id] = [];

      if (userId.isNotEmpty) {
        var itemKey = ItemRepository.key;
        var priceKey = PriceRepository.key;
        var itemId = item.id;
        var query = await CoreRepository.getDatabaseReference()
            .doc(userId)
            .collection(itemKey)
            .doc(itemId)
            .collection(priceKey)
            .get();

        query.docs.forEach((QueryDocumentSnapshot qds) {
          var price = PriceModel.fromJson(qds.data());
          price.id = qds.id;
          price.item.id = item.id;
          _priceList[item.id].add(price);
        });
      }
    }

    return _priceList[item.id];
  }

  /// Add [price]
  static Future<List<PriceModel>> add(PriceModel price) async {
    if (price.id != null) {
      return _update(price);
    }

    await PriceRepository.getAllByItem(price.item);

    var userId = await UserRepository.getUserId();

    if (userId.isNotEmpty) {
      var itemKey = ItemRepository.key;
      var priceKey = PriceRepository.key;
      var itemId = price.item.id;

      await CoreRepository.getDatabaseReference()
          .doc(userId)
          .collection(itemKey)
          .doc(itemId)
          .collection(priceKey)
          .add(price.toMap())
          .then((docRef) {
        price.id = docRef.id;
        price.item.prices[price.id] = price.toMap();
        _priceList[price.item.id].add(price);
      }).catchError((dynamic error) {
        print('Error adding price document: $error');
      });
    }

    return _priceList[price.item.id];
  }

  /// Update [price]
  static Future<List<PriceModel>> _update(PriceModel price) async {
    await PriceRepository.getAllByItem(price.item);

    var userId = await UserRepository.getUserId();

    if (userId.isNotEmpty) {
      var itemKey = ItemRepository.key;
      var priceKey = PriceRepository.key;
      var itemId = price.item.id;

      await CoreRepository.getDatabaseReference()
          .doc(userId)
          .collection(itemKey)
          .doc(itemId)
          .collection(priceKey)
          .doc(price.id)
          .set(price.toMap())
          .catchError((dynamic error) {
        print('Error updating price document: $error');
      });
    }

    return _priceList[price.item.id];
  }

  /// Remove [price]
  static Future<List<PriceModel>> remove(PriceModel price) async {
    await PriceRepository.getAllByItem(price.item);

    var userId = await UserRepository.getUserId();

    if (userId.isNotEmpty) {
      var itemKey = ItemRepository.key;
      var priceKey = PriceRepository.key;
      var itemId = price.item.id;
      var storeId = price.store.id;
      await CoreRepository.getDatabaseReference()
          .doc(userId)
          .collection(itemKey)
          .doc(itemId)
          .collection(priceKey)
          .doc(storeId)
          .delete()
          .then((docRef) {
        price.item.prices.remove(price.id);
        _priceList.remove(price);
      }).catchError((dynamic error) {
        print('Error removing price document: $error');
      });
    }

    return _priceList[price.item.id];
  }
}
