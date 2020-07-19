import 'package:flutter/material.dart';
import 'package:the_dead_masked_company.price_comparator/login_signup_page.dart';
import 'package:the_dead_masked_company.price_comparator/services/authentification.dart';
import 'package:the_dead_masked_company.price_comparator/services/repository.dart';
import 'package:the_dead_masked_company.price_comparator/translate.dart';

class SettingsList extends StatefulWidget {
  @override
  createState() => new SettingsListState();
}

class SettingsListState extends State<SettingsList> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(title: new Text(Translate.translate('Paramètres'))),
        body: Container(
            margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                LoginSignupPage(auth: new Auth())));
                  },
                  child: Text(Translate.translate('LOGIN'),
                      style: TextStyle(fontSize: 20)),
                ),
                RaisedButton(
                  onPressed: () {
                    Repository.exportUserDataToDatabase();
                  },
                  child: Text(Translate.translate('EXPORT'),
                      style: TextStyle(fontSize: 20)),
                ),
                RaisedButton(
                  onPressed: () {
                    Repository.getUserDataFromDatabase();
                  },
                  child: Text(Translate.translate('IMPORT'),
                      style: TextStyle(fontSize: 20)),
                ),
              ],
            )));
  }
}
