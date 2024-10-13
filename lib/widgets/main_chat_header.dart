import 'package:ask_qx/widgets/qx_branding_widget.dart';
import 'package:flutter/material.dart';


class MainChatAiHeader extends StatelessWidget {
  final Color currentColor;
  final String title;
  const MainChatAiHeader({
    super.key,
    required this.currentColor,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/QX_logo-02.png",
              height: 34,
              width: 34,
              color: currentColor,
            ),
            const SizedBox(width: 10,),
            QxBrandingWidget(key: UniqueKey(),scaleFactor: 0.5,),

          ],
        ),
        Visibility(
          visible: title.trim().isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0,right: 0,left: 10),
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

}