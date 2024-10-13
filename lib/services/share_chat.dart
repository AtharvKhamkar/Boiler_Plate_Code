
import 'package:ask_qx/firebase/firebase_dynamic_link.dart';
import 'package:ask_qx/firebase/remote_config_service.dart';
import 'package:ask_qx/network/error_handler.dart';
import 'package:ask_qx/repository/share_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

import '../themes/colors.dart';
import '../utils/utils.dart';
import '../widgets/custom_form_button.dart';

class ShareChatService {
  ShareChatService._();

  static final ShareChatService _instance = ShareChatService._();

  static ShareChatService get service => _instance;

  //classes
  final  _shareChatRepository=ShareChatRepository();

  //variables
  var shareLink = ''.obs;
  var conversationId = ''.obs;
  var shareConversationId = ''.obs;
  var isUpdate = false;
  var isLoading = true.obs;
  var isGenerating = false.obs;

  void checkAndCreateLink({required String conversationId}) {
    shareLink("");
    shareConversationId('');
    this.conversationId(conversationId);
    isLoading(true);

    shareBottomSheet();
    _shareChatRepository.getShareConversationId(conversationId).then((value) {
        final link = RemoteConfigService.instance.shareMessage('');
        shareLink(link);
        isLoading(false);

        if (value['data']['shareConversationId'] != null) {
          isUpdate = true;
          shareConversationId(value['data']['shareConversationId']);
        } else {
          isUpdate = false;
        }
      },
      onError: (e) {
        Get.back();
        ErrorHandle.error(e);
      },
    );
  }

  void createLinkAndShare() async {
    await FirebaseDynamicLinkService.link.shareLink(shareConversationId.value).then((value) {
        final link = RemoteConfigService.instance.shareMessage(value);
        shareLink.value = link;
        Get.back();
        Share.share(shareLink.value, subject: "Conversation-QX Lab AI");
        isLoading(false);
        isGenerating(false);
      },
      onError: (e) {
        isLoading(false);
        isGenerating(false);
        ErrorHandle.error(e);
      },
    );
  }

  void copyPostConversation() {
    isGenerating(true);
    _shareChatRepository.postShareConversation(conversationId).then(
      (value) {
        Map map = value['data']['sharedConversation'];
        shareConversationId(map['sharedConversationId']);
        createLinkAndShare();
      },
      onError: (e) {
        isLoading(false);
        isGenerating(false);
        ErrorHandle.error(e);
      },
    );
  }

  void copyPatchConversation() {
    isGenerating(true);
    _shareChatRepository.patchShareConversation(conversationId.value, shareConversationId.value).then(
      (value) {
        createLinkAndShare();
      },
      onError: (e) {
        isLoading(false);
        isGenerating(false);
        ErrorHandle.error(e);
      },
    );
  }

  void deleteConversationLink(){
    Get.back();
    _shareChatRepository.deleteConversations(conversationId.value, shareConversationId.value);
    ErrorHandle.success('The previous link deleted successfully');
  }

  //views
  void shareBottomSheet() {
    Get.bottomSheet(
        Obx(
          () => PopScope(
            canPop: false,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
              decoration: BoxDecoration(
                color: Get.theme.colorScheme.background,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Share Chat",
                        style: TextStyle(
                          color: getTextColor(),
                          fontSize: 16,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
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
                  if(isLoading.value)
                    SharePlaceHolder(),
                  if(!isLoading.value)...[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 20),
                      child: SelectableText(
                        shareLink.value,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    if (isUpdate)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                        child: Column(
                          children: [
                            const Text(
                              'You have shared this conversation before. If you want to update the shared conversation content, delete this link and create a new shared link.',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 14),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      minimumSize: const Size(double.infinity, 50),
                                      foregroundColor: Colors.red,
                                      side: const BorderSide(color: Colors.red)
                                    ),
                                    onPressed: () {
                                      ErrorHandle.qxLabConfirmationDialogue(
                                        message: 'Are you sure want to delete previous share link ?',
                                        confirmText: 'Delete',
                                        actionColor: kPrimaryLight,
                                        onConfirm: ()=>deleteConversationLink(),
                                      );
                                    },
                                    child: const Text(
                                      'Delete',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () => copyPatchConversation(),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: kPrimaryLight,
                                      minimumSize: const Size(double.infinity, 50),
                                    ),
                                    child: const Text(
                                      'Update Link',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                        child: CustomFormButton(
                          isLoading: isGenerating.value,
                          innerText: "Copy",
                          onPressed: ()=>copyPostConversation(),
                        ),
                      ),
                  ]
                ],
              ),
            ),
          ),
        ),
        isDismissible: false,
    );
  }
}

class SharePlaceHolder extends StatelessWidget {
   SharePlaceHolder({super.key});

  final decoration = BoxDecoration(
    color: Colors.black38,
    borderRadius: BorderRadius.circular(10.0),
  );


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 20),
        Container(
          height: 14,
          decoration: decoration,
          margin: const EdgeInsets.symmetric(vertical: 6,horizontal: 20),
        ),
        Container(
          height: 14,
          decoration: decoration,
          margin: const EdgeInsets.symmetric(vertical: 6,horizontal: 40),
        ),
        Container(
          height: 14,
          decoration: decoration,
          margin: const EdgeInsets.symmetric(vertical: 6,horizontal: 20),
        ),
        Container(
          height: 14,
          decoration: decoration,
          margin: const EdgeInsets.symmetric(vertical: 6,horizontal: 40),
        ),
        const SizedBox(height: 10),
        Container(
          height: 50,
          decoration: decoration,
          margin: const EdgeInsets.symmetric(vertical: 20),
        ),
      ],
    ).animate(
      onPlay: (controller) {
        controller.repeat();
      },
    ).shimmer(
      color: Colors.grey,
      duration: const Duration(milliseconds: 1500),
      angle:120,
    );
  }
}
