import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:the_dead_masked_company.price_comparator/main.dart';

void main() {
  testWidgets('Start app', (WidgetTester tester) async {
    await tester.pumpWidget(ProviderScope(child: StartApp()));
  });
}
