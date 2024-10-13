import 'dart:io';

import 'package:flutter/material.dart';

///This extension will help to reduce the typo error
///Like suppose we have to type the assets name in image , icon or Lotti
///Old Method as below:
///1.assets/images/abc.png
///2.assets/icons/abc.png or jpg
///3. assets/jsons/success.json
///
/// But by using this extension you can achieve this in simple way
/// abc.png.toIcon
/// abc.png.toIcon
/// success.json.toJson
extension AssetsExtension on String {
  String get toJson{
    return "assets/jsons/$this";
  }

  String get toIcon{
    return "assets/icons/$this";
  }

  String get toImage{
    return "assets/images/$this";
  }

  String get isCode{
    return isEmpty?"Code":this;
  }
}

extension SizedBoxExtension on BuildContext{

  Widget get kToolBarHeight {
    if(Platform.isAndroid) {
      return const SizedBox(height: 40,);
    } else {
      return const SizedBox(height: kToolbarHeight,);
    }
  }

  Widget get kBottomSafePadding {
    if(Platform.isAndroid) {
      return const SizedBox(height: 14,);
    } else {
      return const SizedBox(height: 20,);
    }
  }

}