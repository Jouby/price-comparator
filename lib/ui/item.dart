import 'package:flutter/material.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/price_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/item_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/price_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';
import 'package:the_dead_masked_company.price_comparator/ui/price.dart';
import 'package:the_dead_masked_company.price_comparator/services/custom_icons_icons.dart';
import 'package:the_dead_masked_company.price_comparator/services/tools.dart';
import 'package:the_dead_masked_company.price_comparator/services/translate.dart';

/// The Item widget
///
/// Display item (name, price list and minimum price)
class Item extends StatefulWidget {
  final ItemModel item;

  Item({Key key, @required this.item}) : super(key: key);

  @override
  createState() => new _ItemState();
}

class _ItemState extends State<Item> {
  ItemModel _item;
  List<PriceModel> _priceList = [];
  List<Widget> _minPriceTextWidget;
  PriceModel _minimumPrice;

  @override
  void initState() {
    _item = widget.item;
    _initializePriceList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _buildMinimumPriceText();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(_item.name),
        actions: <Widget>[
          IconButton(
            icon: Icon(CustomIcons.pencil),
            color: Colors.white,
            tooltip: Translate.translate('Edit'),
            onPressed: () {
              showEditItemScreen(_item);
            },
          ),
          IconButton(
            icon: Icon(CustomIcons.trash),
            color: Colors.white,
            tooltip: Translate.translate('Remove'),
            onPressed: () {
              _showRemoveItemDialog();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          ..._minPriceTextWidget,
          SizedBox(height: 10),
          ...<Widget>[Expanded(child: _buildPriceItemList())]
        ],
      ),
    );
  }

  /// Initialize price list
  ///
  /// For current item, we display one price by store
  Future<void> _initializePriceList() async {
    _priceList = await PriceRepository.getPriceListByItem(_item);
    List<StoreModel> storesList = await StoreRepository.getStoresList();

    setState(() {
      checkListToGetMinimumPrice();

      if (storesList != null) {
        for (int storeIndex = 0; storeIndex < storesList.length; storeIndex++) {
          bool found = false;
          for (int priceIndex = 0;
              priceIndex < _priceList.length;
              priceIndex++) {
            if (_priceList[priceIndex].store.name ==
                storesList[storeIndex].name) {
              found = true;
              break;
            }
          }
          if (!found) {
            _priceList.add(PriceModel(_item, storesList[storeIndex]));
          }
        }
      }

      if (_priceList == null) _priceList = [];
    });
  }

  /// Edit [item] with [name]
  Future<bool> _editItem(ItemModel item, String name) async {
    List<ItemModel> itemList = await ItemRepository.getItemList();

    if (name.length > 0 && !itemList.contains(name)) {
      // TODO test this!! (instead of remove and add)
      item.name = name;
      // itemList.remove(item);
      // item = ItemModel(name);
      // itemList.add(item);
      PriceRepository.setPriceListByItem(item);
      ItemRepository.setItemList(itemList);
      return true;
    }

    return false;
  }

