import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/price_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/price_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';
import 'package:the_dead_masked_company.price_comparator/ui/item.dart';
import 'package:the_dead_masked_company.price_comparator/ui/price.dart';

class MockPriceRepository extends Mock implements PriceRepository {}

class MockStoreRepository extends Mock implements StoreRepository {}

void main() {
  MockPriceRepository mockPriceRepository;
  PriceModel price;

  setUp(() {
    mockPriceRepository = MockPriceRepository();
  });
  testWidgets('Price : empty', (WidgetTester tester) async {
    price = PriceModel(ItemModel('test item'), StoreModel('test store'));

    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            home: Price(
          price: price,
          priceRepository: mockPriceRepository,
        )));

    await tester.pumpWidget(testWidget);
  });
}
