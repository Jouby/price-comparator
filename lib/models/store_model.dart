import 'dart:convert';

import 'package:the_dead_masked_company.price_comparator/models/model_interface.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';

/// The Store model
class StoreModel implements ModelInterface {
  String id;
  String name;

  StoreModel(this.name) {
    StoreRepository.getAll().then((storeList) {
      storeList.forEach((key, value) {
        if (name == value.name) {
          id = value.id;
        }
      });
    });
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
