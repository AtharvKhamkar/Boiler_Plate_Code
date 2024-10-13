import 'package:ask_qx/controller/profile_controller.dart';
import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/network/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../firebase/firebase_analytic_service.dart';
import '../../widgets/custom_button.dart';


class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text(
          "Security",
          maxLines: 1,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: GetBuilder<ProfileController>(
        builder: (controller) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    "Delete Account",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),

                const Text('''Caution: Deleting your account is irreversible and will erase all your data permanently.'''),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 30),
                  child: CustomButton(
                    text: "Delete Account",
                    onPressed: () {
                      ErrorHandle.qxLabConfirmationDialogue(
                        title: 'Delete Account?',
                        message: 'Are you sure you want to delete your account? This action cannot be undone.',
                        onConfirm: () {
                          FirebaseAnalyticService.instance.logEvent("Click_Delete_Account");
                          controller.otpController.clear();
                          controller.deleteAccount();
                        },
                        confirmText: 'Delete',
                      );
                    },
                  ),
                ),

                const Divider(),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    "Hibernate Account",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),

                const Text("Note: Temporarily deactivate the user's account. Reactivate the account by logging in again."),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 30),
                  child: CustomButton(
                    text: "Hibernate Account",
                    onPressed: () {
                    ErrorHandle.qxLabConfirmationDialogue(
                      title: 'Hibernate Account?',
                      message: 'Are you sure you want to Hibernate your account?',
                      onConfirm: () {
                        AppStorage.logout();
                        FirebaseAnalyticService.instance.logEvent("Click_Hibernate_Account");
                        ErrorHandle.success('Your account has been hibernated');
                      },
                      confirmText: 'Hibernate',
                    );
                    },
                  ),
                ),

                const Divider(),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Text(
                    "Change Password",
                    style: TextStyle(
                      fontSize: 22,
                    ),
                  ),
                ),

                const Text("Note: Your account password will be change"),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 30),
                  child: CustomButton(
                    text: "Change Password",
                    onPressed: () {
                      ErrorHandle.qxLabConfirmationDialogue(
                          title: 'Change Password',
                          message: 'Do you want to change your password?',
                          confirmText: 'Yes',
                          cancelText: 'No',
                          dialogueType: DialogueType.info,
                          onConfirm: (){
                            controller.otpController.clear();
                            controller.sendCode();
                          }
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}