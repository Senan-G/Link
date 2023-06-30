import 'package:flutter/material.dart';
import 'package:link/SubPages/Authenticate.dart';
import 'Home.dart';
import 'services/userInfo.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserData>(context);
    print(user.uid);

    if(user.uid == "undefined"){
      return Authenticate();
    }

    return Home();
  }
}