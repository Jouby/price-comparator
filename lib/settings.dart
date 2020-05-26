import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:the_dead_masked_company.price_comparator/login_signup_page.dart';
import 'package:the_dead_masked_company.price_comparator/services/authentification.dart';
import 'package:the_dead_masked_company.price_comparator/translate.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SettingsList extends StatefulWidget {
  @override
  createState() => new SettingsListState();
}

class SettingsListState extends State<SettingsList> {
  List<String> _storesList = [];

  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

Future<FirebaseUser> _handleSignIn() async {
  final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  final AuthCredential credential = GoogleAuthProvider.getCredential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
  print("signed in " + user.displayName);
  return user;
}

Future<FirebaseUser> _mailSignIn(String mail, String password) async {
  final FirebaseUser user = (await _auth.createUserWithEmailAndPassword(
      email: mail,
      password: password,
    ))
        .user;
  print("signed in " + user.displayName);
  return user;
}

final _formKey = GlobalKey<FormState>();

TextEditingController emailController = new TextEditingController();
TextEditingController passwordController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(Translate.translate('Settings'))),
      body: Container(
           margin: const EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
           child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          RaisedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => LoginSignupPage(auth: new Auth())));
            },
            child: Text(
              Translate.translate('LOGIN'),
              style: TextStyle(fontSize: 20)
            ),
          ),
          // TextField(
          //   controller: emailController,
          //   obscureText: false,
          //   textAlign: TextAlign.left,
          //   decoration: InputDecoration(
          //     border: InputBorder.none,
          //     hintText: 'PLEASE ENTER YOUR EMAIL',
          //     hintStyle: TextStyle(color: Colors.grey),
          //   ),
          // ),
          // TextField(
          //   controller: passwordController,
          //   obscureText: true,
          //   textAlign: TextAlign.left,
          //   decoration: InputDecoration(
          //     border: InputBorder.none,
          //     hintText: 'PLEASE ENTER YOUR PASSWORD',
          //     hintStyle: TextStyle(color: Colors.grey),
          //   ),
          // ),
          // RaisedButton(
          //   onPressed: () {
          //     if (emailController.text != null && passwordController.text != null) {
          //       _mailSignIn(emailController.text, passwordController.text)
          //         .then((FirebaseUser user) => print(user))
          //         .catchError((e) => print(e));
          //     }
          //   },
          //   child: Text(
          //     Translate.translate('Create account MAIL'),
          //     style: TextStyle(fontSize: 20)
          //   ),
          // ),
          // RaisedButton(
          //   onPressed: () {
          //     _handleSignIn()
          //     .then((FirebaseUser user) => print(user))
          //     .catchError((e) => print(e));
          //   },
          //   child: Text(
          //     Translate.translate('Create account GOOGLE'),
          //     style: TextStyle(fontSize: 20)
          //   ),
          // ),
        ],
      )
      )
      
    );
  }
}
