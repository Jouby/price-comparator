import 'package:flutter_test/flutter_test.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';

void main() {
  test('Models - item : toString', () async {
    var item = ItemModel('test');
    item.id = 'itemid';

    expect(item.toString(), '{"id":"itemid","name":"test"}');
  });

  test('Models - item : toJson', () async {
    var item = ItemModel('test');
    item.id = 'itemid';

    expect(item.toJson(), '{"name":"test"}');
  });
}
