import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/item_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/price_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/user_repository.dart';
import 'package:the_dead_masked_company.price_comparator/ui/item.dart';
import 'package:the_dead_masked_company.price_comparator/services/custom_icons_icons.dart';
import 'package:the_dead_masked_company.price_comparator/ui/settings.dart';
import 'package:the_dead_masked_company.price_comparator/ui/store_list.dart';
import 'package:the_dead_masked_company.price_comparator/services/tools.dart';
import 'package:i18n_omatic/i18n_omatic.dart';

/// The Item list widget
///
/// Main screen
/// Display item list (sort alphabetically or possible to filter)
class ItemList extends StatefulWidget {
  final ItemRepository itemRepository;
  final PriceRepository priceRepository;
  final StoreRepository storeRepository;
  final UserRepository userRepository;

  ItemList(
      {Key key,
      @required this.itemRepository,
      this.priceRepository,
      this.storeRepository,
      this.userRepository})
      : super(key: key);
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  List<ItemModel> _itemList = [];
  List<ItemModel> _displayedItemList = [];
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Price Comparator'.tr()), actions: <Widget>[
        IconButton(
          icon: Icon(CustomIcons.shop),
          color: Colors.white,
          tooltip: 'Stores'.tr(),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute<void>(
                    builder: (context) => StoreList(
                          storeRepository: widget.storeRepository,
                          priceRepository: widget.priceRepository,
                        )));
          },
        ),
        IconButton(
            icon: Icon(CustomIcons.params),
            color: Colors.white,
            tooltip: 'Settings'.tr(),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                      builder: (context) => SettingsList(
                            userRepository: widget.userRepository,
                            priceRepository: widget.priceRepository,
                            storeRepository: widget.storeRepository,
                            itemRepository: widget.itemRepository,
                          ))).then((value) {
                setState(() {});
              });
            }),
      ]),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  setState(() {});
                },
                controller: editingController,
                decoration: InputDecoration(
                    labelText: 'Search'.tr(),
                    hintText: 'Search'.tr(),
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            _buildItemList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: _showAddItemScreen,
          tooltip: 'Add a new item'.tr(),
          child: Icon(Icons.add)),
    );
  }

  /// Build item list
  Widget _buildItemList() {
    return FutureBuilder<List<ItemModel>>(
      builder: (context, projectSnap) {
        if (projectSnap.connectionState == ConnectionState.none ||
            projectSnap.data == null) {
          return CircularProgressIndicator();
        }

        _displayedItemList.sort((a, b) {
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        return Expanded(
            child: ListView.builder(
          itemCount: _displayedItemList.length,
          itemBuilder: (context, index) {
            return _buildItem(_displayedItemList[index]);
          },
        ));
      },
      future: _getDisplayItemList(),
    );
  }

  /// Add item by [name]
  Future<bool> _addItem(ItemModel item) async {
    var itemList = await widget.itemRepository.getAll();

    if (item.name.isNotEmpty && !itemList.containsKey(item.id)) {
      await widget.itemRepository.add(item);
      _itemList.add(item);
      _displayedItemList.add(item);
      setState(() {});
      return true;
    }

    return false;
  }

  /// Initialize item list
  Future<List<ItemModel>> _getDisplayItemList() async {
    await widget.itemRepository.getAll().then((list) {
      _itemList = list.entries.map((e) => e.value).toList();
      _displayedItemList = List.from(_itemList);
    });

    filterSearchResults(editingController.text);

    return _displayedItemList;
  }

  /// Remove [item] from item list
  void _removeItem(ItemModel item) async {
    _itemList.remove(item);
    await widget.itemRepository.remove(item);
    setState(() {});
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
            type: PageTransitionType.rightToLeftWithFade,
            child: Item(
              item: item,
              priceRepository: widget.priceRepository,
              storeRepository: widget.storeRepository,
              itemRepository: widget.itemRepository,
            )));

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
      _displayedItemList.addAll(dummyListData);
      return;
    }

    _displayedItemList.addAll(_itemList);
  }

  /// Show a screen to add a new item
  void _showAddItemScreen() {
    Navigator.of(context).push(PageTransition<Map<String, dynamic>>(
        type: PageTransitionType.bottomToTop,
        child: Scaffold(
            appBar: AppBar(title: Text('Add a new item'.tr())),
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
                    var error = (name.isEmpty)
                        ? 'Fill this field.'.tr()
                        : 'An item with same name already exists.'.tr();
                    Tools.showError(context, error);
                  }
                });
              },
              decoration: InputDecoration(
                  hintText: 'Enter item name'.tr(),
                  contentPadding: const EdgeInsets.all(16.0)),
            ))));
  }
}
