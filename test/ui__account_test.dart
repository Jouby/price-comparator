import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the_dead_masked_company.price_comparator/services/globals.dart';
import 'package:the_dead_masked_company.price_comparator/ui/login_signup_page.dart';
import 'package:the_dead_masked_company.price_comparator/ui/account.dart';
import 'mock.dart';

void main() {
  MockNavigatorObserver mockObserver;
  MockUserRepository mockUserRepository;
  MockItemRepository mockItemRepository;
  MockStoreRepository mockStoreRepository;
  MockPriceRepository mockPriceRepository;
  MockAuth mockAuth;

  setUp(() {
    mockUserRepository = MockUserRepository();
    mockItemRepository = MockItemRepository();
    mockStoreRepository = MockStoreRepository();
    mockPriceRepository = MockPriceRepository();
    mockAuth = MockAuth();

    MockSetUp.mockI18nOMatic();
  });
  testWidgets('Account : empty', (WidgetTester tester) async {
    when(mockUserRepository.getUserName())
        .thenAnswer((realInvocation) async => 'name');
    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            home: Account(
          userRepository: mockUserRepository,
        )));

    await tester.pumpWidget(testWidget);

    final logoutFinder = find.text('LOGOUT');
    expect(logoutFinder, findsOneWidget);
  });

  testWidgets('Account : logout', (WidgetTester tester) async {
    mockObserver = MockNavigatorObserver();

    when(mockUserRepository.getUserName())
        .thenAnswer((realInvocation) async => 'name');
    when(mockUserRepository.dispose())
        .thenAnswer((realInvocation) async => null);
    when(mockItemRepository.dispose())
        .thenAnswer((realInvocation) async => null);
    when(mockStoreRepository.dispose())
        .thenAnswer((realInvocation) async => null);
    when(mockPriceRepository.dispose())
        .thenAnswer((realInvocation) async => null);

    Widget testWidget = MediaQuery(
      data: MediaQueryData(),
      child: MaterialApp(
        navigatorObservers: [mockObserver],
        routes: <String, WidgetBuilder>{
          Constants.loginScreen: (BuildContext context) =>
              LoginSignupPage(auth: mockAuth),
          'settings': (BuildContext context) => Account(
                userRepository: mockUserRepository,
                itemRepository: mockItemRepository,
                storeRepository: mockStoreRepository,
                priceRepository: mockPriceRepository,
              )
        },
        initialRoute: 'settings',
      ),
    );

    await tester.pumpWidget(testWidget);

    final logoutFinder = find.text('LOGOUT');
    expect(logoutFinder, findsOneWidget);

    await tester.tap(logoutFinder);
    await tester.pumpAndSettle();

    verify(mockObserver.didPush(any, any));
  });
}
