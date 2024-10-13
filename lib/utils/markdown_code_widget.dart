import 'package:ask_qx/widgets/copy_button.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:flutter/material.dart';


class MarkdownCodeWidget extends MarkdownElementBuilder {

  bool isCodeBlock(md.Element element) {
    if (element.attributes['class'] != null) {
      return true;
    } else if (element.textContent.contains("\n")) {
      return true;
    }
    return false;
  }

  @override
  Widget? visitElementAfter(md.Element element, TextStyle? preferredStyle) {

    if (!isCodeBlock(element)) {
      return Text(
        element.textContent,
        style: preferredStyle,
      );
    } else {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text((element.attributes['class']?.split("-").last??"Code").capitalizeFirst??"Code",style: const TextStyle(color: Colors.white,fontSize: 13),),
                CopyButton(data: element.textContent),
              ],
            ),
          ),
          Container(
            height: 0.2,
            width: double.maxFinite,
            color: Colors.grey,
            margin: const EdgeInsets.symmetric(vertical: 8),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Text(
                element.textContent,
                style: preferredStyle,
                softWrap: false,
                textAlign: TextAlign.start,
              ),
            ),
          ),
        ],
      );
    }
  }
}