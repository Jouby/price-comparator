import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_dead_masked_company.price_comparator/translate.dart';

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
  List<Widget> minPriceTextWidget;
  String minStore = '';

  @override
  void initState() {
    name = widget.name;
    initPriceList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    buildMinPriceText();
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
        children: [
          ...minPriceTextWidget,
          ...<Widget>[Expanded(child: _buildPriceItemsList())]
        ],
      ),
    );
  }

  void buildMinPriceText() {
    if (minPrice != 999999999) {
      minPriceTextWidget = [
        Text(Translate.translate('The minimum price is '),
            style: TextStyle(
                fontFamily: 'Letters-for-Learners',
                color: Colors.black,
                fontSize: 30)),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
                fontFamily: 'Letters-for-Learners',
                color: Colors.black,
                fontSize: 30),
            children: <TextSpan>[
              TextSpan(
                  text: minPrice.toStringAsFixed(2) + '€',
                  style: TextStyle(
                      fontFamily: 'HighVoltage',
                      color: Colors.red[700],
                      fontSize: 40)),
              TextSpan(text: Translate.translate(' in ')),
              TextSpan(
                  text: minStore,
                  style: TextStyle(
                      fontFamily: 'HighVoltage',
                      color: Colors.red[700],
                      fontSize: 40)),
            ],
          ),
        )
      ];
    } else {
      minPriceTextWidget = [
        Text(Translate.translate('No data'),
            style: TextStyle(
                fontFamily: 'Letters-for-Learners',
                color: Colors.black,
                fontSize: 30))
      ];
    }
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

  void resetMinPrice() {
    minPrice = 999999999;
    minStore = '';
  }

  Future<bool> addOrUpdatePriceItem(String store, num price) async {
    var update = false;
    resetMinPrice();

    for (var i = 0; i < _priceList.length; i++) {
      if (_priceList[i]['store'] == store) {
        setState(() {
          _priceList[i]['price'] = price;
        });
        update = true;
      }

      if (_priceList[i]['price'] != '') {
        updateMinPrice(num.parse(_priceList[i]['price'].toString()),
            _priceList[i]['store']);
      }
    }

    if (!update) {
      setState(() {
        _priceList.add({'store': store, 'price': price});
      });
    }
    updateMinPrice(price, store);

    if (store != null && price != null) {
      final prefs = await SharedPreferences.getInstance();
      prefs.setStringList('price_list_$name', jsonEncodePriceList());
    }

    return true;
  }

  void updateMinPrice(num price, String store) {
    setState(() {
      if (minPrice > price) {
        minPrice = price;
        minStore = store;
        buildMinPriceText();
      }
    });
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
        updateMinPrice(num.parse(returnList[i]['price'].toString()),
            returnList[i]['store']);
      }
    }
    return returnList;
  }

  Widget _buildPriceItem(int index) {
    String price;
    String store = _priceList[index]['store'];

    if (_priceList[index]['price'] == '') {
      price = '';
    } else {
      price = _priceList[index]['price'].toStringAsFixed(2) + '€';
    }

    return Card(
      child: ListTile(
          title: new Text(store),
          subtitle: new Text(price),
          onTap: () => _pushAddPriceScreen(store)),
    );
  }

  void _pushAddPriceScreen(String store) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
        appBar:
            new AppBar(title: new Text(Translate.translate('Add a new price'))),
        body: TextField(
          autofocus: true,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: <TextInputFormatter>[
            WhitelistingTextInputFormatter(RegExp(r'^\d+(\.)?\d{0,2}'))
          ],
          decoration: new InputDecoration(
            hintText: Translate.translate('Enter your price'),
            contentPadding: const EdgeInsets.all(16.0),
          ),
          onSubmitted: (val) {
            addOrUpdatePriceItem(store, num.parse(val)).then((result) {
              if (result) {
                Navigator.pop(context);
              } 
            });
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
    _priceList.sort((a, b) {
      if (a['price'] == '') {
        return 1;
      }
      if (b['price'] == '') {
        return -1;
      }
      return a['price'].compareTo(b['price']);
    });
    return new ListView.builder(
      itemCount: _priceList.length,
      itemBuilder: (context, index) {
        return _buildPriceItem(index);
      },
    );
  }
}
