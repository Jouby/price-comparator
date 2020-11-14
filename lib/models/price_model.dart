import 'dart:convert';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';

class PriceModel {
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

  String toJson() {
    return jsonEncode({
      'item': item.toMap(),
      'store': store.toMap(),
      'value': value,
      'options': options
    });
  }

  factory PriceModel.fromJson(Map<String, dynamic> parsedJson) {
    return PriceModel(
      ItemModel.fromJson(parsedJson['item']),
      StoreModel.fromJson(parsedJson['store']),
      value: (parsedJson['value'] != '') ? parsedJson['value'].toDouble() : PriceModel.DEFAULT_VALUE,
      options: Map<String, bool>.from(parsedJson['options']) ?? PriceModel.DEFAULT_OPTIONS,
    );
  }
}
