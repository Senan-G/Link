import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:link/services/userInfo.dart';
import '../SharedParts/TitleText.dart';
import '../SubPages/FindLink.dart';
import '../services/userInfo.dart';


class LinkPage extends StatefulWidget {
  final Map<String, dynamic> data;
  final String uid;
  final String imageurl;

  const LinkPage({Key? key, required this.data, required this.uid, required this.imageurl}) : super(key: key);

  @override
  _LinkPageState createState() => _LinkPageState(data, uid, imageurl);

}

class _LinkPageState extends State<LinkPage> {

  _LinkPageState(this.data, this.uid, this.imageurl);
  Map<String, dynamic> data;
  String uid;
  String imageurl;


  @override
  Widget build(BuildContext context){

    final storageRef = FirebaseStorage.instance.ref();
    var imageRef = storageRef.child("$uid/profile.png");

    return MaterialApp(
        home: Scaffold(
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
            title: ElevatedButton(
              child: buttonText(
                'Link',
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => FindLink(data: data, peeruid: uid, imageurl: imageurl)));
              },
            ),
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
                          Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TitleText(data['name'] ?? "loading")
                              ],
                            ),
                          ),
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
                            padding: EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
    );
  }
}