/*
 * Created or updated by Deepak Gupta on 15/02/24, 12:12 pm
 *  Copyright (c) 2024 . All rights reserved for Ask Qx Lab.
 * Last modified 15/02/24, 12:12 pm
 */

import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/themes/colors.dart';
import 'package:ask_qx/utils/extension_utils.dart';
import 'package:ask_qx/widgets/conversation_style_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../global/app_util.dart';

class AnimatedSlideMenu extends StatefulWidget {
  final String style;
  const AnimatedSlideMenu({super.key,this.style = "balanced"});

  @override
  State<AnimatedSlideMenu> createState() => _AnimatedSlideMenuState();
}

class _AnimatedSlideMenuState extends State<AnimatedSlideMenu> with TickerProviderStateMixin {

  List<SlideMenu> slideMenu = [];

  ConversationStyle conversationStyle = AppStorage.getConversationStyle();

  @override
  void initState() {
    slideMenu.add(SlideMenu(
      conversationStyle == ConversationStyle.precise ? kThird : Colors.black,
      "Professional Chat",
      "professional.png".toIcon,
      AnimationController(vsync: this),
      1,
    ));
    slideMenu.add(SlideMenu(
      conversationStyle == ConversationStyle.balanced ? Colors.blue.shade800 : Colors.black,
      "Standard Chat",
      "standard.png".toIcon,
      AnimationController(vsync: this),
      2,
    ));
    slideMenu.add(SlideMenu(
      conversationStyle == ConversationStyle.creative ? kSecondary : Colors.black,
      "Creative Chat",
      "creative.png".toIcon,
      AnimationController(vsync: this),
      3,
    ));
    slideMenu.add(SlideMenu(
      Colors.black,
      "New Chat",
      "chat.png".toIcon,
      AnimationController(vsync: this),
      4,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        onClose(null);
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 4,
          sigmaY: 4,
        ),
        child: Material(
          color: Colors.white10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 28),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ...slideMenu.map((e) {
                  return FadeInLeft(
                    manualTrigger: false,
                    delay: Duration(milliseconds: 60 * slideMenu.indexOf(e)),
                    duration: const Duration(milliseconds: 200),
                    child: GestureDetector(
                      onTap: (){
                        onClose(e.menuType);
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),
                        decoration: BoxDecoration(
                          color: e.selectedColor,
                          borderRadius: BorderRadius.circular(24)
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(e.icon,color: Colors.white,width: 20,),
                            const SizedBox(width: 8,),
                            Text(e.title,style: textStyle(size: 12,color: Colors.white,weight: FontWeight.w500),)
                          ],
                        ),
                      ),
                    ),
                    controller: (controller) {
                      e.animationController = controller;
                    },
                  );
                }).toList(),
                const SizedBox(height: 10,),
                GestureDetector(
                  onTap: () async {
                    onClose(null);
                  },
                  child: FadeIn(
                    child: CircleAvatar(
                      backgroundColor: AppUtil.styleColor(AppStorage.getConversationStyle().name),
                      child: const Icon(Icons.clear,color: Colors.white,),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onClose(int? result) async {
    for (var model in slideMenu) {
      await Future.delayed(const Duration(milliseconds: 62));
      model.animationController.reverse();
    }
    Get.back(result: result);
  }
}


class SlideMenu {
  Color selectedColor;
  String title;
  String icon;
  AnimationController animationController;
  int menuType;

  SlideMenu(this.selectedColor, this.title, this.icon, this.animationController,this.menuType);
}