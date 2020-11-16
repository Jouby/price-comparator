import 'package:the_dead_masked_company.price_comparator/services/data_version/data_version_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_dead_masked_company.price_comparator/resources/item_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';

/// The Data Version 1
/// 
/// For more details, see DataManager
class DataVersion1 implements DataVersionInterface {
  @override
  void loadData(Map<dynamic, dynamic> dataFromDB) async {
    final prefs = await SharedPreferences.getInstance();

    var itemsList = List<String>.from(dataFromDB[ItemRepository.key]);
    prefs.setStringList(StoreRepository.key,
        List<String>.from(dataFromDB[StoreRepository.key]));
    prefs.setStringList(ItemRepository.key, itemsList);

    for (var itemName in itemsList) {
      if (dataFromDB['price_list_$itemName'] != null) {
        prefs.setStringList('price_list_$itemName',
            List<String>.from(dataFromDB['price_list_$itemName']));
      }
    }
  }

  @override
  void upgradeData() async {}

  @override
  void sendData(int currentDataVersion) async {}
}
