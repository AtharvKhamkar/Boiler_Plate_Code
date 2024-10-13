import 'package:ask_qx/binding/archive_chat_binding.dart';
import 'package:ask_qx/binding/profile_binding.dart';
import 'package:ask_qx/binding/share_chat_link_binding.dart';
import 'package:ask_qx/binding/subscription_binding.dart';
import 'package:ask_qx/firebase/remote_config_service.dart';
import 'package:ask_qx/global/app_config.dart';
import 'package:ask_qx/global/app_data_provider.dart';
import 'package:ask_qx/global/app_dialogue_handler.dart';
import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/model/conversation.dart';
import 'package:ask_qx/network/error_handler.dart';
import 'package:ask_qx/screens/chat/archive_chat_screen.dart';
import 'package:ask_qx/screens/chat/share_chat_link_screen.dart';
import 'package:ask_qx/screens/profile/security_screen.dart';
import 'package:ask_qx/screens/setting/follow_us_screen.dart';
import 'package:ask_qx/screens/subscription/subscription_screen.dart';
import 'package:ask_qx/services/method_channel_service.dart';
import 'package:ask_qx/utils/extension_utils.dart';
import 'package:ask_qx/widgets/qx_branding_widget.dart';
import 'package:ask_qx/widgets/session_manager_bottomsheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../../firebase/firebase_analytic_service.dart';
import '../../global/app_util.dart';
import '../../services/theme.dart';
import '../../themes/colors.dart';
import '../../widgets/custom_setting_listtile.dart';
import '../profile/profile_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool darkMode = false;

  final scrollController = ScrollController();

  Map<String,dynamic> options = {};

  @override
  void initState() {
    super.initState();
    darkMode = ThemeService().themeBool();
    options = RemoteConfigService.instance.developerOptions();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Settings",
          maxLines: 1,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  const SizedBox(height: 5),
                  GestureDetector(
                      onTap: () {
                        Get.to(
                          () => const ProfileScreen(),
                          binding: ProfileBinding(),
                          transition: Transition.rightToLeft,
                        )!.then((value) {
                          if (value != null && value == true) {
                            setState(() {});
                          }
                        });
                      },
                      child: profileViewTile(),
                  ),
                  const SizedBox(height: 10),
                  heading("General"),
                  CustomSettingListTile(
                    prefixIcon: Icons.person,
                    labelText: "Edit Profile",
                    trailingWidget: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                    onTap: () {
                      Get.to(() => const ProfileScreen(),binding: ProfileBinding(),transition: Transition.rightToLeft,)!.then((value){
                        if(value!=null && value==true){
                          setState(() {});
                        }
                      });
                    },
                  ),
                  CustomSettingListTile(
                    prefixIcon: Icons.security,
                    labelText: "Security",
                    trailingWidget: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                    onTap: () {
                      Get.to(() => const SecurityScreen(),binding: ProfileBinding(),transition: Transition.rightToLeft,);
                    },
                  ),
                  CustomSettingListTile(
                    prefixIcon: Icons.archive_outlined,
                    labelText: "Archived Chat",
                    trailingWidget: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                    onTap: () {
                      Get.to(() => const ArchiveChatScreen(),binding: ArchiveChatBinding(),transition: Transition.rightToLeft,)!.then((value){
                        if(value!= null && value is Item){
                          Get.back(result: value);
                        }
                      });
                    },
                  ),
                  CustomSettingListTile(
                    prefixIcon: Icons.link_rounded,
                    labelText: "Shared Links",
                    trailingWidget: const Icon(Icons.arrow_forward_ios, size: 20),
                    onTap: () {
                      Get.to(() => const ShareChatLinkScreen(), binding: ShareChatLinkBinding(), transition: Transition.rightToLeft)!.then((value) {
                        if (value != null) {
                          Get.back(result: value);
                        }
                      });
                    },
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: context.theme.scaffoldBackgroundColor,
                          width: 0.5,
                        ),
                      ),
                    ),
                    child: CustomSettingListTile(
                      prefixIcon: Icons.attach_money_rounded,
                      labelText: "Subscription Plus",
                      trailingWidget: const Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                      onTap: () {
                        FirebaseAnalyticService.instance.logEvent("Click_Subscription_Plus");
                        Get.to(
                          () => const SubscriptionScreen(),
                          binding: SubscriptionBinding(),
                          transition: Transition.rightToLeft,
                        );
                      },
                    ),
                  )
                      .animate(
                        onPlay: (controller) => controller.repeat(),
                      )
                      .shimmer(angle: 250, duration: const Duration(seconds: 2), color: kSecondary),
                  CustomSettingListTile(
                    prefixIcon:Get.isDarkMode? Icons.dark_mode_outlined:Icons.light_mode,
                    labelText: "Dark Mode",
                    trailingWidget: Switch(
                      value: darkMode,
                      onChanged: (value) {
                        setState(() {
                          darkMode=value;
                        });
                        Get.changeThemeMode(ThemeMode.dark);
                          ThemeService().switchTheme();
                      },
                    ),
                    onTap: () {
                      ///Not in use here
                      ///Or Here we also can manage the switch operation
                    },
                  ),
                  heading("About"),
                  CustomSettingListTile(
                    prefixIcon:  Icons.person_add_alt,
                    labelText: "Follow Us",
                    trailingWidget: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                    onTap: () {
                      Get.to(()=> const FollowUsScreen(),transition:Transition.rightToLeft);
                    },
                  ),
                  CustomSettingListTile(
                    prefixIcon: Icons.feedback_outlined,
                    labelText: "Feedback",
                    trailingWidget: const Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                    onTap: () {
                      FirebaseAnalyticService.instance.logEvent('Click_Feedback_From_Setting');
                      AppDialogueHandler.feedBackDialogue();
                    },
                  ),
                  CustomSettingListTile(
                    prefixIcon: Icons.share_outlined,
                    labelText: "Share App",
                    trailingWidget: const Icon(Icons.open_in_new, size: 18,),
                    onTap: (){
                      final message = RemoteConfigService.instance.shareAppMessage();
                      Share.share(message,subject: "Ask QX");
                    },
                  ),
                  CustomSettingListTile(
                    prefixIcon: Icons.star_rounded,
                    labelText: "Rate us",
                    trailingWidget: const Icon(Icons.open_in_new, size: 18,),
                    onTap: () =>AppUtil.launchReview(),
                  ),
                  CustomSettingListTile(
                    prefixIcon: Icons.privacy_tip_outlined,
                    labelText: "Privacy Policy",
                    trailingWidget: const Icon(
                      Icons.open_in_new,
                      size: 18
                    ),
                    onTap: () {
                      FirebaseAnalyticService.instance.logEvent("Click_Privacy_Policy");
                      AppUtil.launchAppUrl(AppConfig.privacyPolicies);
                    },
                  ),
                  CustomSettingListTile(
                    prefixIcon: Icons.insert_drive_file_outlined,
                    labelText: "Terms & Conditions",
                    trailingWidget: const Icon(
                      Icons.open_in_new,
                      size: 18
                    ),
                    onTap: () {
                      FirebaseAnalyticService.instance.logEvent("Click_Terms_Condition");
                      AppUtil.launchAppUrl(AppConfig.termsCondition);
                      },
                    ),
                  CustomSettingListTile(
                    prefixIcon: Icons.live_help_outlined,
                    labelText: "FAQ",
                    trailingWidget: const Icon(
                      Icons.open_in_new,
                      size: 18
                    ),
                    onTap: () {
                      FirebaseAnalyticService.instance.logEvent("Click_FAQ");
                      AppUtil.launchAppUrl(AppConfig.faq);
                      },
                    ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: InkWell(
                      overlayColor: const MaterialStatePropertyAll(Colors.transparent),
                      onTap: (){
                        FirebaseAnalyticService.instance.logEvent("Click_About_Us");
                        AppUtil.launchAppUrl(AppConfig.aboutAskQx);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(Icons.info_outline_rounded, size: 24, color: Get.isDarkMode ? Colors.white60 : const Color.fromARGB(133, 0, 0, 0)),
                          const SizedBox(width: 10),
                          QxBrandingDescription(leadingText: 'About ', textSize: 15,color: darkLight,),
                          const Spacer(),
                          const Icon(Icons.open_in_new, size: 18),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                      onTap: () {
                        ErrorHandle.qxLabConfirmationDialogue(
                          title: 'Logout Confirmation',
                          message: 'Are you sure you want to log out?',
                          confirmText: 'Logout',
                          cancelText: "Cancel",
                          // dialogueType: ,
                          onConfirm: () {
                            FirebaseAnalyticService.instance.logEvent("Click_Logout");
                            AppStorage.logout();
                          },
                        );
                      },
                      child: Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.logout_rounded,
                                size: 28,
                                color: Colors.red[300],
                              ),
                            ),
                            Text(
                              "Logout",
                              style: TextStyle(
                                  // fontFamily: ,
                                  fontSize: 15,
                                  color: Colors.red[300],
                                  fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  if(AppDataProvider.devCount==5)...[
                    heading("Developer Option"),
                    CustomSettingListTile(
                      prefixIcon:  Icons.timer_outlined,
                      labelText: "Session Manager",
                      trailingWidget: const Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                      ),
                      onTap: () {
                        Get.bottomSheet(
                          SessionManagerBottomSheet(password: options['password'],),
                          isScrollControlled: true,
                        );
                      },
                    ),
                  ]
                ],
              ),
            ),
          ),
          FutureBuilder(
            future: MethodChannelService.instance.version(),
            builder: (context, snapshot) {
              if(snapshot.hasData){
                return InkWell(
                  onTap:options.containsKey("email")?(){
                    if(options['email'].toString().contains(AppStorage.getUserDetails().emailId)){
                      if(AppDataProvider.devCount == 5){
                        ErrorHandle.success("You are already developer.");
                        scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.ease);
                      }else{
                        setState(() {
                          ++AppDataProvider.devCount;
                        });
                      }
                    }
                  }:null,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text('${AppStorage.isDevBuild()?"Dev.":""}v.${snapshot.data}',style: TextStyle(color: Colors.grey.shade800,fontSize: 12),),
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
          context.kBottomSafePadding,
        ],
      ),
    );
  }


  Widget profileViewTile() {
    final userDetail = AppStorage.getUserDetails();
    return Row(
      key: UniqueKey(),
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CachedNetworkImage(
          key: UniqueKey(),
          height: Get.context!.width * 0.20,
          width: Get.context!.width * 0.20,
          imageUrl: userDetail.profileImage.isEmpty? 'https://avatar.iran.liara.run/public/boy?username=Scott': userDetail.profileImage,
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
          ).animate(
            onPlay: (controller) => controller.repeat(),
          ).shimmer(
            duration: const Duration(milliseconds: 1500),
            color: Colors.grey.shade400,
          ),
          imageBuilder: (context, imageProvider) => Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          fit: BoxFit.fill,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userDetail.fullName,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
               Text(
                userDetail.emailId,
                overflow: TextOverflow.ellipsis,
                style:const TextStyle(
                    overflow: TextOverflow.ellipsis,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: greyColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget heading(String headLine) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              headLine
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }

}
