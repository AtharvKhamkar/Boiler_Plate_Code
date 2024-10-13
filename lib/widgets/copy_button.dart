import 'package:animate_do/animate_do.dart';
import 'package:ask_qx/themes/colors.dart';
import 'package:ask_qx/utils/extension_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum Direction{left,right}
class CopyButton extends StatefulWidget {
  final String data;
  final Color? color;
  final String? helperText;
  final Direction direction;

  const CopyButton({super.key, required this.data, this.color, this.helperText,this.direction = Direction.right});

  @override
  State<CopyButton> createState() => _CopyButtonState();
}

class _CopyButtonState extends State<CopyButton> {
  bool isCopied = false;

  @override
  Widget build(BuildContext context) {
    return isCopied
        ? FadeIn(
            key: UniqueKey(),
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Copied",
                    style: textStyle(size: 12, color: widget.color),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Icon(
                    Icons.check,
                    color: widget.color,
                    size: 18,
                  )
                ],
              ),
            ),
          )
        : InkWell(
            onTap: () {
              Clipboard.setData(ClipboardData(text: widget.data));
              // ErrorHandle.success("Copied successfully");
              setState(() {
                isCopied = true;
                Future.delayed(const Duration(seconds: 1),(){
                  setState(() {
                    isCopied = false;
                  });
                });
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.helperText != null) ...[
                    Text(
                      widget.helperText!,
                      style: textStyle(size: 12, color: widget.color),
                    ),
                    const SizedBox(
                      width: 3,
                    ),
                  ],
                  Image.asset(
                    "copy-right.png".toIcon,//widget.direction == Direction.right?"copy-right.png".toIcon :"copy-left.png".toIcon ,
                    color: widget.color ?? Colors.grey,
                    width: 18,
                  ),
                ],
              ),
            ),
          );
  }
}
