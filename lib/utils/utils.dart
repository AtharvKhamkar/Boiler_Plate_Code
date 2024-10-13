import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

import '../themes/colors.dart';

Color getPrimaryColor(
    {Color darkTheme = kPrimaryDark, Color lightTheme = kPrimaryLight, required BuildContext context}) {
  return context.isDarkMode ? darkTheme : lightTheme;
}

Color getTextColor(
    {
      Color darkTheme = Colors.white,
      Color lightTheme = Colors.black}) {
  return Get.isDarkMode ? darkTheme : lightTheme;
}

Color getSubTitleColor({
      Color darkTheme = Colors.white54,
      Color lightTheme = Colors.black54}) {
  return Get.isDarkMode ? darkTheme : lightTheme;
}

getOutlineInputBorder(context) {
  return OutlineInputBorder(
      borderSide: BorderSide(
          color: getSubTitleColor(
              darkTheme: Colors.white24,
              lightTheme: Colors.black26)),
      borderRadius: BorderRadius.circular(12));
}

void showSnackBar({required BuildContext context, required String content}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(content),
    ),
  );
}

getLog(message) {
  log(message.toString());
}

getJsonDecodeRes(res) {
  return json.decode(res);
}

void showGetSnackBar({required String title, required String content , Color? color}) {
  ScaffoldMessenger.maybeOf(Get.context!)!.showSnackBar(
    SnackBar(
      backgroundColor:  color ?? kPrimaryLight,
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
      ),
      content: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    ),
  );
}

showDialogCustom(
    context, {
      required String title,
      required String content,
      required Function onConfirmed,
      required String buttonName,
    }) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: <Widget>[
            TextButton(
              child: const Text('CANCEL'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(buttonName),
              onPressed: () => onConfirmed(),
            ),
          ],
        );
      });
}

PopupMenuItem buildPopupMenuItem(
    {required String title,
      required IconData iconData,
      required bool isActive,
      required VoidCallback onTap}) {
  return PopupMenuItem(
    onTap: onTap,
    enabled: isActive,
    child: Row(
      children: [
        Icon(
          iconData,
        ),
        const SizedBox(
          width: 10,
        ),
        Text(title),
      ],
    ),
  );
}

calculateWordRead(String data) {
  int read = data.split(" ").length;
  int readTime = read ~/ 200;
  if (readTime == 0) {
    return 1;
  }
  return readTime;
}

enum HapticFeedbackTypeCustom {
  lightImpact,
  mediumImpact,
  heavyImpact,
  selectionClick,
  vibrate,
}

hapticFeedbackCustom(HapticFeedbackTypeCustom type) {
  switch (type) {
    case HapticFeedbackTypeCustom.lightImpact:
      HapticFeedback.lightImpact();
      break;
    case HapticFeedbackTypeCustom.mediumImpact:
      HapticFeedback.mediumImpact();
      break;
    case HapticFeedbackTypeCustom.heavyImpact:
      HapticFeedback.heavyImpact();
      break;
    case HapticFeedbackTypeCustom.selectionClick:
      HapticFeedback.selectionClick();
      break;
    case HapticFeedbackTypeCustom.vibrate:
      HapticFeedback.vibrate();
      break;
  }
}

