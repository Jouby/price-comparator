import 'package:flutter/material.dart';
import 'package:the_dead_masked_company.price_comparator/ui/login_signup_page.dart';
import 'package:the_dead_masked_company.price_comparator/services/authentification.dart';
import 'package:the_dead_masked_company.price_comparator/services/translate.dart';

/// The Settings list widget
/// 
/// Display settings list (connection parameters)
class SettingsList extends StatefulWidget {
  @override
  createState() => new _SettingsListState();
}

class _SettingsListState extends State<SettingsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(Translate.translate('Paramètres'))),
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
              child: Text(
                Translate.translate('LOGIN'),
                style: TextStyle(fontSize: 20)
              ),
            ),
            // RaisedButton(
            //   onPressed: () {
            //     Repository.exportUserDataToDatabase();
            //   },
            //   child: Text(Translate.translate('EXPORT'),
            //       style: TextStyle(fontSize: 20)),
            // ),
            // RaisedButton(
            //   onPressed: () {
            //     Repository.getUserDataFromDatabase();
            //   },
            //   child: Text(Translate.translate('IMPORT'),
            //       style: TextStyle(fontSize: 20)),
            // ),
          ],
        )
      )
    );
  }
}
