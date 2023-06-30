import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:link/SubPages/BugReport.dart';
import 'package:link/services/auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/userInfo.dart';
import '../SharedParts/TitleText.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  RangeValues ages = new RangeValues(0, 0);

  @override
  void initState() {
    super.initState();
    initialize();
  }

  Future<void> initialize() async {
    ages = await UserData.getAgeRange();
    setState(() {
      ages = ages;
    });
  }

  @override
  Widget build(BuildContext context){

    final user = Provider.of<UserData>(context);

    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Settings'),
            centerTitle: true,
            backgroundColor: Colors.lightBlue,
            actions: [
              InkWell(
                onTap: () async {
                  CollectionReference users = FirebaseFirestore.instance.collection('users');

                  users.doc(user.uid).update({'minAge': ages.start.round()})
                      .then((value) => print("User Updated"))
                      .catchError((error) => print("Failed to update user: $error"));
                  users.doc(user.uid).update({'maxAge': ages.end.round()})
                      .then((value) => print("User Updated"))
                      .catchError((error) => print("Failed to update user: $error"));

                  final prefs = await SharedPreferences.getInstance();
                  await prefs.setDouble('minAge', ages.start.round().toDouble());
                  await prefs.setDouble('maxAge', ages.end.round().toDouble());

                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.check,
                  color: Colors.black,
                  size: 24,
                ),
              ),
            ]
          ),
          body: Padding(
            padding: EdgeInsets.all(15.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                subTitleText("Age Range"),
                RangeSlider(
                  values: ages,
                  max: 100,
                  divisions: 100,
                  labels: RangeLabels(
                    ages.start.round().toString(),
                    ages.end.round().toString(),
                  ),
                  onChanged: (RangeValues newRange) {
                    setState(() {
                      ages = newRange;
                    });
                  },
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(15, 30, 15, 0),
                  child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => BugReport()));
                      },
                      child: Text('Report Bug')),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: OutlinedButton(
                      onPressed: () async {
                        await AuthService().signOut();
                        final directory = (await getApplicationDocumentsDirectory()).path;
                        await File('$directory/profile.png').delete();
                        Navigator.pop(context);
                        Navigator.pop(context);
                        },
                      child: Text('Sign Out')),
                )
              ],
            ),
          ),
        )
    );
  }
}