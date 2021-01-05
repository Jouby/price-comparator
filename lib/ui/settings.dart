import 'package:flutter/material.dart';
import 'package:the_dead_masked_company.price_comparator/resources/item_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/price_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/user_repository.dart';
import 'package:the_dead_masked_company.price_comparator/services/globals.dart';
import 'package:the_dead_masked_company.price_comparator/services/translate.dart';

/// The Settings list widget
///
/// Display settings list (connection parameters)
class SettingsList extends StatefulWidget {
  @override
  _SettingsListState createState() => _SettingsListState();
}

class _SettingsListState extends State<SettingsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(Translate.translate('Paramètres'))),
        body: Container(
            margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RaisedButton(
                  onPressed: () async {
                    UserRepository.dispose();
                    PriceRepository.dispose();
                    ItemRepository.dispose();
                    StoreRepository.dispose();
                    Navigator.pop(context);
                    await Navigator.of(context)
                        .pushReplacementNamed(Constants.loginScreen);
                  },
                  child: Text(Translate.translate('LOGOUT'),
                      style: TextStyle(fontSize: 20)),
                ),
              ],
            )));
  }
}
