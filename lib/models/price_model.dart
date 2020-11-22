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
  static const double DEFAULT_VALUE = 0;

  ItemModel item;
  StoreModel store;
  double value;
  Map<String, bool> options;

  PriceModel(ItemModel item, StoreModel store,
      {double value, Map<String, bool> options}) {
    this.item = item;
    this.store = store;
    this.value = value ?? PriceModel.DEFAULT_VALUE;
    this.options = options ?? PriceModel.DEFAULT_OPTIONS;
  }

  @override
  String toString() {
    return toJson();
  }

  @override
  Map toMap() {
    return <String, dynamic>{
      'item': item.toMap(),
      'store': store.toMap(),
      'value': value,
      'options': options
    };
  }

  @override
  String toJson() {
    return jsonEncode({
      'item': item.toMap(),
      'store': store.toMap(),
      'value': value,
      'options': options
    });
  }

  @override
  factory PriceModel.fromJson(Map<String, dynamic> parsedJson) {
    return PriceModel(
      ItemModel.fromJson(parsedJson['item'] as Map<String, dynamic>),
      StoreModel.fromJson(parsedJson['store'] as Map<String, dynamic>),
      value: parsedJson['value'] as double ?? PriceModel.DEFAULT_VALUE,
      options: Map<String, bool>.from(
              parsedJson['options'] as Map<dynamic, dynamic>) ??
          PriceModel.DEFAULT_OPTIONS,
    );
  }
}
