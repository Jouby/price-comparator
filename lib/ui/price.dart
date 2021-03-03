import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_dead_masked_company.price_comparator/models/price_model.dart';
import 'package:the_dead_masked_company.price_comparator/resources/price_repository.dart';
import 'package:the_dead_masked_company.price_comparator/services/custom_icons_icons.dart';
import 'package:i18n_omatic/i18n_omatic.dart';
import 'package:the_dead_masked_company.price_comparator/services/custom_theme.dart';

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
  Map<String, bool> options = {};

  @override
  void initState() {
    price = widget.price;
    priceController.text = (price.value == 0) ? '' : price.value.toString();
    options = Map<String, bool>.from(price.options);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: CustomAppBarTitle('Add a new price'.tr()),
        leading: BackButton(
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
              value: options['isBio'],
              onChanged: (val) {
                setState(() {
                  options['isBio'] = val;
                });
              },
              secondary: const Icon(CustomIcons.leaf, color: Colors.green),
            ),
            CheckboxListTile(
              title: Text('Can'.tr()),
              value: options['isCan'],
              onChanged: (val) {
                setState(() {
                  options['isCan'] = val;
                });
              },
              secondary: const Icon(CustomIcons.boxes, color: Colors.grey),
            ),
            CheckboxListTile(
              title: Text('Freeze'.tr()),
              value: options['isFreeze'],
              onChanged: (val) {
                setState(() {
                  options['isFreeze'] = val;
                });
              },
              secondary:
                  const Icon(CustomIcons.snowflake, color: Color(0xFF90CAF9)),
            ),
            CheckboxListTile(
              title: Text('Wrap'.tr()),
              value: options['isWrap'],
              onChanged: (val) {
                setState(() {
                  options['isWrap'] = val;
                });
              },
              secondary: const Icon(CustomIcons.prescription_bottle_alt,
                  color: Colors.black),
            ),
            CheckboxListTile(
              title: Text('Unavailable'.tr()),
              value: options['isUnavailable'],
              onChanged: (val) {
                setState(() {
                  options['isUnavailable'] = val;
                });
              },
              secondary:
                  const Icon(CustomIcons.times_circle, color: Colors.red),
            ),
          ],
        )),
      ]),
      floatingActionButton: CustomFloatingActionButton(
          onPressed: _submitPrice,
          tooltip: 'Save'.tr().toUpperCase(),
          child: Icon(Icons.save)),
    );
  }

  /// Submit price value
  void _submitPrice() {
    price.value =
        (priceController.text.isEmpty) ? 0 : double.parse(priceController.text);
    price.options = options;
    widget.priceRepository.add(price);

    Navigator.pop(context, returnData);
  }
}
