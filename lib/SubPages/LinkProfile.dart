import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link/services/userInfo.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../SharedParts/TitleText.dart';
import '../services/userInfo.dart';


class LinkProfile extends StatefulWidget {
  final Map<String, dynamic> data;
  final String uid;
  final String imageurl;

  const LinkProfile({Key? key, required this.data, required this.uid, required this.imageurl}) : super(key: key);

  @override
  _LinkProfileState createState() => _LinkProfileState(data, uid, imageurl);

}

class _LinkProfileState extends State<LinkProfile> {

  _LinkProfileState(this.data, this.uid, this.imageurl);
  Map<String, dynamic> data;
  String uid;
  String imageurl;

  @override
  Widget build(BuildContext context){

    return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
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
            title: TitleText(data['name'] ?? "loading"),
            actions: [],
            centerTitle: true,
            elevation: 0,
          ),
          backgroundColor: Colors.white,
          body: SafeArea(
            child: SingleChildScrollView(
              primary: true,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(data['quip'],
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 13,
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: (imageurl == null) ? Image.asset(
                                      'assets/blankprofilepicture.png',
                                      width: MediaQuery.of(context).size.width * 0.6,
                                      height: MediaQuery.of(context).size.width * 0.6,
                                      fit: BoxFit.cover,
                                    )
                                        : Image.network(
                                      imageurl,
                                      width: MediaQuery.of(context).size.width * 0.6,
                                      height: MediaQuery.of(context).size.width * 0.6,
                                      fit: BoxFit.cover,
                                    )
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                            child: FutureBuilder<List<Widget>>(
                                future: getSocials(),
                                builder: (context, snapshot) {

                                  if (snapshot.connectionState == ConnectionState.done) {
                                    return Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: snapshot.data ?? [],
                                    );
                                  }

                                  return SizedBox.shrink();
                                }
                            ),
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                subTitleText(
                                  'Interests',
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Padding(
                                padding:
                                EdgeInsetsDirectional.fromSTEB(10, 10, 0, 0),
                                child:
                                FutureBuilder(
                                    future: UserData.getInterests(),
                                    builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {

                                      if (snapshot.connectionState == ConnectionState.done) {
                                        List<String> myInterests = snapshot.data ?? ["error"];
                                        List<String> linkInterests = data["interests"].cast<String>();
                                        return Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [for(int i = 0; i < 5 && i < linkInterests.length; i++)
                                                  Text(linkInterests.elementAt(i),
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 13,
                                                      color: myInterests.contains(linkInterests.elementAt(i)) ? Colors.lightBlue : null,
                                                    ),
                                                  )
                                                ]
                                            ),
                                            SizedBox(width: 40),
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [for(int i = 5; i < 10 && i < linkInterests.length; i++)
                                                  Text(linkInterests.elementAt(i),
                                                    style: TextStyle(
                                                      fontFamily: 'Poppins',
                                                      fontSize: 13,
                                                    ),)]
                                            ),
                                          ],
                                        );
                                      }

                                      return Text("Loading");
                                    }),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                subTitleText('About Me      ' +
                                    (DateTime.now().year - (data['birthdate']).toDate().year).toString()),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding:
                                  EdgeInsetsDirectional.fromSTEB(10, 10, 0, 0),
                                  child: Text(
                                    data["bio"] ?? "error",
                                    style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40.0),
                          OutlinedButton(
                            child: Text('Block Link',
                                style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              showBlockDialog(context);
                            },
                          ),
                          SizedBox(height: 20.0),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
    );
  }

  Future<List<Widget>> getSocials() async {
    List<Widget> arr = [];


    if (data['instagram'] != '' && data['instagram'] != null) {
      arr.add(IconButton(
          onPressed: () async {
            Uri nativeUrl = Uri.parse("instagram://user?username=${data['instagram']}");
            Uri webUrl = Uri.parse("https://www.instagram.com/${data['instagram']}/");
            if (await canLaunchUrl(nativeUrl)) {
              await launchUrl(nativeUrl);
            } else if (await canLaunchUrl(webUrl)) {
              await launchUrl(webUrl);
            } else {
            print("can't open Instagram");
            }
          },
          icon: Icon(
              FontAwesomeIcons.instagram,
              color: Colors.blue,
              size: MediaQuery.of(context).size.width * 0.1
          )
      ));
    }
    if (data['snapchat'] != '' && data['snapchat'] != null) {
      arr.add(IconButton(
          onPressed: () async {
            Uri nativeUrl = Uri.parse("snapchat://add/${data['snapchat']}/");
            Uri webUrl = Uri.parse("https://snapchat.com/add/${data['snapchat']}/");
            if (await canLaunchUrl(nativeUrl)) {
              await launchUrl(nativeUrl);
            } else if (await canLaunchUrl(webUrl)) {
              await launchUrl(webUrl);
            } else {
              print("can't open Snapchat");
            }
          },
          icon: Icon(
              FontAwesomeIcons.snapchat,
              color: Colors.blue,
              size: MediaQuery.of(context).size.width * 0.1
          )
      ));
    }
    if (data['facebook'] != '' && data['facebook'] != null) {
      arr.add(IconButton(
          onPressed: () async {
            Uri nativeUrl = Uri.parse("fb://profile/${data['facebook']}/");
            Uri webUrl = Uri.parse("https://www.facebook.com/${data['facebook']}/");
            if (false) {
              await launchUrl(nativeUrl);
            } else if (await canLaunchUrl(webUrl)) {
              await launchUrl(webUrl);
            } else {
              print("can't open Facebook");
            }
          },
          icon: Icon(
              FontAwesomeIcons.facebook,
              color: Colors.blue,
              size: MediaQuery.of(context).size.width * 0.1
          )
      ));
    }
    if (data['linkedin'] != '' && data['linkedin'] != null) {
      arr.add(IconButton(
          onPressed: () async {
            Uri nativeUrl = Uri.parse("linkedin://profile/${data['linkedin']}/");
            Uri webUrl = Uri.parse("https://www.linkedin.com/in/${data['linkedin']}/");
            if (await canLaunchUrl(nativeUrl)) {
              await launchUrl(nativeUrl);
            } else if (await canLaunchUrl(webUrl)) {
              await launchUrl(webUrl);
            } else {
              print("can't open Linkedin");
            }
          },
          icon: Icon(
              FontAwesomeIcons.linkedin,
              color: Colors.blue,
              size: MediaQuery.of(context).size.width * 0.1
          )
      ));
    }
    if (data['linkedin'] != '' && data['linkedin'] != null) {
      arr.add(IconButton(
          onPressed: () async {
            Uri nativeUrl = Uri.parse("twitter://${data['linkedin']}/");
            Uri webUrl = Uri.parse("https://www.twitter.com/${data['linkedin']}/");
            if (await canLaunchUrl(nativeUrl)) {
              await launchUrl(nativeUrl);
            } else if (await canLaunchUrl(webUrl)) {
              await launchUrl(webUrl);
            } else {
              print("can't open Twitter");
            }
          },
          icon: Icon(
              FontAwesomeIcons.twitter,
              color: Colors.blue,
              size: MediaQuery.of(context).size.width * 0.1
          )
      ));
    }

    return arr;
  }

  void showBlockDialog(BuildContext context) {

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Are you sure?"),
          content: Text("Blocking this link will remove them from your link list and prevent any future links"),
          actions: [
            TextButton(
              child: Text("Cancel"),
              onPressed:  () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text("Block",
                style: TextStyle(color: Colors.red),
              ),
              onPressed:  () async {

                final myuid = Provider.of<UserData>(context, listen: false).uid;
                CollectionReference users = FirebaseFirestore.instance.collection('users');
                final prefs = await SharedPreferences.getInstance();
                List<String> newLinkList = prefs.getStringList('linkList') ?? [];
                List<String> newBlockList = prefs.getStringList('blockedList') ?? [];

                newLinkList.remove(uid);
                newBlockList.add(uid);

                //update my link list and blocked list
                await users.doc(myuid).update({'linkList': newLinkList})
                    .then((value) => print("Link list Updated"))
                    .catchError((error) => print("Failed to update link list: $error"));
                await prefs.setStringList('linkList', newLinkList);

                await users.doc(myuid).update({'blockedList': newBlockList})
                    .then((value) => print("Blocked list Updated"))
                    .catchError((error) => print("Failed to update blocked list: $error"));
                await prefs.setStringList('blockedList', newBlockList);


                //update their link list and blocked list
                DocumentSnapshot theirDocument = await users.doc(uid).get();
                Map<String, dynamic> theirData = theirDocument.data() as Map<String, dynamic>;
                newLinkList = (theirData['linkList'] ?? []).cast<String>();
                newBlockList = (theirData['blockedList'] ?? []).cast<String>();
                newLinkList.remove(myuid);
                newBlockList.add(myuid);

                await users.doc(uid).update({'linkList': newLinkList})
                    .then((value) => print("Link list Updated"))
                    .catchError((error) => print("Failed to update link list: $error"));
                await users.doc(uid).update({'blockedList': newBlockList})
                    .then((value) => print("Blocked list Updated"))
                    .catchError((error) => print("Failed to update blocked list: $error"));


                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}