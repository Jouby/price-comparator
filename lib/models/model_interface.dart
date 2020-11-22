class ModelInterface {
  ModelInterface();

  /// Convert object to String
  @override
  String toString() => '';

  /// Convert object to Map<String, dynamic>
  Map toMap() => <String, dynamic>{};

  /// Convert object to json: String
  String toJson() => '';

  /// Create model object from parsed json
  factory ModelInterface.fromJson(Map<String, dynamic> parsedJson) =>
      ModelInterface();
}
