import 'dart:convert';

import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../adjust/adjust_services.dart';

class FirebaseMessageService {
  FirebaseMessageService._();

  static final FirebaseMessageService _instance = FirebaseMessageService._();

  static FirebaseMessageService get instance => _instance;

  Future<void> permission() async {
    FirebaseMessaging.instance.requestPermission(
      alert: true,
      sound: true,
      badge: true
    ).then((value){
      token();
    });
  }

  Future<void> token() async {
    //This will give us the FCM token
    FirebaseMessaging.instance.getToken().then((value){
      AdjustServices.instance.adjustPushToken(value??"");
      AppStorage.setFcmToken(value??"");
    });

    //This will give us the FCM token after
    //deleting the token.
    FirebaseMessaging.instance.onTokenRefresh.listen((event) {
      AdjustServices.instance.adjustPushToken(event);
      AppStorage.setFcmToken(event);
    });
  }

  Future<void> receiveMessage() async {
    //To listen to messages whilst your application is in the foreground, listen to the onMessage stream.
    FirebaseMessaging.onMessage.listen((event) {
      NotificationService.service.show(
        title: event.notification!.title ?? "",
        body: event.notification!.body?? "",
        data: jsonEncode(event.data),
      );
    });

    //When the application is open, however in the background (minimised). This
    // typically occurs when the user has pressed the "home" button on the device,
    // has switched to another app via the app switcher or has
    // the application open on a different tab (web).
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      NotificationService.service.handleActions(jsonEncode(event.data));
    });

    //When the device is locked or the application is not running. The user can
    // terminate an app by "swiping it away" via the app switcher
    // UI on the device or closing a tab (web).
    FirebaseMessaging.instance.getInitialMessage().then((value){
      if(value!=null){
        NotificationService.service.handleActions(jsonEncode(value.data));
      }
    });
  }

  Future<void> tokenRefresh() async {
    FirebaseMessaging.instance.deleteToken().then((value){
      token();
    });
  }

}