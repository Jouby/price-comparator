import 'dart:convert';

import 'package:the_dead_masked_company.price_comparator/models/model_interface.dart';

/// The Store model
class StoreModel implements ModelInterface {
  String? id;
  String name;

  static List<StoreModel> all = [];

  factory StoreModel(String name) {
    for (var store in StoreModel.all) {
      if (name == store.name) {
        return store;
      }
    }
    ;

    var storeModel = StoreModel._internal(name);
    all.add(storeModel);

    return storeModel;
  }

  StoreModel._internal(this.name);

  @override
  String toString() {
    return jsonEncode(<String, dynamic>{
      ...<String, dynamic>{'id': id},
      ...toMap(),
    });
  }

  @override
  Map<String, dynamic> toMap() {
    return <String, dynamic>{'name': name};
  }

  @override
  String toJson() {
    return jsonEncode(toMap());
  }

  @override
  factory StoreModel.fromJson(Map<String, dynamic> parsedJson) {
    return StoreModel(parsedJson['name'].toString());
  }
}
