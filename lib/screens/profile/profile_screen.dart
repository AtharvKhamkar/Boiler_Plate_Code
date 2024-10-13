import 'package:ask_qx/firebase/firebase_analytic_service.dart';
import 'package:ask_qx/utils/validator_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../controller/profile_controller.dart';
import '../../themes/colors.dart';
import '../../utils/utils.dart';
import '../../widgets/custom_form_button.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          title: const Text(
            "Set up your Profile",
            maxLines: 1,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: controller.editFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: context.width * 0.32,
                  height: context.width * 0.35,
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: greyColor, width: 2)),
                        child: GestureDetector(
                          onTap: () {
                            if(controller.imageFile!=null || controller.imageUrl.isNotEmpty){
                              Get.dialog(
                                GestureDetector(
                                  onTap: Get.back,
                                  child: Dialog(
                                    backgroundColor: Colors.transparent,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(20),
                                      child: controller.imageFile!=null?
                                      Image.file(controller.imageFile!, fit: BoxFit.contain):
                                      Image.network(controller.imageUrl, fit: BoxFit.contain)
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.grey,
                            maxRadius: 100,
                            child: controller.imageFile != null
                                ? CircleAvatar(
                                    maxRadius: 100,
                                    backgroundImage: FileImage(controller.imageFile!),
                                  )
                                : CachedNetworkImage(
                                    imageUrl: controller.imageUrl.isEmpty ? 'https://avatar.iran.liara.run/public/boy?username=Scott' : controller.imageUrl,
                                    errorWidget: (context, url, error) => Center(
                                      child: Image.asset(
                                        "assets/images/img.png",
                                      ),
                                    ),
                                    placeholder: (context, url) => Container(
                                      height: 100,
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                      ),
                                      width: double.infinity,
                                    )
                                        .animate(
                                          onPlay: (controller) => controller.repeat(),
                                        )
                                        .shimmer(
                                          duration: const Duration(milliseconds: 1500),
                                          color: Colors.grey.shade400,
                                        ),
                                    imageBuilder: (context, imageProvider) {
                                      return CircleAvatar(
                                        backgroundImage: imageProvider,
                                        maxRadius: 100,
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -10,
                        right: 9,
                        child: IconButton(
                          onPressed: () {
                            controller.openDialog();
                          },
                          icon: const CircleAvatar(
                            maxRadius: 18,
                            backgroundColor: kPrimaryLight,
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                  child: TextFormField(
                    onChanged: (value) => controller.onChange(value),
                    validator: (value) => AppValidatorUtil.validateFirstName(value, 'first name'),
                    enableSuggestions: true,
                    textInputAction: TextInputAction.next,
                    autofocus: false,
                    controller: controller.firstNameController,
                    decoration: InputDecoration(
                      hintText: 'First Name',
                      hintStyle: TextStyle(
                        color: getTextColor(lightTheme: greyColor, darkTheme: greyColor),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      errorStyle: const TextStyle(color: Colors.red),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                  child: TextFormField(
                    onChanged: (value) => controller.onChange(value),
                    validator: (value) => AppValidatorUtil.validateFirstName(value, 'last name'),
                    enableSuggestions: true,
                    textInputAction: TextInputAction.next,
                    autofocus: false,
                    controller: controller.lastNameController,
                    decoration: InputDecoration(
                      hintText: 'Last Name',
                      hintStyle: TextStyle(color: getTextColor(lightTheme: greyColor, darkTheme: greyColor)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      errorStyle: const TextStyle(color: Colors.red),
                    ),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                if (controller.redOnly.value) const SizedBox(),
                if (!controller.redOnly.value) const SizedBox(height: 30),
                if (!controller.redOnly.value)
                  CustomFormButton(
                    isLoading: controller.isLoading.value,
                    onPressed: () {
                      if (!controller.redOnly.value) {
                        if (controller.editFormKey.currentState!.validate()) {
                          FirebaseAnalyticService.instance.logEvent("Click_Edit_Profile");
                          controller.updateProfile();
                        }
                      }
                    },
                    innerText: 'Save Changes',
                  ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
