/// Data Version interface
/// 
/// For more details, see DataManager
class DataVersionInterface {
  void loadData(Map<dynamic, dynamic> dataFromDB) async {}

  void upgradeData() async {}

  void sendData(int currentDataVersion) async {}
}
