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
  final UserRepository userRepository;
  final PriceRepository priceRepository;
  final StoreRepository storeRepository;
  final ItemRepository itemRepository;

  SettingsList(
      {Key key,
      this.userRepository,
      this.priceRepository,
      this.storeRepository,
      this.itemRepository})
      : super(key: key);

  @override
  _SettingsListState createState() => _SettingsListState();
}

class _SettingsListState extends State<SettingsList> {
  bool loaderVisible = false;

  @override
  Widget build(BuildContext context) {
    var loader = loaderVisible
        ? Container(
            margin: const EdgeInsets.only(top: 20.0),
            child: CircularProgressIndicator())
        : Container();

    return Scaffold(
        appBar: AppBar(title: Text(Translate.translate('Paramètres'))),
        body: Container(
            margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: Column(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    RaisedButton(
                      onPressed: () async {
                        widget.userRepository.dispose();
                        widget.priceRepository.dispose();
                        widget.itemRepository.dispose();
                        widget.storeRepository.dispose();
                        // Navigator.pop(context);
                        await Navigator.of(context)
                            .pushReplacementNamed(Constants.loginScreen);
                      },
                      child: Text(Translate.translate('LOGOUT'),
                          style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
                loader
              ],
            )));
  }
}
