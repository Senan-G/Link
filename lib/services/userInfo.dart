import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class UserData {

  final String uid;

  UserData({required this.uid}) {
    setPrefs();
  }

  setPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    DocumentSnapshot document = await users.doc(uid).get();
    Map<String, dynamic> data = document.data() as Map<String, dynamic>;
    final storageRef = FirebaseStorage.instance.ref();
    final FirebaseMessaging _messaging = FirebaseMessaging.instance;

    String? token = await _messaging.getToken();
    users.doc(uid).update({'notificationToken': token})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

    var imageRef = storageRef.child("$uid/profile.png");
    final directory = (await getApplicationDocumentsDirectory()).path;
    imageRef.writeToFile(File('$directory/profile.png'));


    await prefs.setString('name', data['name']);
    await prefs.setString('quip', data['quip']);
    await prefs.setString('bio', data['bio']);
    await prefs.setDouble('minAge', (data['minAge'] ?? 0).toDouble());
    await prefs.setDouble('maxAge', (data['maxAge'] ?? 0).toDouble());
    await prefs.setString('age', (DateTime.now().year - data['birthdate'].toDate().year).toString());
    await prefs.setStringList('linkList', (data['linkList'] ?? []).cast<String>());
    await prefs.setStringList('blockedList', (data['blockedList'] ?? []).cast<String>());
    await prefs.setStringList('interests', (data['interests'] ?? []).cast<String>());

    await prefs.setString('instagram', data['instagram'] ?? '');
    await prefs.setString('snapchat', data['snapchat'] ?? '');
    await prefs.setString('facebook', data['facebook'] ?? '');
    await prefs.setString('linkedin', data['linkedin'] ?? '');
    await prefs.setString('twitter', data['twitter'] ?? '');
  }

  static Future<String> getName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('name') ?? 'Name';
  }
  static Future<String> getQuip() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('quip') ?? 'Add a funny quote, job title or interesting fact';
  }
  static Future<String> getBio() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('bio') ?? 'Add a short description of you';
  }
  static Future<RangeValues> getAgeRange() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return new RangeValues(prefs.getDouble('minAge') ?? 0.0, prefs.getDouble('maxAge') ?? 0.0);
  }
  static Future<String> getAge() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('age') ?? 'error';
  }
  static Future<List<String>> getInterests() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('interests') ?? [];
  }

  static Future<List<String>> getLinkList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('linkList') ?? [];
  }

  static Future<List<String>> getBlockedList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('blockedList') ?? [];
  }

  static Future<File?> getImage() async {
    final Directory directory = await getApplicationDocumentsDirectory();
    var path = directory.path;

    if(File("$path/profile.png").existsSync())
      return File("$path/profile.png");

    return null;
  }

  static Future<String> getInstagram() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('instagram') ?? '';
  }
  static Future<String> getSnapchat() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('snapchat') ?? '';
  }
  static Future<String> getFacebook() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('facebook') ?? '';
  }
  static Future<String> getLinkedin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('linkedin') ?? '';
  }
  static Future<String> getTwitter() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('twitter') ?? '';
  }

  static Future<void> clear() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}