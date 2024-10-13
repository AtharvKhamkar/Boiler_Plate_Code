import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuggestionAnimatedWidget extends StatelessWidget {
  final List<String> suggestions;
  final String title;
  const SuggestionAnimatedWidget({
    super.key,
    required this.suggestions,
    this.title='Ask me anything....',
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {

      },
      child: Container(
        width: Get.width * 0.82,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 6.0,
            horizontal: 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 5,
              ),
               Text(
                title,
                style:const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: AnimatedTextKit(
                      displayFullTextOnTap: true,
                      isRepeatingAnimation: true,
                      pause: const Duration(seconds: 2),
                      repeatForever: true,
                      onNextBeforePause: (int index, bool isLast) {
                      },
                      animatedTexts: suggestions.map((e) => TyperAnimatedText(
                        e,
                        textAlign: TextAlign.center,
                        textStyle: const TextStyle(
                            overflow: TextOverflow.ellipsis,
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                        speed: const Duration(milliseconds: 100),
                      )).toList(),
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 1),
                  Image.asset(
                    "assets/QX_logo-02.png",
                    height: 17,
                    width: 17,
                    color: const Color(0xffFFC444),
                  ),
                ],
              ),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedSuggestionWidget extends StatelessWidget {
  const AnimatedSuggestionWidget({
    super.key,
    required this.suggestion,
    required this.currentColor,
    required this.onChange,
    required this.onTap,
  });

  final List<String> suggestion;
  final Color currentColor;
  final Function(int index)? onChange;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: currentColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 6.0,
          horizontal: 12,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            DefaultTextStyle(
              style: TextStyle(
                color: currentColor,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              child: AnimatedTextKit(
                displayFullTextOnTap: true,
                isRepeatingAnimation: true,
                pause: const Duration(seconds: 2),
                repeatForever: true,
                onNextBeforePause: (int index, bool isLast) {
                  onChange?.call(index);
                },
                onNext: (p0, p1) {
                  onChange?.call(p0);
                },
                animatedTexts: suggestion.map((e) => TyperAnimatedText(
                  e,
                  textAlign: TextAlign.center,
                  textStyle: const TextStyle(
                      overflow: TextOverflow.ellipsis,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                  ),
                  speed: const Duration(milliseconds: 100),
                ),
                ).toList(),
                onTap:onTap,
              ),
            ),
            const SizedBox(
              width: 1,
            ),
            Image.asset(
              "assets/QX_logo-02.png",
              height: 16,
              width: 16,
              color: currentColor,
            ),
          ],
        ),
      ),
    );
  }
}