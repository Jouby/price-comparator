import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:the_dead_masked_company.price_comparator/resources/item_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/price_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/user_repository.dart';
import 'package:the_dead_masked_company.price_comparator/services/authentification.dart';

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
