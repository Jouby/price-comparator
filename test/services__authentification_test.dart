import 'dart:ffi';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:the_dead_masked_company.price_comparator/services/authentification.dart';
import 'mock.dart';

void main() {
  MockFirebaseAuth mockFirebaseAuth;
  MockUserCredential mockUserCredential;
  MockUser mockUser;

  setUp(() {
    mockFirebaseAuth = MockFirebaseAuth();
    mockUserCredential = MockUserCredential();
    mockUser = MockUser();
  });

  testWidgets('Services - authentification : signIn',
      (WidgetTester tester) async {
    when(mockUser.uid).thenReturn('uid_test');
    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockFirebaseAuth.signInWithEmailAndPassword(
            email: 'email', password: 'password'))
        .thenAnswer((realInvocation) async => mockUserCredential);
    var auth = Auth(firebaseAuth: mockFirebaseAuth);

    var uid = await auth.signIn('email', 'password');

    expect(uid, 'uid_test');
  });

  testWidgets('Services - authentification : signUp',
      (WidgetTester tester) async {
    when(mockUser.uid).thenReturn('uid_test');
    when(mockUserCredential.user).thenReturn(mockUser);
    when(mockFirebaseAuth.createUserWithEmailAndPassword(
            email: 'email', password: 'password'))
        .thenAnswer((realInvocation) async => mockUserCredential);
    var auth = Auth(firebaseAuth: mockFirebaseAuth);

    var uid = await auth.signUp('email', 'password');

    expect(uid, 'uid_test');
  });

  testWidgets('Services - authentification : getCurrentUser',
      (WidgetTester tester) async {
    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    var auth = Auth(firebaseAuth: mockFirebaseAuth);

    var user = await auth.getCurrentUser();

    expect(user, mockUser);
  });

  testWidgets('Services - authentification : signOut',
      (WidgetTester tester) async {
    when(mockFirebaseAuth.signOut()).thenAnswer((realInvocation) async => Void);
    var auth = Auth(firebaseAuth: mockFirebaseAuth);
    await auth.signOut();

    verify(mockFirebaseAuth.signOut());
  });

  testWidgets('Services - authentification : sendEmailVerification',
      (WidgetTester tester) async {
    when(mockFirebaseAuth.currentUser).thenReturn(mockUser);
    var auth = Auth(firebaseAuth: mockFirebaseAuth);
    await auth.sendEmailVerification();

    verify(mockUser.sendEmailVerification());
  });
}
