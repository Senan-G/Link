import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:link/services/database.dart';
import 'userInfo.dart';
import 'database.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInEmail(String email, String password) async {
    try {
      UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      User? user = await result.user;


      return _createUser(user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await FirebaseAuth.instance.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  Future registerWithEmailAndPassword(String email, String password, String name, DateTime date) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = await result.user;

      await DatabaseService(uid: user!.uid).updateUserData(name);

      FirebaseFirestore.instance.collection('users').doc(user.uid).update({'birthdate': Timestamp.fromDate(date)});

      return _createUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  UserData _createUser(User? user){

    if (user != null) {
      return UserData(uid: user.uid);
    } else {
      return UserData(uid: "undefined");
    }
  }

  Stream<UserData> get user {
    return _auth.authStateChanges().map(_createUser);
  }
}