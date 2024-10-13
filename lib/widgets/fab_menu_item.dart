import 'package:flutter/material.dart';

import '../themes/colors.dart';

class FabMenuItem extends StatelessWidget {
  final String title;
  final Widget icon;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  const FabMenuItem({super.key,required this.title,required this.icon,this.onTap,this.backgroundColor = Colors.black,});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
          color: backgroundColor,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon,
            const SizedBox(width: 6,),
            Text(title,style: textStyle(size: 12,weight: FontWeight.w500,color: Colors.white),)
          ],
        ),
      ),
    );
  }
}
