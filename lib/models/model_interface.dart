class ModelInterface {
  ModelInterface();

  /// Convert object to String
  String toString() => '';

  /// Convert object to Map<String, dynamic>
  Map toMap() => Map();

  /// Convert object to json: String
  String toJson() => '';

  /// Create model object from parsed json
  factory ModelInterface.fromJson(Map<String, dynamic> parsedJson) =>ModelInterface();
}
