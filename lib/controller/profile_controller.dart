import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/model/error_model.dart';

import 'package:ask_qx/network/error_handler.dart';
import 'package:ask_qx/repository/profile_repository.dart';
import 'package:ask_qx/utils/extension_utils.dart';
import 'package:ask_qx/widgets/change_password_bottomsheet.dart';
import 'package:ask_qx/widgets/otp_bottomsheet.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../adjust/adjust_services.dart';


class ProfileController extends GetxController with StateMixin<dynamic> {

  final profileRepository = ProfileRepository();
  final userDetail = AppStorage.getUserDetails();

  //Controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final otpController = TextEditingController();
  final passwordOldController = TextEditingController();
  final passwordNewController = TextEditingController();

  //booleans
  var redOnly = true.obs;
  var isLoading = false.obs;
  var dataChanges = false.obs;

  //keys
  final editFormKey = GlobalKey<FormState>();
  final passwordFormKey = GlobalKey<FormState>();
  final validateKey = GlobalKey<FormState>();

  //Variables
  final picker = ImagePicker();
  File? imageFile;
  // var bytes;

  String imageUrl = '';

  Timer? timer;
  var limit = 30;

  @override
  void onInit() {
    super.onInit();
    initTextController();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  void initTextController(){

    final list = userDetail.firstName.split(" ");

    firstNameController.text = list.first;

    list.remove(firstNameController.text);

    final last = list.join(" ");

    final serverLast = last.contains(userDetail.lastName)?last:"$last ${userDetail.lastName}";

    lastNameController.text = serverLast;

    imageUrl = userDetail.profileImage;
  }

  void chooseImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source,imageQuality: 60);

      if (pickedFile != null) {
        // bytes = (pickedFile as ui.Image).toByteData();
        imageFile = File(pickedFile.path);
        redOnly.value = false;
        update();
      }
    } catch (e) {
      log('chooseImage $e');
    }
  }
  void onChange(value){
    redOnly(false);
    update();
  }

  void startTimer(){
    timer?.cancel();
    limit = 30;

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if(limit>0) {
        limit--;
      } else {
        timer.cancel();
      }
      update();
    });
  }

  void openDialog() {
    Get.bottomSheet(
      Container(
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(12.0),
          )
        ),
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  ' Choose Image',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                Container(
                  alignment: FractionalOffset.topLeft,
                  child: GestureDetector(
                    child: const Icon(
                      Icons.clear_rounded,
                      size: 25,
                      // color: dividerColor,
                    ),
                    onTap: () {
                      Get.back();
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      chooseImage(ImageSource.gallery);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color:Colors.black38,
                      ),
                      child: const Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Icon(
                            Icons.image,
                            color: Colors.white,
                            size: 40,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'From Gallery',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                      chooseImage(ImageSource.camera);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.black38,
                      ),
                      child: const Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Icon(
                            Icons.camera_alt_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'From Camera',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Get.context!.kBottomSafePadding,
          ],
        ),
      ),
    );
  }

  void send(String type){
    if(isLoading.value)return;
    isLoading(true);
    update();

    profileRepository.sendVerificationCode(type).then((value){
      startTimer();
      isLoading(false);
      update();
      ErrorHandle.success("Verification code sent successfully to your registered email.");
    },onError: (e){
      isLoading(false);
      update();
    });
    update();
  }

  void sendCode(){
    limit = 30;
    update();
    send("CHANGE_PASSWORD");
    passwordOldController.clear();
    passwordNewController.clear();
    otpController.clear();
    Get.bottomSheet(
      const ChangePaasBottomSheet(),
      isScrollControlled: true,
      isDismissible: false
    );
  }

  void changePassword(){
    if(isLoading.value)return;
    isLoading(true);
    update();
    profileRepository.changePassword(otpController.text,passwordNewController.text).then((value){
      isLoading(false);

      if(value['success']){
        Get.back();
        Get.back();
        ErrorHandle.success("Password reset successfully");
      }else{
        final model = ErrorModel.fromJson(value['error']);
        ErrorHandle.error(model.toString());
      }

      update();
    },onError: (e){
      isLoading(false);
      ErrorHandle.error("$e");
      update();
    });
  }

  void updateProfile() async {
    if(isLoading.value)return;
    isLoading(true);
    update();

    if(imageFile!=null){
      try{
        await profileRepository.updateUserImage(imageFile!.path);
      }catch(_){}
    }

    profileRepository.updateUserProfile(firstNameController.text, firstNameController.text , lastNameController.text).then((value) async{
      if(value['success']){
        await  profileRepository.userDetails();
      }

      isLoading(false);
      Get.back(result: true);
      ErrorHandle.success("Profile updated successfully");
      update();
    },onError: (e){
      isLoading(false);
      update();
      ErrorHandle.error(e);
    });
    dataChanges(true);
  }

  void deleteAccount(){
    limit = 30;
    update();
    send("DELETE_ACCOUNT");
    Get.bottomSheet(
        const OtpBottomSheet(),
        isScrollControlled: true,
        isDismissible: false
    ).then((value){
      if(value!=null){
        isLoading(false);
      }
    });
  }

  void delete()async{
    if(isLoading.value)return;
    isLoading(true);
    update();
    ProfileRepository().deleteAccount(otpController.text).then((value){
      isLoading(false);
      update();
      Future.delayed(const Duration(seconds: 1),(){
        if(value['success']){
          AdjustServices.instance.adjustEvent(AdjustServices.deleteAccount.toString());
          AppStorage.logout("delete");
          ErrorHandle.success("Account deleted successfully");
        }else{
          final model = ErrorModel.fromJson(value['error']);
          ErrorHandle.error(model.toString());
        }
      });
    },onError: (e){
      isLoading(false);
      ErrorHandle.error(e);
      update();
    });
  }

}
