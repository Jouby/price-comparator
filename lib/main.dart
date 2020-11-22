import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:the_dead_masked_company.price_comparator/services/constants.dart';
import 'package:the_dead_masked_company.price_comparator/services/data_manager.dart';
import 'package:the_dead_masked_company.price_comparator/services/splashscreen.dart';
import 'package:the_dead_masked_company.price_comparator/ui/item_list.dart';

void main() {
  runApp(
    Phoenix(
      child: App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    _upgradeData(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Price Comparator',
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: <String, WidgetBuilder>{
        Constants.splashScreen: (BuildContext context) => ImageSplashScreen(),
        Constants.homeScreen: (BuildContext context) => ItemList()
      },
      initialRoute: Constants.splashScreen,
    );
  }

  /// Upgrade data using data manager and reload app using [context]
  void _upgradeData(BuildContext context) async {
    await DataManager.upgradeData().then((reload) {
      print('reload');
      if (reload) Phoenix.rebirth(context);
    });
  }
}
