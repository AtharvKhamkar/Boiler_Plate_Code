
import 'dart:developer';
import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/network/api_client.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AppRepository{

  //this function will check network connectivity
  Future<bool> isNetworkAvailable() async {
    try{
      final connectivity = await Connectivity().checkConnectivity();

      return (connectivity == ConnectivityResult.mobile || connectivity == ConnectivityResult.wifi);
    }catch(e){
      return false;
    }
  }

  //this function will return the app key
  Future<dynamic> getAppKey()async{
    try{
      final response = await ApiClient.client.getRequest("app");
      
      if (response is Map){
        AppStorage.setAppKey(response['data']['appDetails']['appKey']);
      }
      
      return response;
    }catch(e){
      return null;
    }
  }

  //this function will post feedback and rating
  Future<dynamic> submitFeedBack(double rating,String feedback) async{
    Map<String,dynamic>body={
      "data": {
        "rating": rating,
        "feedback": feedback,
      }
    };
    try{
      final response=await ApiClient.client.postRequest('app/feedback',request: body);
      return response;
    }catch(e){
      log('submitFeedBack $e');
      return Future.error(e);
    }
  }

  //this function will update the token & refresh token ex time
  Future<dynamic> updateToken(String access,String refresh,String password) async{
    Map<String,dynamic>body={
      "data": {
        "accessToken": AppStorage.getToken(),
        "refreshToken": AppStorage.getRefreshToken(),
        "accessTokenExpiry": access,
        "refreshTokenExpiry": refresh,
      }
    };
    try{
      final response = await ApiClient.client.request(
        'token/update',
        request: body,
        header: {"x-token-update-key":password},
        method: "POST"
      );
      return response;
    }catch(e){
      log('updateToken $e');
      return Future.error(e);
    }
  }
}