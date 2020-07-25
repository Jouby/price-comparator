import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:the_dead_masked_company.price_comparator/price.dart';
import 'package:the_dead_masked_company.price_comparator/services/custom_icons_icons.dart';
import 'package:the_dead_masked_company.price_comparator/services/repository.dart';
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
          IconButton(
            icon: Icon(CustomIcons.trash),
            color: Colors.white,
            tooltip: Translate.translate('Remove'),
            onPressed: () {
              tryRemoveItem();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          ...minPriceTextWidget,
          SizedBox(height: 10),
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
                fontFamily: 'Nunito', color: Colors.black, fontSize: 25)),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: TextStyle(
                fontFamily: 'Nunito', color: Colors.black, fontSize: 25),
            children: <TextSpan>[
              TextSpan(
                  text: minPrice.toStringAsFixed(2).replaceAll('.', ',') + '€',
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.red[700],
                      fontSize: 30)),
              TextSpan(text: Translate.translate(' in ')),
              TextSpan(
                  text: minStore,
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.red[700],
                      fontSize: 30)),
            ],
          ),
        )
      ];
    } else {
      minPriceTextWidget = [
        Text(Translate.translate('No data'),
            style: TextStyle(
                fontFamily: 'Nunito', color: Colors.black, fontSize: 25))
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

  Future<bool> addOrUpdatePriceItem(
      String store, Map<String, Object> data) async {
    var update = false;
    var price = (data['price'] != '' && data['isUnavailable'] != true)
        ? num.parse(data['price'])
        : '';
    resetMinPrice();

    for (var i = 0; i < _priceList.length; i++) {
      print(_priceList[i]);
      if (_priceList[i]['store'] == store) {
        setState(() {
          _priceList[i]['price'] = price;
          _priceList[i]['isBio'] = data['isBio'];
          _priceList[i]['isCan'] = data['isCan'];
          _priceList[i]['isFreeze'] = data['isFreeze'];
          _priceList[i]['isUnavailable'] = data['isUnavailable'];
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
        _priceList.add({
          'store': store,
          'price': price,
          'isBio': data['isBio'],
          'isCan': data['isCan'],
          'isFreeze': data['isFreeze'],
          'isUnavailable': data['isUnavailable']
        });
      });
    }
    updateMinPrice(price, store);

    if (store != null && price != null) {
      Repository.setPriceListByItem(name, jsonEncodePriceList());
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
    String price = '';
    String store = _priceList[index]['store'];
    List<Widget> options = [];

    if (_priceList[index]['isUnavailable'] != true) {
      if (_priceList[index]['price'] != '') {
        price = _priceList[index]['price'].toStringAsFixed(2) + '€';
      }

      if (_priceList[index]['isBio'] == true) {
        options.add(Container(
            child: Tooltip(
                message: Translate.translate('Bio'),
                child: Text(
                  'BIO',
                  style: TextStyle(
                      color: Colors.green, fontWeight: FontWeight.bold),
                ))));
      }

      if (_priceList[index]['isCan'] == true) {
        options.add(Container(
          child: IconButton(
            icon: Icon(CustomIcons.cup),
            color: Colors.grey[800],
            tooltip: Translate.translate('Can'),
            onPressed: () {},
          ),
        ));
      }

      if (_priceList[index]['isFreeze'] == true) {
        options.add(Container(
          child: IconButton(
            icon: Icon(Icons.ac_unit),
            color: Colors.blue[200],
            tooltip: Translate.translate('Freeze'),
            onPressed: () {},
          ),
        ));
      }
    }

    return Card(
        child: Ink(
      color: (_priceList[index]['isUnavailable'] == true)
          ? Colors.grey
          : Colors.transparent,
      child: ListTile(
          title:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text(store),
            Row(
              children: <Widget>[...options],
            )
          ]),
          subtitle: new Text(price),
          onTap: () => _pushAddPriceScreen(_priceList[index])),
    ));
  }

  void _pushAddPriceScreen(Map<String, Object> data) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Price(data: data)),
    );

    if (result != null) {
      addOrUpdatePriceItem(data['store'], result);
    }
  }

  void initPriceList() async {
    var priceItemList = await Repository.getPriceListByItem(name);
    var storesList = await Repository.getStoresList();

    setState(() {
      if (priceItemList != null) {
        _priceList = jsonDecodePriceList(priceItemList);
      }

      if (storesList != null) {
        for (var storeIndex = 0; storeIndex < storesList.length; storeIndex++) {
          var found = false;
          for (var priceIndex = 0;
              priceIndex < _priceList.length;
              priceIndex++) {
            if (_priceList[priceIndex]['store'] == storesList[storeIndex]) {
              found = true;
              break;
            }
          }
          if (!found) {
            _priceList.add({'store': storesList[storeIndex], 'price': ''});
          }
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
