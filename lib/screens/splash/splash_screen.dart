import 'package:ask_qx/binding/auth_binding.dart';
import 'package:ask_qx/binding/onboarding_binding.dart';
import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/screens/auth/login_screen.dart';
import 'package:ask_qx/screens/auth/signup_screen.dart';
import 'package:ask_qx/screens/onboarding/onboarding_screen.dart';
import 'package:ask_qx/widgets/qx_branding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../binding/chat_binding.dart';
import '../../firebase/firebase_messaging_service.dart';
import '../../utils/utils.dart';
import '../chat/chat_ai_screen.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3),(){
      FirebaseMessageService.instance.permission();
      if(AppStorage.isLoggedIn()){
        Get.offAll(()=>const ChatAiScreen(),binding: ChatBinding());
        return;
      }else if (AppStorage.isNewUser()){
        Get.offAll(()=> const OnBoardingScreen(),binding: OnboardingBinding());
        return;
      }else{
        Get.offAll(()=>  AppStorage.isAccountDeleted()? const SignUpScreen() : const LoginScreen(backAction: "signup",),binding: AuthBinding());
        return;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              const Spacer(),
              Image.asset(
                "assets/QX_logo-02.png",  
                height: 140,
                width: 140,
                color: getTextColor(),
              ).animate().fadeIn(),
              const SizedBox(
                height: 30,
              ),

              const QxBrandingWidget()
                  .animate()
                  .fadeIn(
                    delay: const Duration(milliseconds: 600),
                  )
                  .slide(
                    delay: const Duration(milliseconds: 800),
                  ),
              const Spacer(),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
