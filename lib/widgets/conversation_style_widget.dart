import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';

enum ConversationStyle { creative, balanced, precise }

class ConversationStyleWidget extends StatefulWidget {
   final Function(ConversationStyle style) onChanged;
   final Color darkColor;
   const ConversationStyleWidget({super.key,required this.onChanged, this.darkColor=kPrimaryDark});

  @override
  State<ConversationStyleWidget> createState() => ConversationStyleWidgetState();
}

class ConversationStyleWidgetState extends State<ConversationStyleWidget> {

  late ConversationStyle style = ConversationStyle.balanced;


  @override
  void initState() {
    super.initState();
    style = AppStorage.getConversationStyle();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Choose a conversation style",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20.0,),
          AnimatedToggleSwitch.size(
            values: ConversationStyle.values,
            current: style,
            animationCurve: Curves.fastEaseInToSlowEaseOut,
            indicatorSize: const Size(double.infinity, double.infinity),
            loading: false,
            style: ToggleStyle(
              indicatorBoxShadow: [
                BoxShadow(
                  color: widget.darkColor,
                  blurRadius: 12,
                  blurStyle: BlurStyle.normal,
                  spreadRadius: -3,
                )
              ],

              // indicatorBorder: Border.all(),
              backgroundColor: widget.darkColor.withOpacity(0.03),
              borderColor: widget.darkColor.withOpacity(0.04),
              borderRadius: BorderRadius.circular(30),

              indicatorColor: widget.darkColor,
            ),
            onChanged: (value) {
              AppStorage.setConversationStyle(value);
              style = value;
              widget.onChanged.call(style);
            },
            iconBuilder: (value) {
              return Text(
                localName(value).capitalizeFirst.toString(),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: getTextColor(
                      lightTheme: style == value
                          ? Colors.white
                          : Colors.black,
                  ),
                ),
              );
            },
            selectedIconScale: 1.1,
          )
        ],
      ),
    );
  }

 static  String localName(ConversationStyle style){
    switch(style){
      case ConversationStyle.creative:
        return "creative";
      case ConversationStyle.balanced:
        return "standard";
      case ConversationStyle.precise:
        return "professional";
    }
  }
}
