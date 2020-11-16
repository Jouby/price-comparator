import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_dead_masked_company.price_comparator/resources/core_repository.dart';

/// The Data Update repository
///
/// This repository got the following purposes :
/// 1. Handle data management (get data for the data manager)
/// 2. Manage data which couldn't sent to database (cause of unconnect device for example)
class DataUpdateRepository {
  /// Data Queue key index
  static const dataQueueKey = 'data_queue';

  /// Add data to pending queue
  /// 
  /// Pending queue is used to save data locally in case of disconnected device
  static Future<bool> addToDataQueue(data, type) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> newData = prefs.getStringList(DataUpdateRepository.dataQueueKey) ?? [];
    newData.add(jsonEncode({'type': type, 'data': data}));

    return prefs.setStringList(DataUpdateRepository.dataQueueKey, newData);
  }

  /// Remove data from pending queue
  /// 
  /// Pending queue is used to save data locally in case of disconnected device
  static Future<bool> removeFromDataQueue(data, type) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> newData = prefs.getStringList(DataUpdateRepository.dataQueueKey);
    newData.remove(jsonEncode({'type': type, 'data': data}));
    return prefs.setStringList(DataUpdateRepository.dataQueueKey, newData);
  }

  /// Resend data from pending queue to database
  ///
  /// Pending queue is used to save data locally in case of disconnected device
  static Future<void> resendData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> newData = prefs.getStringList(DataUpdateRepository.dataQueueKey);

    if (newData != null && newData.isNotEmpty) {
      newData.forEach((element) {
        var decodeElement = jsonDecode(element);
        CoreRepository.sendDataToDatabase(
          decodeElement['data'],
          type: decodeElement['type'], resend: false
        );
      });
    }
  }
}
