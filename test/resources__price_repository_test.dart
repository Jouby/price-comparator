import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/price_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/price_repository.dart';
import 'mock.dart';

void main() {
  MockItemRepository? mockItemRepository;
  MockStoreRepository? mockStoreRepository;
  ItemModel? item;
  MockFirestoreInstance? firestoreInstance;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(
        <String, Object>{'user_id': 'userid'});
    mockItemRepository = MockItemRepository();
    mockStoreRepository = MockStoreRepository();
    item = ItemModel('test');
    item!.id = '123';
    firestoreInstance = MockFirestoreInstance();
  });

  test('Resources - priceRepository : getAllByItem', () async {
    var store = StoreModel('test');
    store.id = '12';
    var price = PriceModel(item, store);

    when(mockItemRepository!.get(item!.id))
        .thenAnswer((realInvocation) async => item);
    when(mockStoreRepository!.get(store.id))
        .thenAnswer((realInvocation) async => store);

    await firestoreInstance!
        .collection('users')
        .doc('userid')
        .collection(PriceRepository.key)
        .add(price.toMap());

    final priceRepository = PriceRepository(
        itemRepository: mockItemRepository,
        storeRepository: mockStoreRepository,
        databaseReference: firestoreInstance);

    await priceRepository.getAllByItem(item!);
  });

  test('Resources - priceRepository : add', () {
    final priceRepository = PriceRepository(
        itemRepository: mockItemRepository,
        storeRepository: mockStoreRepository,
        databaseReference: firestoreInstance);

    var store = StoreModel('test');
    var price = PriceModel(item, store);

    priceRepository.add(price);
  });

  test('Resources - priceRepository : update', () {
    final priceRepository = PriceRepository(
        itemRepository: mockItemRepository,
        storeRepository: mockStoreRepository,
        databaseReference: firestoreInstance);

    var store = StoreModel('test');
    var price = PriceModel(item, store);
    price.id = 'test';

    priceRepository.add(price);
  });

  test('Resources - priceRepository : remove', () {
    final priceRepository = PriceRepository(
        itemRepository: mockItemRepository,
        storeRepository: mockStoreRepository,
        databaseReference: firestoreInstance);

    var store = StoreModel('test');
    var price = PriceModel(item, store);

    priceRepository.remove(price);
  });

  test('Resources - priceRepository : removeByStore', () {
    final priceRepository = PriceRepository(
        itemRepository: mockItemRepository,
        storeRepository: mockStoreRepository,
        databaseReference: firestoreInstance);
    var store = StoreModel('test');

    priceRepository.removeByStore(store);
  });

  test('Resources - priceRepository : dispose', () {
    final priceRepository = PriceRepository(
        itemRepository: mockItemRepository,
        storeRepository: mockStoreRepository,
        databaseReference: firestoreInstance);

    priceRepository.dispose();
  });
}
