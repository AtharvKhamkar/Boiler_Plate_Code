
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../themes/colors.dart';
import '../utils/utils.dart';


class CustomFormButton extends StatelessWidget {
  final String innerText;
  final void Function()? onPressed;
  final double? horizontalPadding;
  final bool isOutlined;
  final bool isLoading;
  final bool isEnable;
  final Widget? icon;
  final double? borderRadius;
  const CustomFormButton(
      {Key? key,
      required this.innerText,
      required this.onPressed,
      this.isOutlined = false,
      this.borderRadius,
      this.isLoading = false,
      this.isEnable = true,
      this.icon,
      this.horizontalPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxWidth: size.width * 0.92,
          minWidth: size.width * 0.92,
          minHeight: horizontalPadding ?? 55,
      ),
      child: ElevatedButton(
        onPressed:isEnable? () {
          hapticFeedbackCustom(HapticFeedbackTypeCustom.lightImpact);

          if (isEnable) {
            FocusScope.of(context).unfocus();
            onPressed?.call();
          }
        }:null,
        style: ButtonStyle(
          enableFeedback: isEnable,
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius ?? 14),
            side: BorderSide(
                color: isOutlined ? kPrimaryLight : Colors.transparent),
          )),
          backgroundColor: !isEnable
              ? MaterialStateProperty.all(
                  getPrimaryColor(context: context).withOpacity(.3))
              : MaterialStateProperty.all(
                  isOutlined ? Colors.white : kPrimaryLight),
          overlayColor: MaterialStateProperty.resolveWith(
            (states) {
              return states.contains(MaterialState.pressed)
                  ? Colors.white30
                  : null;
            },
          ),
        ),
        child: isLoading
            ? LoadingAnimationWidget.staggeredDotsWave(color: Colors.white , size: 35)
            : icon ??
                Text(
                  innerText,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      // fontFamily: '',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: !isEnable
                          ? Colors.grey
                          : isOutlined
                              ? kPrimaryLight
                              : Colors.white),
                ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final Widget? icon;
  final String text;
  final bool isLoading;
  final VoidCallback onTap;
  const SocialButton({super.key,
    required this.icon,
    required this.text,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        fixedSize: const Size(150, 44)
      ),
      onPressed: onTap,
      child: Visibility(
        visible: !isLoading,
        replacement: Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.white,
            size: 34,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(icon!=null)...[
              icon!,
              const SizedBox(width: 10,),//abcd@yopmail.com
            ],
            Text(text,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontSize: 16),)
          ],
        ),
      ),
    );
  }
}

