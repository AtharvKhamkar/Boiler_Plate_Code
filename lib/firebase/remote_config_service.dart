import 'dart:convert';
import 'dart:developer';

import 'package:ask_qx/global/app_config.dart';
import 'package:ask_qx/model/subscription_model.dart';
import 'package:ask_qx/model/update_model.dart';
import 'package:ask_qx/services/method_channel_service.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';

import '../model/adjust.dart';

class RemoteConfigService {
  RemoteConfigService._();

  static final RemoteConfigService _instance = RemoteConfigService._();

  static RemoteConfigService get instance => _instance;

  final _remoteConfig = FirebaseRemoteConfig.instance;

  Future<void> init() async {
    _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(seconds: 1),
      minimumFetchInterval: const Duration(seconds: 1),
    ));
    _remoteConfig.fetchAndActivate();
  }


  Future<void> fetchAndUpdate() async {

    Future.delayed(const Duration(seconds: 5),(){
       fetch();
      _remoteConfig.onConfigUpdated.listen((event) {
        fetch();
      });
    });

  }

  Future<bool> fetch() async {
    final flavor = await MethodChannelService.instance.buildFlavor();
    final remote = _remoteConfig.getString(flavor);
    try{
      Map map = jsonDecode(remote.toString());
      AppConfig.apiKey = map['api_key'];
      AppConfig.chatApiKey = map['api_key_askqx'];
      AppConfig.subscriptionApiKey = map['api_key_subscription'];
      AppConfig.appId = map['app_id'];
      AppConfig.linkedinClientId = map['linked_in_client_id'];
      AppConfig.linkedinClientSecret = map['linked_in_client_secret'];
      AppConfig.linkedinRedirectUrl = map['linked_in_redirect_url'];
      return true;
    }catch(e){
      debugPrint(e.toString());
      return false;
    }
  }

  Future<List<UpdateModel>> updates() async {
    final remote = _remoteConfig.getString("updates");
    kDebugMode?log(remote):null;
    try{
      List<UpdateModel> temp = [];
      final map = jsonDecode(remote.toString());

      temp = List<UpdateModel>.from(map.map((u)=>UpdateModel.fromJson(u)));

      return temp;
    }catch(e){
      debugPrint(e.toString());
      return [];
    }
  }

  String shareMessage(link) {
    final remote = _remoteConfig.getString("share_message");
    try{
      return remote.replaceAll("\$LINK", link);
    }catch(e){
      debugPrint(e.toString());
      return link;
    }
  }

  String shareAppMessage() {
    var link = "https://play.google.com/store/apps/details?id=com.qxlabai.askqx";
    final remote = _remoteConfig.getString("share_app_message");
    try{
      return remote.replaceAll("\$LINK", link);
    }catch(e){
      debugPrint(e.toString());
      return link;
    }
  }

  SubscriptionMessage subscriptionMessage() {
    final remote = _remoteConfig.getString("subscription_message");
    try{
      var map = jsonDecode(remote);
      return SubscriptionMessage.fromJson(map);
    }catch(e){
      return SubscriptionMessage.def();
    }
  }

  Map<String, dynamic> developerOptions() {
    try {
      final remote = _remoteConfig.getString("developer_option");
      return jsonDecode(remote);
    } catch (e) {
      return {};
    }
  }
  AdjustModel? adjust(){
    try{
      final remote = _remoteConfig.getString("adjust");
      var map = jsonDecode(remote);
      return AdjustModel.fromJson(map);
    } catch(e){
      return null;
    }
  }
}
