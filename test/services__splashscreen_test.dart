import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:the_dead_masked_company.price_comparator/services/globals.dart';
import 'package:the_dead_masked_company.price_comparator/services/splashscreen.dart';
import 'mock.dart';

class FakeFirestoreNotifier extends FirestoreNotifier {
  @override
  bool isLoaded = true;
}

void main() {
  MockUserRepository mockUserRepository;

  setUp(() {
    mockUserRepository = MockUserRepository();
  });

  testWidgets('Services - splashscreen : database loaded', (WidgetTester tester) async {
    when(mockUserRepository.getUserName())
        .thenAnswer((realInvocation) async => null);

    await tester.pumpWidget(ProviderScope(
        overrides: [
          firestoreProvider.overrideWithProvider(
              ChangeNotifierProvider.autoDispose<FirestoreNotifier>((ref) {
            return FakeFirestoreNotifier();
          }))
        ],
        child: MediaQuery(
            data: MediaQueryData(),
            child: MaterialApp(
              home: ImageSplashScreen(
                userRepository: mockUserRepository,
              ),
              routes: <String, WidgetBuilder>{
                Constants.loginScreen: (BuildContext context) =>
                    const Material(child: Text('login screen')),
              },
            ))));

    await tester.pump(Duration(milliseconds: 1500));
    await tester.pump();

    expect(find.text('login screen'), findsOneWidget);
  });

    testWidgets('Services - splashscreen : database unloaded', (WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(
        child: MediaQuery(
            data: MediaQueryData(),
            child: MaterialApp(
              home: ImageSplashScreen(
                userRepository: mockUserRepository,
              ),
            ))));

    await tester.pump(Duration(milliseconds: 1500));

    expect(find.byType(Image), findsOneWidget);
  });
}
