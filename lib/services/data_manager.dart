import 'package:the_dead_masked_company.price_comparator/resources/user_repository.dart';
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

  UserRepository userRepository;

  static final DataManager _singleton = DataManager._internal();

  factory DataManager({UserRepository userRepository}) {
    _singleton.userRepository = userRepository;

    return _singleton;
  }

  DataManager._internal();

  /// Upgrade data
  ///
  /// 1. Load data from databse
  /// 2. Change data if we have new data_version in application
  /// 3. Update and send data to database
  Future<void> upgradeData() async {
    await _loadData().then((currentDataVersion) {
      _getAppDataVersion().then((appDataVersion) async {
        var update = false;

        // TODO : Apply Data Update
        // If data to send
        // apply data to local storage
        // update = true

        while (currentDataVersion < appDataVersion) {
          switch (currentDataVersion) {
            case 1:
              await DataVersion2().upgradeData();
              update = true;
              break;
            default:
              currentDataVersion = appDataVersion;
          }
          currentDataVersion++;
        }

        if (update) {
          await _sendData(currentDataVersion);
        }
      });
    });
  }

  /// Load data from database
  Future<int> _loadData() async {
    var dataFromDB = await userRepository.getUserDataFromDatabase();
    var dataVersionNumber =
        dataFromDB[DataManager.dataVersionNumber] as int ?? 1;
    DataVersionInterface dataVersionPatch;

    switch (dataVersionNumber) {
      case 1:
        dataVersionPatch = DataVersion1();
        break;
      case 2:
        dataVersionPatch = DataVersion2();
        break;
      default:
        dataVersionPatch = null;
    }

    if (dataVersionPatch != null) {
      await dataVersionPatch.loadData(dataFromDB);
    }

    return dataVersionNumber;
  }

  /// Send new data version to database
  Future<void> _sendData(int currentDataVersion) async {
    DataVersionInterface dataVersionPatch;

    switch (currentDataVersion) {
      case 1:
        dataVersionPatch = DataVersion1();
        break;
      case 2:
        dataVersionPatch = DataVersion2();
        break;
      default:
        dataVersionPatch = null;
    }

    if (dataVersionPatch != null) {
      await dataVersionPatch.sendData(currentDataVersion);
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(DataManager.dataVersionNumber, currentDataVersion);
  }

  /// Get Application data version from pubspec.yaml
  Future<int> _getAppDataVersion() async {
    var pubspecContent =
        await rootBundle.loadString(DataManager.pubspecFilePath);
    var yaml = loadYaml(pubspecContent) as Map;

    return yaml[DataManager.dataVersionNumber] as int;
  }
}
