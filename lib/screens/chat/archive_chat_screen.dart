import 'package:ask_qx/controller/archive_chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:timeago/timeago.dart';

import '../../global/app_util.dart';
import '../../themes/colors.dart';

class ArchiveChatScreen extends StatelessWidget {
  const ArchiveChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ArchiveChatController>(builder: (controller) {
      return Scaffold(
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: Get.back,
                    child: const Icon(
                      Icons.arrow_back,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 15),
                  const Text(
                    "Archived Chat",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                ],
              ),
            ),

            if(controller.isLoading.value && controller.archivedList.isEmpty)
              Expanded(
                child: Center(
                  child: LoadingAnimationWidget.fourRotatingDots(color: primaryColor, size: 40.0),
                ),
              ),

            if (!controller.isLoading.value && controller.archivedList.isEmpty)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.archive_outlined,
                        size: 70,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "No Archive Chats Found!!",
                        style: TextStyle(color: Colors.grey),
                      )
                    ],
                  ),
                ),
              ),
            if (!controller.isLoading.value && controller.archivedList.isNotEmpty)
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: controller.archivedList.length,
                  separatorBuilder: (context, index) {
                    return const Divider(height: 8);
                  },
                  itemBuilder: (context, i) {
                    final item = controller.archivedList[i];
                    return ListTile(
                      contentPadding: const EdgeInsets.only(left: 20),
                      enableFeedback: true,
                      dense: true,
                      onTap: () {
                        Get.back(result: item);
                      },
                      title: Row(
                        children: [
                          Image.asset("assets/QX_logo-02.png",width: 16,color: AppUtil.styleColor(item.style),),
                          const SizedBox(width: 10,),
                          Flexible(
                            child: Text(
                              item.conversation,
                              style: const TextStyle(
                                overflow:
                                TextOverflow.ellipsis,
                                fontSize: 14,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
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
                                  onTap: (){
                                    HapticFeedback.lightImpact();
                                    controller.unarchive(item.conversationId);
                                  },
                                  enabled: true,
                                  child: const Row(
                                    children: [
                                      Icon(Icons.unarchive_outlined),
                                      SizedBox(width: 10,),
                                      Text('Unarchive'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  onTap: (){
                                    HapticFeedback.lightImpact();
                                    controller.deleteConversation(item.conversationId);
                                  },
                                  enabled: true,
                                  child: const Row(
                                    children: [
                                      Icon(Icons.delete_outline,color: Colors.red,),
                                      SizedBox(width: 10,),
                                      Text("Delete"),
                                    ],
                                  ),
                                ),
                              ];
                            },
                            child:const Padding(
                              padding: EdgeInsets.all(6.0),
                              child: Icon(Icons.more_vert_rounded,size: 18,),
                            ),
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
