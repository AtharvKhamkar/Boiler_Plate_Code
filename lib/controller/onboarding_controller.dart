import 'dart:async';

import 'package:ask_qx/global/app_data_provider.dart';
import 'package:ask_qx/screens/onboarding/page1.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../screens/onboarding/page2.dart';
import '../screens/onboarding/page3.dart';
import '../themes/colors.dart';
import '../widgets/conversation_style_widget.dart';

class OnboardingController extends GetxController with StateMixin<dynamic>{

  var pageIndex = 0;

  var listOfStyle = <ConversationStyle>[
    ConversationStyle.creative,
    ConversationStyle.balanced,
    ConversationStyle.precise,
  ];

  var listOfOboard = [
    "Ignite Your Creativity",
    "Be More Productive",
    "Get Inspired",
    "Discover Ideas",
    "Spark Your Imagination",
    "Simplify Everyday Tasks",
  ];

  List<String> suggestionQuery = [];

  List<String> promptsQuery = [
    'हिंदी को स्पैनिश में अनुवाद करें', //Hindi
    'Write a Nicholas Sparks short love story', //English
    'નવરાતિ 2024 ક્યારે છે', //Gujarati
    'হাউ তো মেক মিষ্টি দই', //Bengali
    'ਇੱਕ ਰੈਪ ਗੀਤ ਲਿਖੋ', //Punjabi
    'تلخيص اقتراح تجاري', //Arabic
    '2024లో పన్ను ఆదా చేయడం ఎలా', //Telugu
    'ఆన్‌లైన్‌లో డబ్బు సంపాదించడం ఎలా', //Malayalam
    'வாழ்த்துச் செய்தியை எழுதுங்கள்', //Tamil
    'FASTag साठी माझे KYC ऑनलाइन कसे अपडेट करावे?', //Marathi
  ];

  var conversationStyle = ConversationStyle.balanced.obs;
  var currentColor = kPrimaryDark.obs;
  var currentColorOnboard = kPrimaryDark.obs;
  var currentDarkColor = Colors.blue.shade800.obs;
  var conversationToolTipMessage = "Clear your chat and start an original and imaginative chat".obs;
  var conversationToolTipMessage2 = "The standard mode gives you straightforward answers and is perfect for everyday queries, information retrieval, and quick assistance.".obs;


  var children = [
    const Page1(),
    const Page2(),
    const Page3(),
  ];

  var colors = [
    const Color(0xff211e5e),
    Colors.white,
    const Color(0xff211e5e),
  ];
  var indicator = [
    const Color(0xff211e5e),
    Colors.white,
    Colors.white,
  ];

  Timer? timer;

  @override
  void onInit() {
    suggestionQuery.addAll(AppDataProvider.suggestionBasedOnStyle(conversationStyle.value));
    super.onInit();
  }


  @override
  void onReady() {
    super.onReady();
    initTime();
  }


  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }



  void changeConversationStyle(title) {
    suggestionQuery.clear();
    switch (title.toString().toLowerCase()) {
      case "creative":
        conversationStyle.value = ConversationStyle.creative;
        currentColor.value = kSecondary;
        currentDarkColor.value = kSecondary;
        conversationToolTipMessage.value = "Clear your chat and start an original and imaginative chat";
        conversationToolTipMessage2 = '''The creative mode gives you imaginative, out-of-the-box answers and is perfect for creative projects, brainstorming, content creation, and more.'''
            .obs;
        break;

    //Balanced ConversationStyle
      case "balanced":
        conversationStyle.value = ConversationStyle.balanced;
        currentColor.value = kPrimaryDark;
        currentDarkColor.value = kPrimaryDark;
        conversationToolTipMessage.value = "Clear your chat and start an informative and friendly chat";
        conversationToolTipMessage2.value = '''The standard mode gives you straightforward answers and is perfect for everyday queries, information retrieval, and quick assistance.''';

        break;
    //Precise ConversationStyle
      case "precise":
        conversationStyle.value = ConversationStyle.precise;
        currentColor.value = kThird;
        currentDarkColor.value = kThird;
        conversationToolTipMessage.value = "Clear your chat and start an concise and straightforward chat";
        conversationToolTipMessage2.value = '''The professional mode gives more formal answers and is perfect for work-related queries, professional advice, and productivity tasks.''';
        break;
    }
    suggestionQuery.addAll(AppDataProvider.suggestionBasedOnStyle(conversationStyle.value));
    update();
  }

  void initTime(){
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if(conversationStyle.value == ConversationStyle.balanced){
        changeConversationStyle(ConversationStyle.precise.name);
      }else if(conversationStyle.value == ConversationStyle.precise){
        changeConversationStyle(ConversationStyle.creative.name);
      }else{
        changeConversationStyle(ConversationStyle.balanced.name);
      }
    });
  }

}