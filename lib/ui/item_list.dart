import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
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
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List<ItemModel> _itemList = [];
  List<ItemModel> _displayedItemList = [];
  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    _initializeItemList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(Translate.translate('Price Comparator')),
          actions: <Widget>[
            IconButton(
              icon: Icon(CustomIcons.shop),
              color: Colors.white,
              tooltip: Translate.translate('Stores'),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute<void>(builder: (context) => StoreList()));
              },
            ),
            IconButton(
              icon: Icon(CustomIcons.params),
              color: Colors.white,
              tooltip: Translate.translate('Settings'),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                        builder: (context) => SettingsList()));
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
            Expanded(
              child: _buildItemList(),
              // child: RefreshIndicator(
              //     child: _buildItemList(),
              //     onRefresh: DataUpdateRepository.resendData),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _showAddItemScreen,
          tooltip: Translate.translate('Add a new item'),
          child: Icon(Icons.add)),
    );
  }

  /// Add item by [name]
  Future<bool> _addItem(ItemModel item) async {
    var itemList = await ItemRepository.getAll();

    if (item.name.isNotEmpty && !itemList.containsKey(item.id)) {
      await ItemRepository.add(item);
      _itemList.add(item);
      _displayedItemList.add(item);
      filterSearchResults(editingController.text);
      return true;
    }

    return false;
  }

  /// Initialize item list
  void _initializeItemList() async {
    await ItemRepository.getAll().then((list) {
      setState(() {
        _itemList = list.entries.map((e) => e.value).toList();
        _displayedItemList = List.from(_itemList);
      });
    });

    _itemList ??= [];
    _displayedItemList ??= [];
  }

  /// Remove [item] from item list
  void _removeItem(ItemModel item) async {
    _itemList.remove(item);
    await ItemRepository.remove(item);
    filterSearchResults(editingController.text);
  }

  /// Build item list
  Widget _buildItemList() {
    _displayedItemList.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index < _displayedItemList.length) {
          return _buildItem(_displayedItemList[index]);
        }
        return null;
      },
    );
  }

  /// Build [item] card for item list
  Widget _buildItem(ItemModel item) {
    return Card(
      child: ListTile(
        title: Text(item.name),
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
        PageTransition<Map<String, dynamic>>(
            type: PageTransitionType.rightToLeft, child: Item(item: item)));

    if (result != null) {
      if (result['remove'] != null) {
        _removeItem(result['remove'] as ItemModel);
      }

      if (result['update'] as bool == true) {
        setState(() {});
      }
    }
  }

  /// Filter _itemList with [query]
  void filterSearchResults(String query) async {
    var dummySearchList = <ItemModel>[];

    _displayedItemList.clear();
    if (query.isNotEmpty) {
      dummySearchList.addAll(_itemList);
      var dummyListData = <ItemModel>[];
      dummySearchList.forEach((item) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        _displayedItemList.addAll(dummyListData);
      });
      return;
    }

    setState(() {
      _displayedItemList.addAll(_itemList);
    });
  }

  /// Show a screen to add a new item
  void _showAddItemScreen() {
    Navigator.of(context).push(PageTransition<Map<String, dynamic>>(
        type: PageTransitionType.bottomToTop,
        child: Scaffold(
            appBar: AppBar(title: Text(Translate.translate('Add a new item'))),
            body: TextField(
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              onSubmitted: (String name) {
                var item = ItemModel(name);
                _addItem(item).then((result) {
                  if (result) {
                    Navigator.pop(context);
                    _goToItemScreen(context, item);
                  } else {
                    var error = Translate.translate((name.isEmpty)
                        ? 'Fill this field.'
                        : 'An item with same name already exists.');
                    Tools.showError(context, error);
                  }
                });
              },
              decoration: InputDecoration(
                  hintText: Translate.translate('Enter item name'),
                  contentPadding: const EdgeInsets.all(16.0)),
            ))));
  }
}
