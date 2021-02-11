import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';
import 'package:the_dead_masked_company.price_comparator/ui/store_list.dart';
import 'mock.dart';

void main() {
  MockStoreRepository mockStoreRepository;
  MockPriceRepository mockPriceRepository;
  MockNavigatorObserver mockObserver;

  setUp(() {
    mockStoreRepository = MockStoreRepository();
    mockPriceRepository = MockPriceRepository();
  });
  testWidgets('StoreList: display store', (WidgetTester tester) async {
    var store1 = StoreModel('Store 1');
    var store2 = StoreModel('Store 2');
    store1.id = '1';
    store2.id = '2';

    when(mockStoreRepository.getAll()).thenAnswer((realInvocation) async => {
          '1': store1,
          '2': store2,
        });

    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            home: StoreList(
          storeRepository: mockStoreRepository,
        )));

    await tester.pumpWidget(testWidget);

    await tester.pumpAndSettle();

    expect(find.byType(Card), findsNWidgets(2));
  });

  testWidgets('StoreList: add', (WidgetTester tester) async {
    var store1 = StoreModel('Store 1');
    var store2 = StoreModel('Store 2');
    var store3 = StoreModel('Store 3');
    store1.id = '1';
    store2.id = '2';

    when(mockStoreRepository.getAll()).thenAnswer((realInvocation) async => {
          '1': store1,
          '2': store2,
        });

    when(mockStoreRepository.add(store3)).thenAnswer((realInvocation) async {
      return <String, bool>{'success': true};
    });

    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            home: StoreList(
          storeRepository: mockStoreRepository,
        )));

    await tester.pumpWidget(testWidget);

    var addFinder = find.byIcon(Icons.add);
    expect(addFinder, findsOneWidget);

    await tester.tap(addFinder);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.enterText(find.byType(TextField), store3.name);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    expect(StoreModel.all.length, 3);
  });

  testWidgets('StoreList: remove', (WidgetTester tester) async {
    mockObserver = MockNavigatorObserver();

    var store1 = StoreModel('Store 1');
    var store2 = StoreModel('Store 2');
    store1.id = '1';
    store2.id = '2';

    when(mockStoreRepository.getAll()).thenAnswer((realInvocation) async => {
          '1': store1,
          '2': store2,
        });

    when(mockStoreRepository.remove(store2)).thenAnswer((realInvocation) async {
      return true;
    });

    when(mockPriceRepository.removeByStore(store2))
        .thenAnswer((realInvocation) async {});

    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            navigatorObservers: [mockObserver],
            home: StoreList(
                storeRepository: mockStoreRepository,
                priceRepository: mockPriceRepository)));

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    var storeFinder = find.byType(Card);
    expect(storeFinder, findsNWidgets(2));

    await tester.tap(storeFinder.first);
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);

    var cancelFinder = find.text('ANNULER');
    await tester.tap(cancelFinder);
    await tester.pumpAndSettle();

    verify(mockObserver.didPop(any, any));

    await tester.tap(storeFinder.first);
    await tester.pumpAndSettle();

    var removeFinder = find.text('SUPPRIMER');
    await tester.tap(removeFinder);
    await tester.pumpAndSettle();
  });
}
