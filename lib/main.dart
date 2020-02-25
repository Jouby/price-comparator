import 'package:flutter/material.dart';
import 'package:the_dead_masked_company.price_comparator/item.dart';
import 'package:the_dead_masked_company.price_comparator/stores.dart';
import 'package:the_dead_masked_company.price_comparator/tools.dart';
import 'package:the_dead_masked_company.price_comparator/translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  List<String> _itemsList = [];

  Future<bool> _addTodoItem(String item) async {
    if (item.length > 0 && !_itemsList.contains(item)) {
      setState(() => _itemsList.add(item));

      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('items_list', _itemsList);

      return true;
    }

    return false;
  }

  void initList() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _itemsList = prefs.getStringList('items_list');
      if (_itemsList == null) _itemsList = [];
    });
  }

  void _removeItem(String name) async {
    setState(() => _itemsList.remove(name));

    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('items_list', _itemsList);
    prefs.remove('price_list_$name');
  }

  Widget _buildItemsList() {
    _itemsList.sort((a, b) {
      return a.toLowerCase().compareTo(b.toLowerCase());
    });
    return new ListView.builder(
      itemBuilder: (context, index) {
        if (index < _itemsList.length) {
          return _buildItem(_itemsList[index], index);
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
            FlatButton.icon(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => StoresList()));
                },
                icon: Icon(Icons.store, color: Colors.white),
                label: new Text(''))
          ]),
      body: _buildItemsList(),
      floatingActionButton: new FloatingActionButton(
          onPressed: _pushAddTodoScreen,
          tooltip: Translate.translate('Add a new item'),
          child: new Icon(Icons.add)),
    );
  }

  void _pushAddTodoScreen() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(
              title: new Text(Translate.translate('Add a new item'))),
          body: new TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            onSubmitted: (val) {
              _addTodoItem(val).then((result) {
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
