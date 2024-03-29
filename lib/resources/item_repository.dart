import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/core_repository.dart';
import 'package:i18n_omatic/i18n_omatic.dart';

/// The Item repository
class ItemRepository extends CoreRepository {
  /// Item list key index
  static const key = 'items';

  /// Item list
  Map<String, ItemModel> _itemList;

  static final ItemRepository _singleton = ItemRepository._internal();

  factory ItemRepository({FirebaseFirestore databaseReference}) {
    _singleton.setDatabaseReference(databaseReference);
    return _singleton;
  }

  ItemRepository._internal();

  /// Get items
  Future<Map<String, ItemModel>> getAll() async {
    if (_itemList == null) {
      /// Get all datas from database for current user

      var userId = await getUserId();
      _itemList = {};

      if (userId.isNotEmpty) {
        var key = ItemRepository.key;
        var query =
            await getDatabaseReference().doc(userId).collection(key).get();

        query.docs.forEach((QueryDocumentSnapshot<Map<String, dynamic>> qds) {
          var item = ItemModel.fromJson(qds.data());
          item.id = qds.id;
          _itemList[item.id] = item;
        });
      }
    }

    return _itemList;
  }

  /// Get item by [id]
  FutureOr<ItemModel> get(String id) async {
    await getAll();

    if (_itemList[id] != null) {
      return _itemList[id];
    }

    var userId = await getUserId();

    if (userId.isNotEmpty) {
      var doc = await getDatabaseReference()
          .doc(userId)
          .collection(ItemRepository.key)
          .doc(id)
          .get();

      if (doc.exists) {
        return ItemModel.fromJson(doc.data());
      }
    }

    return null;
  }

  /// Check if we can add [item]
  String _canAdd(ItemModel item) {
    var canAdd = '';
    for (var itemFromList in _itemList.values) {
      if (itemFromList.name == item.name) {
        canAdd = 'An item with same name already exists.'.tr();
      }
    }

    return canAdd;
  }

  /// Add [item]
  Future<Map<String, dynamic>> add(ItemModel item) async {
    Map<String, dynamic> result = <String, bool>{'success': false};

    if (item.id != null) {
      return _update(item);
    }

    await getAll();

    var check = _canAdd(item);

    if (check == '') {
      var userId = await getUserId();

      if (userId.isNotEmpty) {
        await getDatabaseReference()
            .doc(userId)
            .collection(ItemRepository.key)
            .add(item.toMap())
            .then((docRef) {
          item.id = docRef.id.toString();
          _itemList[item.id] = item;
          result['success'] = true;
        }).catchError((dynamic error) {
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
  String _canUpdate(ItemModel item) {
    var canUpdate = '';

    for (var itemFromList in _itemList.values) {
      if (itemFromList.id != item.id && itemFromList.name == item.name) {
        canUpdate = 'An item with same name already exists.'.tr();
      }
    }

    return canUpdate;
  }

  /// Update [item]
  Future<Map<String, dynamic>> _update(ItemModel item) async {
    Map<String, dynamic> result;

    await getAll();

    var check = _canUpdate(item);

    if (check == '') {
      var userId = await getUserId();

      if (userId.isNotEmpty) {
        await getDatabaseReference()
            .doc(userId)
            .collection(ItemRepository.key)
            .doc(item.id)
            .set(item.toMap())
            .then((docRef) {
          result = <String, bool>{'success': true};
        }).catchError((dynamic error) {
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
  Future<bool> remove(ItemModel item) async {
    await getAll();

    var userId = await getUserId();

    if (userId.isNotEmpty) {
      var key = ItemRepository.key;
      var itemId = item.id;
      await getDatabaseReference()
          .doc('$userId/$key/$itemId')
          .delete()
          .catchError((dynamic error) {
        print('Error removing item document: $error');
        return false;
      });
      ;
      _itemList.remove(item.id);
    }

    return true;
  }

  /// Dispose item data
  void dispose() {
    if (_itemList != null) _itemList = null;
  }

  Map<String, ItemModel> getInternalStoreList() {
    return _itemList;
  }
}
