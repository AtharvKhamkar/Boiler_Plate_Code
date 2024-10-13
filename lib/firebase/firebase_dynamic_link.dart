import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/network/api_client.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';

class FirebaseDynamicLinkService {

  FirebaseDynamicLinkService._();

  static final FirebaseDynamicLinkService _service = FirebaseDynamicLinkService._();

  static FirebaseDynamicLinkService get link => _service;

  final FirebaseDynamicLinks _dynamicLinks = FirebaseDynamicLinks.instance;

  var receivedConversationShareId = "";
  var utmParameters = {};

  ///Receive the dynamic link callback here
  ///Reference link https://firebase.google.com/docs/dynamic-links/flutter/receive
  Future<void> init()async{
    ///When application is in foreground state
    ///Means user is interacting with the application
    _dynamicLinks.onLink.listen((PendingDynamicLinkData? pendingIntent) {
      if(pendingIntent!=null){
        _handleLink(pendingIntent);
      }
    });

    ///When app application is in background & terminated state
    final pendingIntent = await _dynamicLinks.getInitialLink();
    if(pendingIntent!=null){
      _handleLink(pendingIntent);
    }
  }


  ///Create the dynamic link by calling this function
  ///Reference link https://firebase.google.com/docs/dynamic-links/flutter/create
  Future<String> shareLink(dynamic conversationId)async{
    final parameters = DynamicLinkParameters(
      link: Uri.parse("${ApiClient.client.WEB_URL}share/$conversationId"),
      uriPrefix: "https://qxlabai.page.link",
      androidParameters: AndroidParameters(
        packageName:AppStorage.isDevBuild()? "com.qxlabai.askqx.dev" : "com.qxlabai.askqx",
        minimumVersion: 1,
      ),
      iosParameters: const IOSParameters(
        bundleId: "com.qxlabai.askqx",
        appStoreId: "123456789",
      ),
    );

    final shortLink = await _dynamicLinks.buildShortLink(parameters);

    return shortLink.shortUrl.toString();

  }

  ///Handle the deep link received from dynamic link
  Future<void> _handleLink(PendingDynamicLinkData pendingIntent)async{
    debugPrint('Received link => ${pendingIntent.link}');
    utmParameters = pendingIntent.link.queryParameters;
    if(pendingIntent.link.pathSegments.contains("share")){
      receivedConversationShareId = pendingIntent.link.toString().split("/").last;
    }
  }

}
