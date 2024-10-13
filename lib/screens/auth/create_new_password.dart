import 'package:animate_do/animate_do.dart';
import 'package:ask_qx/controller/auth_controller.dart';
import 'package:ask_qx/utils/validator_utils.dart';
import 'package:ask_qx/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../widgets/chat_ai_custom_header.dart';
import '../../widgets/custom_form_button.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/qx_branding_widget.dart';

class CreatePasswordScreen extends StatefulWidget {
  const CreatePasswordScreen({Key? key}) : super(key: key);

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (controller){
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
        },
        child: Scaffold(
          backgroundColor: context.theme.scaffoldBackgroundColor,
          body: ResponsiveWidget(
            child: FadeInUp(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ImageAnimateRotate(
                        child: Image.asset(
                          "assets/QX_logo-02.png",
                          height: 130,
                          width: 130,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const QxBrandingWidget(),
                      Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(
                          left: 22,
                          right: 22,
                          top: 22,
                        ),
                        child: const Text(
                          'Create New Password',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Form(
                        key: controller.newPasswordFormKey,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CustomInputField(
                              listOfAutofill: const [],
                              controller: controller.otpController,
                              labelText: "OTP",
                              hintText: "Enter Verification Code",
                              validator: (value)=>AppValidatorUtil.validateVerificationCode(value),
                              colorText: Colors.white,
                              hintColor: Colors.white70,
                              inputType: TextInputType.number,
                              prefixIcon: const Icon(Icons.lock_clock_outlined, color: Colors.white70),
                              suffixIcon: false,
                              isDense: true,
                              obscureText: false,
                            ),
                            Container(
                              margin: const EdgeInsets.only(right: 10),
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                onPressed: controller.limit<=0?(){
                                  controller.resendForgotPassword();
                                }:null,
                                child: Text(controller.limit<=0 ? "Resend" : "Resend in ${controller.limit}s"),
                              ),
                            ),
                            CustomInputField(
                              listOfAutofill: const [
                                AutofillHints.password,
                              ],
                              controller: controller.passwordController,
                              labelText: "Password",
                              hintText: "Enter Password",
                              validator: (value)=>AppValidatorUtil.validatePassword(value),
                              colorText: Colors.white,
                              hintColor: Colors.white70,
                              inputType: TextInputType.visiblePassword,
                              formatter: [
                                FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
                              ],
                              prefixIcon: const Icon(Icons.password, color: Colors.white70),
                              suffixIcon: true,
                              isDense: true,
                              obscureText: true,
                            ),
                            CustomInputField(
                              listOfAutofill: const [
                                AutofillHints.password,
                              ],
                              colorText: Colors.white,
                              hintColor: Colors.white70,
                              controller: controller.conformPassword,
                              labelText: "Confirm Password",
                              hintText: "Confirm Password",
                              validator: (value)=>AppValidatorUtil.validatePasswordNotMatch(value, controller.passwordController.text),
                              inputType: TextInputType.visiblePassword,
                              formatter: [
                                FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
                              ],
                              prefixIcon: const Icon(Icons.password,
                                  color: Colors.white70),
                              suffixIcon: true,
                              isDense: true,
                              obscureText: true,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Obx(() => CustomFormButton(
                        isLoading: controller.isLoading.value,
                        innerText: "Submit",
                        onPressed: () {
                          if (controller.newPasswordFormKey.currentState!.validate()) {
                            controller.resetPassword();
                          }
                        },
                      ),
                      ),
                      const SizedBox(height: 36),
                    ],
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
