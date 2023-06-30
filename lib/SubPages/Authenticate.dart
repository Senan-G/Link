import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'SignIn.dart';
import 'Register.dart';

class Authenticate extends StatefulWidget {

  @override
  AuthenticateState createState() => AuthenticateState();
}

class AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    if(showSignIn) {
      return SignIn(toggleView: toggleView);
    }
    else {
      return Register(toggleView: toggleView);
    }
  }

  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }
}