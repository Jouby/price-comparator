import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_dead_masked_company.price_comparator/resources/abstract_repository.dart';

class DataUpdateRepository extends AbstractRepository 
{
  static Future<bool> addNewData(data, type) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> newData = prefs.getStringList('new_data') ?? [];
    newData.add(jsonEncode({'type': type, 'data': data}));

    return prefs.setStringList('new_data', newData);
  }

  static Future<bool> removeNewData(data, type) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> newData = prefs.getStringList('new_data');
    newData.remove(jsonEncode({'type': type, 'data': data}));
    return prefs.setStringList('new_data', newData);
  }

  static Future<void> resendNewData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> newData = prefs.getStringList('new_data');

    if (newData != null && newData.isNotEmpty) {
      newData.forEach((element) {
        var decodeElement = jsonDecode(element);
        AbstractRepository.sendDataToDatabase(
          decodeElement['data'],
          type: decodeElement['type'],
          resend: false
        );
      });
    }
  }
}
