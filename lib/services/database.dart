import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  final String uid;
  DatabaseService({required this.uid});

  final CollectionReference firestore = FirebaseFirestore.instance.collection('users');

  Future updateUserData(String name) async {

    return await firestore.doc(uid).set({'name': name})
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));

  }
}