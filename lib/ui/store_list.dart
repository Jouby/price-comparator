import 'package:flutter/material.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';
import 'package:the_dead_masked_company.price_comparator/services/tools.dart';
import 'package:the_dead_masked_company.price_comparator/services/translate.dart';

/// The Store list widget
/// 
/// Display store list and functionnality to manage stores
class StoreList extends StatefulWidget {
  @override
  createState() => new _StoreListState();
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
    return new Scaffold(
      appBar: new AppBar(title: new Text(Translate.translate('Stores'))),
      body: _buildStoreList(),
      floatingActionButton: new FloatingActionButton(
          onPressed: _showAddStoreScreen,
          tooltip: Translate.translate('Add a new store'),
          child: new Icon(Icons.add)),
    );
  }

  /// Initialize store list
  void _initializeStoreList() async {
    _storeList = await StoreRepository.getStoresList() ?? [];
    setState(() {});
  }

  /// Add a store with [name]
  Future<bool> _addStore(String name) async {
    StoreModel storeModel = StoreModel(name);
    if (storeModel.name.length > 0 && !_storeList.contains(storeModel)) {
      setState(() => _storeList.add(storeModel));
      StoreRepository.setStoresList(_storeList);
      return true;
    }

    return false;
  }

  /// Delete [store] from store list
  void _removeStore(StoreModel store) {
    StoreRepository.removeStore(store);
    setState(() => _storeList.remove(store));
    StoreRepository.setStoresList(_storeList);
  }

  /// Build store list widget
  Widget _buildStoreList() {
    _storeList.sort((a, b) {
      return a.name.toLowerCase().compareTo(b.name.toLowerCase());
    });
    return new ListView.builder(
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
        title: new Text(store.name),
        onTap: () => _showRemoveStoreDialog(store)
      ),
    );
  }

  /// Show screen to add a new store
  void _showAddStoreScreen() {
    Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
      return new Scaffold(
          appBar: new AppBar(
            title: new Text(Translate.translate('Add a new store'))
          ),
          body: TextField(
            textCapitalization: TextCapitalization.sentences,
            autofocus: true,
            maxLength: 25,
            onSubmitted: (String storeName) {
              _addStore(storeName).then((result) {
                if (result) {
                  Navigator.pop(context);
                } else {
                  String error;
                  if (storeName.length == 0) {
                    error = Translate.translate('Fill this field.');
                  } else {
                    error = Translate.translate(
                        'A store with same name already exists.');
                  }
                  Tools.showError(context, error);
                }
              });
            },
            decoration: new InputDecoration(
              hintText: Translate.translate('Enter store name'),
              contentPadding: const EdgeInsets.all(16.0)
            ),
          ));
    }));
  }

  /// Show a dialog to remove a store
  void _showRemoveStoreDialog(StoreModel store) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return new AlertDialog(
          title: new Text(Translate.translate('Remove "%1" ?', ['${store.name}'])),
          actions: <Widget>[
            new FlatButton(
              child: new Text(Translate.translate('CANCEL')),
              onPressed: () => Navigator.of(context).pop()
            ),
            new FlatButton(
              child: new Text(Translate.translate('REMOVE')),
              onPressed: () {
                _removeStore(store);
                Navigator.of(context).pop();
              }
            )
          ]
        );
      }
    );
  }
}
