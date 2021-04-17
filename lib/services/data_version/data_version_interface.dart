/// Data Version interface
///
/// For more details, see DataManager
class DataVersionInterface {
  Future<void> loadData(Map<dynamic, dynamic> dataFromDB) async {}

  Future<void> upgradeData() async {}

  Future<void> sendData(int? currentDataVersion) async {}
}
