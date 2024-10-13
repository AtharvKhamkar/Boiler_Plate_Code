import 'package:ask_qx/network/error_handler.dart';
import 'package:ask_qx/utils/extension_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:timeago/timeago.dart';

import '../../controller/share_chat_link_controller.dart';
import '../../firebase/firebase_dynamic_link.dart';
import '../../themes/colors.dart';

class ShareChatLinkScreen extends StatelessWidget {
  const ShareChatLinkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ShareChatLinkController>(builder: (controller) {
      return Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 50, 12, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: Get.back,
                    child: const Icon(Icons.arrow_back, size: 28),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    "Shared Links",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  if(controller.shareChatList.isNotEmpty)
                    PopupMenuButton(
                    onOpened: () {
                      HapticFeedback.lightImpact();
                    },
                    enableFeedback: true,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    offset: const Offset(0, 20),
                    position: PopupMenuPosition.under,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    itemBuilder: (_) {
                      return [
                        PopupMenuItem(
                          onTap: () {
                            HapticFeedback.lightImpact();
                            ErrorHandle.qxLabConfirmationDialogue(
                              message: 'Are you sure want to delete all share links?',
                              confirmText: 'Delete',
                              onConfirm: () {
                                controller.deleteAllSharedLink();
                              },
                            );
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.delete_outline, color: Colors.red),
                              SizedBox(width: 10),
                              Text("Delete All"),
                            ],
                          ),
                        ),
                      ];
                    },
                    child: const Icon(Icons.more_vert_rounded),
                  ),
                ],
              ),
            ),
            if (controller.isLoading.value && controller.shareChatList.isEmpty)
              Expanded(
                child: Center(
                  child: LoadingAnimationWidget.fourRotatingDots(color: primaryColor, size: 40.0),
                ),
              ),
            if (!controller.isLoading.value && controller.shareChatList.isEmpty)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.link_off_rounded, size: 70, color: Colors.grey),
                      SizedBox(height: 10),
                      Text(
                        "No Shared Chat Link Found!!",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ),
            if (!controller.isLoading.value && controller.shareChatList.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: controller.shareChatList.length,
                  separatorBuilder: (context, index) {
                    return const Divider(height: 8);
                  },
                  itemBuilder: (context, i) {
                    final item = controller.shareChatList[i];
                    return ListTile(
                      contentPadding: const EdgeInsets.only(left: 16,right: 16),
                      enableFeedback: true,
                      dense: true,
                      leading: Transform.rotate(angle: 90, child: const Icon(Icons.link_rounded, size: 18)),
                      title: Text(
                        item.shareConversation.title,
                        style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            format(item.createdAt),
                            style: const TextStyle(fontSize: 12),
                          ),
                          const SizedBox(width: 6),
                          PopupMenuButton(
                            onOpened: () {
                              HapticFeedback.lightImpact();
                            },
                            enableFeedback: true,
                            padding: const EdgeInsets.all(12),
                            offset: const Offset(0, 16),
                            position: PopupMenuPosition.under,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            itemBuilder: (_) {
                              return [
                                PopupMenuItem(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    FirebaseDynamicLinkService.link.receivedConversationShareId = item.shareConversationId;
                                    Get.back(result: "share");
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'chat.png'.toIcon,
                                        width: 20,
                                        color: Get.isDarkMode ? Colors.white : Colors.black,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text("View Chat"),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    FirebaseDynamicLinkService.link.shareLink(item.shareConversationId).then((value){
                                      Clipboard.setData(ClipboardData(text: value));
                                      ErrorHandle.success("Link copied!");
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'copy.png'.toIcon,
                                        width: 20,
                                        color: Get.isDarkMode ? Colors.white : Colors.black,
                                      ),
                                      const SizedBox(width: 10),
                                      const Text("Copy Link"),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    controller.deleteSharedLink(item);
                                  },
                                  child: const Row(
                                    children: [
                                      Icon(Icons.delete_outline, color: Colors.red),
                                      SizedBox(width: 10),
                                      Text("Delete"),
                                    ],
                                  ),
                                ),
                              ];
                            },
                            child: const Icon(Icons.more_vert_rounded,size: 18,),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      );
    });
  }
}
