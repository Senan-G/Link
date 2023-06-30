import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../SharedParts/TitleText.dart';
import '../SubPages/LinkProfile.dart';
import '../services/userInfo.dart';

class Links extends StatefulWidget {
  const Links({Key? key}) : super(key: key);

  @override
  _LinksState createState() => _LinksState();
}

class _LinksState extends State<Links> {

  CollectionReference users = FirebaseFirestore.instance.collection('users');
  final storageRef = FirebaseStorage.instance.ref();

  @override
  Widget build(BuildContext context){

    return MaterialApp(
        home: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Color(0xFFE8F6FF),
            automaticallyImplyLeading: false,
            title: TitleText("Links"),
            centerTitle: true,
            elevation: 1,
          ),
          body: FutureBuilder<Object>(
            future: UserData.getLinkList(),
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                List<String> linkList = snapshot.data as List<String>;
                if(linkList.isEmpty){
                  return Center(
                    child: Text("Link list empty\nGo find some people!", textAlign: TextAlign.center,)
                  );
                }
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(25.0),
                      child: Stack(
                        children: [
                          Center(child: getBadge(linkList.length)),
                          Positioned.fill(
                              child: Align(
                                  child: TitleText(linkList.length.toString())
                              )
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                        child: Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(40, 0, 40, 10),
                          child: ListView.builder(
                            reverse: true,
                              shrinkWrap: true,
                              itemCount: linkList.length,
                              itemBuilder: (BuildContext context, int index) {

                                String uid = linkList.elementAt(index);

                                return FutureBuilder(
                                    future: users.doc(uid).get(),
                                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot<Object?>> snapshot) {
                                      Map<String, dynamic> data = snapshot.data?.data() as Map<String, dynamic>;
                                      var imageRef = storageRef.child("$uid/profile.png");

                                      if (snapshot.connectionState == ConnectionState.done) {
                                        return FutureBuilder(
                                            future: imageRef.getDownloadURL(),
                                            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

                                              if (snapshot.connectionState == ConnectionState.done) {
                                                String imageurl = snapshot.data!;
                                                return ListTile(
                                                    title: Text(data["name"]),
                                                    leading: Container(
                                                      clipBehavior: Clip.hardEdge,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                      child: Image.network(
                                                        imageurl,
                                                        width: 40,
                                                        height: 40,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    trailing: Container(
                                                      width: 35,
                                                      height: 35,
                                                      alignment: Alignment.center,
                                                      child: getBadge((data['linkList'] ?? []).length),
                                                    ),
                                                    onTap: () async {
                                                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => LinkProfile(data: data, uid: uid, imageurl: imageurl)));
                                                    }
                                                );
                                              }
                                              return SizedBox.shrink();
                                            }
                                        );
                                      }
                                      return SizedBox.shrink();
                                    });
                              }),
                        )
                    ),
                  ],
                );
              }
              else{
                return Center(child: CircularProgressIndicator(color: Colors.blue));
              }
            }
          ),
        )
    );
  }

  Image getBadge(int numLinks) {

    String name = 'assets/blankprofilepicture.png';

    if(numLinks <= 2)
      name = 'assets/introverted_makebadges-1669102852.png';
    else if(numLinks <= 5)
      name = 'assets/sociable_makebadges-1669102969.png';
    else if(numLinks <= 10)
      name = 'assets/neighborly_makebadges-1669103042.png';
    else
      name = 'assets/socialite_makebadges-1669103098.png';

    return Image.asset(
        name,
        width: MediaQuery.of(context).size.width * 0.3,
        height: MediaQuery.of(context).size.width * 0.3,
        fit: BoxFit.cover
    );
  }
}