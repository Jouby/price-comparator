import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:price_compare/translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StoresList extends StatefulWidget {
  @override
  createState() => new StoresListState();
}

class StoresListState extends State<StoresList> {
  List<String> _storesList = [];

  void _addStore(String store) async {
    if (store.length > 0) {
      setState(() => _storesList.add(store));

      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('stores_list', _storesList);
    }
  }

  void initList() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _storesList = prefs.getStringList('stores_list');
      if (_storesList == null) _storesList = [];
    });
  }

  void _removeStore(int index) async {
    var storeName = _storesList[index];
    setState(() => _storesList.removeAt(index));

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('stores_list', _storesList);

    var itemsList = prefs.getStringList('items_list');
    if (itemsList == null) itemsList = [];

    for (var i = 0; i < itemsList.length; i++) {
      var name = itemsList[i];
      var priceItemList = prefs.getStringList('price_list_$name');

      if (priceItemList != null) {
        for (var i = 0; i < priceItemList.length; i++) {
          var decodePriceItem = jsonDecode(priceItemList[i]);
          if (decodePriceItem['store'] == storeName) {
            priceItemList.removeAt(i);
          }
        }
      }

      prefs.setStringList('price_list_$name', priceItemList);
    }
  }

  void _promptRemoveStore(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(Translate.translate(
              'Remove "%1" ?', ['${_storesList[index]}'])),
          actions: <Widget>[
            new FlatButton(
              child: new Text(Translate.translate('CANCEL')),
              onPressed: () => Navigator.of(context).pop()
            ),
            new FlatButton(
              child: new Text(Translate.translate('REMOVE')),
              onPressed: () {
                _removeStore(index);
                Navigator.of(context).pop();
              }
            )
          ]
        );
      }
    );
  }

  Widget _buildStoresList() {
    return new ListView.builder(
      itemBuilder: (context, index) {
        if (index < _storesList.length) {
          return _buildStore(_storesList[index], index);
        }
        return null;
      },
    );
  }

  Widget _buildStore(String name, int index) {
    return Card(
      child: ListTile(
          title: new Text(name), onTap: () => _promptRemoveStore(index)),
    );
  }

  @override
  void initState() {
    initList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(Translate.translate('Stores'))),
      body: _buildStoresList(),
      floatingActionButton: new FloatingActionButton(
        onPressed: _pushAddStoreScreen,
        tooltip: Translate.translate('Add a new store'),
        child: new Icon(Icons.add)
      ),
    );
  }

  void _pushAddStoreScreen() {
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text(Translate.translate('Add a new store'))),
          body: new TextField(
            autofocus: true,
            onSubmitted: (val) {
              _addStore(val);
              Navigator.pop(context);
            },
            decoration: new InputDecoration(
              hintText: Translate.translate('Enter store name'),
              contentPadding: const EdgeInsets.all(16.0)
            ),
          )
        );
      })
    );
  }
}
