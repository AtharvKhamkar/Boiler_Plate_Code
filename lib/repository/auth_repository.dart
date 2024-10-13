import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/network/api_client.dart';

class AuthRepository {

  //this function will post user details for login the user into app
  Future<dynamic> login(String email, String password) async {
    try {
      Map<String, dynamic> body = {
        "data": {"emailId": email.trim(), "password": password.trim()}
      };
      final response = await ApiClient.client.postRequest("user/login", request: body);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  //this function will post user details for login via social platforms the user into app
  Future<dynamic> socialLogin(dynamic body) async {
    try {
      final response = await ApiClient.client.postRequest("user/social", request: body, serverType: ServerType.user);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  //this function will post user details for register the user into app
  Future<dynamic> register(dynamic body) async {
    try {
      final response = await ApiClient.client.postRequest("user/register", request: body);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }


  //this function will post the code and reset password
  Future<dynamic> resetPassword(String code, String password) async {
    try {
      Map<String, dynamic> body = {
        "data": {
          "verificationCode": code.trim(),
          "password": password.trim(),
        }
      };
      final response = await ApiClient.client.postRequest("user/reset-password", request: body);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  //this function will post the email for forget password
  Future<dynamic> forgotPassword(String email) async {
    try {
      Map<String, dynamic> body = {
        "data": {
          "emailId": email.trim(),
        }
      };
      final response = await ApiClient.client.postRequest("user/forgot-password", request: body);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  //this function will post the code for verify account
  Future<dynamic> verifyAccount(String code) async {
    try {
      Map<String, dynamic> body = {
        "data": {
          "verificationCode": code.trim(),
        }
      };
      final response = await ApiClient.client.postRequest("user/verify-account", request: body);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  //this function will post for resend code
  Future<dynamic> resendVerifyCode() async {
    try {
      Map<String, dynamic> body = {};
      final response = await ApiClient.client.postRequest("user/resend-verification-code", request: body);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }


  //this function will post the updated firebase token
  Future<dynamic> updateFirebaseToken() async {
    try {
      if(AppStorage.fcmToken().isEmpty) return;
      if(AppStorage.isFcmTokenSync()) return;

      Map<String, dynamic> body = {
        "data": {
          "notificationToken": AppStorage.fcmToken(),
        }
      };
      final response = await ApiClient.client.postRequest("user/firebase/token", request: body, serverType: ServerType.user);
      AppStorage.setFcmTokenSync(true);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
}
