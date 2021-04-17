import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';

void main() {
  MockFirestoreInstance? mockFirestoreInstance;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(
        <String, Object>{'user_id': 'userid'});

    mockFirestoreInstance = MockFirestoreInstance();
  });

  test('Resources - storeRepository : getAll', () async {
    var store = StoreModel('test');

    await mockFirestoreInstance!
        .collection('users')
        .doc('userid')
        .collection(StoreRepository.key)
        .add(store.toMap());

    final storeRepository =
        StoreRepository(databaseReference: mockFirestoreInstance);

    var storeList = await storeRepository.getAll();

    expect(storeList!.containsValue(store), true);
  });

  test('Resources - storeRepository : get', () async {
    var store = StoreModel('test');

    await mockFirestoreInstance!
        .collection('users')
        .doc('userid')
        .collection(StoreRepository.key)
        .add(store.toMap())
        .then((docRef) {
      store.id = docRef.id;
    });

    final storeRepository =
        StoreRepository(databaseReference: mockFirestoreInstance);

    var storeFromDatabase = await storeRepository.get(store.id);
    expect(storeFromDatabase, store);
  });

  test('Resources - storeRepository : add', () async {
    var store = StoreModel('test');
    var store2 = StoreModel('test2');

    await mockFirestoreInstance!
        .collection('users')
        .doc('userid')
        .collection(StoreRepository.key)
        .add(store.toMap())
        .then((docRef) {
      store.id = docRef.id;
    });

    final storeRepository =
        StoreRepository(databaseReference: mockFirestoreInstance);

    var result = await storeRepository.add(store2);
    expect(result!['success'], true);
  });

  test('Resources - storeRepository : update', () async {
    var store = StoreModel('test');

    await mockFirestoreInstance!
        .collection('users')
        .doc('userid')
        .collection(StoreRepository.key)
        .add(store.toMap())
        .then((docRef) {
      store.id = docRef.id;
    });

    final storeRepository =
        StoreRepository(databaseReference: mockFirestoreInstance);

    var result = await storeRepository.add(store);
    expect(result!['success'], true);
  });

  test('Resources - storeRepository : remove', () async {
    var store = StoreModel('test');

    await mockFirestoreInstance!
        .collection('users')
        .doc('userid')
        .collection(StoreRepository.key)
        .add(store.toMap())
        .then((docRef) {
      store.id = docRef.id;
    });

    final storeRepository =
        StoreRepository(databaseReference: mockFirestoreInstance);

    var result = await storeRepository.remove(store);
    expect(result, true);
  });

  test('Resources - storeRepository : dispose', () async {
    var store = StoreModel('test');

    await mockFirestoreInstance!
        .collection('users')
        .doc('userid')
        .collection(StoreRepository.key)
        .add(store.toMap())
        .then((docRef) {
      store.id = docRef.id;
    });

    final storeRepository =
        StoreRepository(databaseReference: mockFirestoreInstance);

    await storeRepository.add(store);

    var storeList = await storeRepository.getInternalStoreList()!;
    expect(storeList.containsValue(store), true);

    storeRepository.dispose();

    storeList = await storeRepository.getInternalStoreList()!;

    expect(storeList, null);
  });
}
