import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:the_dead_masked_company.price_comparator/resources/item_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/price_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';

class MockItemRepository extends Mock implements ItemRepository {}

class MockPriceRepository extends Mock implements PriceRepository {}

class MockStoreRepository extends Mock implements StoreRepository {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
