import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';

Future _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Handling background notification: ${message.messageId}");
}

class PushNotification{
  PushNotification({
    this.title,
    this.body,
  });
  String? title;
  String? body;
}

class NotificationHandler {
  late final FirebaseMessaging _messaging;
  PushNotification? _notificationInfo;

  void requestNotification() async {
    await Firebase.initializeApp();

    _messaging = FirebaseMessaging.instance;
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted notification permission');

      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        PushNotification notification = PushNotification(
          title: message.notification?.title,
          body: message.notification?.body,
        );

        _notificationInfo = notification;

        if (_notificationInfo != null) {
          showSimpleNotification(
            Text(_notificationInfo!.title!),
            leading: Text(_notificationInfo!.title!),
            subtitle: Text(_notificationInfo!.body!),
            background: Colors.cyan.shade700,
            duration: Duration(seconds: 2),
          );
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }
}