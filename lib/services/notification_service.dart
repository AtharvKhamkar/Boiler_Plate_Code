import 'dart:convert';
import 'dart:math';
import 'package:ask_qx/services/upgrader_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {

  NotificationService._internal();

  static final NotificationService _service = NotificationService._internal();

  static NotificationService get service => _service;

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  ///Android
  final androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'AskQx','AskQxChannel', //Required for Android 8.0 or after
    channelDescription: 'All AskQx notification will get on this channel.', //Required for Android 8.0 or after
    importance: Importance.max,
    priority: Priority.high,
    channelShowBadge: true,
    visibility: NotificationVisibility.public,
    autoCancel: true,
    category: AndroidNotificationCategory.promo,
  );

  ///iOS Permission Setting
  final DarwinInitializationSettings _initializationSettingsIOS =const DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  final DarwinNotificationDetails _iOSPlatformChannelSpecifics = const DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    threadIdentifier: 'askqx',
  );


  ///Android Permission Setting
  final AndroidInitializationSettings _initializationSettingsAndroid =  const AndroidInitializationSettings('@drawable/ic_notification');


  Future<void> init() async{

    InitializationSettings initializationSettings = InitializationSettings(
      android: _initializationSettingsAndroid,
      iOS: _initializationSettingsIOS,
      macOS: null,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,onDidReceiveNotificationResponse: selectNotification,);
  }

  void show({String title = '',String body = '',String? data})async{

    final platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics,iOS: _iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(10000),
      title,
      body,
      platformChannelSpecifics,
      payload: '$data',
    );

  }

  Future selectNotification(NotificationResponse payload) async {
    if(payload.payload!=null){
      handleActions(payload.payload!);
    }
  }

  Future handleActions(String payload) async {
    try{
      Map map = jsonDecode(payload);
      if(map.containsKey("is_update") && map['is_update'] == "true"){
        UpgraderService.instance.isAvailable();
      }
    }catch(_){}
  }

}