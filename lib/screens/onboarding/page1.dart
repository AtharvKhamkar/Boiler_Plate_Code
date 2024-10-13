import 'package:ask_qx/controller/onboarding_controller.dart';
import 'package:ask_qx/widgets/qx_branding_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../animation/suggestion_animation_widget.dart';
import '../../widgets/chat_ai_custom_header.dart';

class Page1 extends StatelessWidget {
  const Page1({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      builder: (controller) {
        return Column(
          children: [
            SizedBox(
              height: context.height * 0.12,
            ),
            ImageAnimateRotate(
              child: Image.asset(
                "assets/QX_logo-02.png",
                height: 140,
                width: 140,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            const QxBrandingDescription(leadingText: 'Welcome to ',textSize: 32,color: Colors.white,weight: FontWeight.bold,),
            const SizedBox(height: 10),
            const Padding(
              padding: EdgeInsets.all(6.0),
              child: Text(
                "The Future of AI Interactions \n Generative AI to Get More Efficient, Productive, and Creative.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 40),
            Container(
              width: Get.width * 0.9,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SuggestionAnimatedWidget(
                      suggestions: controller.promptsQuery,
                      title: 'Ask QX Anything',
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: context.height * 0.08),
            const SizedBox(height: 10),
          ],
        );
      }
    );
  }
}
