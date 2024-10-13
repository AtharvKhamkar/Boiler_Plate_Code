
import 'package:ask_qx/controller/auth_controller.dart';
import 'package:ask_qx/screens/auth/signup_screen.dart';
import 'package:ask_qx/utils/extension_utils.dart';
import 'package:ask_qx/utils/validator_utils.dart';
import 'package:ask_qx/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../firebase/firebase_analytic_service.dart';
import '../../themes/colors.dart';
import '../../widgets/custom_form_button.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/page_heading.dart';
import 'forgot_password.dart';

class LoginScreen extends StatelessWidget {
  final String backAction;
  const LoginScreen({super.key,this.backAction = ""});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (controller){
      return Scaffold(
        backgroundColor: context.theme.scaffoldBackgroundColor,
        body: ResponsiveWidget(
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: controller.loginFormKey,
                child: Column(
                  children: [
                    const Center(child: PageHeading(title: "Login")),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                           Text(
                            'With',
                            style: textStyle(size: 14, weight: FontWeight.normal, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialButton(
                          onTap:()=>controller.loginWithGoogle(eventName: 'Sign_In_With_Google'),
                          icon: Image.asset("google.png".toIcon,width: 20,),
                          text: "Google",
                          isLoading: controller.isGoogleSignInLoading.value,
                        ),
                        const SizedBox(width: 20),
                        SocialButton(
                          onTap:() =>controller.loginWithLinkedIn(eventName: 'Sign_In_With_LinkedIn'),
                          icon: Image.asset("linkedin.png".toIcon,width: 20,color: Colors.blue,),
                          text: "LinkedIn",
                          isLoading: controller.isLinkedInSigningLoading.value,
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 0.5,
                            color: Colors.grey,
                            width: context.width*0.30,
                            margin: const EdgeInsets.only(right: 4),
                          ),
                          Text(
                            'OR',
                            style: textStyle(size: 14, weight: FontWeight.normal, color: Colors.white),
                          ),
                          Container(
                            height: 0.5,
                            color: Colors.grey,
                            width: context.width*0.30,
                            margin: const EdgeInsets.only(left: 4),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        'With Email',
                        style: textStyle(size: 14, weight: FontWeight.normal, color: Colors.white),
                      ),
                    ),
                    Obx(
                      () => CustomInputField2(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        errorMessage: controller.errorEmailMessage.value,
                        listOfAutofill: const [AutofillHints.email],
                        colorText: Colors.white,
                        controller: controller.emailController,
                        labelText: "Email ",
                        hintText: "Enter Email ID",
                        onChanged: (c) {},
                        validator:(value)=> AppValidatorUtil.validateEmail(value),
                        inputType: TextInputType.emailAddress,
                        prefixIcon: const Icon(
                          Icons.email,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                    Obx(
                      () => CustomInputField2(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        colorText: Colors.white,
                        listOfAutofill: const [
                          AutofillHints.password,
                        ],
                        controller: controller.passwordController,
                        labelText: "Password",
                        hintText: "Enter Password",
                        errorMessage: controller.errorPasswordMessage.value,
                        validator: (value) =>AppValidatorUtil.validateEmpty(value: value,message: 'password'),
                        onChanged: (c) {},
                        inputType: TextInputType.visiblePassword,
                        formatter: [
                          FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
                        ],
                        prefixIcon: const Icon(
                          Icons.password,
                          color: Colors.white70,
                        ),
                        suffixIcon: true,
                        isDense: true,
                        obscureText: true,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            )
                        ),
                        onPressed: () {
                          controller.emailController.clear();
                          FirebaseAnalyticService.instance.logEvent('Forgot_Password');
                          Get.to(() => const ForgotPasswordScreen())!.then((value){
                            controller.emailController.clear();
                            controller.passwordController.clear();
                            controller.loginFormKey = GlobalKey<FormState>();
                            controller.update();
                            Future.delayed(const Duration(milliseconds: 400),(){
                              controller.loginFormKey.currentState!.reset();
                            });
                          });
                        },
                        child: Text(
                          'Forgot Password?',
                          style: textStyle(color: Colors.white,),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Obx(
                          () => CustomFormButton(
                        isLoading: controller.isLoading.value,
                        innerText: "Sign In",
                        onPressed: () {
                          if (controller.loginFormKey.currentState!.validate()) {
                            controller.login();
                          }
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: textStyle(size: 15, weight: FontWeight.normal, color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.isHapticOn.value = true;
                            controller.emailController.clear();
                            controller.passwordController.clear();
                            controller.signupFormKey = GlobalKey<FormState>();
                            controller.loginFormKey = GlobalKey<FormState>();
                            controller.update();
                            FirebaseAnalyticService.instance.logEvent('Sign_Up_Toggle');
                            if(backAction=="signup"){
                              Get.to(()=>const SignUpScreen(backAction: "back",));
                            }else {
                              Get.back();
                            }
                            Future.delayed(const Duration(milliseconds: 400),(){
                              controller.signupFormKey.currentState!.reset();
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              'Sign Up',
                              style: textStyle(
                                size: 15,
                                weight: FontWeight.bold,
                                color: Colors.blue,
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
        ),
      );
    });
  }
}
