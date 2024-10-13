import 'package:ask_qx/themes/colors.dart';
import 'package:ask_qx/utils/extension_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QxBrandingWidget extends StatelessWidget {
  final double scaleFactor;
  final Color? color;
  const QxBrandingWidget({super.key, this.scaleFactor = 1.0,this.color,}) : assert(scaleFactor >= 0.0 && scaleFactor <= 1.0, "Scale factor must be between 0.0 to 1.0");

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset("ask.png".toIcon, height: 36 * scaleFactor, color: color??(Get.isDarkMode ? Colors.white : null)),
      ],
    );
  }
}

class QxBrandingDescription extends StatelessWidget {
  final String? leadingText;
  final String? trailingText;
  final TextAlign textAlign;
  final Color? color;
  final double textSize;
  final FontWeight weight;

  const QxBrandingDescription({
    super.key,
    this.leadingText,
    this.trailingText,
    this.textAlign = TextAlign.center,
    this.color,
    this.weight= FontWeight.normal,
    this.textSize = 14,
  });


  @override
  Widget build(BuildContext context) {
    return RichText(
      key: UniqueKey(),
      textAlign: textAlign,
      text: TextSpan(
        style: TextStyle(color: color,fontSize: textSize,fontWeight: weight),
        children: [
          if(leadingText != null)
            TextSpan(
              text: leadingText,
            ),
          WidgetSpan(
            alignment: PlaceholderAlignment.top,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(3, 3, 3, 0),
              child: Image.asset("ask.png".toIcon, height: textSize-3, color: color??(Get.isDarkMode ? Colors.white : blackColor)),
            ),
          ),
         if(trailingText != null)
           TextSpan(
             text: trailingText,
           ),
        ],
      ),
    );
  }
}
