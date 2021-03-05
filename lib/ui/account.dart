import 'package:flutter/material.dart';
import 'package:the_dead_masked_company.price_comparator/resources/item_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/price_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/user_repository.dart';
import 'package:the_dead_masked_company.price_comparator/services/custom_theme.dart';
import 'package:the_dead_masked_company.price_comparator/services/globals.dart';
import 'package:i18n_omatic/i18n_omatic.dart';

/// The Settings list widget
///
/// Display settings list (connection parameters)
class Account extends StatefulWidget {
  final UserRepository userRepository;
  final PriceRepository priceRepository;
  final StoreRepository storeRepository;
  final ItemRepository itemRepository;

  Account(
      {Key key,
      this.userRepository,
      this.priceRepository,
      this.storeRepository,
      this.itemRepository})
      : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String username = '';

  @override
  void initState() {
    widget.userRepository
        .getUserName()
        .then((val) => setState(() => username = val));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(title: CustomAppBarTitle('My account'.tr())),
        body: Container(
            margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                CustomBasicText(
                    'Email : %email'.tr(<String, String>{'email': username})),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomButton(
                      onPressed: () async {
                        disposeAll();
                        await Navigator.of(context).pushNamedAndRemoveUntil(
                            Constants.loginScreen,
                            (Route<dynamic> route) => false);
                      },
                      child: Text('Logout'.tr().toUpperCase(),
                          style: TextStyle(fontSize: 20)),
                    ),
                  ],
                ),
              ],
            )));
  }

  void disposeAll() {
    widget.userRepository.dispose();
    widget.priceRepository.dispose();
    widget.itemRepository.dispose();
    widget.storeRepository.dispose();
  }
}
