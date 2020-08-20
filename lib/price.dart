import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_dead_masked_company.price_comparator/services/custom_icons_icons.dart';
import 'package:the_dead_masked_company.price_comparator/translate.dart';

class Price extends StatefulWidget {
  final Map<String, Object> data;

  Price({Key key, @required this.data}) : super(key: key);

  @override
  createState() => new PriceState();
}

class PriceState extends State<Price> {
  TextEditingController priceController = TextEditingController();
  String price;
  bool isBio;
  bool isCan;
  bool isFreeze;
  bool isUnavailable;

  @override
  void initState() {
    priceController.text = widget.data['price'].toString();
    isBio = widget.data['isBio'] ?? false;
    isCan = widget.data['isCan'] ?? false;
    isFreeze = widget.data['isFreeze'] ?? false;
    isUnavailable = widget.data['isUnavailable'] ?? false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar:
            new AppBar(title: new Text(Translate.translate('Add a new price'))),
        body: Column(children: [
          TextField(
            controller: priceController,
            autofocus: true,
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter(RegExp(r'^\d+(\.)?\d{0,2}'))
            ],
            decoration: new InputDecoration(
              hintText: Translate.translate('Enter your price'),
              contentPadding: const EdgeInsets.all(16.0),
            ),
          ),
          Expanded(child: ListView(children: <Widget>[
            CheckboxListTile(
            title: Text(Translate.translate('Bio')),
            value: isBio,
            onChanged: (val) {
              setState(() {
                isBio = val;
              });
            },
            secondary: const Icon(CustomIcons.leaf, color: Colors.green),
          ),
          CheckboxListTile(
            title: Text(Translate.translate('Can')),
            value: isCan,
            onChanged: (val) {
              setState(() {
                isCan = val;
              });
            },
            secondary: const Icon(CustomIcons.boxes, color: Colors.grey),
          ),
          CheckboxListTile(
            title: Text(Translate.translate('Freeze')),
            value: isFreeze,
            onChanged: (val) {
              setState(() {
                isFreeze = val;
              });
            },
            secondary: const Icon(CustomIcons.snowflake, color: Color(0xFF90CAF9)),
          ),
          CheckboxListTile(
            title: Text(Translate.translate('Unavailable')),
            value: isUnavailable,
            onChanged: (val) {
              setState(() {
                isUnavailable = val;
              });
            },
            secondary: const Icon(CustomIcons.times_circle, color: Colors.red),
          ),
          ],)),
        ]),
        floatingActionButton: new FloatingActionButton(
          onPressed: submitPrice,
          tooltip: Translate.translate('SAVE'),
          child: new Icon(Icons.save)),
    );
  }

  submitPrice() {
    Navigator.pop(context, {
      'price': priceController.text,
      'isBio': isBio,
      'isCan': isCan,
      'isFreeze': isFreeze,
      'isUnavailable': isUnavailable
    });
  }
}
