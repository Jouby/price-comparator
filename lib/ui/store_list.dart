import 'package:flutter/material.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/price_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';
import 'package:the_dead_masked_company.price_comparator/services/tools.dart';
import 'package:i18n_omatic/i18n_omatic.dart';

/// The Store list widget
///
/// Display store list and functionnality to manage stores
class StoreList extends StatefulWidget {
  final StoreRepository storeRepository;
  final PriceRepository priceRepository;

  StoreList({Key key, @required this.storeRepository, this.priceRepository})
      : super(key: key);

  @override
  _StoreListState createState() => _StoreListState();
}

class _StoreListState extends State<StoreList> {
  /// The store list sorted alphabetically
  List<StoreModel> _storeList;

  @override
  void initState() {
    _storeList = [];
    _initializeStoreList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stores'.tr())),
      body: _buildStoreList(),
      floatingActionButton: FloatingActionButton(
          onPressed: _showAddStoreScreen,
          tooltip: 'Add a new store'.tr(),
          child: Icon(Icons.add)),
    );
  }

  /// Initialize store list
  void _initializeStoreList() async {
    var list = await widget.storeRepository.getAll() ?? {};
    _storeList = list.entries.map((e) => e.value).toList();
    setState(() {});
  }

  /// Add a store with [name]
  Future<bool> _addStore(String name) async {
    var result = false;

    if (name.isEmpty) {
      Tools.showError(context, 'Fill this field.'.tr());
    } else {
      var store = StoreModel(name);
      if (store.name.isNotEmpty && !_storeList.contains(store)) {
        await widget.storeRepository.add(store).then((e) {
          if (e['success'] == true) {
            setState(() {
              _storeList.add(store);
            });
            result = true;
          } else {
            Tools.showError(context, e['error'].toString());
          }
        });
      }
    }

    return result;
  }

  /// Delete [store] from store list
  void _removeStore(StoreModel store) async {
    await widget.storeRepository.remove(store);
    await widget.priceRepository.removeByStore(store);
    setState(() {
      _storeList.remove(store);
    });
  }

  /// Build store list widget
  Widget _buildStoreList() {
    _storeList.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index < _storeList.length) {
          return _buildStore(_storeList[index]);
        }
        return null;
      },
    );
  }

  /// Build [store] widget
  Widget _buildStore(StoreModel store) {
    return Card(
      child: ListTile(
          title: Text(store.name), onTap: () => _showRemoveStoreDialog(store)),
    );
  }

  /// Show screen to add a new store
  void _showAddStoreScreen() {
    Navigator.of(context).push(MaterialPageRoute<void>(builder: (context) {
      return Scaffold(
          appBar: AppBar(title: Text('Add a new store'.tr())),
          body: TextField(
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            maxLength: 25,
            onSubmitted: (String storeName) {
              _addStore(storeName).then((result) {
                if (result) {
                  Navigator.pop(context);
                }
              });
            },
            decoration: InputDecoration(
                hintText: 'Enter store name'.tr(),
                contentPadding: const EdgeInsets.all(16.0)),
          ));
    }));
  }

  /// Show a dialog to remove a store
  void _showRemoveStoreDialog(StoreModel store) {
    showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text(
                  'Remove "%name" ?'.tr(<String, String>{'name': store.name})),
              actions: <Widget>[
                FlatButton(
                    child: Text('Cancel'.tr().toUpperCase()),
                    onPressed: () => Navigator.of(context).pop()),
                FlatButton(
                    child: Text('Remove'.tr().toUpperCase()),
                    onPressed: () {
                      _removeStore(store);
                      Navigator.of(context).pop();
                    })
              ]);
        });
  }
}
