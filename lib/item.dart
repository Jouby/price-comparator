import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:price_compare/translate.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Item extends StatefulWidget {
  final String name;

  Item({Key key, @required this.name}) : super(key: key);

  @override
  createState() => new ItemState();
}

class ItemState extends State<Item> {
  String name;
  List<Map<String, dynamic>> _priceList = [];
  num minPrice = 999999999;
  String minStore = '';

  @override
  void initState() {
    name = widget.name;
    initPriceList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var minPriceText = minPrice != 999999999
        ? Translate.translate(
            'The minimum price is %1€ in %2', ['$minPrice', '$minStore'])
        : Translate.translate('No data');
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('$name'),
        actions: <Widget>[
          FlatButton.icon(
              onPressed: () {
                tryRemoveItem();
              },
              icon: Icon(Icons.highlight_off, color: Colors.white),
              label: new Text(''))
        ],
      ),
      body: Column(
        children: <Widget>[
          Text(minPriceText,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              )),
          Expanded(child: _buildPriceItemsList())
        ],
      ),
    );
  }

  void tryRemoveItem() async {
    var remove = false;
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
              title: new Text(Translate.translate('Remove "%1" ?', [name])),
              actions: <Widget>[
                new FlatButton(
                    child: new Text(Translate.translate('CANCEL')),
                    onPressed: () => Navigator.of(context).pop()),
                new FlatButton(
                    child: new Text(Translate.translate('REMOVE')),
                    onPressed: () {
                      remove = true;
                      Navigator.pop(context);
                    })
              ]);
        });

    if (remove) {
      Navigator.pop(context, {
        'name': name,
      });
    }
  }

  void addOrUpdatePriceItem(String store, num price) async {
    var update = false;
    for (var i = 0; i < _priceList.length; i++) {
      if (_priceList[i]['store'] == store) {
        setState(() {
          _priceList[i]['price'] = price;
          updateMinPrice(price, store);
        });
        update = true;
      }
    }
    if (!update) {
      setState(() {
        _priceList.add({'store': store, 'price': price});
        updateMinPrice(price, store);
      });
    }

    if (store != null && price != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('price_list_$name', jsonEncodePriceList());
    }
  }

  void updateMinPrice(num price, String store) {
    if (minPrice > price) {
      minPrice = price;
      minStore = store;
    }
  }

  List<String> jsonEncodePriceList() {
    List<String> list = [];
    for (var i = 0; i < _priceList.length; i++) {
      list.add(jsonEncode(_priceList[i]));
    }
    return list;
  }

  List<Map<String, dynamic>> jsonDecodePriceList(List list) {
    List<Map<String, dynamic>> returnList = [];
    for (var i = 0; i < list.length; i++) {
      returnList.add(jsonDecode(list[i]));
      if (returnList[i]['price'].toString().length > 0) {
        updateMinPrice(num.parse(returnList[i]['price'].toString()), returnList[i]['store']);
      }
    }
    return returnList;
  }

  Widget _buildPriceItem(int index) {
    var store = _priceList[index]['store'];
    var price = _priceList[index]['price'];
    return Card(
      child: ListTile(
          title: new Text("$store"),
          subtitle: new Text("$price€"),
          onTap: () => _pushAddPriceScreen(store)),
    );
  }

  void _pushAddPriceScreen(String store) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
        appBar:
            new AppBar(title: new Text(Translate.translate('Add a new price'))),
        body: new TextField(
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter(RegExp(r'^\d+.?\d{0,2}'))
          ],
          decoration: new InputDecoration(
            hintText: Translate.translate('Enter your price'),
            contentPadding: const EdgeInsets.all(16.0),
          ),
          onSubmitted: (val) {
            addOrUpdatePriceItem(store, num.parse(val));
            //_addPriceItem(store, num.parse(val));
            Navigator.pop(context);
          },
        ),
      );
    }));
  }

  void initPriceList() async {
    final prefs = await SharedPreferences.getInstance();
    var priceItemList = prefs.getStringList('price_list_$name');
    setState(() {
      if (priceItemList != null) {
        _priceList = jsonDecodePriceList(priceItemList);
      }

      var storesList = prefs.getStringList('stores_list');
      for (var storeIndex = 0; storeIndex < storesList.length; storeIndex++) {
        var found = false;
        for (var priceIndex = 0; priceIndex < _priceList.length; priceIndex++) {
          if (_priceList[priceIndex]['store'] == storesList[storeIndex]) {
            found = true;
            break;
          }
        }
        if (!found) {
          _priceList.add({'store': storesList[storeIndex], 'price': ''});
        }
      }

      if (_priceList == null) _priceList = [];
    });
  }

  Widget _buildPriceItemsList() {
    return new ListView.builder(
      itemCount: _priceList.length,
      itemBuilder: (context, index) {
        return _buildPriceItem(index);
      },
    );
  }
}
