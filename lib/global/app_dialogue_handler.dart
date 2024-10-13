
import 'package:ask_qx/widgets/feedback_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class AppDialogueHandler {
  static void feedBackDialogue() {
    Get.dialog(
       const PopScope(
        canPop: false,
        child: Dialog(
          child: FeedBackScreen(),
        ),
      ),
      barrierDismissible:true,
      transitionDuration: const Duration(milliseconds: 400),
      transitionCurve: Curves.easeInOut,
    );
  }
}
