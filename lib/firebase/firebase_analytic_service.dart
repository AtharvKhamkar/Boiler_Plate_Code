
import 'dart:io';

import 'package:ask_qx/global/app_storage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

class FirebaseAnalyticService{
  FirebaseAnalyticService._();

  static final FirebaseAnalyticService _instance = FirebaseAnalyticService._();

  static FirebaseAnalyticService get instance => _instance;


  Future<void> init() async {
    await FirebaseAnalytics.instance.setAnalyticsCollectionEnabled(true);
    await FirebaseAnalytics.instance.logScreenView();
  }



  
  Future<void> logEvent(String name,{Map<String,dynamic> data = const {}}) async {
    if(kDebugMode || AppStorage.isDevBuild()) return;
    Map<String,dynamic> parameters = {
      "datetime":DateTime.now().toLocal().toString(),
    };

    parameters.addAll(data);

    await FirebaseAnalytics.instance.logEvent(name: name,parameters: parameters);
  }

  void userDefaults() {
    var countryCode = PlatformDispatcher.instance.locale.countryCode;

    if (countryCode != null) {
      FirebaseAnalytics.instance.setUserProperty(name: 'country', value: countryCode);
    }

    if (AppStorage.isLoggedIn()) {
      final user = AppStorage.getUserDetails();
      FirebaseAnalytics.instance.setUserProperty(name: 'user_name', value: user.firstName);
      FirebaseAnalytics.instance.setUserId(id: user.userId);
    }

    FirebaseAnalytics.instance.setUserProperty(name: 'platform', value: Platform.isAndroid ? "ANDROID" : 'IOS');
  }
}
