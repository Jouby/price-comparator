import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:the_dead_masked_company.price_comparator/services/data_manager.dart';
import 'package:the_dead_masked_company.price_comparator/ui/item_list.dart';

void main() {
  runApp(
    Phoenix(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _upgradeData(context);

    return MaterialApp(
      title: 'Price Comparator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ItemList(),
    );
  }

  void _upgradeData(BuildContext context) async {
    DataManager.upgradeData().then((reload) {
      print('reload');
      if (reload) Phoenix.rebirth(context);
    });
  }
}
