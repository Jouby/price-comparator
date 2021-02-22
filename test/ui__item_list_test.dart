import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/services/custom_icons_icons.dart';
import 'package:the_dead_masked_company.price_comparator/ui/item.dart';
import 'package:the_dead_masked_company.price_comparator/ui/item_list.dart';
import 'mock.dart';

void main() {
  MockItemRepository mockItemRepository;
  MockStoreRepository mockStoreRepository;
  MockPriceRepository mockPriceRepository;
  MockNavigatorObserver mockObserver;

  setUp(() {
    mockItemRepository = MockItemRepository();
    mockStoreRepository = MockStoreRepository();
    mockPriceRepository = MockPriceRepository();

    MockSetUp.mockI18nOMatic();
  });

  testWidgets('ItemList: empty', (WidgetTester tester) async {
    when(mockItemRepository.getAll()).thenAnswer((realInvocation) async => {});
    when(mockStoreRepository.getAll()).thenAnswer((realInvocation) async => {});

    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            home: ItemList(
          itemRepository: mockItemRepository,
          storeRepository: mockStoreRepository,
        )));

    await tester.pumpWidget(testWidget);

    await tester.pumpAndSettle();

    expect(find.byType(Card), findsNothing);
  });

  testWidgets('ItemList: display item', (WidgetTester tester) async {
    when(mockItemRepository.getAll()).thenAnswer((realInvocation) async => {
          '1': ItemModel('1'),
          '2': ItemModel('2'),
        });

    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            home: ItemList(
          itemRepository: mockItemRepository,
        )));

    await tester.pumpWidget(testWidget);

    await tester.pumpAndSettle();

    expect(find.byType(Card), findsNWidgets(2));
  });

  testWidgets('ItemList: go to store', (WidgetTester tester) async {
    mockObserver = MockNavigatorObserver();

    when(mockItemRepository.getAll()).thenAnswer((realInvocation) async => {});
    when(mockStoreRepository.getAll()).thenAnswer((realInvocation) async => {});

    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            navigatorObservers: [mockObserver],
            home: ItemList(
              itemRepository: mockItemRepository,
              storeRepository: mockStoreRepository,
            )));
    await tester.pumpWidget(testWidget);

    var shopFinder = find.byIcon(CustomIcons.shop);
    expect(shopFinder, findsOneWidget);

    await tester.tap(shopFinder);
    await tester.pumpAndSettle();

    verify(mockObserver.didPush(any, any));

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
  });

  testWidgets('ItemList: go to account', (WidgetTester tester) async {
    mockObserver = MockNavigatorObserver();

    when(mockItemRepository.getAll()).thenAnswer((realInvocation) async => {});

    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            navigatorObservers: [mockObserver],
            home: ItemList(
              itemRepository: mockItemRepository,
            )));
    await tester.pumpWidget(testWidget);

    var paramsFinder = find.byIcon(CustomIcons.user);
    expect(paramsFinder, findsOneWidget);

    await tester.tap(paramsFinder);
    await tester.pumpAndSettle();

    verify(mockObserver.didPush(any, any));

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
  });

  testWidgets('ItemList: go to item', (WidgetTester tester) async {
    mockObserver = MockNavigatorObserver();
    var item1 = ItemModel('1');

    when(mockItemRepository.getAll()).thenAnswer((realInvocation) async => {
          '1': item1,
          '2': ItemModel('2'),
        });
    when(mockPriceRepository.getAllByItem(item1))
        .thenAnswer((realInvocation) async => []);
    when(mockStoreRepository.getAll()).thenAnswer((realInvocation) async => {});

    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            navigatorObservers: [mockObserver],
            home: ItemList(
              itemRepository: mockItemRepository,
              priceRepository: mockPriceRepository,
              storeRepository: mockStoreRepository,
            )));
    await tester.pumpWidget(testWidget);
    await tester.pumpAndSettle();

    var itemFinder = find.byType(Card);
    expect(itemFinder, findsNWidgets(2));

    await tester.tap(itemFinder.first);
    await tester.pumpAndSettle();

    verify(mockObserver.didPush(any, any));
  });

  testWidgets('ItemList: search item', (WidgetTester tester) async {
    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            home: ItemList(
          itemRepository: mockItemRepository,
        )));

    when(mockItemRepository.getAll()).thenAnswer((realInvocation) async => {
          '1': ItemModel('1'),
          '2': ItemModel('2'),
        });

    await tester.pumpWidget(testWidget);

    await tester.pumpAndSettle();

    expect(find.byType(Card), findsNWidgets(2));

    var textFinder = find.byType(TextField);
    expect(textFinder, findsOneWidget);

    await tester.enterText(textFinder, '1');
    await tester.pumpAndSettle();

    expect(find.byType(Card), findsOneWidget);
  });

  testWidgets('ItemList: add item', (WidgetTester tester) async {
    mockObserver = MockNavigatorObserver();

    when(mockItemRepository.getAll()).thenAnswer((realInvocation) async => {
          '1': ItemModel('1'),
          '2': ItemModel('2'),
        });
    var item3 = ItemModel('3');

    when(mockPriceRepository.getAllByItem(item3))
        .thenAnswer((realInvocation) async => []);
    when(mockStoreRepository.getAll()).thenAnswer((realInvocation) async => {});

    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            navigatorObservers: [mockObserver],
            home: ItemList(
              itemRepository: mockItemRepository,
              priceRepository: mockPriceRepository,
              storeRepository: mockStoreRepository,
            )));

    await tester.pumpWidget(testWidget);

    await tester.pumpAndSettle();

    expect(find.byType(Card), findsNWidgets(2));

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    verify(mockObserver.didPush(any, any));

    //TODO test with same name

    var textFinder = find.byType(TextField);
    expect(textFinder, findsOneWidget);

    await tester.enterText(textFinder, item3.name);
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    verify(mockObserver.didPop(any, any));

    await tester.pumpAndSettle();

    expect(find.byType(Item), findsOneWidget);
    expect(find.text(item3.name), findsOneWidget);
  });
}
