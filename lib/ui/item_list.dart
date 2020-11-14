import 'package:flutter/material.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/data_update_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/item_repository.dart';
import 'package:the_dead_masked_company.price_comparator/ui/item.dart';
import 'package:the_dead_masked_company.price_comparator/services/custom_icons_icons.dart';
import 'package:the_dead_masked_company.price_comparator/ui/settings.dart';
import 'package:the_dead_masked_company.price_comparator/ui/store_list.dart';
import 'package:the_dead_masked_company.price_comparator/services/tools.dart';
import 'package:the_dead_masked_company.price_comparator/services/translate.dart';

/// The Item list widget
/// 
/// Main screen
/// Display item list (sort alphabetically or possible to filter)
class ItemList extends StatefulWidget {
  @override
  createState() => new _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List<ItemModel> _itemList = [];
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    _initializeItemList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text(Translate.translate('Price Comparator')),
      actions: <Widget>[
        IconButton(
          icon: Icon(CustomIcons.shop),
          color: Colors.white,
          tooltip: Translate.translate('Stores'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => StoreList())
            );
          },
        ),
        IconButton(
          icon: Icon(CustomIcons.params),
          color: Colors.white,
          tooltip: Translate.translate('Settings'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsList())
            );
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
                    borderRadius: BorderRadius.all(Radius.circular(25.0))
                  )
                ),
              ),
            ),
            Expanded(
              // child: _buildItemsList(),
              child: new RefreshIndicator(
                child: _buildItemList(),
                onRefresh: DataUpdateRepository.resendNewData
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          onPressed: _showAddItemScreen,
          tooltip: Translate.translate('Add a new item'),
          child: new Icon(Icons.add)),
    );
  }

  /// Add item by [name]
  Future<bool> _addItem(String name) async {
    ItemModel itemModel = ItemModel(name);
    List<ItemModel> itemList = await ItemRepository.getItemsList();

    if (itemModel.name.length > 0 && !itemList.contains(itemModel)) {
      itemList.add(itemModel);
      ItemRepository.setItemsList(itemList);
      filterSearchResults(editingController.text);
      return true;
    }

    return false;
  }

  /// Initialize item list
  void _initializeItemList() async {
    _itemList = await ItemRepository.getItemsList();
    setState(() {
      if (_itemList == null) _itemList = [];
    });
  }

  /// Remove item by [name]
  void _removeItem(String name) async {
    List<ItemModel> itemList = await ItemRepository.getItemsList();
    itemList.remove(name);
    ItemRepository.setItemsList(itemList);
    ItemRepository.removeItem(name);
    filterSearchResults(editingController.text);
  }

  /// Build item list
  Widget _buildItemList() {
    _itemList.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return new ListView.builder(
      itemBuilder: (context, index) {
        if (index < _itemList.length) {
          return _buildItem(_itemList[index]);
        }
        return null;
      },
    );
  }

  /// Build [item] card for item list
  Widget _buildItem(ItemModel item) {
    return Card(
      child: ListTile(
        title: new Text(item.name),
        onTap: () {
          _goToItemScreen(context, item);
        },
      ),
    );
  }

  /// Go to [item] screen (see ui/item.dart)
  /// 
  /// We used current [context] to send current context to new screen
  void _goToItemScreen(BuildContext context, ItemModel item) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute<Map<String, dynamic>>(builder: (BuildContext _) => Item(item: item))
    );

    if (result != null && result['remove'] != '') {
      _removeItem(result['remove']);
    }
  }

  /// Filter _itemList with [query]
  void filterSearchResults(String query) async {
    List<ItemModel> itemList = await ItemRepository.getItemsList();
    List<ItemModel> dummySearchList = List<ItemModel>();
    dummySearchList.addAll(itemList);
    if (query.isNotEmpty) {
      List<ItemModel> dummyListData = List<ItemModel>();
      dummySearchList.forEach((item) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _itemList.clear();
        _itemList.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        _itemList.clear();
        _itemList.addAll(itemList);
      });
    }
  }

  /// Show a screen to add a new item
  void _showAddItemScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
          appBar: AppBar(title: Text(Translate.translate('Add a new item'))),
          body: TextField(
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            onSubmitted: (String name) {
              _addItem(name).then((result) {
                if (result) {
                  Navigator.pop(context);
                  _goToItemScreen(context, new ItemModel(name));
                } else {
                  String error = Translate.translate((name.length == 0) ? 'Fill this field.' : 'An item with same name already exists.');
                  Tools.showError(context, error);
                }
              });
            },
            decoration: InputDecoration(
              hintText: Translate.translate('Enter item name'),
              contentPadding: const EdgeInsets.all(16.0)
            ),
          ));
    }));
  }
}
