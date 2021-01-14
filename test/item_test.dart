import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/price_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';
import 'package:the_dead_masked_company.price_comparator/ui/item.dart';

class MockPriceRepository extends Mock implements PriceRepository {}

class MockStoreRepository extends Mock implements StoreRepository {}

void main() {
  MockPriceRepository mockPriceRepository;
  MockStoreRepository mockStoreRepository;
  ItemModel item;

  setUp(() {
    mockPriceRepository = MockPriceRepository();
    mockStoreRepository = MockStoreRepository();
  });
  testWidgets('Item : empty', (WidgetTester tester) async {
    item = ItemModel('test');

    when(mockStoreRepository.getAll()).thenAnswer((realInvocation) async => {});

    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            home: Item(
          item: item,
          priceRepository: mockPriceRepository,
          storeRepository: mockStoreRepository,
        )));

    await tester.pumpWidget(testWidget);

    final itemNameFinder = find.text(item.name);
    expect(itemNameFinder, findsOneWidget);
  });

  testWidgets('Item : with store', (WidgetTester tester) async {
    item = ItemModel('test');
    var store1 = StoreModel('Store 1');
    var store2 = StoreModel('Store 2');
    var store3 = StoreModel('Store 3');
    store1.id = '1';
    store2.id = '2';
    store3.id = '3';

    when(mockStoreRepository.getAll()).thenAnswer((realInvocation) async => {
          '1': store1,
          '2': store2,
          '3': store3,
        });

    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            home: Item(
          item: item,
          priceRepository: mockPriceRepository,
          storeRepository: mockStoreRepository,
        )));

    await tester.pumpWidget(testWidget);

    await tester.pumpAndSettle();

    expect(find.byType(Card), findsNWidgets(3));
  });
}
