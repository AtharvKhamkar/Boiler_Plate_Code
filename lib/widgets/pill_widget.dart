import 'package:ask_qx/themes/colors.dart';
import 'package:flutter/material.dart';

class PillWidget extends StatelessWidget {
  final String text;
  final Color? color;
  const PillWidget({super.key,required this.text,this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 2),
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: color??Colors.blue.shade800,
      ),
      alignment: Alignment.center,
      child: Text(text,style: textStyle(size: 10,weight: FontWeight.w500,color: Colors.white),),
    );
  }
}
