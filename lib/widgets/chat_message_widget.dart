import 'dart:async';
import 'dart:math';

import 'package:animate_do/animate_do.dart';
import 'package:ask_qx/controller/chat_controller.dart';
import 'package:ask_qx/global/app_data_provider.dart';
import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/model/chat.dart';
import 'package:ask_qx/network/error_handler.dart';
import 'package:ask_qx/repository/chat_repository.dart';
import 'package:ask_qx/services/text_to_speech_service.dart';
import 'package:ask_qx/utils/extension_utils.dart';
import 'package:ask_qx/utils/markdown_code_widget.dart';
import 'package:ask_qx/utils/utils.dart';
import 'package:ask_qx/widgets/chat_feedback_bottomsheet.dart';
import 'package:ask_qx/widgets/copy_button.dart';
import 'package:ask_qx/widgets/pill_widget.dart';
import 'package:ask_qx/widgets/qx_branding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../global/app_util.dart';
import '../themes/colors.dart';

class ChatMessageWidget extends StatelessWidget {
  final Chat chat;
  final String conversationId;
  final bool isLast;
  final VoidCallback? onFinish;
  final VoidCallback? onRefresh;
  final VoidCallback? onRegenerate;
  final Function(String q)? onFollowup;
  final bool isFeedbackEnable;
  final ChatController? chatController;

  const ChatMessageWidget({
    super.key,
    required this.chat,
    this.isLast = false,
    this.onFinish,
    this.onFollowup,
    this.onRefresh,
    this.onRegenerate,
    required this.conversationId,
    this.isFeedbackEnable = true,
    this.chatController
  });

