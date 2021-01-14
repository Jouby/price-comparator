import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';
import 'package:the_dead_masked_company.price_comparator/ui/store_list.dart';

class MockStoreRepository extends Mock implements StoreRepository {}

void main() {
  MockStoreRepository mockStoreRepository;

  setUp(() {
    mockStoreRepository = MockStoreRepository();
  });
  testWidgets('StoreList test', (WidgetTester tester) async {
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
}
