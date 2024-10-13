import 'dart:convert';

import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/network/api_client.dart';

class ProfileRepository{

  //This function will return the user profile details
  Future<dynamic> userDetails()async{
    try{
      final response = await ApiClient.client.getRequest("user/profile");
      if(response is Map){
        AppStorage.setUserDetails(jsonEncode(response['data']['userDetails']));
      }
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  //This function will patch user details
  Future<dynamic> updateUserProfile(String nickname,String fName,String lName)async{
    try{
      Map<String,dynamic> body = {
        "data": {
          "nickName": nickname.trim(),
          "firstName": fName.trim(),
          "lastName": lName.trim()
        }
      };
      final response = await ApiClient.client.patchRequest("user/profile",request: body);
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  //This function will post profile image
  Future<dynamic> updateUserImage(dynamic byte)async{
    try{
      Map<String,String> files = {
        "profileImage":byte,
      };
      final response = await ApiClient.client.multipart("user/profile/image",files: files);
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  //this function will post for resend code
  Future<dynamic> sendVerificationCode(dynamic purpose)async{
    //purpose:[ CHANGE_PASSWORD, DELETE_ACCOUNT ]
    try{
      Map<String,dynamic> body = {
        "data": {
          "purpose": purpose,
        }
      };
      final response = await ApiClient.client.postRequest("user/profile/send-verification-code",request: body);
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  //this function will post for change password
  Future<dynamic> changePassword(String code,String password)async{
    //purpose:[ CHANGE_PASSWORD, DELETE_ACCOUNT ]
    try{
      Map<String,dynamic> body = {
        "data": {
          "verificationCode": code.trim(),
          "password": password.trim(),
        }
      };
      final response = await ApiClient.client.postRequest("user/profile/change-password",request: body);
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  //this function will delete account of user
  Future<dynamic> deleteAccount(String code)async{
    //purpose:[ CHANGE_PASSWORD, DELETE_ACCOUNT ]
    try{
      final response = await ApiClient.client.deleteRequest("user/profile/delete-account/$code");
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  Future<bool> userFirstpromptDetails()async{
    try{
      final response = await ApiClient.client.getRequest("user/profile/first-prompt-details");
      // if(response is Map){
      //   AppStorage.setUserDetails(jsonEncode(response['data']['userDetails']));
      // }
      return response['data']['userDetails']['firstPromptCompleted'];
    }catch(e){
      // Future.error(e);
      return false;
    }
  }

}