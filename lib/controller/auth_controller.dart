import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ask_qx/binding/auth_binding.dart';
import 'package:ask_qx/binding/chat_binding.dart';
import 'package:ask_qx/firebase/firebase_analytic_service.dart';
import 'package:ask_qx/firebase/firebase_dynamic_link.dart';
import 'package:ask_qx/firebase/remote_config_service.dart';
import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/model/error_model.dart';
import 'package:ask_qx/network/error_handler.dart';
import 'package:ask_qx/screens/auth/create_new_password.dart';
import 'package:ask_qx/screens/auth/login_screen.dart';
import 'package:ask_qx/screens/auth/otp_screen.dart';
import 'package:ask_qx/screens/chat/chat_ai_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pinput/pinput.dart';
import 'package:signin_with_linkedin/signin_with_linkedin.dart';

import '../adjust/adjust_services.dart';
import '../global/app_config.dart';
import '../repository/app_repository.dart';
import '../repository/auth_repository.dart';

class AuthController extends GetxController with StateMixin<dynamic> {
  final _authRepo = AuthRepository();
  Timer? timer;

  //Keys
  var loginFormKey = GlobalKey<FormState>();
  var signupFormKey = GlobalKey<FormState>();
  var forgotFormKey = GlobalKey<FormState>();
  final otpFormKey = GlobalKey<FormState>();
  final newPasswordFormKey = GlobalKey<FormState>();

  //TextfieldController's
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final conformPassword = TextEditingController();
  final otpController = TextEditingController();

  //Booleans
  var acceptTnC = false.obs;
  var isLoading = false.obs;
  var isHapticOn = true.obs;
  var isGoogleSignInLoading = false.obs;
  var isLinkedInSigningLoading = false.obs;

  //String
  var errorEmailMessage = "".obs;
  var errorPasswordMessage = "".obs;

  //Integer
  int limit = 30;

  final defaultPinTheme = PinTheme(
    width: 56,
    height: 56,
    textStyle: const TextStyle(
      fontSize: 22,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(19),
      border: Border.all(),
    ),
  );

  //Social Login
  //Google
  late final _googleSignIn = GoogleSignIn();
  GoogleSignInAccount? _currentUser;
  //LinkedIn

  var hasData = false.obs;

  @override
  void onInit() {
    if (kDebugMode) {
      emailController.text = "mujjafar@qxlabai.com";
      passwordController.text = "123456";
    }
    super.onInit();
  }

  void reset() {
    nameController.clear();
    emailController.clear();
    passwordController.clear();
    conformPassword.clear();
    otpController.clear();
    isLoading(false);
    isHapticOn(true);
    acceptTnC(false);
    timer?.cancel();
    // update();
  }

