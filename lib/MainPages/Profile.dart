import 'dart:io';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link/services/userInfo.dart';
import 'package:url_launcher/url_launcher.dart';
import '../SharedParts/TitleText.dart';
import '../SubPages/EditProfile.dart';
import '../services/userInfo.dart';


class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();

}

class _ProfileState extends State<Profile> {


  @override
  Widget build(BuildContext context){


    return Scaffold(
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
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const SizedBox(width: 40.0),
                                FutureBuilder(
                                  future: UserData.getName(),
                                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

                                    if (snapshot.connectionState == ConnectionState.done) {
                                      return TitleText(snapshot.data ?? 'error');
                                    }

                                    return Text("Loading");
                                  }),
                                IconButton(
                                    onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => EditProfile()))
                                        .then((_) => setState(() {}));
                                    },
                                    icon: Icon(Icons.edit)
                                )
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                                  FutureBuilder<String>(
                                    future: UserData.getQuip(),
                                    builder: (context, snapshot) {

                                      if (snapshot.connectionState == ConnectionState.done) {
                                        return Text(
                                          snapshot.data ?? "error",
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 13,
                                          ),
                                        );
                                      }

                                      return SizedBox.shrink();
                                    }
                                  ),
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
                                  child: FutureBuilder(
                                      future: UserData.getImage(),
                                      builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {

                                        if (snapshot.connectionState == ConnectionState.done) {
                                          File? data = snapshot.data;
                                          if(data == null){
                                            return Image.asset(
                                              'assets/blankprofilepicture.png',
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              height: MediaQuery.of(context).size.width * 0.6,
                                              fit: BoxFit.cover,
                                            );
                                          }else {
                                            return Image.file(
                                              data,
                                              width: MediaQuery.of(context).size.width * 0.6,
                                              height: MediaQuery.of(context).size.width * 0.6,
                                              fit: BoxFit.cover,
                                            );
                                          }
                                        }

                                        return Image.asset(
                                          'assets/blankprofilepicture.png',
                                          width: MediaQuery.of(context).size.width * 0.6,
                                          height: MediaQuery.of(context).size.width * 0.6,
                                          fit: BoxFit.cover,
                                        );
                                      }),
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
                                        List<String> data = snapshot.data ?? ["error"];

                                        if(data.isEmpty){
                                          return Text("No interests picked out yet :(");
                                        }

                                        return Row(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [for(int i = 0; i < 5 && i < data.length; i++)
                                                  Text(data.elementAt(i),
                                                    style: TextStyle(
                                                    fontFamily: 'Poppins',
                                                    fontSize: 13,
                                                ),)]
                                            ),
                                            SizedBox(width: 40),
                                            Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [for(int i = 5; i < 10 && i < data.length; i++)
                                                  Text(data.elementAt(i),
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
                                FutureBuilder(
                                    future: UserData.getAge(),
                                    builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

                                      if (snapshot.connectionState == ConnectionState.done) {
                                        return subTitleText(
                                          'About Me      ' + (snapshot.data ?? 'error'),
                                        );
                                      }

                                      return Text("Loading");
                                    }),

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
                                  child: FutureBuilder(
                                      future: UserData.getBio(),
                                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

                                        if (snapshot.connectionState == ConnectionState.done) {
                                          return Text(
                                            snapshot.data ?? "error",
                                            style: TextStyle(
                                              fontFamily: 'Poppins',
                                              fontSize: 13,
                                            ),
                                          );
                                        }

                                        return Text("Loading");
                                      }),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 40.0),
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

    String instagram = await UserData.getInstagram() ?? '';
    String snapchat = await UserData.getSnapchat() ?? '';
    String facebook = await UserData.getFacebook() ?? '';
    String linkedin = await UserData.getLinkedin() ?? '';
    String twitter = await UserData.getTwitter() ?? '';

    if (instagram != '') {
      arr.add(IconButton(
          onPressed: () async {
            Uri nativeUrl = Uri.parse("instagram://user?username=$instagram");
            Uri webUrl = Uri.parse("https://www.instagram.com/$instagram/");
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
    if (snapchat != '') {
      arr.add(IconButton(
          onPressed: () async {
            Uri nativeUrl = Uri.parse("snapchat://add/$snapchat/");
            Uri webUrl = Uri.parse("https://snapchat.com/add/$snapchat/");
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
    if (facebook != '') {
      arr.add(IconButton(
          onPressed: () async {
            Uri nativeUrl = Uri.parse("fb://profile/$facebook/");
            Uri webUrl = Uri.parse("https://www.facebook.com/$facebook/");
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
    if (linkedin != '') {
      arr.add(IconButton(
          onPressed: () async {
            Uri nativeUrl = Uri.parse("linkedin://profile/$linkedin/");
            Uri webUrl = Uri.parse("https://www.linkedin.com/in/$linkedin/");
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
    if (twitter != '') {
      arr.add(IconButton(
          onPressed: () async {
            Uri nativeUrl = Uri.parse("twitter://$twitter/");
            Uri webUrl = Uri.parse("https://www.twitter.com/$twitter/");
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
}