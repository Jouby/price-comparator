import 'dart:convert';

class StoreModel {
  String name;

  StoreModel(this.name);

  @override
  String toString() {
    return name;
  }

  Map toMap() {
    return {'name': name};
  }

  String toJson() {
    return jsonEncode({'name': name});
  }

  factory StoreModel.fromJson(Map<String, dynamic> parsedJson) {
    return StoreModel(parsedJson['name']);
  }
}
