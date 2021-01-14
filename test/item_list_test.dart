import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/item_repository.dart';
import 'package:the_dead_masked_company.price_comparator/ui/item_list.dart';

class MockItemRepository extends Mock implements ItemRepository {}

void main() {
  MockItemRepository mockItemRepository;

  setUp(() {
    mockItemRepository = MockItemRepository();
  });
  testWidgets('ItemList test', (WidgetTester tester) async {
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
  });
}