  void startTime() {
    timer?.cancel();
    limit = 30;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (limit > 0) {
        limit--;
      } else {
        timer.cancel();
      }
      update();
    });
  }

  void login() async {
    if (isLoading.value) return;
    isLoading(true);
    update();

    if (AppStorage.getAppKey().isEmpty) {
      await AppRepository().getAppKey();
    }

    _authRepo.login(emailController.text, passwordController.text).then(
        (value) {
      //Success
      isLoading(false);
      if (value['success']) {
        if (value['data']['userDetails']['status'] == "PENDING") {
          ErrorHandle.qxLabDialogue(
              message: "Your account is not verified yet. Please verify",
              title: "Verification",
              onAction: () {
                AppStorage.setUserId(value['data']['userDetails']['userId']);
                Get.to(() => const OTPScreen())!.then((value) {
                  loginFormKey = GlobalKey<FormState>();
                  update();
                  Future.delayed(const Duration(milliseconds: 400), () {
                    loginFormKey.currentState!.reset();
                  });
                });
                Future.delayed(const Duration(seconds: 1), resentCode);
              });
        } else {
          AdjustServices.instance
              .adjustEvent(AdjustServices.loginSuccess.toString());
          AppStorage.setUserDetails(jsonEncode(value['data']['userDetails']));
          AppStorage.setToken(value['data']['tokens']['accessToken']);
          AppStorage.setRefreshToken(value['data']['tokens']['refreshToken']);
          AppStorage.setIsLogIn(true);
          AppStorage.setIsNewUser(false);
          FirebaseAnalyticService.instance.logEvent('Sign_In_With_Email');
          AppStorage.setFirstPrompt();
          Get.offAll(() => const ChatAiScreen(),
              binding: ChatBinding(), transition: Transition.fadeIn);
        }
      } else {
        final model = ErrorModel.fromJson(value['error']);
        ErrorHandle.error(model.toString());
      }

      update();
    }, onError: (e) {
      isLoading(false);
      ErrorHandle.error("$e");
      update();
    });
  }

  void register() async {
    if (isLoading.value) return;
    isLoading(true);
    update();

    if (AppStorage.getAppKey().isEmpty) {
      await AppRepository().getAppKey();
    }
    Map<String, dynamic> body = {
      "data": {
        "nickName": nameController.text.trim(),
        "firstName": nameController.text.trim(),
        "lastName": "",
        "emailId": emailController.text.trim(),
        "password": passwordController.text.trim(),
        "platform": Platform.isAndroid ? "ANDROID" : "IOS",
        "campaign": [
          {
            "utmId": "",
            "utmSource":
                "${FirebaseDynamicLinkService.link.utmParameters['utm_source'] ?? ""}",
            "utmMedium":
                "${FirebaseDynamicLinkService.link.utmParameters['utm_medium'] ?? ""}",
            "utmName":
                "${FirebaseDynamicLinkService.link.utmParameters['utm_campaign'] ?? ""}",
            "utmTerm":
                "${FirebaseDynamicLinkService.link.utmParameters['utm_term'] ?? ""}",
            "utmContent":
                "${FirebaseDynamicLinkService.link.utmParameters['utm_content'] ?? ""}"
          }
        ],
      }
    };
    _authRepo.register(body).then((value) {
      //Success
      isLoading(false);
      if (value['success']) {
        AdjustServices.instance
            .adjustEvent(AdjustServices.registrationInitiated.toString());
        FirebaseAnalyticService.instance.logEvent('Sign_UP_Email');
        AppStorage.setUserId(value['data']['userDetails']['userId']);
        ErrorHandle.success("OTP sent to ${emailController.text.trim()}");
        Get.to(() => const OTPScreen())!.then((value) {
          signupFormKey = GlobalKey<FormState>();
          update();
          Future.delayed(const Duration(milliseconds: 400), () {
            signupFormKey.currentState!.reset();
          });
        });
        Future.delayed(const Duration(seconds: 1), startTime);
      } else if (value['error']['code'] == 300010) {
        final model = ErrorModel.fromJson(value['error']);
        Get.offAll(
            () => const LoginScreen(
                  backAction: "signup",
                ),
            binding: AuthBinding());
        ErrorHandle.error("${model.toString()} Try Login");
      } else {
        final model = ErrorModel.fromJson(value['error']);
        ErrorHandle.error(model.toString());
      }
      update();
    }, onError: (e) {
      isLoading(false);
      ErrorHandle.error("$e");
      update();
    });
  }

  void resentCode() {
    if (isLoading.value) return;
    otpController.clear();
    isLoading(true);
    update();
    startTime();
    _authRepo.resendVerifyCode().then((value) {
      FirebaseAnalyticService.instance.logEvent('Resend_OTP');
      //Success
      isLoading(false);
      update();
      if (value['success']) {
        ErrorHandle.success('OTP sent to ${emailController.text}');
      } else {
        final model = ErrorModel.fromJson(value['error']);
        ErrorHandle.error(model.toString());
      }
    }, onError: (e) {
      isLoading(false);
      ErrorHandle.error(e);
      update();
    });
  }

  void verifyAccount() {
    if (isLoading.value) return;
    isLoading(true);
    update();
    _authRepo.verifyAccount(otpController.text).then((value) {
      //Success
      isLoading(false);
      if (value['success']) {
        AdjustServices.instance
            .adjustEvent(AdjustServices.registrationComplete.toString());
        AppStorage.setFirstPrompt();
        FirebaseAnalyticService.instance.logEvent('OTP_Verify');
        FirebaseAnalyticService.instance.logEvent('Registration_Completed');
        AppStorage.setUserDetails(jsonEncode(value['data']['userDetails']));
        AppStorage.setToken(value['data']['tokens']['accessToken']);
        AppStorage.setRefreshToken(value['data']['tokens']['refreshToken']);
        AppStorage.setIsLogIn(true);
        AppStorage.setIsNewUser(false);
        Get.offAll(() => const ChatAiScreen(),
            binding: ChatBinding(), transition: Transition.fadeIn);
      } else {
        final model = ErrorModel.fromJson(value['error']);
        ErrorHandle.error(model.toString());
      }
      update();
    }, onError: (e) {
      isLoading(false);
      ErrorHandle.error(e);
      update();
    });
  }

  void resetPassword() {
    if (isLoading.value) return;
    isLoading(true);
    update();

    _authRepo.resetPassword(otpController.text, conformPassword.text).then(
        (value) {
      //Success
      isLoading(false);

      if (value['success']) {
        ErrorHandle.qxLabDialogue(
            message: "Your password has been changed successfully.",
            title: "Congratulation",
            dialogueType: DialogueType.success,
            onAction: () {
              Get.back();
              Get.back();
            });
      } else {
        final model = ErrorModel.fromJson(value['error']);
        ErrorHandle.error(model.toString());
      }
      update();
    }, onError: (e) {
      isLoading(false);
      ErrorHandle.error("$e");
      update();
    });
  }

  void forgotPassword() async {
    if (isLoading.value) return;
    otpController.clear();
    passwordController.clear();
    conformPassword.clear();
    isLoading(true);
    update();

    if (AppStorage.getAppKey().isEmpty) {
      await AppRepository().getAppKey();
    }

    _authRepo.forgotPassword(emailController.text).then((value) {
      //Success
      isLoading(false);
      if (value['success']) {
        if (value['data']['status'] == "PENDING") {
          ErrorHandle.qxLabDialogue(
              message: "Your account is not verified yet. Please verify",
              title: "Verification",
              onAction: () {
                AppStorage.setUserId(value['data']['userId']);
                Get.to(() => const OTPScreen())!.then((value) {
                  loginFormKey = GlobalKey<FormState>();
                  update();
                  Future.delayed(const Duration(milliseconds: 400), () {
                    loginFormKey.currentState!.reset();
                  });
                });
                Future.delayed(const Duration(seconds: 1), resentCode);
              });
        } else {
          ErrorHandle.success("OTP sent to ${emailController.text}");
          AppStorage.setUserId(value['data']['userId']);
          Get.to(() => const CreatePasswordScreen())!.then((value) {});
          startTime();
        }
      } else {
        final model = ErrorModel.fromJson(value['error']);
        ErrorHandle.error(model.toString());
      }
      update();
    }, onError: (e) {
      isLoading(false);
      ErrorHandle.error("$e");
      update();
    });
  }

  void resendForgotPassword() {
    if (isLoading.value) return;
    isLoading(true);
    update();

    _authRepo.forgotPassword(emailController.text).then((value) {
      isLoading(false);
      if (value['success']) {
        ErrorHandle.success("OTP sent to ${emailController.text}");
        AppStorage.setUserId(value['data']['userId']);
        startTime();
      } else {
        final model = ErrorModel.fromJson(value['error']);
        ErrorHandle.error(model.toString());
      }
      update();
    }, onError: (e) {
      isLoading(false);
      update();
      ErrorHandle.error("$e");
      update();
    });
  }

  // Login with Google Account
  void loginWithGoogle({required String eventName}) async {
    if (isGoogleSignInLoading.value) return;
    isGoogleSignInLoading(true);
    update();

    if (AppStorage.getAppKey().isEmpty) {
      await AppRepository().getAppKey();
    }

    await _googleSignIn.signIn().then((value) {
      isGoogleSignInLoading(false);
      _currentUser = value;
      if (_currentUser != null) {
        FirebaseAnalyticService.instance.logEvent(eventName);
        Map<String, dynamic> body = {
          "data": {
            "nickName": _currentUser!.displayName ?? "",
            "firstName": _currentUser!.displayName ?? "",
            "lastName": "",
            "emailId": _currentUser!.email,
            "profilePhoto": _currentUser!.photoUrl ?? "",
            "socialId": _currentUser!.id,
            "group": "Google".toUpperCase(),
            "platform": Platform.isAndroid ? "ANDROID" : "IOS",
          }
        };
        _authRepo.socialLogin(body).then((value) {
          if (value['success']) {
            if (value['data']['isNewUser'] == true) {
              AdjustServices.instance
                  .adjustEvent(AdjustServices.registrationInitiated.toString());
              AdjustServices.instance
                  .adjustEvent(AdjustServices.registrationComplete.toString());
              AppStorage.setFirstPrompt();
            } else {
              AdjustServices.instance
                  .adjustEvent(AdjustServices.loginSuccess.toString());
            }
            AppStorage.setUserId(value['data']['userDetails']['userId']);
            AppStorage.setUserDetails(jsonEncode(value['data']['userDetails']));
            AppStorage.setToken(value['data']['tokens']['accessToken']);
            AppStorage.setRefreshToken(value['data']['tokens']['refreshToken']);
            AppStorage.setIsLogIn(true);
            AppStorage.setIsNewUser(false);
            Get.offAll(() => const ChatAiScreen(),
                binding: ChatBinding(), transition: Transition.fadeIn);
          } else if (value['error']['code'] == 300010) {
            final model = ErrorModel.fromJson(value['error']);
            Get.offAll(() => const LoginScreen(backAction: "signup"),
                binding: AuthBinding());
            ErrorHandle.error("${model.toString()} Try Login");
          } else {
            final model = ErrorModel.fromJson(value['error']);
            ErrorHandle.error(model.toString());
          }
          isGoogleSignInLoading(false);
          update();
        }, onError: (e) {
          isGoogleSignInLoading(false);
          ErrorHandle.error("$e");
          update();
        });
      } else {
        // ErrorHandle.error("Something went wrong");
        update();
      }
    }, onError: (e) {
      isGoogleSignInLoading(false);
      // ErrorHandle.error("$e");
      update();
    }).catchError((stack) {
      isGoogleSignInLoading(false);
      // ErrorHandle.error("$e");
      update();
    });
  }

  void loginWithLinkedIn({required String eventName}) async {
    if (isLinkedInSigningLoading.value) return;
    isLinkedInSigningLoading(true);
    update();

    if (AppStorage.getAppKey().isEmpty) {
      await AppRepository().getAppKey();
    }

    if (AppConfig.linkedinClientId.isEmpty) {
      await RemoteConfigService.instance.fetch();
    }

    SignInWithLinkedIn.signIn(
      Get.context!,
      config: LinkedInConfig(
        clientId: AppConfig.linkedinClientId,
        clientSecret: AppConfig.linkedinClientSecret,
        redirectUrl: AppConfig.linkedinRedirectUrl,
        scope: ['openid', 'profile', 'email'],
      ),
      onGetAuthToken: (data) {
        isLinkedInSigningLoading(false);
        update();
      },
      onGetUserProfile: (_, user) {
        if (hasData.value) return;
        hasData(true);
        FirebaseAnalyticService.instance.logEvent(eventName);
        Map<String, dynamic> body = {
          "data": {
            "nickName": user.givenName ?? "",
            "firstName": user.givenName ?? "",
            "lastName": user.familyName ?? "",
            "emailId": user.email ?? "",
            "profilePhoto": user.picture ?? "",
            "socialId": user.sub,
            "group": "LinkedIn".toUpperCase(),
            "platform": Platform.isAndroid ? "ANDROID" : "IOS",
          }
        };

        _authRepo.socialLogin(body).then((value) {
          isLinkedInSigningLoading(false);
          if (value['success']) {
            if (value['data']['isNewUser'] == true) {
              AdjustServices.instance.adjustEvent(AdjustServices
                  .registrationInitiated
                  .toString()); //registration_initiated_android_app_Event
              AdjustServices.instance.adjustEvent(AdjustServices
                  .registrationComplete
                  .toString()); //registration_complete_android_app_Event
              AppStorage.setFirstPrompt();
            } else {
              AdjustServices.instance
                  .adjustEvent(AdjustServices.loginSuccess.toString());
            }
            AppStorage.setUserId(value['data']['userDetails']['userId']);
            AppStorage.setUserDetails(jsonEncode(value['data']['userDetails']));
            AppStorage.setToken(value['data']['tokens']['accessToken']);
            AppStorage.setRefreshToken(value['data']['tokens']['refreshToken']);
            AppStorage.setIsLogIn(true);
            AppStorage.setIsNewUser(false);
            Get.offAll(() => const ChatAiScreen(),
                binding: ChatBinding(), transition: Transition.fadeIn);
            return;
          } else if (value['error']['code'] == 300010) {
            final model = ErrorModel.fromJson(value['error']);
            Get.to(
                () => const LoginScreen(
                      backAction: "signup",
                    ),
                binding: AuthBinding());
            ErrorHandle.error("${model.toString()} Try Login");
          } else {
            final model = ErrorModel.fromJson(value['error']);
            ErrorHandle.error(model.toString());
          }

          update();
        }, onError: (e) {
          isLinkedInSigningLoading(false);
          ErrorHandle.error("$e");
          update();
        });
      },
      onSignInError: (error) {
        isLinkedInSigningLoading(false);
        update();
      },
    ).then((value) {
      if (hasData.value) return;
      isLinkedInSigningLoading(false);
      update();
    });
  }
}