  @override
  Widget build(BuildContext context) {

    Color color = getTextColor(
        darkTheme: const Color.fromARGB(255, 48, 48, 48),
        lightTheme: const Color.fromARGB(255, 244, 244, 244));

    return SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: CopyButton(
              data: chat.query,
              color: Colors.grey,
              helperText: "copy",
            ),
          ),
          const SizedBox(height: 6,),
          Align(
            alignment: Alignment.centerRight,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                      maxWidth: context.width * .75
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 8),
                  decoration: BoxDecoration(
                      color: AppUtil.styleColor(chat.style),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      )
                  ),
                  child: Text(chat.query,style: chatStyle().copyWith(color: Colors.white,)),
                ),
                Transform(
                  alignment: Alignment.centerRight,
                  transform: Matrix4.rotationY(pi),
                  child: CustomPaint(
                    painter: CustomShape(AppUtil.styleColor(chat.style)),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20,),
          Align(
            alignment: Alignment.centerLeft,
            child:Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform(
                  key: UniqueKey(),
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: CustomPaint(
                    painter: CustomShape(color),
                  ),
                ),
                Container(
                  constraints: BoxConstraints(
                      maxWidth: context.width * .80
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 6),
                  decoration: BoxDecoration(
                      color: color,
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                      )
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 3),
                        child: Row(
                          children: [
                            QxBrandingWidget(scaleFactor: 0.45,color:AppUtil.styleColor(chat.currentChatStyle),),
                            const Spacer(),
                            if(chat.isLoading)...[
                              LoadingAnimationWidget.fourRotatingDots(
                                size: 24,
                                color: AppUtil.styleColor(chat.currentChatStyle),
                              ),
                            ],
                            if(!chat.isLoading)...[
                              CopyButton(data: chat.data,color: AppUtil.styleColor(chat.currentChatStyle),helperText: "copy",direction: Direction.left,),
                            ],
                          ],
                        ),
                      ),
                      const Divider(thickness: 0.5,color: Colors.grey,height: 16,),
                      if(!chat.isLoading && chat.answers.isNotEmpty)
                        FadeIn(
                          key: ValueKey(chat.currentIndex),
                          child: FormattedMessageWidget(
                            answer: chat.answers[chat.currentIndex.value],
                            isLast: isLast,
                            onFinish:onFinish,
                          ),
                        ),
                      if(!chat.isLoading && chat.answers.isEmpty)
                        Text(chat.errorMessage,style: textStyle(color: Colors.redAccent.withOpacity(0.7),),),
                      Row(
                        children: [
                          if(chat.answers.length>1)
                            Obx(
                               () {
                                return AbsorbPointer(
                                  absorbing: (chatController?.showStopButton.value)??false,
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Opacity(
                                          opacity: chat.currentIndex.value==0?0.3:1.0,
                                          child: InkWell(
                                            onTap: (){
                                              // if(TextToSpeechService.instance.isPlaying.value) return;
                                              if(chat.currentIndex>0){
                                                chat.currentIndex--;
                                                chat.currentChatStyle=chat.answers[chat.currentIndex.value].style;
                                                onRefresh?.call();
                                              }
                                            },
                                            child:  CircleAvatar(
                                              backgroundColor: AppUtil.styleColor(chat.answers[chat.currentIndex.value].style),
                                              maxRadius: 12,
                                              child: const Icon(Icons.keyboard_arrow_left_rounded,color: Colors.white,size: 16,),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                                          child: Text(
                                            "${chat.currentIndex.value+1}/${chat.answers.length}",
                                            style: textStyle(size: 10,color: Colors.grey),
                                          ),
                                        ),
                                        Opacity(
                                          opacity: chat.currentIndex.value==chat.answers.length-1?0.3:1.0,
                                          child: InkWell(
                                            onTap: (){
                                              // if(TextToSpeechService.instance.isPlaying.value) return;
                                              if(chat.currentIndex < chat.answers.length-1){
                                                chat.currentIndex++;
                                                chat.currentChatStyle=chat.answers[chat.currentIndex.value].style;
                                                onRefresh?.call();
                                              }
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: AppUtil.styleColor(chat.answers[chat.currentIndex.value].style),
                                              maxRadius: 12,
                                              child: const Icon(Icons.keyboard_arrow_right_rounded,color: Colors.white,size: 16,),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                      ],
                                    ),
                                  ),
                                );
                              }
                            ),

                          // if(chat.answers.isNotEmpty && isLast && !chat.answers.last.isTyping)
                          //   Obx(
                          //     () => InkWell(
                          //       onTap: () {
                          //         if(chatController?.isRegenerating.value == true) return;
                          //         if (TextToSpeechService.instance.isPlaying.value) {
                          //           TextToSpeechService.instance.stop();
                          //           return;
                          //         }
                          //         String tts = '';
                          //         final ans = chat.answers[chat.currentIndex.value];
                          //         if (ans.answer.isEmpty) {
                          //           tts = ans.obxAnswer.value;
                          //         } else {
                          //           tts = ans.answer;
                          //         }
                          //         TextToSpeechService.instance.start(tts.replaceAll('```', "").replaceAll("`", "").replaceAll(";", ""));
                          //       },
                          //       child: CircleAvatar(
                          //         maxRadius: 12,
                          //         backgroundColor: AppUtil.styleColor(chat.currentChatStyle),
                          //         child: TextToSpeechService.instance.isPlaying.value
                          //             ? const Icon(Icons.stop_circle_outlined, color: Colors.white,size: 18,)
                          //             : Image.asset("speaker.png".toIcon, width: 16, color: Colors.white),
                          //       ),
                          //     ),
                          //   ),
                          const Spacer(),
                          if(chat.answers.isNotEmpty)
                            PillWidget(text: "${chat.answers[chat.currentIndex.value].readAbleStyle} Style",color: AppUtil.styleColor(chat.answers[chat.currentIndex.value].style),)
                        ],
                      ),

                    ],
                  ),
                )
              ],
            ),
          ),
          if(chat.answers.isNotEmpty &&  !chat.answers.last.isTyping && isFeedbackEnable)
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                  AbsorbPointer(
                  absorbing: chat.answers[chat.currentIndex.value].reaction.isLiked!=null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if(chat.answers[chat.currentIndex.value].reaction.isLiked==null)...[
                          GestureDetector(
                              onTap: () {
                                Future.delayed(const Duration(milliseconds: 200),()=>showFeedbackBottomSheet(true));
                              },
                              child: Image.asset("like.png".toIcon,width: 20,color: Colors.grey,),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Future.delayed(const Duration(milliseconds: 200),()=>showFeedbackBottomSheet(false));
                              },
                              child: Image.asset("dislike.png".toIcon,width: 20,color: Colors.grey,),
                            ),
                        ],
                        if(chat.answers[chat.currentIndex.value].reaction.isLiked!=null)...[
                            Visibility(
                              visible: chat.answers[chat.currentIndex.value].reaction.isLiked,
                              replacement: Image.asset("dislike.png".toIcon,width: 20,color: AppUtil.styleColor(chat.currentChatStyle),),
                              child: Image.asset("like.png".toIcon,width: 20,color: AppUtil.styleColor(chat.currentChatStyle),),
                            ),
                          ],
                      ],
                    ),
                  ),
                ),
                  Visibility(
                    visible: (chat.answers[chat.currentIndex.value].feedback==null && chat.currentIndex.value!=0 && chat.answers.length>1),
                    replacement: const SizedBox.shrink(),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: AppUtil.styleColor(chat.currentChatStyle),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4.0),
                        )
                      ),
                      onPressed: (){
                        showChatFeedbackBottomSheet();
                      },
                      child: const Text(
                        "is This Helpful?",
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if(isLast && chat.answers.isNotEmpty && chat.answers.last.isAnimationCompleted)...[
            const SizedBox(height: 10,),
            Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: context.width*0.75,
                child: Wrap(
                  alignment: WrapAlignment.start,
                  runSpacing: 10,
                  children: chat.followup.map((e) {
                    return FadeInLeft(
                      delay: Duration(milliseconds: chat.followup.indexOf(e) * 100),
                      child: GestureDetector(
                        onTap:()=> onFollowup?.call(e),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 5),
                          decoration: BoxDecoration(
                            color: AppUtil.styleColor(AppStorage.getConversationStyle().name).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Text(
                            e,
                            softWrap: true,
                            style: chatStyle().copyWith(fontSize: 12),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
          ],
        ],
      ),
    );
  }

  void showFeedbackBottomSheet(like){
    Get.bottomSheet(
      PopScope(
        canPop: false,
        child: ChatFeedbackBottomSheet(suggestion: like?AppDataProvider.likeSuggestion:AppDataProvider.dislikeSuggestion,),
      ),
      isDismissible: false,
      isScrollControlled: true,
    ).then((value){

      if(value==null || value == "close"){
        return;
      }
      Map<String,dynamic> body = {
        "data": {
          "chatId": chat.chatId,
          "answerId": chat.answers[chat.currentIndex.value].answerId,
          "reaction": {
            "isLiked": like,
            "message": value??"",
          }
        }
      };
      ChatRepository().reaction(body, conversationId);
      if(like){
        chat.answers[chat.currentIndex.value].reaction.like();
      }else{
        chat.answers[chat.currentIndex.value].reaction.dislike();
      }

      onRefresh?.call();
      if(value!=null)ErrorHandle.success("Thanks for feedback!");
    });
  }

  void showChatFeedbackBottomSheet(){
    Get.bottomSheet(
      PopScope(
        canPop: false,
        child: ChatFeedbackBottomSheet(suggestion: AppDataProvider.helpfulSuggestion,showTextField: false,),
      ),
      isDismissible: false,
      isScrollControlled: true,
    ).then((value){
      if(value==null || value == "close"){
        return;
      }
      chat.answers[chat.currentIndex.value].feedback = value;
      onRefresh?.call();
      Map<String,dynamic> body = {
        "data": {
          "chatId": chat.chatId,
          "answerId": chat.answers[chat.currentIndex.value].answerId,
          "feedback" : value??"NA",
        }
      };
      ChatRepository().chatFeedback(body, conversationId);
      if(value!=null)ErrorHandle.success("Thanks for feedback!");
    });
  }

}

class FormattedMessageWidget extends StatelessWidget {
  final Answer answer;
  final bool isLast;
  final VoidCallback? onFinish;
  const FormattedMessageWidget({super.key,required this.answer,this.isLast = false,this.onFinish});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      key: UniqueKey(),
      width: context.width * .75,
      child: Obx(
         () {
          return MarkdownBody(
            // physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            data: answer.obxAnswer.value.isEmpty?answer.answer:answer.obxAnswer.value,
            selectable: true,
            styleSheet: MarkdownStyleSheet(
              code: GoogleFonts.poppins(
                color: Colors.green,
                backgroundColor: Colors.transparent,
                fontSize: 13,
                height:1.5,
              ),
              codeblockDecoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8),
              ),
              p: GoogleFonts.poppins(
                fontSize: 14,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
              tableBorder: TableBorder.all(color: Colors.grey,width: 0.4),
              tableCellsPadding: const EdgeInsets.symmetric(horizontal: 2,vertical: 4),
              tableHead: GoogleFonts.poppins(
                fontSize: 9,
                height: 1.5,
                fontWeight: FontWeight.w600,
              ),
              tableBody: GoogleFonts.poppins(
                fontSize: 10,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
              tableHeadAlign: TextAlign.center,
              tableVerticalAlignment: TableCellVerticalAlignment.middle,
            ),
            styleSheetTheme: MarkdownStyleSheetBaseTheme.platform,
            builders: {
              'code': MarkdownCodeWidget(), // new
            },
          );
        }
      )/*ListView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: answer.messages.length,
        itemBuilder: (context, index) {
          final message = answer.messages[index];
          if(message.messageType == MessageType.string){

            if(message.message.isEmpty){
              return const SizedBox.shrink();
            }

           return (isLast && !answer.isAnimationCompleted) ? DefaultTextStyle(
             style: chatStyle(),
             child: AnimatedTextKit(
               key: ValueKey(answer.answerId),
               animatedTexts: [
                 TypewriterAnimatedText(
                   message.message,
                   textStyle: chatStyle(),
                   speed: const Duration(milliseconds: 50),
                 ),
               ],
               onFinished:() {
                 answer.isAnimationCompleted=true;
                 onFinish?.call();
               },
               totalRepeatCount: 0,
               isRepeatingAnimation: false,
               repeatForever: false,
               displayFullTextOnTap: false,
               stopPauseOnTap: false,
             ),
           ): SelectableText(message.message,style:chatStyle(),);
          }else{
            if(message.message.isEmpty){
              return const SizedBox.shrink();
            }
            return Container(
              width: context.width*0.75,
              margin: const EdgeInsets.all(3),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(8.0),
                border: Border.all(color: Colors.grey)
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text((message.message.split("\n").first.capitalizeFirst??"").isCode,style: textStyle(color: Colors.white),),
                      CopyButton(data: message.message,direction: Direction.left,),
                    ],
                  ),
                  const Divider(height: 12,),
                  AnySyntaxHighlighter(
                    message.message.substring(message.message.indexOf("\n")),
                    softWrap: true,
                    fontSize: 13,
                    useGoogleFont: "Poppins",
                    theme: const AnySyntaxHighlighterTheme(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                      )
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),*/
    );
  }
}


class CustomShape extends CustomPainter {
  final Color bgColor;

  CustomShape(this.bgColor);

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()..color = bgColor;

    var path = Path();
    path.lineTo(-5, 0);
    path.lineTo(0, 10);
    path.lineTo(5, 0);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
