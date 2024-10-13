import 'package:ask_qx/themes/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Loader{

  static bool _isLoading = false;

  static void show(){
    if(!_isLoading){
      _isLoading = true;
      _hideAutomatically();
      Get.dialog(
        PopScope(
          canPop: false,
          child: Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Get.context!.theme.scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: LoadingAnimationWidget.fourRotatingDots(
                color: primaryColor,
                size: 40,
              ),
            ),
          ),
        ),
        barrierDismissible: false,
      );
    }
  }

  static void hide(){
    if(_isLoading){
      _isLoading = false;
      Get.back();
    }
  }

  static void _hideAutomatically(){
    Future.delayed(const Duration(seconds: 20),(){
      if(_isLoading){
        _isLoading = false;
        Get.back();
      }
    });
  }

}