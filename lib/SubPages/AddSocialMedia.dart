import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../SharedParts/constants.dart';
import '../services/userInfo.dart';

class AddSocialMedia extends StatefulWidget {
  final String type;

  const AddSocialMedia({required this.type}) : super();

  @override
  _AddSocialMediaState createState() => _AddSocialMediaState(type);
}

class _AddSocialMediaState extends State<AddSocialMedia> {
  String type;

  _AddSocialMediaState(this.type);
  String form = '';


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);

    return Scaffold(
      backgroundColor: Color(0xFFE8F6FF),
      appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          elevation: 0.0,
          title: Text('Add Social Media'),
        centerTitle: true,
        leading: InkWell(
          onTap: () async {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back_rounded,
            color: Colors.black,
            size: 24,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 20.0),
              Icon(
                  pickIcon(),
                  color: Colors.blue,
                  size: MediaQuery.of(context).size.width * 0.3
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: textInputDecoration.copyWith(hintText: 'myusername'),
                validator: (val) => val!.isEmpty ? 'Enter username' : null,
                onChanged: (val) {
                  setState(() => form = val);
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                  child: Text(
                    'Add',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                  ),
                  onPressed: () async {
                    CollectionReference users = FirebaseFirestore.instance.collection('users');
                    users.doc(user.uid).update({type: form})
                        .then((value) => print("User Updated"))
                        .catchError((error) => print("Failed to update user: $error"));

                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString(type, form);

                    Navigator.pop(context);
                  }
              ),
              SizedBox(height: 12.0),
            ],
          ),
        ),
      ),
    );
  }

  IconData pickIcon() {
    switch(type){
      case 'instagram':
        return FontAwesomeIcons.instagram;
      case 'facebook':
        return FontAwesomeIcons.facebook;
      case 'linkedin':
        return FontAwesomeIcons.linkedin;
      case 'snapchat':
        return FontAwesomeIcons.snapchat;
      case 'twitter':
        return FontAwesomeIcons.twitter;
      default:
        return FontAwesomeIcons.font;
    }
  }
}