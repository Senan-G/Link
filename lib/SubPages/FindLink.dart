import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link/SharedParts/TitleText.dart';
import 'package:link/SubPages/LinkProfile.dart';
import 'package:link/services/userInfo.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/chat.dart';
import '../services/userInfo.dart';
import 'package:breathing_collection/breathing_collection.dart';

import 'Linked.dart';


class FindLink extends StatefulWidget {
  final Map<String, dynamic> data;
  final String peeruid;
  final String imageurl;

  const FindLink({Key? key, required this.data, required this.peeruid, required this.imageurl}) : super(key: key);

  @override
  _FindLinkState createState() => _FindLinkState(data, peeruid, imageurl);

}

class _FindLinkState extends State<FindLink> {
  bool linked = false;


  _FindLinkState(this.data, this.peeruid, this.imageurl);

  Map<String, dynamic> data;
  String peeruid;
  String imageurl;
  String myuid = '';
  String groupChatId = '';
  String status = '';
  int myLastButtonPress = 0;
  int peerLastButtonPress = 0;

  TextEditingController textEditingController = TextEditingController();
  ChatProvider chat = ChatProvider();


  @override
  Widget build(BuildContext context) {
    myuid = Provider.of<UserData>(context, listen: false).uid;
    groupChatId = (myuid.hashCode + peeruid.hashCode).toString();

    return Scaffold(
          appBar: AppBar(
            title: Text("Find Link"),
            centerTitle: true,
            backgroundColor: Colors.white,
            leading: InkWell(
              onTap: () async {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.clear,
                color: Colors.black,
                size: 24,
              ),
            ),
          ),
            body: SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: BreathingGlowingButton(
                            height: MediaQuery.of(context).size.width * 0.6,
                            width: MediaQuery.of(context).size.width * 0.6,
                            buttonBackgroundColor: Colors.lightBlue,
                            icon: FontAwesomeIcons.link,
                            iconColor: Colors.white,
                            glowColor: Colors.lightBlueAccent,
                            onTap: () {
                              chat.sendChatMessage("Button Pressed", groupChatId, myuid, 'system');
                            }
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Press button simultaneously to Link!"),
                    SizedBox(height: 20),
                    buildListMessage(context),
                    buildMessageInput(),
                  ],
                ),
              )    ,
            )
        );
  }

  Widget buildMessageInput() {

    void onSendMessage(String content) {
      if (content.trim().isNotEmpty) {
        textEditingController.clear();
        chat.sendChatMessage(
            content, groupChatId, myuid, peeruid);
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
                //focusNode: focusNode,
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

  Widget buildItem(BuildContext context, int index, DocumentSnapshot? documentSnapshot) {
    if (documentSnapshot != null) {
      ChatMessage chatMessage = ChatMessage.fromDocument(documentSnapshot);
      if (chatMessage.content == 'Button Pressed' && chatMessage.idTo == 'system'){
        if (chatMessage.idFrom == peeruid){
          peerLastButtonPress = int.parse(chatMessage.timestamp);
        }
        else if (chatMessage.idFrom == myuid){
          myLastButtonPress = int.parse(chatMessage.timestamp);
        }
        if ((myLastButtonPress - peerLastButtonPress).abs() < 2000){
          link(context);
        }
        return SizedBox.shrink();
      }
      else if (chatMessage.idTo == 'system'){
        return Center(
            child: Text(
              chatMessage.content,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            )
        );
      }
      else if (chatMessage.idFrom == myuid) {
        // right side (my message)
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  chatMessage.content,
                ),
                const SizedBox(width: 10),
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: FutureBuilder(
                      future: UserData.getImage(),
                      builder: (BuildContext context, AsyncSnapshot<File?> snapshot) {

                        if (snapshot.connectionState == ConnectionState.done) {
                          File? data = snapshot.data;
                          if(data == null){
                            return Image.asset(
                              'assets/blankprofilepicture.png',
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            );
                          }else {
                            return Image.file(
                              data,
                              width: 40,
                              height: 40,
                              fit: BoxFit.cover,
                            );
                          }
                        }

                        return Image.asset(
                          'assets/blankprofilepicture.png',
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                        );
                      }),
                ),
              ],
            ),
          ],
        );
      } else {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                // left side (received message)
                Container(
                  clipBehavior: Clip.hardEdge,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: (imageurl == null) ?
                  Image.asset(
                      'assets/blankprofilepicture.png',
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    )
                      : Image.network(
                      imageurl,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                ),
                const SizedBox(width: 10),
                Text(
                  chatMessage.content,
                )
              ],
            ),
          ],
        );
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  Widget buildListMessage(BuildContext context) {
    ChatProvider chatProvider = ChatProvider();

    return Flexible(
      child: groupChatId.isNotEmpty
          ? StreamBuilder<QuerySnapshot>(
          stream: chatProvider.getChatMessage(groupChatId, 20),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              var listMessages = snapshot.data!.docs;
              if (listMessages.isNotEmpty) {
                return ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: snapshot.data?.docs.length,
                    reverse: true,
                    itemBuilder: (context, index) =>
                        buildItem(context, index, snapshot.data?.docs[index]));
              } else {
                chat.initialize(groupChatId, myuid, data);
                return Center(
                  child: Text("Loading Chat"),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.red,
                ),
              );
            }
          })
          : const Center(
        child: CircularProgressIndicator(
          color: Colors.red,
        ),
      ),
    );
  }

  void link(BuildContext context) async{

    CollectionReference users = FirebaseFirestore.instance.collection('users');
    final prefs = await SharedPreferences.getInstance();
    List<String> newList = prefs.getStringList('linkList') ?? [];

    if(!newList.contains(peeruid)) {
      newList.add(peeruid);
    }

    await users.doc(myuid).update({'linkList': newList})
        .then((value) => print("Link list Updated"))
        .catchError((error) => print("Failed to update link list: $error"));

    await prefs.setStringList('linkList', newList);



    Navigator.of(context).pop(context);
    Navigator.of(context).pop(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => LinkProfile(data: data, uid: peeruid, imageurl: imageurl)));
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => Linked()));
  }
}