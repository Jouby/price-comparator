import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the_dead_masked_company.price_comparator/ui/item_list.dart';
import 'package:the_dead_masked_company.price_comparator/ui/login_signup_page.dart';
import 'mock.dart';

void main() {
  MockAuth? mockAuth;
  MockGlobalKeyFormState? mockGlobalKeyFormState;
  MockFormState? mockFormState;
  MockUserRepository? mockUserRepository;
  MockItemRepository? mockItemRepository;
  MockNavigatorObserver? mockObserver;

  setUp(() {
    mockAuth = MockAuth();
    mockGlobalKeyFormState = MockGlobalKeyFormState();
    mockFormState = MockFormState();
    mockUserRepository = MockUserRepository();
    mockItemRepository = MockItemRepository();
    mockObserver = MockNavigatorObserver();

    MockSetUp.mockI18nOMatic();
  });
  testWidgets('Login : empty', (WidgetTester tester) async {
    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
            home: LoginSignupPage(
          auth: mockAuth,
        )));

    await tester.pumpWidget(testWidget);
  });

  testWidgets('Login : log user', (WidgetTester tester) async {
    when(mockGlobalKeyFormState!.currentState).thenReturn(mockFormState);
    when(mockFormState!.validate()).thenAnswer((realInvocation) => true);

    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(routes: <String, WidgetBuilder>{
          'login': (BuildContext context) => LoginSignupPage(
                auth: mockAuth,
                globalKey: mockGlobalKeyFormState,
                userRepository: mockUserRepository,
              ),
          'HOME_SCREEN': (BuildContext context) => ItemList(
                itemRepository: mockItemRepository,
              ),
        }, initialRoute: 'login'));

    await tester.pumpWidget(testWidget);

    var loginFinder = find.byKey(Key('login_button'));
    expect(loginFinder, findsOneWidget);

    await tester.tap(loginFinder);
  });

  testWidgets('Login : create user', (WidgetTester tester) async {
    when(mockGlobalKeyFormState!.currentState).thenReturn(mockFormState);
    when(mockFormState!.validate()).thenAnswer((realInvocation) => true);
    when(mockUserRepository!.setUserId(any!))
        .thenAnswer((realInvocation) async => true);
    when(mockUserRepository!.setUserName(any!))
        .thenAnswer((realInvocation) async => true);

    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(
          navigatorObservers: [mockObserver!],
          routes: <String, WidgetBuilder>{
            'login': (BuildContext context) => LoginSignupPage(
                  auth: mockAuth,
                  globalKey: mockGlobalKeyFormState,
                  userRepository: mockUserRepository,
                ),
            'HOME_SCREEN': (BuildContext context) => ItemList(
                  itemRepository: mockItemRepository,
                ),
          },
          initialRoute: 'login',
        ));

    await tester.pumpWidget(testWidget);

    var createFinder = find.byKey(Key('login_switch_button'));
    expect(createFinder, findsOneWidget);

    await tester.tap(createFinder);
    await tester.pumpAndSettle();

    var createFinder2 = find.byKey(Key('login_button'));
    expect(createFinder2, findsOneWidget);

    await tester.tap(createFinder2);
  });

  testWidgets('Login : throw error on login user', (WidgetTester tester) async {
    when(mockGlobalKeyFormState!.currentState).thenReturn(mockFormState);
    when(mockFormState!.validate()).thenAnswer((realInvocation) => true);
    when(mockUserRepository!.setUserId(any!)).thenThrow(ArgumentError);
    ;

    Widget testWidget = MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(routes: <String, WidgetBuilder>{
          'login': (BuildContext context) => LoginSignupPage(
                auth: mockAuth,
                globalKey: mockGlobalKeyFormState,
                userRepository: mockUserRepository,
              ),
          'HOME_SCREEN': (BuildContext context) => ItemList(
                itemRepository: mockItemRepository,
              ),
        }, initialRoute: 'login'));

    await tester.pumpWidget(testWidget);

    var loginFinder = find.byKey(Key('login_button'));
    expect(loginFinder, findsOneWidget);

    await tester.tap(loginFinder);
  });
}
