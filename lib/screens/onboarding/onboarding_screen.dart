import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:ask_qx/controller/onboarding_controller.dart';
import 'package:ask_qx/firebase/firebase_analytic_service.dart';
import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/screens/auth/signup_screen.dart';
import 'package:concentric_transition/concentric_transition.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../binding/auth_binding.dart';
import '../auth/login_screen.dart';

// OnBoardingScreen
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {

  @override
  void initState() {
    super.initState();
    FirebaseAnalyticService.instance.logEvent('Click_Walkthroug1');
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      builder: (controller) {
        return Scaffold(
          extendBody: true,
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [0,1,2].map((e){
                return Container(
                  margin: const EdgeInsets.only(right: 4),
                  decoration: BoxDecoration(
                    color:controller.pageIndex==e?controller.indicator[controller.pageIndex]:Colors.grey,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  height: 6,
                  width: controller.pageIndex==e?16:6,
                );
              }).toList(),
            ),
          ),
          body: ConcentricPageView(
            radius: 280,
            duration: const Duration(milliseconds: 600),
            onChange: (index) {
              FirebaseAnalyticService.instance.logEvent('Click_Walkthroug${index +1}');
              controller.pageIndex = index;
              controller.update();
            },
            onFinish: () {
              if(AppStorage.isLoggedOut()){
                Get.offAll(() => const LoginScreen(backAction: "signup",), binding: AuthBinding());
              }else{
                Get.offAll(() => const SignUpScreen(), binding: AuthBinding());
              }
            },
            nextButtonBuilder: (ctx) {
              return Container(
                padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if(controller.pageIndex==2)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedTextKit(
                          displayFullTextOnTap: true,
                          isRepeatingAnimation: true,
                          pause: const Duration(seconds: 1),
                          repeatForever: true,
                          animatedTexts: controller.listOfOboard.map((e) => TyperAnimatedText(
                            e,
                            textAlign: TextAlign.center,
                            textStyle: const TextStyle(overflow: TextOverflow.ellipsis, fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
                            speed: const Duration(milliseconds: 80),
                          )).toList(),
                        ),
                        const SizedBox(
                          width: 2,
                        ),
                        Image.asset(
                          "assets/QX_logo-02.png",
                          key: UniqueKey(),
                          height: 22,
                          width: 22,
                          color: controller.currentColor.value,
                        ),
                      ],
                    ),
                  Padding(
                    padding: EdgeInsets.only(top: controller.pageIndex==2?20:40),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 28,
                      color: Color(0xffFFC444),
                    ),
                  ),
                ],
              ),
            );
            },
            colors: controller.colors,
            itemCount: 3,
            itemBuilder: (int index,) {
              return controller.children[index];
            },
          ),
        );
      }
    );
  }
}