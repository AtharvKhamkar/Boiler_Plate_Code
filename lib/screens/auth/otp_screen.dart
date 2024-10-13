import 'package:animate_do/animate_do.dart';
import 'package:ask_qx/controller/auth_controller.dart';
import 'package:ask_qx/widgets/custom_form_button.dart';
import 'package:ask_qx/widgets/responsive_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../themes/colors.dart';
import '../../utils/utils.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (controller){
      return PopScope(
        canPop: true,
        onPopInvoked: (didPop) {
          controller.reset();
        },
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Get.theme.colorScheme.background,
            appBar: AppBar(
              leading: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                ),
              ),
              elevation: 0,
            ),
            body:  ResponsiveWidget(
              child: FadeInUp(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'OTP Verification',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'OTP sent on ${controller.emailController.text}',
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 50),
                      SizedBox(
                        width: context.width * 0.8,
                        child: Form(
                          key: controller.otpFormKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Directionality(
                                textDirection: TextDirection.ltr,
                                child: Pinput(
                                  length: 6,
                                  controller: controller.otpController,
                                  listenForMultipleSmsOnAndroid: false,
                                  defaultPinTheme: controller.defaultPinTheme,
                                  keyboardType: const TextInputType.numberWithOptions(),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please Enter The OTP';
                                    } else if (value.length != 6) {
                                      return 'Please Enter The OTP';
                                    }
                                    else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                                      return 'Enter Valid OTP';
                                    }
                                    return null;
                                  },
                                  hapticFeedbackType: HapticFeedbackType.mediumImpact,
                                  onCompleted: (pin) {},
                                  onChanged: (value) {},
                                  cursor: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(
                                        margin: const EdgeInsets.only(bottom: 9),
                                        width: 22,
                                        height: 1,
                                      ),
                                    ],
                                  ),
                                  followingPinTheme: controller.defaultPinTheme.copyWith(
                                    decoration: controller.defaultPinTheme.decoration!.copyWith(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: kPrimaryLight),
                                    ),
                                  ),
                                  disabledPinTheme:controller.defaultPinTheme.copyWith(
                                    decoration: controller.defaultPinTheme.decoration!.copyWith(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: getPrimaryColor(context: context),
                                      ),
                                    ),
                                  ),
                                  focusedPinTheme: controller.defaultPinTheme.copyWith(
                                    decoration: controller.defaultPinTheme.decoration!.copyWith(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: getPrimaryColor(context: context)),
                                    ),
                                  ),
                                  submittedPinTheme: controller.defaultPinTheme.copyWith(
                                    decoration: controller.defaultPinTheme.decoration!.copyWith(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color: getPrimaryColor(context: context)),
                                    ),
                                  ),
                                  errorPinTheme: controller.defaultPinTheme.copyWith(
                                    decoration: controller.defaultPinTheme.decoration!.copyWith(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.red),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 50),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: CustomFormButton(
                                  onPressed: () {
                                    FocusScope.of(context).unfocus();
                                    if (controller.otpFormKey.currentState!.validate()) {
                                      controller.verifyAccount();
                                    }
                                  },
                                  innerText: 'Verify Otp',
                                  isLoading: controller.isLoading.value,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Didn't get code? ",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                            ),
                          ),
                          TextButton(
                            onPressed: controller.limit<=0?() {
                              controller.resentCode();
                            }:null,
                            child: Text(
                              controller.limit > 0 ? "${controller.limit}s" : "Resend OTP",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                color: kPrimaryDark
                              ),
                            ),
                          )
                        ],
                      ),
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


