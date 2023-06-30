import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import '../SharedParts/TitleText.dart';
import '../services/chat.dart';
import '../services/userInfo.dart';

class Feed extends StatefulWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {

  DatabaseReference ref = FirebaseDatabase.instance.ref("feed");
  late LocationData location;
  List<String> nearbyMessages = [];
  String myuid = '';

  TextEditingController textEditingController = TextEditingController();
  ChatProvider chat = ChatProvider();

  @override
  void initState() {
    super.initState();
    setState(() {
      Geofire.initialize("feed");
    });
  }

  @override
  Widget build(BuildContext context){

    myuid = Provider.of<UserData>(context, listen: false).uid;

    return MaterialApp(
        home: Scaffold(
          body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    buildListMessage(context),
                    buildMessageInput(),
                  ],
                ),
              )
          )
        )
    );
  }

  Widget buildMessageInput() {
    Future<void> onSendMessage(String content) async {
      if (content.trim().isNotEmpty) {
        location = await Location().getLocation();
        textEditingController.clear();
        String time = DateTime.now().millisecondsSinceEpoch.toString();
        await Geofire.setLocation(time, location.latitude ?? 0.0, location.longitude ?? 0.0);
        //await ref.update({time + "/msg": content, time + "/uid": myuid});
      } else {
        Fluttertoast.showToast(
            msg: 'Nothing to send', backgroundColor: Colors.grey);
      }
    }

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 4),
            decoration: BoxDecoration(
              color: Colors.lightBlue,
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          Flexible(
              child: TextField(
                textInputAction: TextInputAction.send,
                keyboardType: TextInputType.text,
                textCapitalization: TextCapitalization.sentences,
                controller: textEditingController,
                onSubmitted: (value) {
                  onSendMessage(textEditingController.text);
                },
              )),
          Container(
            margin: const EdgeInsets.only(left: 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
            ),
            child: IconButton(
              onPressed: () {
                onSendMessage(textEditingController.text);
              },
              icon: const Icon(Icons.send_rounded),
              color: Colors.lightBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, int index, String message) {
    DatabaseReference ref = FirebaseDatabase.instance.ref();


    return FutureBuilder<DataSnapshot>(
        future: ref.child("feed/" + message).get(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot);
            Map map = snapshot.data?.children as Map;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 10),
                Text(
                  map['message'],
                )
              ],
            );
          }
          else
            return SizedBox.shrink();
        }
    );
  }

  Widget buildListMessage(BuildContext context) {

    return FutureBuilder<LocationData>(
      future: Location().getLocation(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          location = snapshot.data as LocationData;
          var callBack;

          Geofire.queryAtLocation(location.latitude ?? 0.0, location.longitude ?? 0.0, 2.0)?.listen((map) {
            nearbyMessages.clear();
            if (map != null) {
              callBack = map['callBack'];
              if (callBack == Geofire.onGeoQueryReady){
                map["result"].forEach((key){
                  //print("msg key: " + key);
                  nearbyMessages.add(key.toString());
                });
                return;
              }
            }
            if (!mounted) return;
          });

          if(callBack == Geofire.onGeoQueryReady)
            Geofire.stopListener();
          print(nearbyMessages);

          if(nearbyMessages.isNotEmpty) {
            return Flexible(
                child: ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: nearbyMessages.length,
                    reverse: true,
                    itemBuilder: (context, index) =>
                        buildItem(context, index, nearbyMessages[index])
                )
            );
          }
          else
            return Center(child: Text("No Local Messages"));
        }
        else
          return Center(child: CircularProgressIndicator(color: Colors.blue));
      }
    );
  }
}