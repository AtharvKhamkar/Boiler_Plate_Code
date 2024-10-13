import 'dart:io';
import 'dart:math';

import 'package:ask_qx/services/method_channel_service.dart';
import 'package:ask_qx/utils/extension_utils.dart';
import 'package:flutter/material.dart';

import '../firebase/firebase_analytic_service.dart';
import '../network/error_handler.dart';
import '../themes/colors.dart';

class AppUtil{

  static String uniqueId() {
    const String charset = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final random = Random();
    String id = '';

    for (int i = 0; i < 10; i++) {
      int randomIndex = random.nextInt(charset.length);
      id += charset[randomIndex];
    }

    return id;
  }

   static String getLottieJson(DialogueType type){
    switch(type){
      case DialogueType.info:
        return 'info.json'.toJson;

      case DialogueType.warning:
        return 'warning.json'.toJson;

      case DialogueType.success:
        return 'success.json'.toJson;

      case DialogueType.error:
        return 'error.json'.toJson;

    }
  }
  static void launchReview([String event = "Click_Rate_Us"]) {
    FirebaseAnalyticService.instance.logEvent(event);

      final appId = Platform.isAndroid ? "com.qxlabai.askqx" : 'YOUR_IOS_APP_ID'; ///TODO: iOS App ID
      final url = (Platform.isAndroid ? "https://play.google.com/store/apps/details?id=$appId" : "https://apps.apple.com/app/id$appId");
      launchAppUrl(url.toString());

  }

  static void launchAppUrl(String url) async{
    try {
      await MethodChannelService.instance.openUrl(url);
    } catch (_) {}
  }

  static Color styleColor(String style) {
    switch(style.toLowerCase()){
      case "creative":
        return kSecondary;
      case "balanced":
        return Colors.blue.shade800;
      case "precise":
        return kThird;
      default :
        return Colors.blue.shade800;
    }
  }

}