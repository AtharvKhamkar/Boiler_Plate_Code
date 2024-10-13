import 'package:animate_do/animate_do.dart';
import 'package:ask_qx/controller/auth_controller.dart';
import 'package:ask_qx/utils/validator_utils.dart';
import 'package:ask_qx/widgets/responsive_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../themes/colors.dart';
import '../../widgets/chat_ai_custom_header.dart';
import '../../widgets/custom_form_button.dart';
import '../../widgets/custom_input_field.dart';
import '../../widgets/page_heading.dart';
import '../../widgets/qx_branding_widget.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (controller) {
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
                    key: controller.forgotFormKey,
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
                        const SizedBox(height: 24),
                        const QxBrandingWidget(),
                        const PageHeading(title: "Forgot Password"),
                        const SizedBox(height: 10),
                        CustomInputField2(
                          onChanged: (value) {
                            controller.forgotFormKey.currentState!.validate();
                            controller.update();
                          },
                          errorMessage: "",
                          colorText: Colors.white,
                          listOfAutofill: const [
                            AutofillHints.email,
                          ],
                          controller: controller.emailController,
                          labelText: "Email ",
                          hintText: "Enter Email ID",
                          validator: (value) =>
                              AppValidatorUtil.validateEmail(value),
                          inputType: TextInputType.emailAddress,
                          prefixIcon: const Icon(
                            Icons.email,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Obx(
                          () => CustomFormButton(
                            isEnable:
                                controller.emailController.text.isNotEmpty,
                            isLoading: controller.isLoading.value,
                            innerText: "Submit",
                            onPressed: () {
                              if (controller.forgotFormKey.currentState!
                                  .validate()) {
                                controller.forgotPassword();
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: context.width * 0.80,
                          alignment: Alignment.center,
                          child: GestureDetector(
                            onTap: () {
                              controller.isHapticOn.value = true;
                              Get.back();
                            },
                            child: Text(
                              'Go to Login',
                              style: textStyle(
                                size: 15,
                                color: kPrimaryDark,
                                weight: FontWeight.bold,
                              ),
                            ),
                          ),
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
