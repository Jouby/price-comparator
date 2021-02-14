import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:i18n_omatic/i18n_omatic.dart';
import 'package:mockito/mockito.dart';
import 'package:the_dead_masked_company.price_comparator/resources/item_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/price_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/user_repository.dart';
import 'package:the_dead_masked_company.price_comparator/services/authentification.dart';
import 'package:the_dead_masked_company.price_comparator/services/globals.dart';

abstract class MockWithExpandedToString extends Mock {
  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.debug}) {
    return super.toString();
  }
}

class MockItemRepository extends Mock implements ItemRepository {}

class MockPriceRepository extends Mock implements PriceRepository {}

class MockStoreRepository extends Mock implements StoreRepository {}

class MockUserRepository extends Mock implements UserRepository {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}

class MockAuth extends Mock implements Auth {}

// ignore: must_be_immutable
class MockGlobalKeyFormState extends Mock implements GlobalKey<FormState> {}

class MockFormState extends MockWithExpandedToString implements FormState {}

class MockI18nOMatic extends Mock implements I18nOMatic {}

class MockFirestoreNotifier extends Mock implements FirestoreNotifier {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockUserCredential extends Mock implements UserCredential {}

class MockUser extends Mock implements User {}

class MockSetUp {
  static void mockI18nOMatic() {
    I18nOMatic.instance = MockI18nOMatic();
    when(I18nOMatic.instance.tr(any, any)).thenAnswer((realInvocation) {
      var strTranslated = realInvocation.positionalArguments[0].toString();
      if (realInvocation.positionalArguments[1] != null) {
        realInvocation.positionalArguments[1]
            .forEach((String key, String value) {
          value ??= '';
          strTranslated = strTranslated.replaceAll('%$key', value.toString());
        });
      }
      return strTranslated;
    });
  }
}
