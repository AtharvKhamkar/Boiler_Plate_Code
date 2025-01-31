import 'package:flutter/material.dart';

import '../themes/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimaryLight,
        minimumSize: const Size(double.infinity, 50),
      ),
      child: Text(
        text,
        style:textStyle(color: Colors.white),
      ),
    );
  }
}
