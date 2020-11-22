import 'dart:convert';

import 'package:the_dead_masked_company.price_comparator/models/model_interface.dart';

/// The Store model
class StoreModel implements ModelInterface {
  String name;

  StoreModel(this.name);

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
  factory StoreModel.fromJson(Map<String, dynamic> parsedJson) {
    return StoreModel(parsedJson['name'].toString());
  }
}
