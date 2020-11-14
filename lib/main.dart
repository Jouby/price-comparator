import 'dart:io';

import 'package:flutter/material.dart';
import 'package:the_dead_masked_company.price_comparator/services/patch_manager.dart';
import 'package:the_dead_masked_company.price_comparator/ui/item_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Get data from DB
    PatchManager.checkDataVersion();
    // TODO: If data version was !=, send transform data to DB
    return MaterialApp(
      title: 'Price Comparator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ItemList(),
    );
  }
}
