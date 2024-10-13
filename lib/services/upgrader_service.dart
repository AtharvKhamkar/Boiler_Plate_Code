
import 'package:ask_qx/firebase/remote_config_service.dart';
import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/global/app_util.dart';
import 'package:ask_qx/model/update_model.dart';
import 'package:ask_qx/services/method_channel_service.dart';
import 'package:ask_qx/themes/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:upgrader/upgrader.dart';

import '../widgets/chat_ai_custom_header.dart';

class UpgraderService {
  UpgraderService._();

  static final UpgraderService _instance = UpgraderService._();

  static UpgraderService get instance => _instance;

  final String _message = "We're excited to announce a new update for Ask QX is now available. In this update, we've made several enhancements to improve your overall experience and bring new features to your fingertips.";

  Future<void> isAvailable() async {
    // if(kDebugMode) return;
    UpdateModel? oldBuild;

    final list  = await RemoteConfigService.instance.updates();

    if(list.isEmpty) return;

    String bundleId = "com.qxlabai.askqx";
    final appVersionData = await MethodChannelService.instance.version();
    String appVersion = appVersionData.split("+").first;

    int v1 = int.parse(appVersion.replaceAll(".", ""));

    oldBuild = list.firstWhereOrNull((element) => element.oldVersion == appVersion);

    if(oldBuild==null) {

      oldBuild = list.last;

      if(oldBuild.rollout == "SPECIFIC") return;

    }


    if (oldBuild.isAndroid) {

      final playStore = PlayStoreSearchAPI();
      final document = await playStore.lookupById(bundleId);
      if (document != null) {
        final storeVersion = playStore.version(document)??"0.0.0";

        final note = playStore.releaseNotes(document);
        oldBuild.note = note;

        final v2 = int.parse((storeVersion).replaceAll(".", ""));
        
        if(v2 != oldBuild.intVersion) return;

        check(v1, v2, oldBuild);
      }
    }

    if (oldBuild.isIOS) {
      final iTunesSearchAPI = ITunesSearchAPI();
      Map? result = await iTunesSearchAPI.lookupByBundleId(bundleId, country: 'US');
      if (result != null) {
        final appStoreVersion = iTunesSearchAPI.version(result) ?? '0.0.0';

        final note = iTunesSearchAPI.releaseNotes(result);
        oldBuild.note = note;

        int v2 = int.parse(appStoreVersion.replaceAll('.', ''));

        if(v2 != oldBuild.intVersion) return;

        check(v1, v2, oldBuild);
      }
    }
  }

  void check(int v1, int v2, UpdateModel model){
    if (v2 > v1) {
      if(model.isForceUpdate){
        Future.delayed(const Duration(seconds: 1), () => _upgrade(model));
      }else{
        final date = DateTime.now();
        final lastDate = AppStorage.getLastUpdatePopupDateTime();
        switch(model.frequency.toLowerCase()){
          case "day":
            if(date.difference(lastDate).inDays >= model.duration.inDays){
              Future.delayed(const Duration(seconds: 1), () => _upgrade(model));
            }
            break;
          case "hour":
            if(date.difference(lastDate).inHours >= model.duration.inHours){
              Future.delayed(const Duration(seconds: 1), () => _upgrade(model));
            }
          default:
            break;
        }
      }
    }
  }

  void _upgrade(UpdateModel model) {
    if (Get.isDialogOpen == true) return;
    Get.bottomSheet(
      PopScope(
        canPop: false,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Get.theme.scaffoldBackgroundColor,
            borderRadius: const  BorderRadius.vertical(
              top: Radius.circular(12.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 20,),
              ImageAnimateRotate(
                child:Image.asset(
                  "assets/QX_logo-02.png",
                  height: 120,
                  width: 120,
                  color:AppUtil.styleColor(AppStorage.getConversationStyle().name),
                ),
              ),

              const SizedBox(height: 20,),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Update Available",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20,),
              Text(
                _message,
                textAlign: TextAlign.start,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20,),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "What's new?",
                  textAlign: TextAlign.start,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if(model.note!=null)...[
                const SizedBox(height: 10,),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    model.note??"",
                    textAlign: TextAlign.start,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                )
              ],
              const SizedBox(height: 20,),
              SizedBox(
                width: double.maxFinite,
                child: Row(
                  children: [
                    if(!model.isForceUpdate)...[
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              fixedSize: const Size(double.maxFinite, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                                side: const BorderSide(color: kPrimaryLight,width: 1.0)
                              )
                          ),
                          onPressed: () {
                          Get.back();
                          },
                          child: Text("CANCEL",style: TextStyle(color: Get.isDarkMode ? Colors.white:Colors.black),),
                        ),
                      ),
                      const SizedBox(width: 20,),
                    ],
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: kPrimaryLight,
                          fixedSize: const Size(double.maxFinite, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          )
                        ),
                        onPressed: () {
                          AppUtil.launchReview("Click_Update_App");
                        },
                        child: const Text("UPDATE NOW"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      isDismissible: false,
      isScrollControlled: true,
      enableDrag: false
    ).then((value){
      AppStorage.setLastUpdatePopupDateTime();
    });
  }
}
