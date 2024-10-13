import 'package:ask_qx/utils/extension_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../themes/colors.dart';
import '../utils/utils.dart';
import 'custom_form_button.dart';

class ChatFeedbackBottomSheet extends StatefulWidget {
  final List<String> suggestion;
  final bool showTextField;
  const ChatFeedbackBottomSheet({super.key,this.suggestion = const [],this.showTextField = true});

  @override
  State<ChatFeedbackBottomSheet> createState() => _ChatFeedbackBottomSheetState();
}

class _ChatFeedbackBottomSheetState extends State<ChatFeedbackBottomSheet> {
  final formKey = GlobalKey<FormState>();
  final _feedbackController = TextEditingController();


  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Container(
        height: widget.suggestion.length>6?context.height*0.65:null,
        decoration:  BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 10),
          child: Form(
            key:formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Feedback",
                      style: TextStyle(
                        color: getTextColor(),
                        fontSize: 16,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.back(result:  "close");
                        HapticFeedback.lightImpact();
                      },
                      child: const Icon(Icons.highlight_remove),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                const Divider(
                  color: Colors.grey,
                  height: 0,
                  thickness: 0.5,
                ),
                const SizedBox(
                  height: 20,
                ),
                if(widget.showTextField)
                TextField(
                  controller: _feedbackController,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.go,
                  keyboardAppearance: Get.theme.brightness,
                  maxLines: 10,
                  minLines: 1,
                  maxLength: 200,
                  onSubmitted: (value) {
                    FocusScope.of(context).unfocus();
                  },
                  style: textStyle(color: getTextColor(),size: 14,weight: FontWeight.w500,),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: const BorderSide(color: Colors.grey,width: 0.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: const BorderSide(color: Colors.grey,width: 0.5),
                    ),
                    hintText: "Type here...",
                    hintStyle: textStyle(color: Colors.grey,size: 12,),
                    isDense: false,
                    contentPadding: const EdgeInsets.only(left: 14,top: 7,bottom: 7,right: 14),
                  ),
                ),
                if(widget.suggestion.isNotEmpty)...[
                  const SizedBox(height: 10,),
                  ListView(
                    shrinkWrap: true,
                    children: [
                      Wrap(
                        runSpacing: 0,
                        spacing: 8,
                        alignment: WrapAlignment.start,
                        children: widget.suggestion.map((e) {
                          return ActionChip(
                            padding: const EdgeInsets.symmetric(horizontal: 3,vertical: 0),
                            label: Text(e,maxLines: 3,overflow: TextOverflow.ellipsis,style: const TextStyle(fontSize: 12),),
                            onPressed: (){
                              Get.back(result: e);
                            },
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                ],
                if(widget.showTextField)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 10),
                  child: CustomFormButton(
                    isLoading:false,
                    innerText: "Submit",
                    onPressed: () {
                      Get.back(result: _feedbackController.text);
                    },
                  ),
                ),
                Text(
                  "Once submitted, cannot be undone.",
                  style: textStyle(size: 12, color: Colors.grey),
                ),
                context.kBottomSafePadding,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
