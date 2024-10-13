import 'package:ask_qx/themes/colors.dart';
import 'package:ask_qx/global/app_util.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

enum DialogueType { info, warning, success, error }

class ErrorHandle {
  static void error(dynamic message) {
    Get.closeAllSnackbars();
    Get.showSnackbar(
      GetSnackBar(
        messageText: Text(
          "$message",
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        margin: EdgeInsets.zero,
        borderRadius: 0,
        backgroundColor: Colors.red,
        duration: const Duration(milliseconds: 3000),
        snackStyle: SnackStyle.GROUNDED,
        snackPosition: SnackPosition.BOTTOM,
        dismissDirection: DismissDirection.down,
      ),
    );
  }

  static void success(dynamic message,{VoidCallback? onAction,String? actionName}) {
    Get.closeAllSnackbars();
    Get.showSnackbar(
      GetSnackBar(
        messageText: Row(
          children: [
            Expanded(
              child: Text(
                "$message",
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            if(onAction!=null)
              InkWell(
                borderRadius: BorderRadius.circular(6.0),
                onTap: onAction,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                  child: Text(
                    "$actionName".toUpperCase(),
                    style: textStyle(size: 12,color: Colors.white,weight: FontWeight.bold),
                  ),
                ),
              )
          ],
        ),
        margin: EdgeInsets.zero,
        borderRadius: 0,
        backgroundColor: kPrimaryLight,
        duration: const Duration(seconds: 3),
        snackStyle: SnackStyle.GROUNDED,
        snackPosition: SnackPosition.BOTTOM,
        dismissDirection: DismissDirection.down,
      ),
    );
  }

  static void qxLabDialogue({
    required String message,
    String title = 'Warning',
    VoidCallback? onAction,
    DialogueType dialogueType = DialogueType.warning,
  }) {
    Get.dialog(
        PopScope(
          canPop: false,
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    AppUtil.getLottieJson(dialogueType),
                    height: 180,
                    fit: BoxFit.fill,
                    repeat: false,
                  ),
                  Flexible(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      onAction?.call();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                    ),
                    child: const Text(
                      'Okay',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false);
  }

  static void qxLabConfirmationDialogue({
    required String message,
    String title = 'Warning',
    String confirmText = 'Okay',
    String cancelText = 'Cancel',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    DialogueType dialogueType = DialogueType.warning,
    Color? actionColor,
  }) {
    Get.dialog(
        PopScope(
          canPop: false,
          child: Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Lottie.asset(
                    AppUtil.getLottieJson(dialogueType),
                    height: 180,
                    fit: BoxFit.fill,
                  ),
                  Flexible(
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Get.theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  Flexible(
                    child: Text(
                      message,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: Get.theme.colorScheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Get.back();
                            onCancel?.call();
                          },
                          style: OutlinedButton.styleFrom(backgroundColor: Colors.transparent, side: BorderSide(color: actionColor??primaryColor)),
                          child: Text(
                            cancelText,
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Get.theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.back();
                            onConfirm?.call();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: actionColor??primaryColor,
                          ),
                          child: Text(
                            confirmText,
                            style:  const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        barrierDismissible: false);
  }
}
