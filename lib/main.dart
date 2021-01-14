import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hooks_riverpod/all.dart';
import 'package:the_dead_masked_company.price_comparator/resources/item_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/price_repository.dart';
import 'package:the_dead_masked_company.price_comparator/resources/store_repository.dart';
import 'package:the_dead_masked_company.price_comparator/services/authentification.dart';
import 'package:the_dead_masked_company.price_comparator/services/globals.dart';
import 'package:the_dead_masked_company.price_comparator/services/splashscreen.dart';
import 'package:the_dead_masked_company.price_comparator/ui/item_list.dart';
import 'package:the_dead_masked_company.price_comparator/ui/login_signup_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(ProviderScope(child: StartApp()));
}

class StartApp extends StatelessWidget {
  // Create the initialization Future outside of `build`:
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          print('ERRRRRRRROR');
          print(snapshot.error);
          // TODO : handle when error to connect to DB
          return App();
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          context.read(firestoreProvider).loaded();
        }

        return App();
      },
    );
  }
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // TODO : reuse upgrade functionnality
    // _upgradeData(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Price Comparator',
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: <String, WidgetBuilder>{
        Constants.splashScreen: (BuildContext context) => ImageSplashScreen(),
        Constants.loginScreen: (BuildContext context) =>
            LoginSignupPage(auth: Auth()),
        Constants.homeScreen: (BuildContext context) => ItemList(
              itemRepository: ItemRepository(),
              priceRepository: PriceRepository(),
              storeRepository: StoreRepository(),
            )
      },
      initialRoute: Constants.splashScreen,
    );
  }

  /// Upgrade data using data manager and reload app using [context]
  // void _upgradeData(BuildContext context) async {
  //   await DataManager.upgradeData();
  // }
}
