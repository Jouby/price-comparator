import 'package:flutter/material.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/price_model.dart';
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
  final PriceRepository priceRepository;
  final StoreRepository storeRepository;

  Item(
      {Key key,
      @required this.item,
      this.priceRepository,
      this.storeRepository})
      : super(key: key);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  ItemModel _item;
  List<PriceModel> _priceList = [];
  List<Widget> _minPriceTextWidget;
  PriceModel _minimumPrice;
  Map<String, dynamic> returnData = <String, dynamic>{};

  @override
  void initState() {
    _item = widget.item;
    _initializePriceList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _buildMinimumPriceText();
    return Scaffold(
      appBar: AppBar(
        title: Text(_item.name),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context, returnData),
        ),
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
    _priceList = await widget.priceRepository.getAllByItem(_item) ?? [];
    var storesList = await widget.storeRepository.getAll() ?? {};

    setState(() {
      checkListToGetMinimumPrice();

      storesList.forEach((key, store) {
        var found = false;
        for (var priceIndex = 0; priceIndex < _priceList.length; priceIndex++) {
          if (_priceList[priceIndex].store.id == store.id) {
            found = true;
            break;
          }
        }

        if (!found) {
          _priceList.add(PriceModel(_item, store));
        }
      });
    });
  }

  /// Edit [item] with [name]
  Future<bool> _editItem(ItemModel item, String name) async {
    var result = false;

    if (name.isEmpty) {
      Tools.showError(context, Translate.translate('Fill this field.'));
    } else {
      item.name = name;
      await ItemRepository().add(item).then((e) async {
        if (e['success'] == true) {
          setState(() {});
          result = true;
        } else {
          Tools.showError(context, e['error'].toString());
        }
      });
    }

    return result;
  }

  /// Show screen to edit [item]
  void showEditItemScreen(ItemModel item) {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      return Scaffold(
          appBar: AppBar(title: Text(Translate.translate('Edit an item'))),
          body: TextField(
            autofocus: true,
            controller: TextEditingController(text: item.name),
            textCapitalization: TextCapitalization.sentences,
            onSubmitted: (newVal) {
              _editItem(item, newVal).then((result) {
                if (result) {
                  Navigator.pop(context);
                  returnData['update'] = true;
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
    var remove = false;

    await showDialog<void>(
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
      returnData['remove'] = _item;
      Navigator.pop(context, returnData);
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
    resetMinimumVariables();

    for (var i = 0; i < _priceList.length; i++) {
      if (_priceList[i].store == price.store) {
        setState(() {
          _priceList[i] = price;
        });
      }

      if (_priceList[i].value != 0) {
        updateMinimumVariables(_priceList[i]);
      }
    }

    updateMinimumVariables(price);

    return true;
  }

  /// Check price list to get minimum price to display
  bool checkListToGetMinimumPrice() {
    var result = false;

    for (var i = 0; i < _priceList.length; i++) {
      if (_priceList[i].value.toString().isNotEmpty) {
        updateMinimumVariables(_priceList[i]);
        result = true;
      }
    }

    return result;
  }

  /// Build a [price] card for _priceList
  Widget _buildPriceItem(PriceModel price) {
    var text = '';
    var options = <Widget>[];

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
        subtitle: Text(text),
        onTap: () => _showAddPriceScreen(price),
        trailing:
            Row(mainAxisSize: MainAxisSize.min, children: <Widget>[...options]),
      ),
    ));
  }

  /// Show screen to add a new [price]
  void _showAddPriceScreen(PriceModel price) async {
    await Navigator.push(
      context,
      MaterialPageRoute<Map<String, dynamic>>(
          builder: (context) => Price(price: price)),
    );

    if (price != null) {
      await _editPrice(price);
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

    return ListView.builder(
      itemCount: _priceList.length,
      itemBuilder: (context, index) {
        return _buildPriceItem(_priceList[index]);
      },
    );
  }
}
