import 'package:ask_qx/themes/colors.dart';
import 'package:ask_qx/widgets/qx_branding_widget.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/chat_ai_custom_header.dart';

class ChatInfoWidget extends StatelessWidget {
  const ChatInfoWidget({
    super.key,
    required this.currentDark,
    required this.currentLight,
  });

  final Color currentDark;
  final Color currentLight;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ImageAnimateRotate(
          child:Image.asset(
            "assets/QX_logo-02.png",
            height: 130,
            width: 130,
            color:currentDark,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        QxBrandingWidget(key: UniqueKey(),scaleFactor: 1.0,),
        const SizedBox(height: 14),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: QxBrandingDescription(
            trailingText: 'is AI based chatbot which can help you to find your answers in a very easy way.',
            textSize: 13,
            color: darkLight,
          ),
        ),
        const SizedBox(height: 10),

        Padding(
          padding:  const EdgeInsets.symmetric(horizontal: 12.0),
          child:QxBrandingDescription(trailingText: 'can make mistakes. Verify important information.',textSize: 13,color: getSubTitleColor(),),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}