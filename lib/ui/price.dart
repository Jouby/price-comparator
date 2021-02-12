import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_dead_masked_company.price_comparator/models/price_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/price_repository.dart';
import 'package:the_dead_masked_company.price_comparator/services/custom_icons_icons.dart';
import 'package:i18n_omatic/i18n_omatic.dart';

/// The Price widget
///
/// Display price screen to update value or options
class Price extends StatefulWidget {
  final PriceModel price;
  final PriceRepository priceRepository;

  Price({Key key, @required this.price, this.priceRepository})
      : super(key: key);

  @override
  _PriceState createState() => _PriceState();
}

class _PriceState extends State<Price> {
  TextEditingController priceController = TextEditingController();
  PriceModel price;
  Map<String, dynamic> returnData = <String, dynamic>{};

  @override
  void initState() {
    price = widget.price;
    priceController.text = (price.value == 0) ? '' : price.value.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a new price'.tr()),
        leading: IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context, returnData),
        ),
      ),
      body: Column(children: [
        TextField(
          controller: priceController,
          autofocus: true,
          keyboardType: TextInputType.numberWithOptions(decimal: true),
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter(RegExp(r'^\d+(\.)?\d{0,2}'),
                allow: true)
          ],
          decoration: InputDecoration(
            hintText: 'Enter your price'.tr(),
            contentPadding: const EdgeInsets.all(16.0),
          ),
        ),
        Expanded(
            child: ListView(
          children: <Widget>[
            CheckboxListTile(
              title: Text('Bio'.tr()),
              value: price.options['isBio'],
              onChanged: (val) {
                setState(() {
                  price.options['isBio'] = val;
                });
              },
              secondary: const Icon(CustomIcons.leaf, color: Colors.green),
            ),
            CheckboxListTile(
              title: Text('Can'.tr()),
              value: price.options['isCan'],
              onChanged: (val) {
                setState(() {
                  price.options['isCan'] = val;
                });
              },
              secondary: const Icon(CustomIcons.boxes, color: Colors.grey),
            ),
            CheckboxListTile(
              title: Text('Freeze'.tr()),
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
              title: Text('Wrap'.tr()),
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
              title: Text('Unavailable'.tr()),
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
      floatingActionButton: FloatingActionButton(
          onPressed: _submitPrice,
          tooltip: 'Save'.tr().toUpperCase(),
          child: Icon(Icons.save)),
    );
  }

  /// Submit price value
  void _submitPrice() {
    price.value = double.parse(priceController.text);
    widget.priceRepository.add(price);

    // returnData['price'] = price;
    Navigator.pop(context, returnData);
  }
}
