import 'package:animate_do/animate_do.dart';
import 'package:ask_qx/utils/extension_utils.dart';
import 'package:ask_qx/widgets/qx_branding_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class Page2 extends StatelessWidget {
  const Page2({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        children: [
          Image.asset(
            "assets/artificial-intelligence.gif",
            height: context.height * 0.22,
            width: double.infinity,
          ),
          FadeInUp(
            delay: const Duration(milliseconds: 200),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("thunder.png".toIcon, width: 20, color: Colors.deepOrange),
                    const SizedBox(width: 4),
                    const Text(
                      "Faster Response",
                      style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Get lightning-fast responses to your questions",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(35, 35, 35, 0.702),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          FadeInUp(
            delay: const Duration(milliseconds: 400),
            child: const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.g_translate, color: Colors.green, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Supporting 100+ Languages",
                      style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                QxBrandingDescription(
                  trailingText: 'anything in your own language',
                  textAlign: TextAlign.center,
                  textSize: 15,
                  color: Color.fromRGBO(35, 35, 35, 0.702),
                )
              ],
            ),
          ),
          const SizedBox(height: 30),
          FadeInUp(
            delay: const Duration(milliseconds: 600),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("personaliz_ex.png".toIcon, width: 24),
                    const SizedBox(width: 8),
                    const Text(
                      "Personalized Experience",
                      style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Text(
                  "Suggestions tailored to your interests and use case",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(35, 35, 35, 0.702),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          FadeInUp(
            delay: const Duration(milliseconds: 800),
            child: const Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.health_and_safety_rounded, color: Colors.amber, size: 22),
                    SizedBox(width: 8),
                    Text(
                      "Safe Interaction",
                      style: TextStyle(color: Colors.black, fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  "Safeguarded interactions with sophisticated algorithms and content filters",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color.fromRGBO(35, 35, 35, 0.702),
                    fontSize: 15,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
