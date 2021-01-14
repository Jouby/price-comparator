import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/core_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/user_repository.dart';
import 'package:the_dead_masked_company.price_comparator/services/translate.dart';

/// The Store repository
class StoreRepository {
  /// Store list key index
  static const key = 'stores';

  /// Store list
  static Map<String, StoreModel> _storeList;

  static final StoreRepository _singleton = StoreRepository._internal();

  factory StoreRepository() {
    return _singleton;
  }
  StoreRepository._internal();

  /// Get stores
  Future<Map<String, StoreModel>> getAll() async {
    if (_storeList == null) {
      var userId = await UserRepository().getUserId();
      _storeList = {};

      if (userId.isNotEmpty) {
        var key = StoreRepository.key;
        var query = await CoreRepository.getDatabaseReference()
            .doc(userId)
            .collection(key)
            .get();

        query.docs.forEach((QueryDocumentSnapshot qds) {
          var store = StoreModel.fromJson(qds.data());
          store.id = qds.id;
          _storeList[store.id] = store;
        });
      }
    }

    return _storeList;
  }

  /// Get item by [id]
  FutureOr<StoreModel> get(String id) async {
    await getAll();

    if (_storeList[id] != null) {
      return _storeList[id];
    }

    var userId = await UserRepository().getUserId();

    if (userId.isNotEmpty) {
      await CoreRepository.getDatabaseReference()
          .doc(userId)
          .collection(StoreRepository.key)
          .doc(id)
          .get()
          .then((doc) {
        if (doc.exists) {
          return StoreModel.fromJson(doc.data());
        } else {
          print('Error getting item document: $id');
        }
      }).catchError((dynamic error) {
        print('Error updating price document: $error');
      });
    }

    return null;
  }

  /// Check if we can add [store]
  String _canAdd(StoreModel store) {
    var canAdd = '';
    for (var storeFromList in _storeList.values) {
      if (storeFromList.name == store.name) {
        print('Error adding store document: duplicate ' + store.name);
        canAdd = Translate.translate('A store with same name already exists.');
      }
    }

    return canAdd;
  }

  /// Add [store]
  Future<Map<String, dynamic>> add(StoreModel store) async {
    Map<String, dynamic> result = <String, bool>{'success': false};

    if (store.id != null) {
      return _update(store);
    }

    await getAll();

    var check = _canAdd(store);

    if (check == '') {
      var userId = await UserRepository().getUserId();

      if (userId.isNotEmpty) {
        await CoreRepository.getDatabaseReference()
            .doc(userId)
            .collection(StoreRepository.key)
            .add(store.toMap())
            .then((docRef) {
          store.id = docRef.id;
          _storeList[store.id] = store;
          result['success'] = true;
        }).catchError((dynamic error) {
          print('Error adding store document: $error');
          result = <String, String>{
            'error': 'Error adding store document: $error'
          };
        });
      }
    } else {
      result = <String, String>{'error': check};
    }

    return result;
  }

  /// Check if we can update [store]
  String _canUpdate(StoreModel store) {
    var canUpdate = '';

    for (var storeFromList in _storeList.values) {
      if (storeFromList.id != store.id && storeFromList.name == store.name) {
        print('Error updating store document: duplicate ' + store.name);
        canUpdate =
            Translate.translate('A store with same name already exists.');
      }
    }

    return canUpdate;
  }

  /// Update [store]
  Future<Map<String, dynamic>> _update(StoreModel store) async {
    Map<String, dynamic> result;

    await getAll();

    var check = _canUpdate(store);

    if (check == '') {
      var userId = await UserRepository().getUserId();

      if (userId.isNotEmpty) {
        await CoreRepository.getDatabaseReference()
            .doc(userId)
            .collection(StoreRepository.key)
            .doc(store.id)
            .set(store.toMap())
            .then((docRef) {
          result = <String, bool>{'success': true};
        }).catchError((dynamic error) {
          print('Error updating store document: $error');
          result = <String, String>{
            'error': 'Error updating store document: $error'
          };
        });
      }
    } else {
      result = <String, String>{'error': check};
    }

    return result;
  }

  /// Remove [store]
  Future<bool> remove(StoreModel store) async {
    await getAll();

    var userId = await UserRepository().getUserId();

    if (userId.isNotEmpty) {
      var key = StoreRepository.key;
      var id = store.id;
      await CoreRepository.getDatabaseReference()
          .doc('$userId/$key/$id')
          .delete()
          .then((docRef) {
        _storeList.remove(store.id);
      }).catchError((dynamic error) {
        print('Error removing store document: $error');
        return false;
      });
    }

    return true;
  }

  /// Dispose store data
  void dispose() {
    if (_storeList != null) _storeList = null;
  }
}
