import 'dart:convert';

AdjustModel adjustFromJson(String str) => AdjustModel.fromJson(json.decode(str));

String adjustToJson(AdjustModel data) => json.encode(data.toJson());

class AdjustModel {
  String appToken;
  String registrationInitiated;
  String registrationComplete;
  String firstPrompt;
  String loginSuccess;
  String deleteAccount;

  AdjustModel({
    required this.appToken,
    required this.registrationInitiated,
    required this.registrationComplete,
    required this.firstPrompt,
    required this.loginSuccess,
    required this.deleteAccount
  });

  factory AdjustModel.fromJson(Map<String, dynamic> json) => AdjustModel(
    appToken: json["adjust_app_token"] ?? "",
    registrationInitiated: json["registration_initiated"] ?? "",
    registrationComplete: json["registration_complete"] ?? "",
    firstPrompt: json["first_prompt"] ?? "",
    loginSuccess: json["login_success"] ?? "",
    deleteAccount: json["delete_account"] ?? "",
  );

  Map<String, dynamic> toJson() => {
    "adjust_app_token": appToken,
    "registration_initiated": registrationInitiated,
    "registration_complete": registrationComplete,
    "first_prompt": firstPrompt,
    "login_success":loginSuccess,
    "delete_account":deleteAccount,
  };
}