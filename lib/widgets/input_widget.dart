import 'package:ask_qx/animation/animated_slide_menu.dart';
import 'package:ask_qx/controller/chat_controller.dart';
import 'package:ask_qx/firebase/firebase_analytic_service.dart';
import 'package:ask_qx/services/speech_to_text_service.dart';
import 'package:ask_qx/services/text_to_speech_service.dart';
import 'package:ask_qx/themes/colors.dart';
import 'package:ask_qx/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../adjust/adjust_services.dart';

class InputWidget extends StatefulWidget {
  final TextEditingController queryController;
  final Function(String value)? onChange;
  final Function(String value)? onSubmit;
  final Function(int? menuType)? onMenuClick;
  final FocusNode? focusNode;
  const InputWidget({super.key,this.focusNode,this.onChange,this.onSubmit,this.onMenuClick,required this.queryController});

  @override
  State<InputWidget> createState() => _InputWidgetState();
}

class _InputWidgetState extends State<InputWidget> {

  var isSpeechOn = false;
  var speechData = "".obs;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (controller) {
      return Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap:isSpeechOn?null:(){
                   FirebaseAnalyticService.instance.logEvent('Click_Edit_Menu');
                    Get.dialog(
                      const AnimatedSlideMenu(),
                      barrierDismissible: true,
                    ).then((value) => widget.onMenuClick?.call(value));
                  },//isSpeechOn?null:widget.onNewChat,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0),
                    child: CircleAvatar(
                      backgroundColor: controller.currentDarkColor.value,
                      child: const Icon(Icons.edit,color: Colors.white,)
                    ),
                  ),
                ),
                const SizedBox(
                  width: 4,
                ),
                Expanded(
                  child: TextField(
                    focusNode: widget.focusNode,
                    readOnly: isSpeechOn,
                    controller: widget.queryController,
                    autofocus: false,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    keyboardAppearance: Get.theme.brightness,
                    maxLines: 6,
                    minLines: 1,
                    maxLength: 2000,
                    textCapitalization: TextCapitalization.sentences,
                    inputFormatters: [
                      NoSpaceFormatter(),
                    ],
                    onTap: () {
                      // if(controller.expandableFabState.currentState!=null && controller.expandableFabState.currentState!.isOpen){
                      //   controller.expandableFabState.currentState!.toggle();
                      // }
                      FirebaseAnalyticService.instance.logEvent("Click_Prompt_Box");
                    },
                    onChanged: (value) {
                      widget.onChange?.call(value);
                      setState(() {});
                    },
                    onSubmitted: (value) {
                      widget.onSubmit?.call(value);
                      widget.queryController.clear();
                      FocusScope.of(context).unfocus();
                    },
                    style: textStyle(color: getTextColor(),size: 14,weight: FontWeight.w500,),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: const BorderSide(color: Colors.grey,width: 0.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24.0),
                        borderSide: const BorderSide(color: Colors.grey,width: 0.5),
                      ),
                      hintText: isSpeechOn?"":"Ask me anything...",
                      counterText: "",
                      prefixIcon: isSpeechOn
                          ? Container(
                              width: context.width*0.75,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: LoadingAnimationWidget.staggeredDotsWave(
                                color: controller.currentDarkColor.value,
                                size: 30,
                              ),
                            )
                          : null,
                      hintStyle: textStyle(color: Colors.grey,size: 12,),
                      suffixIcon:widget.queryController.value.text.isEmpty? IconButton(
                        onPressed: () {
                          if(controller.isRegenerating.value || controller.queryLoading.value) return;
                          // if(TextToSpeechService.instance.isPlaying.value) return;
                          widget.queryController.clear();
                          FocusScope.of(context).unfocus();
                          if(isSpeechOn){
                            SpeechToTextService.service.stop();
                          }else{
                            _initSpeech();
                          }
                        },
                        icon: Icon(
                          isSpeechOn?Icons.stop_circle_outlined:Icons.mic_none,
                          color: controller.currentDarkColor.value,
                        ),
                      ):IconButton(
                        onPressed: () async{
                          final data = widget.queryController.text.trim();
                          if(data.isNotEmpty){
                            widget.onSubmit?.call(data);
                            controller.isFirstPrompt = controller.checkFirstPrompt();
                            if(controller.isFirstPrompt==false){
                              AdjustServices.instance.adjustEvent(AdjustServices.firstPrompt.toString()); //For first prompt
                            }
                          }
                          widget.queryController.clear();
                          FocusScope.of(context).unfocus();
                        },
                        icon: Icon(
                          Icons.send_rounded,
                          color: controller.currentDarkColor.value,
                        ),
                      ),
                      isDense: false,
                      contentPadding: const EdgeInsets.only(left: 14,top: 7,bottom: 7),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 4,top: 4),
              child: Text(
                "${widget.queryController.text.length}/2000",
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
            )
          ],
        ),
      );
    });
  }

  /// This has to happen only once per app
  void _initSpeech() async {
    speechData("");
    SpeechToTextService.service.initializeAndStart((result) {
        speechData(result);
      },
      (state) {
        switch(state.trim().toLowerCase()){
          case "listening":
            setState(() {
              isSpeechOn = true;
            });
            break;
          case "done":
            widget.onSubmit?.call(speechData.value);

            setState(() {
              isSpeechOn = false;
            });

            break;
          case "notListening":
            break;
          default:
            break;
        }
      },
      (error) {
        setState(() {
          isSpeechOn = false;
        });
      },
    );
  }

}

class NoSpaceFormatter extends TextInputFormatter{
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.startsWith(' ')) {
      return oldValue;
    }else  if (newValue.text.startsWith('\n')) {
      return oldValue;
    }
    return newValue;
  }
}