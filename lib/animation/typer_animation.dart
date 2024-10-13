import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TypingAnimation extends StatefulWidget {
  final String text;
  final TextStyle? style;
  final Function(bool typing)? onTyping;
  const TypingAnimation({super.key,required this.text,this.onTyping,this.style});

  @override
  State<TypingAnimation> createState() => _TypingAnimationState();
}

class _TypingAnimationState extends State<TypingAnimation> {
  var lastIndex = 0.obs;
  bool typing = true;

  @override
  void initState() {
    super.initState();
    lastIndex(0);
    typing = true;
    startTyping();
  }

  @override
  Widget build(BuildContext context) {
    return Obx( () {
        return Text.rich(
          TextSpan(
            text:widget.text.substring(0,lastIndex.value),
            children: [
              if(typing)
                const TextSpan(text:"_"),
            ],
          ),
          textAlign: TextAlign.start,
          style: widget.style,
        );
      }
    );
  }

  void startTyping() async {
    if(lastIndex.value > widget.text.length-1){
      typing = false;
      lastIndex(0);
      widget.onTyping?.call(false);
      return;
    }else{
      await Future.delayed(const Duration(milliseconds: 10),(){
          lastIndex++;
          widget.onTyping?.call(true);
          startTyping();
      });
    }
  }
}
