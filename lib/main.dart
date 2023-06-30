import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:link/services/auth.dart';
import 'package:link/services/userInfo.dart';
import 'Wrapper.dart';
import 'services/userInfo.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate();
  runApp(LinkApp());
}

/// This is the main application widget.
class LinkApp extends StatelessWidget {
  const LinkApp({Key? key}) : super(key: key);

  static const String _title = 'Link';


  @override
  Widget build(BuildContext context) {
    return StreamProvider<UserData>.value(
      initialData: UserData(uid: "undefined"),
      value: AuthService().user,
      child: MaterialApp(
        title: _title,
        home: Wrapper(),
      )
    );
  }
}

