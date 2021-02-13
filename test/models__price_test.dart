import 'package:flutter_test/flutter_test.dart';
import 'package:the_dead_masked_company.price_comparator/models/item_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/price_model.dart';
import 'package:the_dead_masked_company.price_comparator/models/store_model.dart';

void main() {
  test('Models - price : toString', () async {
    var item = ItemModel('test');
    item.id = 'itemid';
    var store = StoreModel('test');
    store.id = 'storeid';
    var price = PriceModel(item, store);
    price.id = 'priceid';

    expect(price.toString(),
        '{"id":"priceid","item":"itemid","store":"storeid","value":0,"options":{"isBio":false,"isCan":false,"isFreeze":false,"isWrap":false,"isUnavailable":false}}');
  });

  test('Models - price : toJson', () async {
    var item = ItemModel('test');
    item.id = 'itemid';
    var store = StoreModel('test');
    store.id = 'storeid';
    var price = PriceModel(item, store);
    price.id = 'priceid';

    expect(price.toJson(),
        '{"item":"itemid","store":"storeid","value":0,"options":{"isBio":false,"isCan":false,"isFreeze":false,"isWrap":false,"isUnavailable":false}}');
  });
}
