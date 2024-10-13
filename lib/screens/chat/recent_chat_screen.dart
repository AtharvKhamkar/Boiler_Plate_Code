import 'package:ask_qx/controller/chat_controller.dart';
import 'package:ask_qx/global/app_util.dart';
import 'package:ask_qx/services/share_chat.dart';
import 'package:ask_qx/themes/colors.dart';
import 'package:ask_qx/utils/extension_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:timeago/timeago.dart';

import '../../network/error_handler.dart';
import '../../utils/utils.dart';

class RecentChatScreen extends StatelessWidget {
  const RecentChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (controller) {
      return SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          body: Column(
            children: [
              context.kToolBarHeight,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: Get.back,
                      child: const Icon(Icons.close, size: 28),
                    ),
                    const SizedBox(width: 15),
                    const Text(
                      "Chat History",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    // if(!controller.historyLoading.value && controller.recentChatList.isNotEmpty)
                    //   PopupMenuButton(
                    //     onOpened: () {
                    //       HapticFeedback.lightImpact();
                    //     },
                    //     enableFeedback: true,
                    //     padding: const EdgeInsets.symmetric(vertical: 10),
                    //     offset: const Offset(0, 20),
                    //     position: PopupMenuPosition.under,
                    //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    //     itemBuilder: (_) {
                    //       return [
                    //         PopupMenuItem(
                    //           onTap: () {
                    //             HapticFeedback.lightImpact();
                    //             ErrorHandle.qxLabConfirmationDialogue(
                    //               message: "If you delete all your conversations, you will not be able to read them later. Are you sure you want to delete all conversations?",
                    //               confirmText: 'Yes',
                    //               cancelText: 'No',
                    //               actionColor: Colors.redAccent,
                    //               onConfirm: () {
                    //                 Get.back();
                    //                 controller.deleteAll();
                    //               },
                    //             );
                    //           },
                    //           child: const Row(
                    //             children: [
                    //               Icon(Icons.delete_outline, color: Colors.red),
                    //               SizedBox(width: 10),
                    //               Text("Delete All"),
                    //             ],
                    //           ),
                    //         ),
                    //       ];
                    //     },
                    //     child: const Icon(Icons.more_vert_rounded),
                    //   ),
                  ],
                ),
              ),
              if (controller.historyLoading.value && controller.recentChatList.isEmpty)
                Expanded(
                  child: Center(
                    child: LoadingAnimationWidget.fourRotatingDots(color: primaryColor, size: 40.0),
                  ),
                ),
              if (!controller.historyLoading.value && controller.recentChatList.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text(
                      "No chat history found",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
              if (!controller.historyLoading.value && controller.recentChatList.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    controller: controller.recentScrollController,
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 20),
                    itemCount: controller.recentChatList.length,
                    itemBuilder: (_, i) {
                      final model = controller.recentChatList[i];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (model.isPinned) ...[
                                  const Icon(Icons.push_pin_rounded, size: 16),
                                  const SizedBox(width: 4),
                                ],
                                Text(
                                  model.duration,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: getSubTitleColor(
                                lightTheme: const Color.fromARGB(31, 217, 217, 217),
                                darkTheme: const Color.fromARGB(255, 44, 44, 44),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0),
                              child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                primary: false,
                                itemCount: model.item.length,
                                itemBuilder: (context, subIndex) {
                                  final item = model.item[subIndex];
                                  return ListTile(
                                    contentPadding: const EdgeInsets.only(left: 8),
                                    enableFeedback: true,
                                    onTap: () {
                                      Get.back(result: item);
                                    },
                                    dense: true,
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(format(item.createdAt)),
                                        PopupMenuButton(
                                          onOpened: () => HapticFeedback.lightImpact(),
                                          enableFeedback: true,
                                          padding: const EdgeInsets.all(12),
                                          offset: const Offset(0, 20),
                                          position: PopupMenuPosition.under,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                          enabled: true,
                                          itemBuilder: (_) {
                                            return [
                                              PopupMenuItem(
                                                onTap: () {
                                                  HapticFeedback.lightImpact();
                                                  controller.pinChat(item.conversationId, model.isPinned);
                                                },
                                                enabled: true,
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      model.isPinned ? Icons.push_pin_rounded : Icons.push_pin_outlined,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Text(model.isPinned ? "Unpin" : "Pin"),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                onTap: () {
                                                  HapticFeedback.lightImpact();
                                                  controller.openRename(item);
                                                },
                                                enabled: true,
                                                child: const Row(
                                                  children: [
                                                    Icon(Icons.edit),
                                                    SizedBox(width: 10),
                                                    Text("Rename"),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                onTap: () {
                                                  HapticFeedback.lightImpact();
                                                  ShareChatService.service.checkAndCreateLink(conversationId: item.conversationId);
                                                },
                                                enabled: true,
                                                child: const Row(
                                                  children: [
                                                    Icon(Icons.ios_share_rounded),
                                                    SizedBox(width: 10),
                                                    Text('Share Chat'),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                onTap: () {
                                                  HapticFeedback.lightImpact();
                                                  controller.archiveChat(item.conversationId);
                                                  model.item.remove(item);

                                                  if (model.item.isEmpty) {
                                                    controller.recentChatList.removeWhere((element) => element.duration == model.duration);
                                                  }

                                                  controller.update();
                                                },
                                                enabled: true,
                                                child: const Row(
                                                  children: [
                                                    Icon(Icons.archive_outlined),
                                                    SizedBox(width: 10),
                                                    Text('Archive'),
                                                  ],
                                                ),
                                              ),
                                              PopupMenuItem(
                                                onTap: () {
                                                  HapticFeedback.lightImpact();
                                                  controller.onDeleteChat(item.conversationId);
                                                },
                                                enabled: true,
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
                                          child: const Padding(
                                            padding: EdgeInsets.all(6.0),
                                            child: Icon(Icons.more_vert_rounded),
                                          ),
                                        ),
                                      ],
                                    ),
                                    leading: Visibility(
                                      visible: (controller.conversationId.value == item.conversationId),
                                      replacement: Image.asset(
                                        "assets/QX_logo-02.png",
                                        width: 16,
                                        color: AppUtil.styleColor(item.style),
                                      ),
                                      child: Icon(
                                        Icons.play_arrow_rounded,
                                        size: 18,
                                        color: controller.currentDarkColor.value,
                                      ),
                                    ),
                                    title: Text(
                                      item.conversation,
                                      style: const TextStyle(
                                        overflow: TextOverflow.ellipsis,
                                        fontSize: 14,
                                      ),
                                      maxLines: 1,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}
