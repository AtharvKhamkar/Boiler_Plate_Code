import 'dart:convert';

import 'package:adjust_sdk/adjust.dart';
import 'package:adjust_sdk/adjust_config.dart';
import 'package:adjust_sdk/adjust_event.dart';
import 'package:ask_qx/model/adjust.dart';
import 'package:ask_qx/utils/extension_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import '../firebase/remote_config_service.dart';
import '../services/method_channel_service.dart';

class AdjustServices {
  AdjustServices._();
  static final AdjustServices _instance = AdjustServices._();

  static AdjustServices get instance => _instance;

  AdjustModel? data;

  static String? registrationComplete;
  static String? registrationInitiated;
  static String? firstPrompt;
  static String? loginSuccess;
  static String? deleteAccount;
  static String? AppToken ;

  Future<void> init() async {
    var tokenPath = 'adjust_service.json'.toJson;
    var tokenData =await rootBundle.loadString(tokenPath);
    data = AdjustModel.fromJson(json.decode(tokenData));
    // data = RemoteConfigService.instance.adjust() ;
    AppToken = data!.appToken ;
    registrationComplete = data!.registrationComplete;
    registrationInitiated = data!.registrationInitiated;
    firstPrompt= data!.firstPrompt;
    loginSuccess =  data!.loginSuccess;
    deleteAccount =  data!.deleteAccount;
    MethodChannelService.instance.buildFlavor().then((value){
        try {
          AdjustConfig config =value == "dev" ? AdjustConfig(AppToken!, AdjustEnvironment.sandbox) :
          AdjustConfig(AppToken!, AdjustEnvironment.production);
          config.logLevel = AdjustLogLevel.verbose;
          Adjust.start(config);
        }catch(e){
          debugPrint("Error  $e");
        }
    });
  }
  Future<void> adjustEvent (String eventToken) async {
    try {
      AdjustEvent adjustEvent = AdjustEvent(eventToken);
      Adjust.trackEvent(adjustEvent);
    } catch (e) {
      debugPrint("Error  $e");
    }
  }
  Future<void> adjustPushToken (String pushToken) async {
    try {
      Adjust.setPushToken(pushToken);
    } catch (e) {
      debugPrint("Error  $e");
    }
  }

  Future<void> adjustEventWithRevenue (String eventName, int amount, String currency) async {
    try {
      AdjustEvent adjustEvent = AdjustEvent(eventName);
      adjustEvent.setRevenue(amount, currency);
      Adjust.trackEvent(adjustEvent);
    } catch (e) {
      debugPrint("Error  $e");
    }
  }

}