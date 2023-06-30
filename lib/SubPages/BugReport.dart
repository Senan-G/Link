import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../SharedParts/constants.dart';
import '../services/userInfo.dart';

class BugReport extends StatefulWidget {


  @override
  _BugReportState createState() => _BugReportState();
}

class _BugReportState extends State<BugReport> {

  String form = '';


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserData>(context);

    return Scaffold(
      backgroundColor: Color(0xFFE8F6FF),
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0.0,
        title: Text('Report Bug'),
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
                  Icons.bug_report_outlined,
                  color: Colors.blue,
                  size: MediaQuery.of(context).size.width * 0.3
              ),
              SizedBox(height: 20.0),
              TextFormField(
                validator: (val) => val!.isEmpty ? 'Enter some info' : null,
                onChanged: (val) {
                  setState(() => form = val);
                },
                obscureText: false,
                decoration: InputDecoration(
                  labelStyle: TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  hintText: 'Describe your bug...',
                  hintStyle: TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Color(0xFF95A1AC),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFDBE2E7),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFDBE2E7),
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsetsDirectional.fromSTEB(20, 40, 0, 25),
                ),
                style: TextStyle(
                  fontFamily: 'Lexend Deca',
                  color: Color(0xFF14181B),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
                textAlign: TextAlign.start,
                maxLines: 3,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                  child: Text(
                    'Report',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                  ),
                  onPressed: () async {
                    CollectionReference bugs = FirebaseFirestore.instance.collection('bugs');
                    bugs.doc(DateTime.now().millisecondsSinceEpoch.toString()).set({'uid': user.uid, 'report' : form})
                        .then((value) => print("Bug Submitted"))
                        .catchError((error) => print("Failed to submit bug: $error"));

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
}