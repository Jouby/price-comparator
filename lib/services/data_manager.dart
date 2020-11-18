import 'package:the_dead_masked_company.price_comparator/resources/core_repository.dart';
import 'package:the_dead_masked_company.price_comparator/services/data_version/data_version_1.dart';
import 'package:the_dead_masked_company.price_comparator/services/data_version/data_version_2.dart';
import 'package:the_dead_masked_company.price_comparator/services/data_version/data_version_interface.dart';
import 'package:yaml/yaml.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The DataManager class
///
/// Used to handle data (version, stored in database and stored in local)
class DataManager {
  static const pubspecFilePath = 'pubspec.yaml';
  static const dataVersionNumber = 'data_version';

  /// Load data from database
  static Future<int> loadData() async {
    Map<dynamic, dynamic> dataFromDB = await CoreRepository.getUserDataFromDatabase();
    int dataVersionNumber = dataFromDB[DataManager.dataVersionNumber] ?? 1;
    DataVersionInterface dataVersionPatch;

    switch (dataVersionNumber) {
      case 1:
        dataVersionPatch = new DataVersion1();
        break;
      case 2:
        dataVersionPatch = new DataVersion2();
        break;
      default:
        dataVersionPatch = null;
    }

    if (dataVersionPatch != null) {
      dataVersionPatch.loadData(dataFromDB);
    }

    return dataVersionNumber;
  }

  /// Send new data version to database
  static void sendData(int currentDataVersion) async {
    DataVersionInterface dataVersionPatch;

    switch (currentDataVersion) {
      case 1:
        dataVersionPatch = new DataVersion1();
        break;
      case 2:
        dataVersionPatch = new DataVersion2();
        break;
      default:
        dataVersionPatch = null;
    }

    if (dataVersionPatch != null) {
      dataVersionPatch.sendData(currentDataVersion);
    }

    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(DataManager.dataVersionNumber, currentDataVersion);
  }

  /// Upgrade data
  ///
  /// 1. Load data from databse
  /// 2. Change data if we have new data_version in application
  /// 3. Update and send data to database
  static Future<bool> upgradeData() async {
    int currentDataVersion = await DataManager.loadData();
    int appDataVersion = await DataManager.getAppDataVersion();
    bool update = false;

    while (currentDataVersion < appDataVersion) {
      switch (currentDataVersion) {
        case 1:
          DataVersion2().upgradeData();
          update = true;
          break;
        default:
          currentDataVersion = appDataVersion;
      }
      currentDataVersion++;
    }

    if (update) {
      DataManager.sendData(currentDataVersion);
      return true;
    }

    return false;
  }

  /// Get Application data version from pubspec.yaml
  static Future<int> getAppDataVersion() async {
    String pubspecContent =
        await rootBundle.loadString(DataManager.pubspecFilePath);
    Map yaml = loadYaml(pubspecContent);

    return yaml[DataManager.dataVersionNumber];
  }
}