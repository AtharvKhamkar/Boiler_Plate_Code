import 'package:get/get.dart';

class UserDetail {
  String userId;
  String nickName;
  String firstName;
  String lastName;
  String emailId;
  String status;
  String profileImage;
// String
  UserDetail({
    required this.userId,
     this.nickName = '',
     this.firstName = '',
     this.lastName = '',
     this.emailId = '',
     this.status = '',
     this.profileImage = '',
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) => UserDetail(
    userId: json["userId"]??"",
    nickName: json["nickName"]??"",
    firstName: json["firstName"]??"",
    lastName: json["lastName"]??"",
    emailId: json["emailId"]??"",
    status: json["status"]??"",
    profileImage: json["profilePhoto"]??"",
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "nickName": nickName,
    "firstName": firstName,
    "lastName": lastName,
    "emailId": emailId,
    "status": status,
    "profilePhoto": profileImage,
  };

  String get fullName {
    return "$firstName $lastName".capitalize??"";
  }
}