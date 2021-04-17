import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/item_repository.dart';
import 'mock.dart';

void main() {
  MockFirestoreInstance? mockFirestoreInstance;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(
        <String, Object>{'user_id': 'userid'});

    mockFirestoreInstance = MockFirestoreInstance();
    MockSetUp.mockI18nOMatic();
  });

  test('Resources - itemRepository : getAll', () async {
    var item = ItemModel('test');

    await mockFirestoreInstance!
        .collection('users')
        .doc('userid')
        .collection(ItemRepository.key)
        .add(item.toMap())
        .then((docRef) {
      item.id = docRef.id;
    });

    final itemRepository =
        ItemRepository(databaseReference: mockFirestoreInstance);

    var itemList = await itemRepository.getAll();

    expect(itemList!.containsValue(item), true);

    itemRepository.dispose();
  });

  test('Resources - itemRepository : get', () async {
    var item = ItemModel('test');

    await mockFirestoreInstance!
        .collection('users')
        .doc('userid')
        .collection(ItemRepository.key)
        .add(item.toMap())
        .then((docRef) {
      item.id = docRef.id;
    });

    final itemRepository =
        ItemRepository(databaseReference: mockFirestoreInstance);

    var itemFromDatabase = await itemRepository.get(item.id);
    expect(itemFromDatabase, item);

    await mockFirestoreInstance!
        .collection('users')
        .doc('userid')
        .collection(ItemRepository.key)
        .add(item.toMap())
        .then((docRef) {
      item.id = docRef.id;
    });

    itemFromDatabase = await itemRepository.get(item.id);
    expect(itemFromDatabase, item);

    itemFromDatabase = await itemRepository.get('unknown id');
    expect(itemFromDatabase, null);

    itemRepository.dispose();
  });

  test('Resources - itemRepository : add', () async {
    var item = ItemModel('test2');

    final itemRepository =
        ItemRepository(databaseReference: mockFirestoreInstance);

    var result = await itemRepository.add(item);
    expect(result!['success'], true);

    item.id = null;
    var result2 = await itemRepository.add(item);
    expect(result2!['error'], 'An item with same name already exists.');

    itemRepository.dispose();
  });

  test('Resources - itemRepository : update', () async {
    var item = ItemModel('test');

    await mockFirestoreInstance!
        .collection('users')
        .doc('userid')
        .collection(ItemRepository.key)
        .add(item.toMap())
        .then((docRef) {
      item.id = docRef.id;
    });

    final itemRepository =
        ItemRepository(databaseReference: mockFirestoreInstance);

    var result = await itemRepository.add(item);
    expect(result!['success'], true);

    itemRepository.dispose();
  });

  test('Resources - itemRepository : remove', () async {
    var item = ItemModel('test');

    await mockFirestoreInstance!
        .collection('users')
        .doc('userid')
        .collection(ItemRepository.key)
        .add(item.toMap())
        .then((docRef) {
      item.id = docRef.id;
    });

    final itemRepository =
        ItemRepository(databaseReference: mockFirestoreInstance);

    var result = await itemRepository.remove(item);
    expect(result, true);

    itemRepository.dispose();
  });

  test('Resources - itemRepository : dispose', () async {
    var item = ItemModel('test');

    await mockFirestoreInstance!
        .collection('users')
        .doc('userid')
        .collection(ItemRepository.key)
        .add(item.toMap())
        .then((docRef) {
      item.id = docRef.id;
    });

    final itemRepository =
        ItemRepository(databaseReference: mockFirestoreInstance);

    await itemRepository.add(item);

    var itemList = await itemRepository.getInternalStoreList()!;
    expect(itemList.containsValue(item), true);

    itemRepository.dispose();

    itemList = await itemRepository.getInternalStoreList()!;

    expect(itemList, null);
  });
}
