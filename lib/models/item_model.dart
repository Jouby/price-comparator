import 'dart:convert';

import 'package:the_dead_masked_company.price_comparator/models/model_interface.dart';

/// The Item model
///
/// 1. An item can be buy on store
/// 2. An item have mutliple prices (maximum one per store)
class ItemModel implements ModelInterface {
  String name;

  ItemModel(this.name);

  @override
  String toString() {
    return name;
  }

  @override
  Map toMap() {
    return <String, dynamic>{'name': name};
  }

  @override
  String toJson() {
    return jsonEncode({'name': name});
  }

  @override
  factory ItemModel.fromJson(Map<String, dynamic> parsedJson) {
    return ItemModel(parsedJson['name'].toString());
  }
}
