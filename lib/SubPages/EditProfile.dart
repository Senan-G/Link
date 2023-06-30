import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:link/SubPages/AddSocialMedia.dart';
import '../MainPages/Settings.dart';
import '../SubPages/PickInterests.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:link/services/userInfo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../SharedParts/TitleText.dart';
import 'package:firebase_storage/firebase_storage.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();

}

class _EditProfileState extends State<EditProfile> {
  String uploadedFileUrl = '';
  TextEditingController quipController = TextEditingController(text: '');
  TextEditingController bioController = TextEditingController(text: '');
  final scaffoldKey = GlobalKey<ScaffoldState>();
  PlatformFile? pickedImage;

  getInfo() async {
    final prefs = await SharedPreferences.getInstance();
    quipController.text = prefs.getString('quip')!;
    bioController.text = prefs.getString('bio')!;
  }

  Future selectImage() async{
    final result = await FilePicker.platform.pickFiles();

    if(result == null) return;

    setState(() {
      pickedImage = result.files.first;
    });
  }

  @override
  void initState() {
    super.initState();
    getInfo();
  }


  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserData>(context);

    return Scaffold(
      key: scaffoldKey,
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
        title: subTitleText(
          'Edit Profile',
        ),
        actions: [
          IconButton(
              onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage()))
                  .then((_) => setState(() {}));
              },
              icon: Icon(Icons.settings, color: Colors.black,)
          ),
        ],
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
              padding: EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FutureBuilder(
                      future: UserData.getName(),
                      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {

                        if (snapshot.connectionState == ConnectionState.done) {
                          return TitleText(snapshot.data ?? 'error');
                        }

                        return Text("Loading");
                      }),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
              child: TextFormField(
                controller: quipController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Quip',
                  labelStyle: TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  hintText: 'Add a quote, job title or funny phrase...',
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
                  contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
                ),
                style: TextStyle(
                  fontFamily: 'Lexend Deca',
                  color: Color(0xFF14181B),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              )
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: (pickedImage == null)?
                  FutureBuilder(
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
                      }):
                  Image.file(
                    File(pickedImage!.path!),
                    width: MediaQuery.of(context).size.width * 0.6,
                    height: MediaQuery.of(context).size.width * 0.6,
                    fit: BoxFit.cover,
                  )
                ),
              ],
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      selectImage();
                    },
                    child:
                    buttonText(
                      'Change Photo',
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 0, 0),
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
                  EdgeInsetsDirectional.fromSTEB(30, 10, 0, 0),
                  child:
                  FutureBuilder(
                      future: UserData.getInterests(),
                      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {

                        if (snapshot.connectionState == ConnectionState.done) {
                          List<String> data = snapshot.data ?? ["error"];
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
              padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 16),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => PickInterests()))
                              .then((_) => setState(() {}));
                    },
                    child:
                    buttonText(
                      'Change Interests',
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(20, 0, 20, 12),
              child: TextFormField(
                controller: bioController,
                obscureText: false,
                decoration: InputDecoration(
                  labelText: 'Bio',
                  labelStyle: TextStyle(
                    fontFamily: 'Lexend Deca',
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                  hintText: 'A little about you...',
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
                  contentPadding: EdgeInsetsDirectional.fromSTEB(20, 24, 0, 24),
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
            ),
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FutureBuilder<String>(
                    future: UserData.getInstagram(),
                    builder: (context, snapshot) {
                      return IconButton(
                          onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddSocialMedia(type: 'instagram')))
                              .then((_) => setState(() {}));
                          },
                          icon: Icon(
                              FontAwesomeIcons.instagram,
                              color: snapshot.data != '' ? Colors.blue : Colors.grey,
                              size: MediaQuery.of(context).size.width * 0.1
                          )
                      );
                    }
                  ),
                  FutureBuilder<String>(
                      future: UserData.getSnapchat(),
                      builder: (context, snapshot) {
                        return IconButton(
                            onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddSocialMedia(type: 'snapchat')))
                                .then((_) => setState(() {}));
                            },
                            icon: Icon(
                                FontAwesomeIcons.snapchat,
                                color: snapshot.data != '' ? Colors.blue : Colors.grey,
                                size: MediaQuery.of(context).size.width * 0.1
                            )
                        );
                      }
                  ),
                  FutureBuilder<String>(
                      future: UserData.getFacebook(),
                      builder: (context, snapshot) {
                        return IconButton(
                            onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddSocialMedia(type: 'facebook')))
                                .then((_) => setState(() {}));
                            },
                            icon: Icon(
                                FontAwesomeIcons.facebook,
                                color: snapshot.data != '' ? Colors.blue : Colors.grey,
                                size: MediaQuery.of(context).size.width * 0.1
                            )
                        );
                      }
                  ),
                  FutureBuilder<String>(
                      future: UserData.getLinkedin(),
                      builder: (context, snapshot) {
                        return IconButton(
                            onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddSocialMedia(type: 'linkedin')))
                                .then((_) => setState(() {}));
                            },
                            icon: Icon(
                                FontAwesomeIcons.linkedin,
                                color: snapshot.data != '' ? Colors.blue : Colors.grey,
                                size: MediaQuery.of(context).size.width * 0.1
                            )
                        );
                      }
                  ),
                  FutureBuilder<String>(
                      future: UserData.getTwitter(),
                      builder: (context, snapshot) {
                        return IconButton(
                            onPressed: () {Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddSocialMedia(type: 'twitter')))
                                .then((_) => setState(() {}));
                            },
                            icon: Icon(
                                FontAwesomeIcons.twitter,
                                color: snapshot.data != '' ? Colors.blue : Colors.grey,
                                size: MediaQuery.of(context).size.width * 0.1
                            )
                        );
                      }
                  ),
                ],
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0, 0.05),
              child: Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 25, 0, 30),
                child: ElevatedButton(
                  onPressed: () async {
                    CollectionReference users = FirebaseFirestore.instance.collection('users');
                    DocumentSnapshot document = await users.doc(user.uid).get();
                    users.doc(user.uid).update({'quip': quipController.text})
                        .then((value) => print("User Updated"))
                        .catchError((error) => print("Failed to update user: $error"));
                    users.doc(user.uid).update({'bio': bioController.text})
                        .then((value) => print("User Updated"))
                        .catchError((error) => print("Failed to update user: $error"));

                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setString('quip', quipController.text);
                    await prefs.setString('bio', bioController.text);

                    if (pickedImage != null){
                      final File image = File(pickedImage!.path!);
                      final directory = (await getApplicationDocumentsDirectory()).path;
                      final File localImage = await image.copy('$directory/profile.png');
                      print("image updated locally $directory/profile.png");

                      final ref = FirebaseStorage.instance.ref().child(user.uid + "/profile.png");
                      ref.putFile(image);
                    }

                    Fluttertoast.showToast(
                      msg: 'Profile Updated',
                      backgroundColor: Colors.grey,
                    );

                    Navigator.pop(context);

                  },
                  child: buttonText(
                    'Save Changes',
                    ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue),
                  ),
                  ),
                ),
              ),
          ],
        ),
      ),
      ),
    );
  }
}