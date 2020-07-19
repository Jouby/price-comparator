import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:the_dead_masked_company.price_comparator/services/repository.dart';
import 'package:the_dead_masked_company.price_comparator/tools.dart';
import 'package:the_dead_masked_company.price_comparator/translate.dart';

class StoresList extends StatefulWidget {
  @override
  createState() => new StoresListState();
}

class StoresListState extends State<StoresList> {
  List<String> _storesList = [];

  Future<bool> _addStore(String store) async {
    if (store.length > 0 && !_storesList.contains(store)) {
      setState(() => _storesList.add(store));
      Repository.setStoresList(_storesList);
      return true;
    }

    return false;
  }

  void initList() async {
    _storesList = await Repository.getStoresList();
    setState(() {
      if (_storesList == null) _storesList = [];
    });
  }

  void _removeStore(int index) async {
    var storeName = _storesList[index];
    setState(() => _storesList.removeAt(index));
    Repository.setStoresList(_storesList);

    var itemsList = await Repository.getItemsList();
    if (itemsList == null) itemsList = [];

    for (var i = 0; i < itemsList.length; i++) {
      var name = itemsList[i];
      var priceItemList = await Repository.getPriceListByItem(name);

      if (priceItemList != null) {
        for (var i = 0; i < priceItemList.length; i++) {
          var decodePriceItem = jsonDecode(priceItemList[i]);
          if (decodePriceItem['store'] == storeName) {
            priceItemList.removeAt(i);
          }
        }
      }

      Repository.setPriceListByItem(name, priceItemList);
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
                    onPressed: () => Navigator.of(context).pop()),
                new FlatButton(
                    child: new Text(Translate.translate('REMOVE')),
                    onPressed: () {
                      _removeStore(index);
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }

  Widget _buildStoresList() {
    _storesList.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
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
          child: new Icon(Icons.add)),
    );
  }

  void _pushAddStoreScreen() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(
              title: new Text(Translate.translate('Add a new store'))),
          body: TextField(
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            maxLength: 25,
            onSubmitted: (val) {
              _addStore(val).then((result) {
                if (result) {
                  Navigator.pop(context);
                } else {
                  String error;
                  if (val.length == 0) {
                    error = Translate.translate('Fill this field.');
                  } else {
                    error = Translate.translate(
                        'A store with same name already exists.');
                  }
                  Tools.showError(context, error);
                }
              });
            },
            decoration: new InputDecoration(
                hintText: Translate.translate('Enter store name'),
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }
}
