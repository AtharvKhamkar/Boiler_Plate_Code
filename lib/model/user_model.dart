class UserModel {
  String? sId;
  String? userEmail;
  String? username;
  String? firstName;
  String? password;
  String? accessToken;
  bool? isEmailVerified;
  bool? isSocialAccount;
  String? verificationCode;
  String? verificationCodeExpiredAt;
  String? deviceType;
  String? createdAt;
  String? updatedAt;
  int? iV;
  String? currentPlan;
  int? verificationCodeAttemptedAt;
  String? lastName;
  String? organization;
  String? profilePhoto;

  UserModel(
      {this.sId,
      this.userEmail,
      this.username,
      this.firstName,
      this.password,
      this.accessToken,
      this.isEmailVerified,
      this.isSocialAccount,
      this.verificationCode,
      this.verificationCodeExpiredAt,
      this.deviceType,
      this.createdAt,
      this.updatedAt,
      this.iV,
      this.currentPlan,
      this.verificationCodeAttemptedAt,
      this.lastName,
      this.organization,
      this.profilePhoto});

  UserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userEmail = json['userEmail'];
    username = json['username'];
    firstName = json['firstName'];
    password = json['password'];
    accessToken = json['accessToken'];
    isEmailVerified = json['isEmailVerified'];
    isSocialAccount = json['isSocialAccount'];
    verificationCode = json['verificationCode'];
    verificationCodeExpiredAt = json['verificationCodeExpiredAt'];
    deviceType = json['deviceType'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    iV = json['__v'];
    currentPlan = json['currentPlan'];
    verificationCodeAttemptedAt = json['verificationCodeAttemptedAt'];
    lastName = json['lastName'];
    organization = json['organization'];
    profilePhoto = json['profilePhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['userEmail'] = userEmail;
    data['username'] = username;
    data['firstName'] = firstName;
    data['password'] = password;
    data['accessToken'] = accessToken;
    data['isEmailVerified'] = isEmailVerified;
    data['isSocialAccount'] = isSocialAccount;
    data['verificationCode'] = verificationCode;
    data['verificationCodeExpiredAt'] = verificationCodeExpiredAt;
    data['deviceType'] = deviceType;
    data['createdAt'] = createdAt;
    data['updatedAt'] = updatedAt;
    data['__v'] = iV;
    data['currentPlan'] = currentPlan;
    data['verificationCodeAttemptedAt'] = verificationCodeAttemptedAt;
    data['lastName'] = lastName;
    data['organization'] = organization;
    data['profilePhoto'] = profilePhoto;
    return data;
  }
}
