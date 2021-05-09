import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';


class PushNotificationsManager {

  PushNotificationsManager._();

  factory PushNotificationsManager() => _instance;

  static final PushNotificationsManager _instance = PushNotificationsManager._();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions();
      _firebaseMessaging.configure(
        onMessage: (Map<String, dynamic> message) async {

        },
        onLaunch: (Map<String, dynamic> message) async {

        },
        onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
        },
      );

      _initialized = true;
    }
  }
}