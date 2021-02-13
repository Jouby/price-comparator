import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:the_dead_masked_company.price_comparator/resources/user_repository.dart';

void main() {
  MockFirestoreInstance mockFirestoreInstance;

  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues(
        <String, dynamic>{'user_id': 'userid', 'user_name': 'user_name_test'});

    mockFirestoreInstance = MockFirestoreInstance();
  });

  test('Resources - userRepository : getUserDataFromDatabase', () async {
    var data = {'test': 'test_data'};

    await mockFirestoreInstance.collection('users').doc('userid').set(data);

    final userRepository =
        UserRepository(databaseReference: mockFirestoreInstance);

    var userData = await userRepository.getUserDataFromDatabase();

    expect(userData, data);
  });

  test('Resources - userRepository : getUserName', () async {
    final userRepository =
        UserRepository(databaseReference: mockFirestoreInstance);

    var userName = await userRepository.getUserName();

    expect(userName, 'user_name_test');
  });

  test('Resources - userRepository : setUserId', () async {
    const userId = 'userid_test';
    final userRepository =
        UserRepository(databaseReference: mockFirestoreInstance);

    await userRepository.setUserId(userId);
    var userIdFromSP = await userRepository.getUserId();

    expect(userIdFromSP, userId);
  });

  test('Resources - userRepository : setUserName', () async {
    const userName = 'username_test';
    final userRepository =
        UserRepository(databaseReference: mockFirestoreInstance);

    await userRepository.setUserName(userName);
    var userNameFromSP = await userRepository.getUserName();

    expect(userNameFromSP, userName);
  });

  test('Resources - userRepository : dispose', () async {
    final userRepository =
        UserRepository(databaseReference: mockFirestoreInstance);

    await userRepository.dispose();

    var userName = await userRepository.getUserName();
    expect(userName, null);
    var userId = await userRepository.getUserId();
    expect(userId, '');
  });
}
