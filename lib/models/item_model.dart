import 'dart:convert';
import 'package:the_dead_masked_company.price_comparator/models/model_interface.dart';

/// The Item model
///
/// 1. An item can be buy on store
/// 2. An item have mutliple prices (maximum one per store)
class ItemModel implements ModelInterface {
  String? id;
  String name;
  Map<String, Map<String, dynamic>> prices = {};

  static List<ItemModel> all = [];

  factory ItemModel(String name) {
    for (var item in ItemModel.all) {
      if (name == item.name) {
        return item;
      }
    }
    ;

    var itemModel = ItemModel._internal(name);
    all.add(itemModel);

    return itemModel;
  }
  ItemModel._internal(this.name);

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
      'name': name,
    };
  }

  @override
  String toJson() {
    return jsonEncode(toMap());
  }

  @override
  factory ItemModel.fromJson(Map<String, dynamic> parsedJson) {
    return ItemModel(parsedJson['name'].toString());
  }
}
