import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_dead_masked_company.price_comparator/models/price_model.dart';
import 'package:the_dead_masked_company.price_comparator/services/custom_icons_icons.dart';
import 'package:the_dead_masked_company.price_comparator/services/translate.dart';

/// The Price widget
///
/// Display price screen to update value or options
class Price extends StatefulWidget {
  final PriceModel price;

  Price({Key key, @required this.price}) : super(key: key);

  @override
  createState() => new _PriceState();
}

class _PriceState extends State<Price> {
  TextEditingController priceController = TextEditingController();
  PriceModel price;

  @override
  void initState() {
    price = widget.price;
    priceController.text = price.value.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(title: Text(Translate.translate('Add a new price'))),
      body: Column(children: [
        TextField(
          controller: priceController,
          autofocus: true,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter(RegExp(r'^\d+(\.)?\d{0,2}'), allow: true)
          ],
          decoration: InputDecoration(
            hintText: Translate.translate('Enter your price'),
            contentPadding: const EdgeInsets.all(16.0),
          ),
        ),
        Expanded(
            child: ListView(
          children: <Widget>[
            CheckboxListTile(
              title: Text(Translate.translate('Bio')),
              value: price.options['isBio'],
              onChanged: (val) {
                setState(() {
                  price.options['isBio'] = val;
                });
              },
              secondary: const Icon(CustomIcons.leaf, color: Colors.green),
            ),
            CheckboxListTile(
              title: Text(Translate.translate('Can')),
              value: price.options['isCan'],
              onChanged: (val) {
                setState(() {
                  price.options['isCan'] = val;
                });
              },
              secondary: const Icon(CustomIcons.boxes, color: Colors.grey),
            ),
            CheckboxListTile(
              title: Text(Translate.translate('Freeze')),
              value: price.options['isFreeze'],
              onChanged: (val) {
                setState(() {
                  price.options['isFreeze'] = val;
                });
              },
              secondary:
                  const Icon(CustomIcons.snowflake, color: Color(0xFF90CAF9)),
            ),
            CheckboxListTile(
              title: Text(Translate.translate('Wrap')),
              value: price.options['isWrap'],
              onChanged: (val) {
                setState(() {
                  price.options['isWrap'] = val;
                });
              },
              secondary: const Icon(CustomIcons.prescription_bottle_alt,
                  color: Colors.black),
            ),
            CheckboxListTile(
              title: Text(Translate.translate('Unavailable')),
              value: price.options['isUnavailable'],
              onChanged: (val) {
                setState(() {
                  price.options['isUnavailable'] = val;
                });
              },
              secondary:
                  const Icon(CustomIcons.times_circle, color: Colors.red),
            ),
          ],
        )),
      ]),
      floatingActionButton: new FloatingActionButton(
          onPressed: _submitPrice,
          tooltip: Translate.translate('SAVE'),
          child: new Icon(Icons.save)),
    );
  }

  /// Submit price value
  void _submitPrice() {
    price.value = double.parse(priceController.text);
    Navigator.pop(context, {'price': price});
  }
}
