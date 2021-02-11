import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/price_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/item_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/core_repository.dart';

// The Price repository
class PriceRepository extends CoreRepository {
  /// Price key index
  static const key = 'prices';

  ItemRepository itemRepository;
  StoreRepository storeRepository;

  /// Price list
  static Map<String, List<PriceModel>> _priceList = {};

  static final PriceRepository _singleton = PriceRepository._internal();

  factory PriceRepository(
      {ItemRepository itemRepository,
      StoreRepository storeRepository,
      FirebaseFirestore databaseReference}) {
    _singleton.itemRepository = itemRepository;
    _singleton.storeRepository = storeRepository;
    _singleton.setDatabaseReference(databaseReference);
    return _singleton;
  }

  PriceRepository._internal();

  /// Get prices by [item]
  Future<List<PriceModel>> getAllByItem(ItemModel item) async {
    if (_priceList[item.id] == null) {
      /// Get all datas from database for current user

      var userId = await getUserId();
      _priceList[item.id] = [];

      if (userId.isNotEmpty) {
        var priceKey = PriceRepository.key;
        var query = await getDatabaseReference()
            .doc(userId)
            .collection(priceKey)
            .where('item', isEqualTo: item.id)
            .get();

        await query.docs.forEach((QueryDocumentSnapshot qds) async {
          var priceData = qds.data();

          priceData['item'] =
              await itemRepository.get(priceData['item'].toString());
          priceData['store'] =
              await storeRepository.get(priceData['store'].toString());

          var price = PriceModel.fromJson(priceData);
          price.id = qds.id;
          price.item.id = item.id;
          _priceList[item.id].add(price);
        });
      }
    }

    return _priceList[item.id];
  }

  /// Add [price]
  Future<List<PriceModel>> add(PriceModel price) async {
    if (price.id != null) {
      return _update(price);
    }

    await getAllByItem(price.item);

    var userId = await getUserId();

    if (userId.isNotEmpty) {
      var priceKey = PriceRepository.key;

      await getDatabaseReference()
          .doc(userId)
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
  Future<List<PriceModel>> _update(PriceModel price) async {
    await getAllByItem(price.item);

    var userId = await getUserId();

    if (userId.isNotEmpty) {
      var priceKey = PriceRepository.key;

      await getDatabaseReference()
          .doc(userId)
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
  Future<List<PriceModel>> remove(PriceModel price) async {
    await getAllByItem(price.item);

    var userId = await getUserId();

    if (userId.isNotEmpty) {
      var priceKey = PriceRepository.key;
      await getDatabaseReference()
          .doc(userId)
          .collection(priceKey)
          .doc(price.id)
          .delete()
          .then((docRef) {
        // price.item.prices.remove(price.id);
        _priceList.remove(price);
      }).catchError((dynamic error) {
        print('Error removing price document: $error');
      });
    }

    return _priceList[price.id];
  }

  Future<void> removeByStore(StoreModel store) async {
    var userId = await getUserId();

    if (userId.isNotEmpty) {
      var priceKey = PriceRepository.key;

      await getDatabaseReference()
          .doc(userId)
          .collection(priceKey)
          .where('store', isEqualTo: store.id)
          .get()
          .then((QuerySnapshot querySnapshot) {
        var batch = getRootDatabaseReference().batch();
        querySnapshot.docs.forEach((DocumentSnapshot doc) {
          batch.delete(doc.reference);
          _priceList[doc.get('item')]
              .removeWhere((price) => price.id == doc.id);
        });
        return batch.commit();
      });
    }
  }

  /// Dispose price data
  void dispose() {
    if (_priceList != null) _priceList = null;
  }
}
