import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/price_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';
import 'package:the_dead_masked_company.price_comparator/services/custom_icons_icons.dart';
import 'package:the_dead_masked_company.price_comparator/ui/item.dart';
import 'mock.dart';

void main() {
  MockPriceRepository mockPriceRepository;
  MockStoreRepository mockStoreRepository;
  MockItemRepository mockItemRepository;
  ItemModel item;
  MockNavigatorObserver mockObserver;

  setUp(() {
    mockPriceRepository = MockPriceRepository();
    mockStoreRepository = MockStoreRepository();
    mockItemRepository = MockItemRepository();
    item = ItemModel('test');

    MockSetUp.mockI18nOMatic();
  });
  testWidgets('Item : empty', (WidgetTester tester) async {
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

  testWidgets('Item : display store', (WidgetTester tester) async {
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

  testWidgets('Item : minimum price', (WidgetTester tester) async {
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

    when(mockPriceRepository.getAllByItem(item)).thenAnswer(
        (realInvocation) async => [
              PriceModel(item, store1, value: 2),
              PriceModel(item, store2, value: 1.3)
            ]);

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
    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is RichText &&
            widget.text.toPlainText() == '1,30€ in Store 2'),
        findsOneWidget);
    expect(
        find.byWidgetPredicate((Widget widget) =>
            widget is RichText &&
            widget.text.toPlainText() == '2,00€ in Store 1'),
        findsNothing);
  });

  testWidgets('Item : pop to ItemList', (WidgetTester tester) async {
    mockObserver = MockNavigatorObserver();

    when(mockStoreRepository.getAll()).thenAnswer((realInvocation) async => {});

    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            navigatorObservers: [mockObserver],
            home: Item(
              item: item,
              priceRepository: mockPriceRepository,
              storeRepository: mockStoreRepository,
            )));

    await tester.pumpWidget(testWidget);

    var popFinder = find.byIcon(Icons.chevron_left);
    expect(popFinder, findsOneWidget);

    await tester.tap(popFinder);
    await tester.pumpAndSettle();

    verify(mockObserver.didPop(any, any));
  });

  testWidgets('Item : edit', (WidgetTester tester) async {
    mockObserver = MockNavigatorObserver();

    when(mockStoreRepository.getAll()).thenAnswer((realInvocation) async => {});
    when(mockItemRepository.add(any)).thenAnswer(
        (realInvocation) async => <String, dynamic>{'success': true});

    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            navigatorObservers: [mockObserver],
            home: Item(
                item: item,
                priceRepository: mockPriceRepository,
                storeRepository: mockStoreRepository,
                itemRepository: mockItemRepository)));

    await tester.pumpWidget(testWidget);

    var editFinder = find.byIcon(CustomIcons.pencil);
    expect(editFinder, findsOneWidget);

    await tester.tap(editFinder);
    await tester.pumpAndSettle();

    verify(mockObserver.didPush(any, any));

    expect(find.text('Edit an item'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();
    expect(find.byType(AlertDialog), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'new test');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    final itemNameFinder = find.text('new test');
    expect(itemNameFinder, findsOneWidget);
  });

  testWidgets('Item : remove', (WidgetTester tester) async {
    mockObserver = MockNavigatorObserver();

    when(mockStoreRepository.getAll()).thenAnswer((realInvocation) async => {});

    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            navigatorObservers: [mockObserver],
            home: Item(
              item: item,
              priceRepository: mockPriceRepository,
              storeRepository: mockStoreRepository,
            )));

    await tester.pumpWidget(testWidget);

    var removeFinder = find.byIcon(CustomIcons.trash);
    expect(removeFinder, findsOneWidget);

    await tester.tap(removeFinder);
    await tester.pumpAndSettle();

    expect(find.text('Remove "test" ?'), findsOneWidget);
    expect(find.text('CANCEL'), findsOneWidget);

    await tester.tap(find.text('CANCEL'));
    await tester.pumpAndSettle();

    verify(mockObserver.didPop(any, any));

    await tester.tap(removeFinder);
    await tester.pumpAndSettle();

    expect(find.text('REMOVE'), findsOneWidget);

    await tester.tap(find.text('REMOVE'));
    await tester.pumpAndSettle();

    verify(mockObserver.didPop(any, any));
  });

  testWidgets('Item : display options', (WidgetTester tester) async {
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

    when(mockPriceRepository.getAllByItem(item))
        .thenAnswer((realInvocation) async => [
              PriceModel(item, store1, value: 2, options: {
                'isBio': true,
                'isCan': true,
                'isFreeze': false,
                'isWrap': true,
                'isUnavailable': false,
              }),
              PriceModel(item, store2, value: 1.3, options: {
                'isBio': true,
                'isCan': false,
                'isFreeze': true,
                'isWrap': false,
                'isUnavailable': false,
              }),
              PriceModel(item, store3, value: 2.3, options: {
                'isBio': false,
                'isCan': false,
                'isFreeze': false,
                'isWrap': false,
                'isUnavailable': true,
              }),
            ]);

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

    var leafFinder = find.byIcon(CustomIcons.leaf);
    expect(leafFinder, findsNWidgets(2));

    var canFinder = find.byIcon(CustomIcons.boxes);
    expect(canFinder, findsOneWidget);

    var freezeFinder = find.byIcon(CustomIcons.snowflake);
    expect(freezeFinder, findsOneWidget);

    var wrapFinder = find.byIcon(CustomIcons.prescription_bottle_alt);
    expect(wrapFinder, findsOneWidget);

    var inkFinder =
        find.descendant(of: find.byType(Card), matching: find.byType(Ink));

    expect(tester.widgetList(inkFinder), [
      isA<Ink>().having((s) => s.decoration, 'decoration',
          BoxDecoration(color: Colors.transparent)),
      isA<Ink>().having((s) => s.decoration, 'decoration',
          BoxDecoration(color: Colors.transparent)),
      isA<Ink>().having((s) => s.decoration, 'decoration',
          BoxDecoration(color: Colors.grey[200])),
    ]);

    await tester.tap(leafFinder.first);
    await tester.tap(canFinder);
    await tester.tap(freezeFinder);
    await tester.tap(wrapFinder);
  });

  testWidgets('Item : add price', (WidgetTester tester) async {
    mockObserver = MockNavigatorObserver();

    var store1 = StoreModel('Store 1');
    var store2 = StoreModel('Store 2');
    var store3 = StoreModel('Store 3');
    store1.id = '1';
    store2.id = '2';
    store3.id = '3';

    var price1 = PriceModel(item, store1, value: 2);

    when(mockStoreRepository.getAll()).thenAnswer((realInvocation) async => {
          '1': store1,
          '2': store2,
          '3': store3,
        });

    when(mockPriceRepository.getAllByItem(item)).thenAnswer(
        (realInvocation) async =>
            [price1, PriceModel(item, store2, value: 1.3)]);

    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            navigatorObservers: [mockObserver],
            home: Item(
              item: item,
              priceRepository: mockPriceRepository,
              storeRepository: mockStoreRepository,
            )));

    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    await tester.tap(find.byType(Card).first);
    await tester.pumpAndSettle();

    //TODO Finish this test after navigation rework
    // verify(mockObserver.didPush(
    //   MaterialPageRoute<Map<String, dynamic>>(builder: (context) => Price(price: price1)),
    //   any
    // ));

    // await tester.enterText(find.byType(TextField), '1.15');
    // await tester.testTextInput.receiveAction(TextInputAction.done);
    // await tester.pumpAndSettle();

    // verify(mockObserver.didPop(any, any));

    // expect(find.byWidgetPredicate((Widget widget) {
    //   if (widget is RichText) print(widget.text.toPlainText());
    //   return widget is RichText &&
    //       widget.text.toPlainText() == '1,15€ à Store 1';
    // }), findsOneWidget);
    // expect(
    //     find.byWidgetPredicate((Widget widget) =>
    //         widget is RichText &&
    //         widget.text.toPlainText() == '1,30€ à Store 2'),
    //     findsNothing);
  });
}
