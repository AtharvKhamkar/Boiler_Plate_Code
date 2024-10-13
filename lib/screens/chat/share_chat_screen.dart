import 'package:animate_do/animate_do.dart';
import 'package:ask_qx/controller/chat_controller.dart';
import 'package:ask_qx/utils/extension_utils.dart';
import 'package:ask_qx/widgets/custom_form_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../widgets/chat_message_widget.dart';
import '../../widgets/main_chat_header.dart';

class ChatReadOnlyScreen extends StatelessWidget {
  final String type;
  const ChatReadOnlyScreen({super.key,this.type = "continue"});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (controller) {
      return SafeArea(
        top: false,
        child: Scaffold(
          body: Column(
            children: [
              context.kToolBarHeight,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: const Icon(
                        Icons.clear,
                        size: 28,
                      ),
                    ),
                    Expanded(
                      child: MainChatAiHeader(
                        currentColor: controller.currentDarkColor.value,
                        title:controller.shareChatName.value,
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 10,),

              if(controller.shareChatList.isNotEmpty)
               Expanded(
                child: FadeIn(
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                    itemCount: controller.shareChatList.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(height: 24,);
                    },
                    itemBuilder: (_, i) {
                      final chat  = controller.shareChatList[i];
                      return ChatMessageWidget(
                        conversationId: "",
                        chat: chat,
                        isLast:false,
                        isFeedbackEnable: false,
                        onFollowup: (value) {},
                        onRefresh: () {
                          controller.update();
                        },
                        onFinish: () {},
                      );
                    },
                  ),
                ),
              ),

              const Divider(height: 0,),
              Container(
                padding: const EdgeInsets.all(14),
                child: CustomFormButton(
                  isLoading: controller.sharChatCoping.value,
                  innerText:type == "archive"?"Unarchive Chat":"Continue Chat",
                  onPressed: () {
                    Get.back(result: type);
                  },
                  borderRadius: 24,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
