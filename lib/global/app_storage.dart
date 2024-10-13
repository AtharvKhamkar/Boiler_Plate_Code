import 'dart:convert';

import 'package:ask_qx/binding/auth_binding.dart';
import 'package:ask_qx/firebase/firebase_messaging_service.dart';
import 'package:ask_qx/global/app_data_provider.dart';
import 'package:ask_qx/model/user_detail.dart';
import 'package:ask_qx/screens/auth/login_screen.dart';
import 'package:ask_qx/screens/auth/signup_screen.dart';
import 'package:ask_qx/services/method_channel_service.dart';
import 'package:ask_qx/services/theme.dart';
import 'package:ask_qx/widgets/conversation_style_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:signin_with_linkedin/signin_with_linkedin.dart';

class AppStorage {

  static final _storage = GetStorage("qxlabai");
  static final _onboardingStorage = GetStorage("qxlabai_onboarding");
  // static final _google  = GoogleSignIn();
  //Clear log
  static void logout([String destination = "login"]) async{
    Get.offAll(()=>destination=="login"?const LoginScreen(backAction: "signup",):const SignUpScreen(),binding: AuthBinding(),transition: Transition.fadeIn,);
    await _storage.erase();
    AppDataProvider.devCount = 0;
    if(destination == "delete"){
      setIsAccountDeleted(true);
    }
    setIsNewUser(true);
    setIsLoggedOut(true);
    ThemeService().toDarkTheme();
    SignInWithLinkedIn.logout();
    FirebaseMessageService.instance.tokenRefresh();
    MethodChannelService.instance.buildFlavor().then((value){
      setBuildFlavor(value);
    });
    try{
     final isSignedIn = await GoogleSignIn().isSignedIn();
     if(isSignedIn){
       await GoogleSignIn().disconnect();
       await GoogleSignIn().signOut();
     }
    }catch(e){
      debugPrint("GoogleSignIn => $e");
    }
  }

  //Onboarding Storage
  static void setIsNewUser(bool data){
    _onboardingStorage.write(AppStorageKey.isNew, data);
  }

  static bool isNewUser(){
    return _onboardingStorage.read(AppStorageKey.isNew)??true;
  }

  static void setIsLoggedOut(bool data){
    _onboardingStorage.write(AppStorageKey.isLoggedOut, data);
  }

  static bool isLoggedOut(){
    return _onboardingStorage.read(AppStorageKey.isLoggedOut)??false;
  }

  static void setLastUpdatePopupDateTime(){
    _onboardingStorage.write(AppStorageKey.lastUpdatePopupTime, DateTime.now().toString());
  }

  static DateTime getLastUpdatePopupDateTime(){
    final d = _onboardingStorage.read(AppStorageKey.lastUpdatePopupTime)??"";
    return d.isEmpty?DateTime.now().subtract(const Duration(days: 10)):DateTime.parse(d);
  }
  static bool isFirstPrompt(){
   return _onboardingStorage.read(AppStorageKey.isFirstPrompt)??false;
  }
  static void setFirstPrompt(){
    _onboardingStorage.write(AppStorageKey.isFirstPrompt,true);
  }

  //qxlabai-storage
  //Helper Methods
  static void setIsLogIn(bool data){
    _onboardingStorage.write(AppStorageKey.isLoggedOut, false);
    _storage.write(AppStorageKey.loggedIn, data);
  }

  static bool isLoggedIn(){
    return _storage.read(AppStorageKey.loggedIn)??false;
  }

  static void setAppKey(String data){
    _storage.write(AppStorageKey.appKey, data);
  }

  static String getAppKey(){
    return _storage.read(AppStorageKey.appKey)??"";
  }

  static void setToken(String data){
    _storage.write(AppStorageKey.token, data);
  }

  static String getToken(){
    return _storage.read(AppStorageKey.token)??"";
  }

  static void setRefreshToken(String data){
    _storage.write(AppStorageKey.refreshToken, data);
  }

  static String getRefreshToken(){
    return _storage.read(AppStorageKey.refreshToken)??"";
  }

  static void setUserDetails(String data){
    _storage.write(AppStorageKey.userDetails, data);
  }

  static UserDetail getUserDetails(){
    return UserDetail.fromJson(jsonDecode(_storage.read(AppStorageKey.userDetails)??"{}"));
  }

  static void setUserId(dynamic data){
    _storage.write(AppStorageKey.userId, data);
  }

  static String getUserId() {
    var uId = "${_storage.read(AppStorageKey.userId) ?? ""}";
    return uId;
  }

  static void setConversationStyle(ConversationStyle data){
    _storage.write(AppStorageKey.conversationStyle, data.name);
  }

  static ConversationStyle getConversationStyle(){
    final style = _storage.read(AppStorageKey.conversationStyle)??"";
    switch(style){
      case "creative":
        return ConversationStyle.creative;
      case "balanced":
        return ConversationStyle.balanced;
      case "precise":
        return ConversationStyle.precise;
      default:
        return ConversationStyle.balanced;
    }
  }

  static void setBuildFlavor(String data){
    _storage.write(AppStorageKey.buildFlavor, data);
  }

  static bool isDevBuild() {
    return (_storage.read(AppStorageKey.buildFlavor)??"dev")=="dev";
  }

  static void setFcmToken(String token){
    _storage.write(AppStorageKey.fcmToken, token);
  }

  static String fcmToken(){
    return _storage.read(AppStorageKey.fcmToken)??"";
  }

  static void setFcmTokenSync(bool data){
    _storage.write(AppStorageKey.fcmTokenSync, data);
  }

  static bool isFcmTokenSync(){
    return _storage.read(AppStorageKey.fcmTokenSync)??false;
  }

  static void setIsAccountDeleted(bool data){
    _storage.write(AppStorageKey.isAccountDeleted, data);
  }

  static bool isAccountDeleted(){
    return _storage.read(AppStorageKey.isAccountDeleted)??false;
  }

  static void setSubscriptionData(String data){
    _storage.write(AppStorageKey.subscriptionData, data);
  }

  static String subscriptionData(){
    return _storage.read(AppStorageKey.subscriptionData)??"";
  }

  static void setSubscriptionSyncDate(){
    _storage.write(AppStorageKey.subscriptionSyncDate, DateTime.now().toLocal().toString());
  }

  static DateTime? subscriptionSyncDate(){
    final date = _storage.read(AppStorageKey.subscriptionSyncDate);
    if(date!=null){
      return DateTime.parse(date);
    }
    return null;
  }
}

class AppStorageKey {
  static const String loggedIn = "login";
  static const String appKey = "app_key";
  static const String token = "token";
  static const String refreshToken = "refresh_token";
  static const String userDetails = "user_details";
  static const String userId = "user_id";
  static const String isNew = "is_new";
  static const String isLoggedOut = "is_logged_out";
  static const String conversationStyle = "conversation_style";
  static const String buildFlavor = "build_flavor";
  static const String fcmToken = "fcm_token";
  static const String fcmTokenSync = "fcm_token_sync";
  static const String isAccountDeleted = "is_account_deleted";
  static const String subscriptionData = "subscription_data";
  static const String subscriptionSyncDate = "subscription_sync_date";
  static const String lastUpdatePopupTime = "last_update_popup_date_time";
  static const String isFirstPrompt = "is_first_prompt";

}
