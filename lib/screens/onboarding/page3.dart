import 'dart:ui';

import 'package:animate_do/animate_do.dart';
import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:ask_qx/controller/onboarding_controller.dart';
import 'package:ask_qx/utils/extension_utils.dart';
import 'package:ask_qx/widgets/conversation_style_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../themes/colors.dart';
import '../../utils/utils.dart';

class Page3 extends StatefulWidget {
  const Page3({super.key});

  @override
  State<Page3> createState() => _Page3State();
}

class _Page3State extends State<Page3> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(builder: (controller) {
      return Column(
        children: [
          SizedBox(
            height: context.height * 0.1,
          ),
          Obx(
            () => Stack(
              children: [
                FadeInUp(
                  delay: const Duration(milliseconds: 300),
                  duration: const Duration(milliseconds: 500),
                  child: CustomCard(
                    bg: Colors.white10,
                    tileColor: controller.currentColor.value,
                    myIcon: Image.asset("chat.png".toIcon, width: 20, color: controller.currentColor.value),
                    title: "Ask QX",
                    description: controller.conversationToolTipMessage2.value.capitalizeFirst.toString(),
                    angle: -0.3,
                  ),
                ),
                FadeInUp(
                  delay: const Duration(milliseconds: 600),
                  duration: const Duration(milliseconds: 500),
                  child: CustomCard(
                    bg: Colors.white10,
                    tileColor: controller.currentColor.value,
                    myIcon: Image.asset(
                      "chat.png".toIcon,
                      width: 20,
                      color: controller.currentColor.value,
                    ),
                    title: "Ask QX",
                    description: controller.conversationToolTipMessage2.value.capitalizeFirst.toString(),
                    angle: -0.2,
                  ),
                ),
                FadeInUp(
                  delay: const Duration(milliseconds: 900),
                  duration: const Duration(milliseconds: 500),
                  child: CustomCard(
                    bg: Colors.white,
                    tileColor: controller.currentColor.value,
                    myIcon: Image.asset(
                      "chat.png".toIcon,
                      width: 20,
                      color: controller.currentColor.value,
                    ),
                    title: ConversationStyleWidgetState.localName(controller.conversationStyle.value).capitalizeFirst??"",
                    description: controller.conversationToolTipMessage2.value.capitalizeFirst.toString(),
                    angle: -0.1,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: Get.height * 0.07),
          const Text(
            "Chat Style",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          const SizedBox(height: 15),
          const Text(
            "Choose how you want Ask QX to respond to your queries. You can chat in three different styles.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color.fromRGBO(255, 255, 255, 0.702), fontSize: 16),
          ),
          const SizedBox(height: 20),
          Column(
            children: [
              const SizedBox(height: 15),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 26.0),
                  child: AnimatedToggleSwitch.size(
                      current: controller.conversationStyle.value,
                      values: controller.listOfStyle,
                      onChanged: (i) async {
                        controller.conversationStyle.value = i;
                        controller.changeConversationStyle(i.name.toString());
                      },
                      animationCurve: Curves.fastEaseInToSlowEaseOut,
                      style: ToggleStyle(
                        indicatorBoxShadow: [
                          BoxShadow(
                            color: controller.currentDarkColor.value,
                            blurRadius: 12,
                            blurStyle: BlurStyle.normal,
                            spreadRadius: -3,
                          )
                        ],
                        backgroundColor: controller.currentDarkColor.value.withOpacity(0.03),
                        borderColor: controller.currentDarkColor.value.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(30),
                        indicatorColor: controller.currentDarkColor.value,
                      ),
                      indicatorSize: const Size(double.infinity, double.infinity),
                      loading: false,
                      iconBuilder: (style) {
                        return Text(
                          ConversationStyleWidgetState.localName(style).capitalizeFirst.toString(),
                          style: TextStyle(
                            fontSize: controller.conversationStyle.value == style ? 11 : 13,
                            fontWeight: FontWeight.bold,
                            color: getTextColor(lightTheme: controller.conversationStyle.value == style ? Colors.white : Colors.black),
                          ),
                        );
                      }),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
          const SizedBox(height: 20),
        ],
      );
    });
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    super.key,
    required this.myIcon,
    required this.title,
    required this.description,
    required this.angle,
    required this.bg,
    this.tileColor = kPrimaryDark,
  });

  final Widget? myIcon;
  final String title;
  final String description;
  final double angle;
  final Color tileColor;
  final Color bg;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: angle,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
            constraints: BoxConstraints(maxWidth: Get.width * 0.85, maxHeight: Get.height * 0.3),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                border: Border.all(color: Colors.white.withOpacity(0.1), width: 1),
                gradient: LinearGradient(colors: [
                  Colors.white.withOpacity(0.09),
                  Colors.white.withOpacity(0.05),
                  Colors.white.withOpacity(0.02),
                ])),
            child: ListTile(
              title: Row(
                children: [
                  Padding(padding: const EdgeInsets.all(6), child: myIcon),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: tileColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              subtitle: Text(
                description,
                maxLines: 5,
                textAlign: TextAlign.start,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: bg, fontSize: 15, fontStyle: FontStyle.italic),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
