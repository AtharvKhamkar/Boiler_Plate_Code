

import 'package:animate_do/animate_do.dart';
import 'package:ask_qx/controller/chat_controller.dart';
import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/global/app_util.dart';
import 'package:ask_qx/model/conversation.dart';
import 'package:ask_qx/network/error_handler.dart';
import 'package:ask_qx/screens/chat/chat_info_widget.dart';
import 'package:ask_qx/services/share_chat.dart';
import 'package:ask_qx/themes/colors.dart';
import 'package:ask_qx/screens/setting/setting_screen.dart';
import 'package:ask_qx/utils/extension_utils.dart';
import 'package:ask_qx/widgets/chat_message_widget.dart';
import 'package:ask_qx/widgets/conversation_style_widget.dart';
import 'package:ask_qx/widgets/input_widget.dart';
import 'package:ask_qx/widgets/suggestion_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import '../../adjust/adjust_services.dart';
import '../../animation/suggestion_animation_widget.dart';
import '../../firebase/firebase_analytic_service.dart';
import '../../services/text_to_speech_service.dart';
import '../../widgets/main_chat_header.dart';

class ChatAiScreen extends StatelessWidget {
  const ChatAiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (controller){
      return PopScope(
        canPop: false,
        onPopInvoked: (didPop) {
          ErrorHandle.success("Are you sure want to exit?",actionName: "Exit",onAction: (){
            SystemNavigator.pop(animated: true);
          });
        },
        child: SafeArea(
          top: false,
          bottom: false,
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            extendBody: false,
            floatingActionButton: Obx(
              () => controller.hasData.value ? GestureDetector(
                onTap: controller.toBottomTap,
                child: CircleAvatar(
                  backgroundColor: AppUtil.styleColor(controller.currentStyle.name).withOpacity(0.5),
                  child: const RotatedBox(
                    quarterTurns: 1,
                    child: Icon(Icons.double_arrow_rounded,color: Colors.white,),
                  ),
                ).animate(
                  onPlay: (controller) {
                    controller.repeat();
                  },
                ).shimmer(angle: 1.5, color: AppUtil.styleColor(controller.currentStyle.name), duration: const Duration(milliseconds: 2000)),
              ):const SizedBox(),
            ),
            // floatingActionButtonLocation: ExpandableFab.location,
            // floatingActionButton:controller.currentChatList.isNotEmpty?Padding(
            //   padding: const EdgeInsets.symmetric(vertical: 0),
            //   child: ExpandableFab(
            //     key: controller.expandableFabState,
            //     fanAngle: 0,
            //     pos: ExpandableFabPos.right,
            //     duration: const Duration(milliseconds: 300),
            //     type: ExpandableFabType.up,
            //     distance: 40,
            //     openButtonBuilder: RotateFloatingActionButtonBuilder(
            //       child: const Icon(Icons.edit,color: Colors.white,),
            //       fabSize: ExpandableFabSize.small,
            //       backgroundColor: controller.currentDarkColor.value,
            //       shape: const CircleBorder(),
            //       heroTag: null,
            //     ),
            //     closeButtonBuilder: DefaultFloatingActionButtonBuilder(
            //       child: const Icon(Icons.close,color: Colors.white,),
            //       fabSize: ExpandableFabSize.small,
            //       backgroundColor: controller.currentDarkColor.value,
            //       shape: const CircleBorder(),
            //       heroTag: null,
            //     ),
            //     overlayStyle: ExpandableFabOverlayStyle(
            //       blur: 10,
            //     ),
            //     onClose: () {
            //       FocusScope.of(context).unfocus();
            //     },
            //     children: [
            //       FabMenuItem(
            //         title: "New Chat",
            //         icon: Image.asset(
            //           'chat.png'.toIcon,
            //           width: 20,
            //           color: Colors.white,
            //         ),
            //         onTap: () {
            //           FirebaseAnalyticService.instance.logEvent('Click_NewChat_Fab');
            //           controller.onNewChat();
            //         },
            //       ),
            //       FabMenuItem(
            //         title: "Creative Chat",
            //         icon: Image.asset(
            //           'creative.png'.toIcon,
            //           width: 20,
            //           color: Colors.white,
            //         ),
            //         backgroundColor: controller.currentStyle == ConversationStyle.creative ? kSecondary:Colors.black,
            //         onTap: () {
            //           AppStorage.setConversationStyle(ConversationStyle.creative);
            //           controller.onStyleChange(ConversationStyle.creative);
            //         },
            //       ),
            //       FabMenuItem(
            //         title: "Standard Chat",
            //         icon: Image.asset(
            //           'standard.png'.toIcon,
            //           width: 20,
            //           color: Colors.white,
            //         ),
            //         backgroundColor: controller.currentStyle == ConversationStyle.balanced ? Colors.blue.shade800:Colors.black,
            //         onTap: () {
            //           AppStorage.setConversationStyle(ConversationStyle.balanced);
            //           controller.onStyleChange(ConversationStyle.balanced);
            //         },
            //       ),
            //       FabMenuItem(
            //         title: "Professional Chat",
            //         icon: Image.asset(
            //           'professional.png'.toIcon,
            //           width: 20,
            //           color: Colors.white,
            //         ),
            //         backgroundColor: controller.currentStyle == ConversationStyle.precise ? kThird:Colors.black,
            //         onTap: () {
            //           AppStorage.setConversationStyle(ConversationStyle.precise);
            //           controller.onStyleChange(ConversationStyle.precise);
            //         },
            //       ),
            //     ],
            //   ),
            // ):null,
            body: Column(
              children: [
                context.kToolBarHeight,
                Expanded(
                  child: FadeIn(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  controller.openRecent();
                                },
                                child: const Icon(
                                  Icons.history_sharp,
                                  size: 28,
                                ),
                              ),
                              if (controller.currentChatList.isNotEmpty)
                                Expanded(
                                  child: MainChatAiHeader(
                                    currentColor: controller.currentDarkColor.value,
                                    title:controller.conversationName??controller.currentChatList.first.query.capitalizeFirst??"",
                                  ),
                                ),
                              PopupMenuButton(
                                onOpened: () {
                                  HapticFeedback.lightImpact();
                                  FirebaseAnalyticService.instance.logEvent('Click_Burger_Menu');
                                },
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
                                        controller.onNewChat();
                                        FirebaseAnalyticService.instance.logEvent('Click_NewChat_Burger');
                                      },
                                      enabled: controller.currentChatList.isNotEmpty,
                                      child:  Row(
                                        children: [
                                          Opacity(
                                            opacity: controller.currentChatList.isNotEmpty?1.0:0.5,
                                            child: Image.asset(
                                              'chat.png'.toIcon,
                                              width: 20,
                                              color:Get.isDarkMode?Colors.white:Colors.black,
                                            ),
                                          ),
                                           const SizedBox(width: 10,),
                                           const Text("New Chat"),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: (){
                                        HapticFeedback.lightImpact();
                                        if(controller.currentChatList.isNotEmpty){
                                          FirebaseAnalyticService.instance.logEvent('Click_Share_Chat_Burger');
                                          // ShareChatService.service.createLinkAndShare(conversationId: controller.conversationId.value);
                                          ShareChatService.service.checkAndCreateLink(conversationId: controller.conversationId.value);
                                        }
                                      },
                                      enabled: controller.currentChatList.isNotEmpty,
                                      child: const Row(
                                        children: [
                                           Icon(Icons.ios_share_rounded),
                                           SizedBox(width: 10,),
                                          Text('Share Chat'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: (){
                                        HapticFeedback.lightImpact();
                                        FirebaseAnalyticService.instance.logEvent('Click_Settings_Burger');
                                        Get.to(()=>const SettingScreen(),transition: Transition.rightToLeft)!.then((value){
                                           controller.update();
                                           if(value!=null && value is Item){
                                             controller.getArchiveChat(value);
                                           }else if (value!=null && value=="share"){
                                             controller.handleDeepLink();
                                           }
                                        });
                                      },
                                      enabled: true,
                                      child: const Row(
                                        children: [
                                           Icon(Icons.settings_outlined,),
                                           SizedBox(width: 10,),
                                          Text("Settings"),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      onTap: (){
                                        HapticFeedback.lightImpact();
                                        if(controller.currentChatList.isNotEmpty &&
                                            controller.currentChatList.last.answers.isNotEmpty &&
                                            controller.currentChatList.last.answers.last.isAnimationCompleted){
                                          FirebaseAnalyticService.instance.logEvent('Click_Delete_Burger');
                                          controller.onDeleteChat(controller.conversationId.value,back: false);
                                        }
                                      },
                                      enabled: (controller.currentChatList.isNotEmpty && controller.currentChatList.last.answers.isNotEmpty && controller.currentChatList.last.answers.last.isAnimationCompleted),
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
                                child: const Icon(Icons.more_vert_rounded),
                              ),
                            ],
                          ),
                        ),
                        if (controller.currentChatList.isNotEmpty)
                          const Divider(height: 0,),

                        if (controller.currentChatList.isEmpty)...[
                          Expanded(
                            child: SingleChildScrollView(
                              controller: controller.suggestionScrollController,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ChatInfoWidget(
                                    currentDark: controller.currentDarkColor.value,
                                    currentLight: controller.currentColor.value,
                                  ),
                                  if(controller.suggestionsQuery.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 24),
                                    child: Center(
                                      child: AnimatedSuggestionWidget(
                                        key: ValueKey(controller.currentStyle.name),
                                        suggestion:  controller.suggestionsQuery,
                                        currentColor: controller.currentDarkColor.value,
                                        onChange: (index) {
                                          controller.currentSuggestionIndex(index);
                                        },
                                        onTap: () {
                                          FirebaseAnalyticService.instance.logEvent('Click_Flash_Message_Main');
                                          if(controller.isFirstPrompt==false){
                                            AdjustServices.instance.adjustEvent(AdjustServices.firstPrompt.toString()); //For first prompt
                                          }
                                          controller.onStreamQuery(controller.suggestionsQuery[controller.currentSuggestionIndex.value]);
                                        },
                                      ),
                                    ),
                                  ),
                                  ConversationStyleWidget(
                                    key: UniqueKey(),
                                    darkColor: controller.currentDarkColor.value,
                                    onChanged: controller.onStyleChange,
                                  ),
                                  const SizedBox(height: 24),
                                  SuggestionTextWidget(
                                    onTap: () {
                                      controller.queryController.clear();
                                      controller.isOpenSuggestion.toggle();
                                      controller.update();
                                    },
                                    color: controller.currentDarkColor.value,
                                  ),
                                  if(controller.tabController!=null)
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    height: controller.isOpenSuggestion.value?400:0,
                                    margin: const EdgeInsets.all(20),
                                    onEnd: () {
                                      if(controller.isOpenSuggestion.value){
                                        FirebaseAnalyticService.instance.logEvent('Click_Suggestions');
                                      }else{
                                        FirebaseAnalyticService.instance.logEvent('Close_Suggestions');
                                      }
                                      if(controller.isOpenSuggestion.value) {
                                        Future.delayed(const Duration(milliseconds: 301),(){
                                          controller.suggestionScrollController.animateTo(
                                            controller.suggestionScrollController.position.maxScrollExtent,
                                            duration: const Duration(milliseconds: 300),
                                            curve: Curves.ease,
                                          );
                                        });
                                      }
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Flexible(
                                          flex: 1,
                                          child: TabBar(
                                            controller: controller.tabController,
                                            dividerHeight: 0,
                                            enableFeedback: false,
                                            isScrollable: true,
                                            unselectedLabelColor: Colors.grey,
                                            labelColor: controller.currentDarkColor.value,
                                            indicatorColor:Colors.transparent,
                                            indicatorSize: TabBarIndicatorSize.tab,
                                            tabAlignment: TabAlignment.start,
                                            labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                                            indicator: BoxDecoration(
                                                border: Border.all(color:controller.currentDarkColor.value),
                                                borderRadius: BorderRadius.circular(24,)
                                            ),
                                            tabs: controller.suggestionList.map((element){
                                              return Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8),
                                                constraints: const BoxConstraints(
                                                  minWidth: 80
                                                ),
                                                decoration: BoxDecoration(
                                                    border:controller.selectedCategory == element?null:Border.all(color:Colors.grey),
                                                    borderRadius: BorderRadius.circular(24,)
                                                ),
                                                child: Tab(
                                                  height: 30,
                                                  text: element.displayText,
                                                ),
                                              );
                                            }).toList(),
                                            onTap: (value) {
                                              controller.selectedCategory = controller.suggestionList[value];
                                              controller.update();
                                            },
                                            splashBorderRadius: BorderRadius.circular(24),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 5,
                                          child: Scrollbar(
                                            radius: const Radius.circular(4),
                                            trackVisibility: false,
                                            thickness: 2,
                                            thumbVisibility: true,
                                            child: ListView.separated(
                                              padding: const EdgeInsets.only(top: 14,left: 4,right: 4),
                                              shrinkWrap: true,
                                              itemCount: controller.suggestionList[controller.tabController!.index].suggestions.length,
                                              separatorBuilder: (context, index) {
                                                return const SizedBox(height: 8,);
                                              },
                                              itemBuilder: (context, index) {
                                                final e = controller.suggestionList[controller.tabController!.index].suggestions[index];
                                                return GestureDetector(
                                                  onTap: (){
                                                    controller.isOpenSuggestion.toggle();
                                                    controller.queryController.text = e.query;
                                                    FirebaseAnalyticService.instance.logEvent('Click_Suggestions_Category',data: {"suggestion_category":e.suggestion});
                                                    Future.delayed(const Duration(milliseconds: 301),(){
                                                      // if(controller.queryController.text.trim().isNotEmpty){
                                                        controller.focusNode = FocusNode();
                                                        controller.focusNode!.requestFocus();
                                                        controller.update();
                                                      // }
                                                    });
                                                    controller.update();
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(14),
                                                    alignment: Alignment.center,
                                                    decoration: BoxDecoration(
                                                      color: AppUtil.styleColor(controller.currentStyle.name).withOpacity(0.1),
                                                      borderRadius: BorderRadius.circular(8.0),
                                                    ),
                                                    child: Text(
                                                      e.suggestion,
                                                      textAlign: TextAlign.center,
                                                      style: textStyle(color:Get.isDarkMode? Colors.white:Colors.black,size: 13),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],

                        if (controller.currentChatList.isNotEmpty)...[
                          Expanded(
                            child: FadeIn(
                              child: ListView.separated(
                                padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                                controller: controller.chatScrollController,
                                itemCount: controller.currentChatList.length,
                                cacheExtent: 100,
                                separatorBuilder: (context, index) {
                                  return const SizedBox(height: 24,);
                                },
                                itemBuilder: (_, i) {
                                  final chat  = controller.currentChatList[i];
                                  return ChatMessageWidget(
                                    chatController: controller,
                                    conversationId: controller.conversationId.value,
                                    chat: chat,
                                    isLast: i == controller.currentChatList.length - 1,
                                    onFollowup: (value) {
                                      controller.onStreamQuery(value);
                                    },
                                    onRefresh: () {
                                      controller.update();
                                    },
                                    onFinish: () {
                                      controller.hasData(false);
                                      controller.scrollToBottom();
                                    },
                                    onRegenerate: (){
                                      controller.onStreamRegenerate();
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ]
                      ],
                    ),
                  ),
                ),
                // if(controller.currentChatList.isNotEmpty
                //     && controller.currentChatList.last.answers.isNotEmpty
                //     && !controller.currentChatList.last.answers.last.isAnimationCompleted)
                // Obx(
                //   () => Visibility(
                //     visible: controller.hasData.value,
                //     child: GestureDetector(
                //       onTap:controller.toBottomTap,
                //       child: CircleAvatar(
                //         backgroundColor: Get.isDarkMode?Colors.white10:Colors.black12,
                //         child: const RotatedBox(
                //           quarterTurns: 1,
                //           child: Icon(Icons.double_arrow_rounded),
                //         ),
                //       ).animate(
                //         onPlay: (controller) {
                //           controller.repeat();
                //         },
                //       ).shimmer(
                //         angle: 1.5,
                //         color: AppUtil.styleColor(controller.currentStyle.name),
                //         duration: const Duration(milliseconds: 2000)
                //       ),
                //     ),
                //   ),
                // ),
                if(controller.currentChatList.isNotEmpty /*controller.currentChatList.last.answers.isNotEmpty
                    && !controller.currentChatList.last.answers.last.isAnimationCompleted*/)
                Visibility(
                  visible: (controller.showStopButton.value),
                  child: FadeInUp(
                    duration: const Duration(milliseconds: 200),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(4.0),
                      onTap: () {
                        // controller.deleteChat(controller.currentChatList.last);
                        // ApiClient.client.stopStream();
                        controller.stopStream();
                        controller.update();
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 12),
                        margin: const EdgeInsets.all(6.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          border: Border.all(color: AppUtil.styleColor(controller.currentStyle.name), width: 1.0),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.stop_circle_outlined,color: AppUtil.styleColor(controller.currentStyle.name),size: 16),
                            const SizedBox(width: 6,),
                            Text(
                              "Stop Response",
                              style: TextStyle(
                                color: AppUtil.styleColor(controller.currentStyle.name),
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                if(controller.currentChatList.isNotEmpty
                    &&  !controller.showStopButton.value/*controller.currentChatList.last.answers.isNotEmpty
                    && controller.currentChatList.last.answers.last.isAnimationCompleted*/)
                  Visibility(
                    visible: (!controller.isRegenerating.value && !controller.queryLoading.value),
                    child: FadeInUp(
                      key: controller.regenerateKey,
                      duration: const Duration(milliseconds: 200),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(4.0),
                        onTap: () {
                          // controller.onRegenerate();
                          controller.onStreamRegenerate();
                        },
                        child: Container(
                          padding: const EdgeInsets.all(6.0),
                          margin: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            border: Border.all(color: AppUtil.styleColor(controller.currentStyle.name), width: 1.0),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.sync,
                                size: 16,
                                color: AppUtil.styleColor(controller.currentStyle.name),
                              ),
                              const SizedBox(width: 6,),
                              Text(
                                "Regenerate Response",
                                style: TextStyle(
                                  color: AppUtil.styleColor(controller.currentStyle.name),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                if(controller.isRegenerating.value)
                  LinearProgressIndicator(
                    color: AppUtil.styleColor(controller.currentStyle.name),
                    minHeight: 2,
                  ),
                // const SizedBox(height: 10),
              ],
            ),
            bottomNavigationBar: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Obx(
                  ()=> AbsorbPointer(
                  absorbing: (
                      controller.showStopButton.value ||
                      controller.queryLoading.value ||
                      controller.isRegenerating.value
                      /*|| TextToSpeechService.instance.isPlaying.value*/),
                  child: InputWidget(
                    key: controller.queryKey,
                    queryController: controller.queryController,
                    focusNode: controller.focusNode,
                    onChange: (value) {
                    },
                    onSubmit: (value) {
                      if(value.trim().isEmpty) return;
                      if (!AppStorage.isFirstPrompt()) {
                        FirebaseAnalyticService.instance.logEvent("First_Prompt");
                        AppStorage.setFirstPrompt();
                      }
                      controller.onStreamQuery(value);
                    },
                    onMenuClick: (int? menuType) {
                      if(menuType==null) return;
                      controller.onMenuClick(menuType);
                      FocusScope.of(context).unfocus();
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
