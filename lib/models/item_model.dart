import 'dart:convert';

class ItemModel {
  String name;

  ItemModel(this.name);

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

  factory ItemModel.fromJson(Map<String, dynamic> parsedJson) {
    return ItemModel(parsedJson['name']);
  }
}
