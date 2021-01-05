import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/core_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/user_repository.dart';
import 'package:the_dead_masked_company.price_comparator/services/translate.dart';

/// The Item repository
class ItemRepository {
  /// Item list key index
  static const key = 'items';

  /// Item list
  static Map<String, ItemModel> _itemList;

  /// Get items
  static Future<Map<String, ItemModel>> getAll() async {
    if (_itemList == null) {
      /// Get all datas from database for current user

      var userId = await UserRepository.getUserId();
      _itemList = {};

      if (userId.isNotEmpty) {
        var key = ItemRepository.key;
        var query = await CoreRepository.getDatabaseReference()
            .doc(userId)
            .collection(key)
            .get();

        query.docs.forEach((QueryDocumentSnapshot qds) {
          var item = ItemModel.fromJson(qds.data());
          item.id = qds.id;
          _itemList[item.id] = item;
        });
      }
    }

    return _itemList;
  }

  /// Get item by [id]
  static FutureOr<ItemModel> get(String id) async {
    await ItemRepository.getAll();

    if (_itemList[id] != null) {
      return _itemList[id];
    }

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

  /// Check if we can add [item]
  static String _canAdd(ItemModel item) {
    var canAdd = '';
    for (var itemFromList in _itemList.values) {
      if (itemFromList.name == item.name) {
        print('Error adding item document: duplicate ' + item.name);
        canAdd = Translate.translate('An item with same name already exists.');
      }
    }

    return canAdd;
  }

  /// Add [item]
  static Future<Map<String, dynamic>> add(ItemModel item) async {
    Map<String, dynamic> result = <String, bool>{'success': false};

    if (item.id != null) {
      return _update(item);
    }

    await ItemRepository.getAll();

    var check = ItemRepository._canAdd(item);

    if (check == '') {
      var userId = await UserRepository.getUserId();

      if (userId.isNotEmpty) {
        await CoreRepository.getDatabaseReference()
            .doc(userId)
            .collection(ItemRepository.key)
            .add(item.toMap())
            .then((docRef) {
          item.id = docRef.id.toString();
          _itemList[item.id] = item;
          result['success'] = true;
        }).catchError((dynamic error) {
          print('Error addind item document: $error');
          result = <String, String>{
            'error': 'Error adding item document: $error'
          };
        });
      }
    } else {
      result = <String, String>{'error': check};
    }

    return result;
  }

  /// Check if we can update [item]
  static String _canUpdate(ItemModel item) {
    var canUpdate = '';

    for (var itemFromList in _itemList.values) {
      if (itemFromList.id != item.id && itemFromList.name == item.name) {
        print('Error updating item document: duplicate ' + item.name);
        canUpdate =
            Translate.translate('An item with same name already exists.');
      }
    }

    return canUpdate;
  }

  /// Update [item]
  static Future<Map<String, dynamic>> _update(ItemModel item) async {
    Map<String, dynamic> result;

    await ItemRepository.getAll();

    var check = ItemRepository._canUpdate(item);

    if (check == '') {
      var userId = await UserRepository.getUserId();

      if (userId.isNotEmpty) {
        await CoreRepository.getDatabaseReference()
            .doc(userId)
            .collection(ItemRepository.key)
            .doc(item.id)
            .set(item.toMap())
            .then((docRef) {
          result = <String, bool>{'success': true};
        }).catchError((dynamic error) {
          print('Error updating item document: $error');
          result = <String, String>{
            'error': 'Error updating item document: $error'
          };
        });
      }
    } else {
      result = <String, String>{'error': check};
    }

    return result;
  }

  /// Remove [item]
  static Future<Map<String, ItemModel>> remove(ItemModel item) async {
    await ItemRepository.getAll();

    var userId = await UserRepository.getUserId();

    if (userId.isNotEmpty) {
      var key = ItemRepository.key;
      var name = item.name;
      await CoreRepository.getDatabaseReference()
          .doc('$userId/$key/$name')
          .delete();
      _itemList.remove(item.id);
    }

    return _itemList;
  }
}
