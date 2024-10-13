
import 'package:ask_qx/global/app_util.dart';
import 'package:ask_qx/model/conversation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../controller/chat_controller.dart';
import '../firebase/firebase_analytic_service.dart';
import '../utils/utils.dart';
import 'custom_form_button.dart';
import 'custom_input_field.dart';

class RenameConversationBottomSheet extends StatelessWidget {
  const RenameConversationBottomSheet({Key? key, required this.item}) : super(key: key);
  final Item item;
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (controller) {
      return PopScope(
        canPop: false,
        child: Container(
          decoration: BoxDecoration(
            color: Get.theme.colorScheme.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
            child: Form(
              key: controller.renameFormKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rename Chat",
                        style: TextStyle(
                          color: getTextColor(),
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                          FirebaseAnalyticService.instance.logEvent('Close_Rename_Chat');
                          HapticFeedback.lightImpact();
                        },
                        child: const Icon(Icons.highlight_remove),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(
                    color: Colors.grey,
                    height: 0,
                    thickness: 0.5,
                  ),
                  const SizedBox(height: 4),
                  CustomInputField(
                    listOfAutofill: const [],
                    controller: controller.renameController,
                    labelText: "Chat Name",
                    hintText: "Chat Name",
                    colorText: getTextColor(),
                    hintColor: getSubTitleColor(),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter chat name';
                      }
                      return null;
                    },
                    inputType: TextInputType.text,
                    prefixIcon: Icon(
                      Icons.drive_file_rename_outline,
                      color: AppUtil.styleColor(item.style),
                    ),
                    suffixIcon: false,
                    isDense: true,
                    obscureText: false,
                    textCapitalization: TextCapitalization.words,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                    child: CustomFormButton(
                      isLoading: controller.renameLoading.value,
                      innerText: "Rename",
                      onPressed: () {
                        if (controller.renameFormKey.currentState!.validate()) {
                          controller.onRename(item);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
