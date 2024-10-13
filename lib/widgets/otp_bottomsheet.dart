import 'package:ask_qx/controller/profile_controller.dart';
import 'package:ask_qx/utils/validator_utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/utils.dart';
import 'custom_form_button.dart';
import 'custom_input_field.dart';

class OtpBottomSheet extends StatelessWidget {

  const OtpBottomSheet({super.key});


  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return PopScope(
          canPop: false,
          child: Container(
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.background,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
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
                          "Verification code",
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
                Form(
                  key: controller.validateKey,
                  child: CustomInputField(
                    listOfAutofill: const [],
                    controller: controller.otpController,
                    labelText: "Verification Code",
                    hintText: "Enter Verification Code",
                    colorText: getTextColor(),
                    hintColor: getSubTitleColor(),
                    validator: (value)=> AppValidatorUtil.validateVerificationCode(value),
                    inputType: TextInputType.number,
                    prefixIcon: Icon(
                      Icons.lock_clock_outlined,
                      color: Colors.blue.shade700,
                    ),
                    suffixIcon: false,
                    isDense: true,
                    obscureText: false,
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(right: 10),
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: controller.limit<=0?(){
                      controller.send("DELETE_ACCOUNT");
                    }:null,
                    child: Text(controller.limit<=0 ? "Resend" : "Resend in ${controller.limit}s"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 20),
                  child: CustomFormButton(
                    isLoading: controller.isLoading.value,
                    innerText: "Submit",
                    onPressed: () {
                      if(controller.validateKey.currentState!.validate()){
                        controller.delete();
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }




}
