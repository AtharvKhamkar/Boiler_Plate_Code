import 'package:ask_qx/controller/profile_controller.dart';
import 'package:ask_qx/utils/validator_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../firebase/firebase_analytic_service.dart';
import '../utils/utils.dart';
import 'custom_form_button.dart';
import 'custom_input_field.dart';

class ChangePaasBottomSheet extends StatelessWidget {
  const ChangePaasBottomSheet({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (controller) {
      return PopScope(
        canPop: false,
        child: Container(
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Form(
            key: controller.passwordFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    const Center(
                      child:  Padding(
                        padding: EdgeInsets.only(
                          left: 22,
                          right: 22,
                          top: 20,
                        ),
                        child: Text(
                          "Change Password",
                          style: TextStyle(
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () => Get.back(),
                        icon: const Icon(
                          Icons.clear,
                        ),
                      ),
                    )
                  ],
                ),
                CustomInputField(
                  listOfAutofill: const [],
                  controller: controller.otpController,
                  labelText: "Verification Code",
                  hintText: "Enter Verification Code",
                  colorText: getTextColor(
                  ),
                  hintColor: getSubTitleColor(),
                  validator: (value)=>AppValidatorUtil.validateVerificationCode(value),
                  inputType: TextInputType.number,
                  prefixIcon: Icon(
                    Icons.lock_clock_outlined,
                    color: Colors.blue.shade700,
                  ),
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
                      controller.send("CHANGE_PASSWORD");
                    }:null,
                    child: Text(controller.limit<=0 ? "Resend" : "Resend in ${controller.limit}s"),
                  ),
                ),
                CustomInputField(
                  listOfAutofill: const [],
                  controller: controller.passwordOldController,
                  labelText: "Password",
                  hintText: "Enter New Password",
                  colorText: getTextColor(
                  ),
                  hintColor: getSubTitleColor(),
                  validator: (value) =>AppValidatorUtil.validateNewPassword(value),
                  inputType: TextInputType.visiblePassword,
                  formatter: [
                    FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
                  ],
                  prefixIcon: Icon(
                    Icons.password,
                    color: Colors.blue.shade700,
                  ),
                  suffixIcon: true,
                  isDense: true,
                  obscureText: true,
                ),
                CustomInputField(
                  listOfAutofill: const [],
                  controller: controller.passwordNewController,
                  labelText: "Confirm Password",
                  hintText: "Enter Confirm Password",
                  validator: (value)=>AppValidatorUtil.validateConfirmPassword(value, controller.passwordOldController.text.trim()),
                  colorText: getTextColor(
                  ),
                  hintColor: getSubTitleColor(),
                  inputType: TextInputType.visiblePassword,
                  formatter: [
                    FilteringTextInputFormatter.deny(RegExp(r'[ ]')),
                  ],
                  prefixIcon: Icon(
                    Icons.password,
                    color: Colors.blue.shade700,
                  ),
                  suffixIcon: true,
                  isDense: true,
                  obscureText: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 20),
                  child: CustomFormButton(
                    isLoading: controller.isLoading.value,
                    innerText: "Change Password",
                    onPressed: () {
                      if (controller.passwordFormKey.currentState!.validate()) {
                        FirebaseAnalyticService.instance.logEvent("Click_Change_Password");
                        controller.changePassword();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
