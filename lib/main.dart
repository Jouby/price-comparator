import 'package:flutter/material.dart';
import 'package:the_dead_masked_company.price_comparator/item.dart';
import 'package:the_dead_masked_company.price_comparator/services/custom_icons_icons.dart';
import 'package:the_dead_masked_company.price_comparator/services/repository.dart';
import 'package:the_dead_masked_company.price_comparator/settings.dart';
import 'package:the_dead_masked_company.price_comparator/stores.dart';
import 'package:the_dead_masked_company.price_comparator/tools.dart';
import 'package:the_dead_masked_company.price_comparator/translate.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Price Comparator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ItemsList(),
    );
  }
}

class ItemsList extends StatefulWidget {
  @override
  createState() => new ItemsListState();
}

class ItemsListState extends State<ItemsList> {
  List<String> _displayedItemsList = [];
  TextEditingController editingController = TextEditingController();

  Future<bool> _addItem(String item) async {
    var itemList = await Repository.getItemsList();
    if (item.length > 0 && !itemList.contains(item)) {
      itemList.add(item);
      Repository.setItemsList(itemList);
      filterSearchResults(editingController.text);
      return true;
    }

    return false;
  }

  void initList() async {
    _displayedItemsList = await Repository.getItemsList();
    setState(() {
      if (_displayedItemsList == null) _displayedItemsList = [];
    });
  }

  void _removeItem(String name) async {
    var itemList = await Repository.getItemsList();
    itemList.remove(name);
    Repository.setItemsList(itemList);
    Repository.removePriceListByItem(name);
    filterSearchResults(editingController.text);
  }

  Widget _buildItemsList() {
    _displayedItemsList.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
    return new ListView.builder(
      itemBuilder: (context, index) {
        if (index < _displayedItemsList.length) {
          return _buildItem(_displayedItemsList[index], index);
        }
        return null;
      },
    );
  }

  Widget _buildItem(String name, int index) {
    return Card(
      child: ListTile(
        title: new Text(name),
        onTap: () {
          _pushItemScreen(context, name);
        },
      ),
    );
  }

  void _pushItemScreen(BuildContext context, name) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute<Map<String, dynamic>>(
            builder: (BuildContext _) => Item(name: name)));

    if (result != null && result['name'] != '') {
      _removeItem(result['name']);
    }
  }

  void filterSearchResults(String query) async {
    var itemList = await Repository.getItemsList();
    List<String> dummySearchList = List<String>();
    dummySearchList.addAll(itemList);
    if (query.isNotEmpty) {
      List<String> dummyListData = List<String>();
      dummySearchList.forEach((item) {
        if (item.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _displayedItemsList.clear();
        _displayedItemsList.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _displayedItemsList.clear();
        _displayedItemsList.addAll(itemList);
      });
    }
  }

  @override
  void initState() {
    initList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
          title: Text(Translate.translate('Price Comparator')),
          actions: <Widget>[
            IconButton(
              icon: Icon(CustomIcons.shop),
              color: Colors.white,
              tooltip: Translate.translate('Stores'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => StoresList()));
              },
            ),
            IconButton(
              icon: Icon(CustomIcons.params),
              color: Colors.white,
              tooltip: Translate.translate('Settings'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsList()));
              },
            ),
          ]),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: Translate.translate('Search'),
                    hintText: Translate.translate('Search'),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            Expanded(child: _buildItemsList()),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          onPressed: _pushAddItemScreen,
          tooltip: Translate.translate('Add a new item'),
          child: new Icon(Icons.add)),
    );
  }

  void _pushAddItemScreen() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(
              title: new Text(Translate.translate('Add a new item'))),
          body: new TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            onSubmitted: (val) {
              _addItem(val).then((result) {
                if (result) {
                  Navigator.pop(context);
                  _pushItemScreen(context, val);
                } else {
                  String error;
                  if (val.length == 0) {
                    error = Translate.translate('Fill this field.');
                  } else {
                    error = Translate.translate(
                        'An item with same name already exists.');
                  }
                  Tools.showError(context, error);
                }
              });
            },
            decoration: new InputDecoration(
                hintText: Translate.translate('Enter item name'),
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }
}
