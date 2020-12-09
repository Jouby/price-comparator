import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/core_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/user_repository.dart';

/// The Store repository
class StoreRepository {
  /// Store list key index
  static const key = 'stores';

  /// Store list
  static List<StoreModel> _storeList;

  /// Get stores
  static Future<List<StoreModel>> getAll() async {
    if (_storeList == null) {
      var userId = await UserRepository.getUserId();
      _storeList = [];

      if (userId.isNotEmpty) {
        var key = StoreRepository.key;
        var query = await CoreRepository.getDatabaseReference()
            .doc(userId)
            .collection(key)
            .get();

        query.docs.forEach((QueryDocumentSnapshot qds) {
          var store = StoreModel.fromJson(qds.data());
          store.id = qds.id;
          _storeList.add(store);
        });
      }
    }

    return _storeList;
  }

  /// Add [store]
  static Future<List<StoreModel>> add(StoreModel store) async {
    if (store.id != null) {
      return _update(store);
    }
    await StoreRepository.getAll();

    var userId = await UserRepository.getUserId();

    if (userId.isNotEmpty) {
      await CoreRepository.getDatabaseReference()
          .doc(userId)
          .collection(StoreRepository.key)
          .add(store.toMap())
          .then((docRef) {
        store.id = docRef.id;
        _storeList.add(store);
      }).catchError((dynamic error) {
        print('Error adding store document: $error');
      });
    }

    return _storeList;
  }

  /// Update [store]
  static Future<List<StoreModel>> _update(StoreModel store) async {
    await StoreRepository.getAll();

    var userId = await UserRepository.getUserId();

    if (userId.isNotEmpty) {
      await CoreRepository.getDatabaseReference()
          .doc(userId)
          .collection(StoreRepository.key)
          .doc(store.id)
          .set(store.toMap())
          .catchError((dynamic error) {
        print('Error updating store document: $error');
      });
    }

    return _storeList;
  }

  /// Remove [store]
  static Future<List<StoreModel>> remove(StoreModel store) async {
    await StoreRepository.getAll();

    var userId = await UserRepository.getUserId();

    if (userId.isNotEmpty) {
      var key = StoreRepository.key;
      var name = store.id;
      await CoreRepository.getDatabaseReference()
          .doc('$userId/$key/$name')
          .delete()
          .then((docRef) {
        _storeList.remove(store);
        // TODO remove all price with this store
      }).catchError((dynamic error) {
        print('Error removing store document: $error');
      });
    }

    return _storeList;
  }
}
