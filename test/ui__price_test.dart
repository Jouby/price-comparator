import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/price_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';
import 'package:the_dead_masked_company.price_comparator/services/custom_icons_icons.dart';
import 'package:the_dead_masked_company.price_comparator/ui/price.dart';
import 'mock.dart';

void main() {
  MockPriceRepository mockPriceRepository;
  PriceModel price;

  setUp(() {
    mockPriceRepository = MockPriceRepository();
    var item = ItemModel('test');
    price = PriceModel(item, StoreModel('test store'));

    MockSetUp.mockI18nOMatic();
  });
  testWidgets('Price : empty', (WidgetTester tester) async {
    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            home: Price(
          price: price,
          priceRepository: mockPriceRepository,
        )));

    await tester.pumpWidget(testWidget);
  });

  testWidgets('Price : options', (WidgetTester tester) async {
    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            home: Price(
          price: price,
          priceRepository: mockPriceRepository,
        )));

    await tester.pumpWidget(testWidget);

    var bioFinder = find.byIcon(CustomIcons.leaf);
    expect(bioFinder, findsOneWidget);
    await tester.tap(bioFinder);
    await tester.pumpAndSettle();

    var canFinder = find.byIcon(CustomIcons.boxes);
    expect(canFinder, findsOneWidget);
    await tester.tap(canFinder);
    await tester.pumpAndSettle();

    var freezeFinder = find.byIcon(CustomIcons.snowflake);
    expect(freezeFinder, findsOneWidget);
    await tester.tap(freezeFinder);
    await tester.pumpAndSettle();

    var wrapFinder = find.byIcon(CustomIcons.prescription_bottle_alt);
    expect(wrapFinder, findsOneWidget);
    await tester.tap(wrapFinder);
    await tester.pumpAndSettle();

    var unavailableFinder = find.byIcon(CustomIcons.times_circle);
    expect(unavailableFinder, findsOneWidget);
    await tester.tap(unavailableFinder);
    await tester.pumpAndSettle();
  });

  testWidgets('Price : save', (WidgetTester tester) async {
    price.value = 3.2;
    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            home: Price(
          price: price,
          priceRepository: mockPriceRepository,
        )));

    await tester.pumpWidget(testWidget);

    var saveFinder = find.byIcon(Icons.save);
    expect(saveFinder, findsOneWidget);
    await tester.tap(saveFinder);
    await tester.pumpAndSettle();
  });
}
