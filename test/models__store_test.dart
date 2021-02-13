import 'package:flutter_test/flutter_test.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';

void main() {
  test('Models - store : toString', () async {
    var store = StoreModel('test');
    store.id = 'storeid';

    expect(store.toString(), '{"id":"storeid","name":"test"}');
  });

  test('Models - store : toJson', () async {
    var store = StoreModel('test');
    store.id = 'storeid';

    expect(store.toJson(), '{"name":"test"}');
  });
}
