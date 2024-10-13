

import 'package:animate_do/animate_do.dart';
import 'package:ask_qx/controller/auth_controller.dart';
import 'package:ask_qx/global/app_config.dart';
import 'package:ask_qx/global/app_util.dart';
import 'package:ask_qx/network/error_handler.dart';
import 'package:ask_qx/screens/auth/login_screen.dart';
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

class SignUpScreen extends StatefulWidget {
  final String backAction;
  const SignUpScreen({super.key,this.backAction = ""});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {

    return GetBuilder<AuthController>(builder: (controller){
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {},
        child: Scaffold(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          body: ResponsiveWidget(
            child: FadeInUp(
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: controller.signupFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Center(child: PageHeading(title: "SIGN UP")),
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
                              onTap:()=>controller.loginWithGoogle(eventName: 'Sign_UP_Google'),
                              icon: Image.asset("google.png".toIcon,width: 20,),
                              text: "Google",
                              isLoading: controller.isGoogleSignInLoading.value,
                            ),
                            const SizedBox(width: 20,),
                            SocialButton(
                              onTap:() =>controller.loginWithLinkedIn(eventName: 'Sign_Up_LinkedIn'),
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
                        CustomInputField2(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          errorMessage: "",
                          listOfAutofill: const [
                            AutofillHints.name,
                          ],
                          colorText: Colors.white,
                          controller: controller.nameController,
                          labelText: "Name ",
                          hintText: "Enter Your Name",
                          validator: (value)=>AppValidatorUtil.validateName(value),
                          onChanged: (c){
                            // controller.signupFormKey.currentState!.validate();
                          },
                          inputType: TextInputType.name,
                          textCapitalization: TextCapitalization.words,
                          prefixIcon: const Icon(
                            Icons.person,
                            color: Colors.white70,
                          ),
                        ),
                        Obx(
                          () => CustomInputField2(
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            errorMessage: controller.errorEmailMessage.value,
                            listOfAutofill: const [
                              AutofillHints.email,
                            ],
                            colorText: Colors.white,
                            controller: controller.emailController,
                            labelText: "Email ",
                            hintText: "Enter Email ID",
                            validator: (value)=>AppValidatorUtil.validateEmail(value),
                            onChanged: (c) {
                              // controller.signupFormKey.currentState!.validate();
                            },
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
                            errorMessage: controller.errorPasswordMessage.value,
                            listOfAutofill: const [
                              AutofillHints.password,
                            ],
                            colorText: Colors.white,
                            controller: controller.passwordController,
                            labelText: "Password",
                            hintText: "Enter Password",
                            validator: (value) =>AppValidatorUtil.validatePassword(value),
                            inputType: TextInputType.visiblePassword,
                            onChanged: (c) {
                              // controller.signupFormKey.currentState!.validate();
                            },
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
                        const SizedBox(height: 15),
                        Obx(
                          () => Center(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: ListTile(
                                enableFeedback: true,
                                onTap: () {
                                  AppUtil.launchAppUrl(
                                      AppConfig.termsCondition);
                                },
                                horizontalTitleGap: 1,
                                leading: Checkbox(
                                  value: controller.acceptTnC.value,
                                  onChanged: (value) {
                                    controller.acceptTnC(value);
                                  },
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0)),
                                  activeColor: kPrimaryLight,
                                  checkColor: Colors.white,
                                ),
                                contentPadding: EdgeInsets.zero,
                                title: RichText(
                                  text: TextSpan(
                                    text: "I accept the ",
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 15),
                                    children: [
                                      TextSpan(
                                        text: "Terms & Conditions",
                                        style: TextStyle(
                                            color: Colors.blue.shade100,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15),
                                      ),
                                      const TextSpan(
                                        text: " of ",
                                        style: TextStyle(
                                          fontSize: 15,
                                          color: Colors.white70,
                                        ),
                                      ),
                                      WidgetSpan(
                                        alignment: PlaceholderAlignment.middle,
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 2),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Text(
                                                "Ask",
                                                style: TextStyle(
                                                    color: Colors.white70,
                                                    fontSize: 15),
                                              ),
                                              const SizedBox(width: 4),
                                              Image.asset("qx.png".toIcon,
                                                  height: 20,
                                                  color: Colors.white70),
                                              const SizedBox(width: 4),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 15),
                        Obx(
                              () => CustomFormButton(
                            isEnable: controller.acceptTnC.value &&
                                !controller.isLoading.value &&
                                controller.emailController.text.isNotEmpty &&
                                controller.nameController.text.isNotEmpty &&
                                controller.passwordController.text.isNotEmpty,
                            isLoading: controller.isLoading.value,
                            innerText: "Sign Up",
                            onPressed: () {
                              if (!controller.signupFormKey.currentState!.validate()) {
                              } else if (!controller.acceptTnC.value) {
                                ErrorHandle.error( "Please accept the terms and conditions to proceed.");
                              } else {
                                FirebaseAnalyticService.instance.logEvent('Registration_Initiated');
                                controller.register();
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Already have an account? ',
                              style: textStyle(size: 15, weight: FontWeight.normal, color: Colors.white),
                            ),
                            GestureDetector(
                              onTap: () {
                                FirebaseAnalyticService.instance.logEvent('Sign_In_Toggle');
                                controller.isHapticOn.value = true;
                                if(widget.backAction == "back"){
                                  Get.back();
                                }else{
                                  Get.to(()=> const LoginScreen());
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4.0),
                                child: Text(
                                  'Sign In',
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
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
