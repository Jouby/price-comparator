import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:the_dead_masked_company.price_comparator/translate.dart';

class Price extends StatefulWidget {
  final Map<String, Object> data;

  Price({Key key, @required this.data}) : super(key: key);

  @override
  createState() => new PriceState();
}

class PriceState extends State<Price> {
  TextEditingController priceController = TextEditingController();
  bool isBio;
  bool isCan;
  bool isFreeze;

  @override
  void initState() {
    priceController.text = widget.data['price'].toString();
    isBio = widget.data['isBio'] ?? false;
    isCan = widget.data['isCan'] ?? false;
    isFreeze = widget.data['isFreeze'] ?? false;

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
            onSubmitted: (val) {
              Navigator.pop(context, {
                'price': val,
                'isBio': isBio,
                'isCan': isCan,
                'isFreeze': isFreeze,
              });
            },
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Checkbox(
                        value: isBio,
                        onChanged: (val) {
                          setState(() {
                            isBio = val;
                          });
                        }),
                    Text(Translate.translate('Bio'))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                        value: isCan,
                        onChanged: (val) {
                          setState(() {
                            isCan = val;
                          });
                        }),
                    Text(Translate.translate('Can'))
                  ],
                ),
                Row(
                  children: <Widget>[
                    Checkbox(
                        value: isFreeze,
                        onChanged: (val) {
                          setState(() {
                            isFreeze = val;
                          });
                        }),
                    Text(Translate.translate('Freeze'))
                  ],
                )
              ])
        ]));
  }
}