  /// Show screen to edit [item]
  void showEditItemScreen(ItemModel item) {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: AppBar(title: new Text(Translate.translate('Edit an item'))),
          body: TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            onSubmitted: (newVal) {
              _editItem(item, newVal).then((result) {
                if (result) {
                  Navigator.pop(context);
                } else {
                  String error;
                  if (newVal.length == 0) {
                    error = Translate.translate('Fill this field.');
                  } else {
                    error = Translate.translate(
                        'An item with same name already exists.');
                  }
                  Tools.showError(context, error);
                }
              });
            },
            decoration: InputDecoration(
                hintText: Translate.translate('Enter item name'),
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    })).then((value) {
      setState(() {});
    });
  }

  /// Build text used to display minimum price and in which store is it
  void _buildMinimumPriceText() {
    if (_minimumPrice != null) {
      _minPriceTextWidget = [
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
                  text: _minimumPrice.value
                          .toStringAsFixed(2)
                          .replaceAll('.', ',') +
                      '€',
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.red[700],
                      fontSize: 30)),
              TextSpan(text: Translate.translate(' in ')),
              TextSpan(
                  text: _minimumPrice != null ? _minimumPrice.store.name : '',
                  style: TextStyle(
                      fontFamily: 'Nunito',
                      color: Colors.red[700],
                      fontSize: 30)),
            ],
          ),
        )
      ];
    } else {
      _minPriceTextWidget = [
        Text(Translate.translate('No data'),
            style: TextStyle(
                fontFamily: 'Nunito', color: Colors.black, fontSize: 25))
      ];
    }
  }

  /// Show dialog to remove current item
  void _showRemoveItemDialog() async {
    bool remove = false;

    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(Translate.translate('Remove "%1" ?', [_item.name])),
              actions: <Widget>[
                FlatButton(
                    child: Text(Translate.translate('CANCEL')),
                    onPressed: () => Navigator.of(context).pop()),
                FlatButton(
                    child: Text(Translate.translate('REMOVE')),
                    onPressed: () {
                      remove = true;
                      Navigator.pop(context);
                    })
              ]);
        });

    if (remove) {
      Navigator.pop(context, {
        'remove': _item,
      });
    }
  }

  /// Update variables used to display minimum [price]
  void updateMinimumVariables(PriceModel price) {
    if (price.value > 0 &&
        (_minimumPrice == null || _minimumPrice.value > price.value)) {
      setState(() {
        _minimumPrice = price;
        _buildMinimumPriceText();
      });
    }
  }

  /// Reset variables used to display minimum price and store
  void resetMinimumVariables() {
    _minimumPrice = null;
  }

  /// Edit [price]
  Future<bool> _editPrice(PriceModel price) async {
    bool update = false;
    resetMinimumVariables();

    for (int i = 0; i < _priceList.length; i++) {
      if (_priceList[i].store == price.store) {
        setState(() {
          _priceList[i] = price;
        });
        update = true;
      }

      if (_priceList[i].value != 0) {
        updateMinimumVariables(_priceList[i]);
      }
    }

    if (!update) {
      setState(() {
        _priceList.add(price);
      });
    }
    updateMinimumVariables(price);

    if (price != null) {
      PriceRepository.setPriceListByItem(_item);
    }

    return true;
  }

  /// Check price list to get minimum price to display
  bool checkListToGetMinimumPrice() {
    bool result = false;

    for (int i = 0; i < _priceList.length; i++) {
      if (_priceList[i].value.toString().length > 0) {
        updateMinimumVariables(_priceList[i]);
        result = true;
      }
    }

    return result;
  }

  /// Build a [price] card for _priceList
  Widget _buildPriceItem(PriceModel price) {
    String text = '';
    List<Widget> options = [];

    if (price.options['isUnavailable'] != true) {
      if (price.value != 0) {
        text = price.value.toStringAsFixed(2) + '€';
      }

      if (price.options['isBio'] == true) {
        options.add(Container(
          child: IconButton(
            icon: Icon(CustomIcons.leaf),
            color: Colors.green,
            tooltip: Translate.translate('Bio'),
            onPressed: () {},
          ),
        ));
      }

      if (price.options['isCan'] == true) {
        options.add(Container(
          child: IconButton(
            icon: Icon(CustomIcons.boxes),
            color: Colors.grey,
            tooltip: Translate.translate('Can'),
            onPressed: () {},
          ),
        ));
      }

      if (price.options['isFreeze'] == true) {
        options.add(Container(
          child: IconButton(
            icon: Icon(CustomIcons.snowflake),
            color: Colors.blue[200],
            tooltip: Translate.translate('Freeze'),
            onPressed: () {},
          ),
        ));
      }

      if (price.options['isWrap'] == true) {
        options.add(Container(
          child: IconButton(
            icon: Icon(CustomIcons.prescription_bottle_alt),
            color: Colors.black,
            tooltip: Translate.translate('Wrap'),
            onPressed: () {},
          ),
        ));
      }
    }

    return Card(
        child: Ink(
      color: (price.options['isUnavailable'] == true)
          ? Colors.grey[200]
          : Colors.transparent,
      child: ListTile(
        title: Text(price.store.name,
            style: TextStyle(
                color: (price.options['isUnavailable'] == true)
                    ? Colors.grey
                    : Colors.black)),
        subtitle: new Text(text),
        onTap: () => _showAddPriceScreen(price),
        trailing:
            Row(mainAxisSize: MainAxisSize.min, children: <Widget>[...options]),
      ),
    ));
  }

  /// Show screen to add a new [price]
  void _showAddPriceScreen(PriceModel price) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Price(price: price)),
    );

    if (result['price'] != null) {
      _editPrice(result['price']);
    }
  }

  /// Build _priceList used to display price list
  Widget _buildPriceItemList() {
    _priceList.sort((a, b) {
      if (a.value == 0 || a.value == null) {
        return 1;
      }
      if (b.value == 0 || b.value == null) {
        return -1;
      }
      return a.value.compareTo(b.value);
    });

    return new ListView.builder(
      itemCount: _priceList.length,
      itemBuilder: (context, index) {
        return _buildPriceItem(_priceList[index]);
      },
    );
  }
}