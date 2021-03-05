import 'package:flutter/material.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/price_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/item_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/price_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';
import 'package:the_dead_masked_company.price_comparator/services/custom_theme.dart';
import 'package:the_dead_masked_company.price_comparator/ui/price.dart';
import 'package:the_dead_masked_company.price_comparator/services/custom_icons_icons.dart';
import 'package:the_dead_masked_company.price_comparator/services/tools.dart';
import 'package:i18n_omatic/i18n_omatic.dart';

/// The Item widget
///
/// Display item (name, price list and minimum price)
class Item extends StatefulWidget {
  final ItemModel item;
  final PriceRepository priceRepository;
  final StoreRepository storeRepository;
  final ItemRepository itemRepository;

  Item(
      {Key key,
      @required this.item,
      this.priceRepository,
      this.storeRepository,
      this.itemRepository})
      : super(key: key);

  @override
  _ItemState createState() => _ItemState();
}

class _ItemState extends State<Item> {
  ItemModel _item;
  List<Widget> _minPriceTextWidget;
  PriceModel _minimumPrice;
  Map<String, dynamic> returnData = <String, dynamic>{};

  @override
  void initState() {
    _item = widget.item;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _buildMinimumPriceText();
    return Scaffold(
      appBar: CustomAppBar(
        title: CustomAppBarTitle(_item.name),
        leading: BackButton(
          onPressed: () => Navigator.pop(context, returnData),
        ),
        actions: <Widget>[
          CustomIconButton(
            icon: Icon(CustomIcons.pencil),
            tooltip: 'Edit'.tr(),
            onPressed: () {
              showEditItemScreen(_item);
            },
          ),
          CustomIconButton(
            icon: Icon(CustomIcons.trash),
            tooltip: 'Remove'.tr(),
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
          ...<Widget>[_buildPriceItemList()]
        ],
      ),
    );
  }

  Widget _buildPriceItemList() {
    return FutureBuilder<List<PriceModel>>(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none ||
            projectSnap.data == null) {
          return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()]);
        }

        projectSnap.data.sort((a, b) {
          if (_checkPriceValue(a)) {
            if (_checkPriceValue(b)) {
              return a.store.name
                  .toLowerCase()
                  .compareTo(b.store.name.toLowerCase());
            } else {
              return 1;
            }
          }
          if (_checkPriceValue(b)) {
            return -1;
          }

          return a.value.compareTo(b.value);
        });

        return Expanded(
            child: ListView.builder(
          itemCount: projectSnap.data.length,
          itemBuilder: (context, index) {
            return _buildPriceItem(projectSnap.data[index]);
          },
        ));
      },
      future: _getPriceList(),
    );
  }

  /// Check if price value is empty
  bool _checkPriceValue(PriceModel price) {
    return price.value == 0 || price.value == null;
  }

  /// Get price list
  ///
  /// For current item, we display one price by store
  Future<List<PriceModel>> _getPriceList() async {
    return await widget.priceRepository
        .getAllByItem(_item)
        .then((_priceList) async {
      await widget.storeRepository.getAll().then((storesList) {
        checkListToGetMinimumPrice(_priceList);

        storesList.forEach((key, store) {
          var found = false;
          for (var priceIndex = 0;
              priceIndex < _priceList.length;
              priceIndex++) {
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

      return _priceList;
    });
  }

  /// Edit [item] with [name]
  Future<bool> _editItem(ItemModel item, String name) async {
    var result = false;

    if (name.isEmpty) {
      Tools.showError(context, 'Fill this field.'.tr());
    } else {
      item.name = name;
      await widget.itemRepository.add(item).then((e) async {
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
          appBar: CustomAppBar(title: CustomAppBarTitle('Edit an item'.tr())),
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
                hintText: 'Enter item name'.tr(),
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
        CustomBasicText('The minimum price is '.tr()),
        RichText(
          textAlign: TextAlign.center,
          text: CustomBasicTextSpan(
            children: <TextSpan>[
              CustomHighlightTextSpan(
                  text: _minimumPrice.value
                          .toStringAsFixed(2)
                          .replaceAll('.', ',') +
                      '€'),
              TextSpan(text: ' in '.tr()),
              CustomHighlightTextSpan(
                text: _minimumPrice != null ? _minimumPrice.store.name : '',
              ),
            ],
          ),
        )
      ];
    } else {
      _minPriceTextWidget = [CustomBasicText('No data'.tr())];
    }
  }

  /// Show dialog to remove current item
  void _showRemoveItemDialog() async {
    var remove = false;

    await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                  'Remove "%name" ?'.tr(<String, String>{'name': _item.name})),
              actions: <Widget>[
                TextButton(
                    child: Text('Cancel'.tr().toUpperCase()),
                    onPressed: () => Navigator.of(context).pop()),
                TextButton(
                    child: Text('Remove'.tr().toUpperCase()),
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

  /// Edit [price]
  Future<bool> _editPrice(PriceModel price) async {
    _minimumPrice = null;

    await widget.priceRepository.getAllByItem(_item).then((_priceList) async {
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
    });

    updateMinimumVariables(price);

    return true;
  }

  /// Check price list to get minimum price to display
  bool checkListToGetMinimumPrice(List<PriceModel> _priceList) {
    var result = false;

    for (var i = 0; i < _priceList.length; i++) {
      if (_priceList[i].value.toString().isNotEmpty) {
        updateMinimumVariables(_priceList[i]);
        result = true;
      }
    }

    return result;
  }

  /// Build a [price] card
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
            tooltip: 'Bio'.tr(),
            onPressed: () {},
          ),
        ));
      }

      if (price.options['isCan'] == true) {
        options.add(Container(
          child: IconButton(
            icon: Icon(CustomIcons.boxes),
            color: Colors.grey,
            tooltip: 'Can'.tr(),
            onPressed: () {},
          ),
        ));
      }

      if (price.options['isFreeze'] == true) {
        options.add(Container(
          child: IconButton(
            icon: Icon(CustomIcons.snowflake),
            color: Colors.blue[200],
            tooltip: 'Freeze'.tr(),
            onPressed: () {},
          ),
        ));
      }

      if (price.options['isWrap'] == true) {
        options.add(Container(
          child: IconButton(
            icon: Icon(CustomIcons.prescription_bottle_alt),
            color: Colors.black,
            tooltip: 'Wrap'.tr(),
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
          builder: (context) => Price(
                price: price,
                priceRepository: widget.priceRepository,
              )),
    );

    if (price != null) {
      await _editPrice(price);
    }
  }
}
