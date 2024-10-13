import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SuggestionTextWidget extends StatelessWidget {
  final VoidCallback onTap;
  final Color color;
  const SuggestionTextWidget({super.key,required this.onTap,required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap:onTap,
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: context.theme.scaffoldBackgroundColor,
                width: 1,
              ),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.0, vertical: 4),
              child: Text(
                "Suggestions",
              ),
            ),
        ).animate(onPlay: (controller) => controller.repeat(),
        ).shimmer(
            angle: 250,
            duration: const Duration(seconds: 2),
            color: color),
    );
  }
}
