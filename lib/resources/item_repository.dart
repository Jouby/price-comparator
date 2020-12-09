import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/core_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/user_repository.dart';

/// The Item repository
class ItemRepository {
  /// Item list key index
  static const key = 'items';

  /// Item list
  static List<ItemModel> _itemList;

  /// Get items
  static Future<List<ItemModel>> getAll() async {
    if (_itemList == null) {
      /// Get all datas from database for current user

      var userId = await UserRepository.getUserId();
      _itemList = [];

      if (userId.isNotEmpty) {
        var key = ItemRepository.key;
        var query = await CoreRepository.getDatabaseReference()
            .doc(userId)
            .collection(key)
            .get();

        query.docs.forEach((QueryDocumentSnapshot qds) {
          var item = ItemModel.fromJson(qds.data());
          item.id = qds.id;
          _itemList.add(item);
        });
      }
    }

    return _itemList;
  }

  /// Get item by [id]
  static FutureOr<ItemModel> get(String id) async {
    await ItemRepository.getAll();
    var userId = await UserRepository.getUserId();

    if (userId.isNotEmpty) {
      await CoreRepository.getDatabaseReference()
          .doc(userId)
          .collection(ItemRepository.key)
          .doc(id)
          .get()
          .then((doc) {
        if (doc.exists) {
          return ItemModel.fromJson(doc.data());
        } else {
          print('Error getting item document: $id');
        }
      }).catchError((dynamic error) {
        print('Error updating price document: $error');
      });
    }

    return null;
  }

  /// Add [item]
  static Future<List<ItemModel>> add(ItemModel item) async {
    if (item.id != null) {
      return _update(item);
    }
    await ItemRepository.getAll();

    var userId = await UserRepository.getUserId();

    if (userId.isNotEmpty) {
      await CoreRepository.getDatabaseReference()
          .doc(userId)
          .collection(ItemRepository.key)
          .add(item.toMap())
          .then((docRef) {
        item.id = docRef.id.toString();
        _itemList.add(item);
      }).catchError((dynamic error) {
        print('Error updating price document: $error');
      });
    }

    return _itemList;
  }

  /// Update [item]
  static Future<List<ItemModel>> _update(ItemModel item) async {
    await ItemRepository.getAll();

    var userId = await UserRepository.getUserId();

    if (userId.isNotEmpty) {
      await CoreRepository.getDatabaseReference()
          .doc(userId)
          .collection(ItemRepository.key)
          .doc(item.id)
          .set(item.toMap())
          .catchError((dynamic error) {
        print('Error updating store document: $error');
      });
    }

    return _itemList;
  }

  /// Remove [item]
  static Future<List<ItemModel>> remove(ItemModel item) async {
    await ItemRepository.getAll();

    var userId = await UserRepository.getUserId();

    if (userId.isNotEmpty) {
      var key = ItemRepository.key;
      var name = item.name;
      await CoreRepository.getDatabaseReference()
          .doc('$userId/$key/$name')
          .delete();
    }

    return _itemList;
  }
}
