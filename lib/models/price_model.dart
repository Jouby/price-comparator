import 'dart:convert';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/model_interface.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';

/// The Price model
///
/// 1. A Price is defined for an Item on a specific Store
/// 2. The value attribut contains the price value ($ or € or whatever currencies)
/// 3. A price have multiple options (Bio, item used Can, ...)
class PriceModel implements ModelInterface {
  static const Map<String, bool> DEFAULT_OPTIONS = {
    'isBio': false,
    'isCan': false,
    'isFreeze': false,
    'isWrap': false,
    'isUnavailable': false,
  };
  static const num DEFAULT_VALUE = 0;

  String? id;
  ItemModel? item;
  StoreModel? store;
  num? value;
  Map<String, bool>? options;

  PriceModel(ItemModel item, StoreModel store,
      {num? value, Map<String, bool>? options}) {
    this.item = item;
    this.store = store;
    this.value = value ?? PriceModel.DEFAULT_VALUE;
    this.options =
        options ?? Map<String, bool>.from(PriceModel.DEFAULT_OPTIONS);
  }

  @override
  String toString() {
    return jsonEncode(<String, dynamic>{
      ...<String, dynamic>{'id': id},
      ...toMap(),
    });
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'item': item?.id,
      'store': store?.id,
      'value': value,
      'options': options
    };
  }

  @override
  String toJson() {
    return jsonEncode(toMap());
  }

  @override
  factory PriceModel.fromJson(Map<String, dynamic> parsedJson) {
    return PriceModel(
      parsedJson['item'] as ItemModel,
      parsedJson['store'] as StoreModel,
      value: parsedJson['value'] as num? ?? PriceModel.DEFAULT_VALUE,
      options: Map<String, bool>.from(
              parsedJson['options'] as Map<dynamic, dynamic>) ??
          PriceModel.DEFAULT_OPTIONS,
    );
  }
}
