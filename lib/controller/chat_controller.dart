/*
 * Created or updated by Deepak Gupta on 13/02/24, 5:53 pm
 *  Copyright (c) 2024 . All rights reserved for Ask Qx Lab AI.
 * Last modified 13/02/24, 5:35 pm
 */

import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:ask_qx/firebase/firebase_analytic_service.dart';
import 'package:ask_qx/firebase/firebase_messaging_service.dart';
import 'package:ask_qx/global/app_data_provider.dart';
import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/global/app_util.dart';
import 'package:ask_qx/model/chat.dart';
import 'package:ask_qx/model/conversation.dart';
import 'package:ask_qx/model/error_model.dart';
import 'package:ask_qx/model/suggestion.dart';
import 'package:ask_qx/network/api_client.dart';
import 'package:ask_qx/network/error_handler.dart';
import 'package:ask_qx/network/loader.dart';
import 'package:ask_qx/repository/app_repository.dart';
import 'package:ask_qx/repository/auth_repository.dart';
import 'package:ask_qx/repository/chat_repository.dart';
import 'package:ask_qx/repository/share_repository.dart';
import 'package:ask_qx/screens/chat/recent_chat_screen.dart';
import 'package:ask_qx/screens/chat/share_chat_screen.dart';
import 'package:ask_qx/firebase/firebase_dynamic_link.dart';
import 'package:ask_qx/services/upgrader_service.dart';
import 'package:ask_qx/widgets/conversation_style_widget.dart';
import 'package:ask_qx/widgets/recommended_suggestion_widget.dart';
import 'package:ask_qx/widgets/rename_conversation_bottomsheet.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../repository/profile_repository.dart';
import '../themes/colors.dart';
class ChatController extends GetxController with StateMixin<dynamic>, GetSingleTickerProviderStateMixin, WidgetsBindingObserver {
  TabController? tabController;

  List<String> suggestionsQuery = [];

  //Key's
  // var expandableFabState = GlobalKey<ExpandableFabState>();
  final renameFormKey = GlobalKey<FormState>();
  final queryKey = const ValueKey("qxlabai_inout");


  //Classes
  final _chatRepository = ChatRepository();
  final _shareChatRepository = ShareChatRepository();
  final _profileRepository = ProfileRepository();

  //controllers
  var chatScrollController = ScrollController();
  var recentScrollController = ScrollController();
  var suggestionScrollController = ScrollController();
  final renameController = TextEditingController();
  final queryController = TextEditingController();

  //Variables
  var conversationName;
  var conversationId = "".obs;
  var chatId = "".obs;
  var shareChatSourceId = "".obs;
  var shareChatName = "".obs;
  var recentChatList = <Conversation>[].obs;
  var currentChatList = <Chat>[].obs;
  var shareChatList = <Chat>[].obs;
  var suggestionList = <Suggestion>[].obs;
  var currentDarkColor = Colors.blue.shade800.obs;
  var currentColor = kPrimaryDark.obs;
  var currentStyle = AppStorage.getConversationStyle();
  var suggestionLoading = true.obs;
  var historyLoading = true.obs;
  var queryLoading = false.obs;
  var isRegenerating = false.obs;
  var renameLoading = false.obs;
  var sharChatCoping = false.obs;
  var currentSuggestionIndex = 0.obs;
  var deleteChatId = "".obs;

  var regenerateKey = UniqueKey();
  FocusNode? focusNode;
  bool isFirstPrompt = false;

  @override
  void onInit() {
    AppStorage.setIsAccountDeleted(false);
    WidgetsBinding.instance.addObserver(this);
    // FirebaseMessageService.instance.permission();
    FirebaseAnalyticService.instance.userDefaults();
    UpgraderService.instance.isAvailable();
    AuthRepository().updateFirebaseToken();
    suggestions();
    _profileRepository.userFirstpromptDetails().then((value) {
      isFirstPrompt = value;
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    onStyleChange(currentStyle);
    handleDeepLink();
    chatScrollController.addListener(() {
      hasData(chatScrollController.position.pixels<chatScrollController.position.maxScrollExtent);
    });
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    chatScrollController.dispose();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.resumed:
         handleDeepLink();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.hidden:
        break;
      case AppLifecycleState.paused:
        break;
    }
  }

  void onNewChat() {
    if (queryLoading.value || isRegenerating.value) return;
    currentChatList.clear();
    conversationId("");
    chatId("");
    conversationName = null;
    chatScrollController.dispose();
    chatScrollController = ScrollController();
    queryController.clear();
    focusNode?.unfocus();
    currentSuggestionIndex(0);
    chatScrollController.addListener(() {
      hasData(chatScrollController.position.pixels<chatScrollController.position.maxScrollExtent);
    });
    hasData(false);
    // TextToSpeechService.instance.stop();
    update();
  }

  void onMenuClick(int menuType){
    switch(menuType){
      case 1:
        AppStorage.setConversationStyle(ConversationStyle.precise);
        onStyleChange(ConversationStyle.precise);
        break;
      case 2:
        AppStorage.setConversationStyle(ConversationStyle.balanced);
        onStyleChange(ConversationStyle.balanced);
        break;
      case 3:
        AppStorage.setConversationStyle(ConversationStyle.creative);
        onStyleChange(ConversationStyle.creative);
        break;
      case 4:
        FirebaseAnalyticService.instance.logEvent("Click_New_Message_Main");
        onNewChat();
        break;
    }
  }



  void openRecent() {
    if(showStopButton.value)return;
    FirebaseAnalyticService.instance.logEvent("Click_Chat_History");
    Get.to<Item?>(
      () => const RecentChatScreen(),
      fullscreenDialog: true,
      transition: Transition.downToUp,
    )!.then((value) {
      FirebaseAnalyticService.instance.logEvent("Close_Chat_History");
      if (value == null) return;
      if (value.conversationId == conversationId.value) return;
      // TextToSpeechService.instance.stop();
      conversationId(value.conversationId);
      conversationName = value.conversation;
      // expandableFabState = GlobalKey<ExpandableFabState>();
      chatScrollController.addListener(() {
        hasData(chatScrollController.position.pixels<chatScrollController.position.maxScrollExtent);
      });
      chats();
    });
    Future.delayed(const Duration(milliseconds: 300),history);
  }

  void onStyleChange(ConversationStyle style) {
    FirebaseAnalyticService.instance.logEvent('Click_${ConversationStyleWidgetState.localName(style).capitalizeFirst}_Chat');
    currentStyle = style;
    currentSuggestionIndex(0);
    suggestionsQuery.clear();
    switch (currentStyle) {
      case ConversationStyle.creative:
        currentDarkColor(kSecondary);
        break;
      case ConversationStyle.balanced:
        currentDarkColor(Colors.blue.shade800);
        break;
      case ConversationStyle.precise:
        currentDarkColor(kThird);
        break;
    }
    // if (expandableFabState.currentState != null) {
    //   expandableFabState = GlobalKey<ExpandableFabState>();
    // }
    // queryController.clear();
    focusNode?.unfocus();
    suggestionsQuery.addAll(AppDataProvider.suggestionBasedOnStyle(style));
    suggestionsQuery.shuffle();
    update();
  }

  void onSuggestionTabChange(int index) {
    update();
  }

  void openSuggestion() {
    Get.bottomSheet(const RecommendedSuggestionWidget(), isDismissible: false).then((value) {
      suggestionLoading(false);
      if (value != null) {
        queryController.text = value.query;
      }
      update();
    });
  }

  void openRename(Item item) {
    renameController.clear();
    renameController.text = item.conversation;
    FirebaseAnalyticService.instance.logEvent('Click_Chat_Rename');
    Get.bottomSheet(RenameConversationBottomSheet(item: item), isDismissible: false).then((value) {
      renameLoading(false);
    });
  }

  void scrollToBottom() {
    update();
    Future.delayed(const Duration(milliseconds: 400), () {
      if (currentChatList.isNotEmpty) {
        // chatScrollController.jumpTo(chatScrollController.position.maxScrollExtent);
        chatScrollController.animateTo(chatScrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 500), curve: Curves.easeInOut);
      }
      hasData(false);
    });
  }

  var isOpenSuggestion = false.obs;
  Suggestion? selectedCategory;
  void suggestions() {
    if (suggestionList.isNotEmpty) {
      return;
    }
    _chatRepository.suggestions().then((value) {
      if (value['success']) {
        var list = List<Suggestion>.from(value['data']['appSuggestions'].map((d) => Suggestion.fromJson(d)));
        suggestionList.clear();
        suggestionList.addAll(list);
        tabController = TabController(length: suggestionList.length, vsync: this);
        selectedCategory = suggestionList.first;
      }
      update();
    }, onError: (e) {
      log("Error suggestions $e");
    });
  }

  void chats(){
    // TextToSpeechService.instance.stop();
    currentChatList.clear();
    update();

    Loader.show();

    _chatRepository.getChats(conversationId.value).then((value) {
      Loader.hide();
      if(value['success'] == false) {
        final model = ErrorModel.fromJson(value['error']);
        ErrorHandle.error(model.message);
        return;
      }
      Map chat = value['data']['conversation'];
      conversationId(chat['conversationId']);
      String name = chat['conversation']??"";

      currentChatList.clear();

      final model = List<Chat>.from(chat['chats'].map((c) => Chat.fromRecentJson(c)));

      currentChatList.addAll(model);

      if(currentChatList.isNotEmpty){
        conversationName = name.isEmpty?currentChatList.first.query:name;

        scrollToBottom();
      } else {
        update();
        hasData(false);
        ErrorHandle.error("Details not available");
      }

    },onError: (e){
      Loader.hide();
    });
  }

  void history() {
    _chatRepository.history().then((value) {
      historyLoading(false);
      if (value['success']) {
        recentChatList.clear();
        var list = List<Conversation>.from(value['data']['conversations'].map((c) => Conversation.fromJson(c)));
        recentChatList(list);
      } else {
        recentChatList.clear();
      }
      update();
      if(recentChatList.isNotEmpty){
        Future.delayed(const Duration(milliseconds: 300),(){
          recentScrollController.animateTo(recentScrollController.position.minScrollExtent,duration: const Duration(milliseconds: 300),curve: Curves.ease);
        });
      }
    }, onError: (e) {
      historyLoading(false);
      update();
      ErrorHandle.error(e);
    });
  }

  void getArchiveChat(Item item){
    currentChatList.clear();
    shareChatList.clear();
    conversationId("");
    update();

    Loader.show();

    _chatRepository.getChats(item.conversationId).then((value) {
      Loader.hide();
      if(value['success'] == false) return;
      Map chat = value['data']['conversation'];

      final model = List<Chat>.from(chat['chats'].map((c) => Chat.fromRecentJson(c)));
      shareChatList.addAll(model);

      if(shareChatList.isNotEmpty){
        var name = chat['conversation']??"";
        shareChatName(name.toString().isEmpty?shareChatList.first.query:name);
      }
      Get.to(() => const ChatReadOnlyScreen(type: "archive",), fullscreenDialog: true,transition: Transition.downToUp)?.then((value) {
        if (value != null && value == 'archive') {
          _chatRepository.archive(item.conversationId,false);
          currentChatList.addAll(shareChatList);
          conversationId(item.conversationId);
          conversationName = (item.conversation);
          scrollToBottom();
        }
      });

      scrollToBottom();
    },onError: (e){
      Loader.hide();
    });
  }

  void onAskQuery(String query) async{

    if(isRegenerating.value) return;

    final connected = await AppRepository().isNetworkAvailable();

    if(!connected){
      ErrorHandle.error(AppDataProvider.connectionError);
      return;
    }

    if(currentChatList.isNotEmpty){
      currentChatList.last.followup.clear();
    }

    final uuid = AppUtil.uniqueId();
    final chat = Chat.Ask(query, uuid);
    currentChatList.add(chat);

    deleteChatId("");
    queryLoading(true);
    scrollToBottom();

    _chatRepository.query(query, conversationId.value).then((value) {
      queryLoading(false);

      if (value['success']) {
        final model = List<Chat>.from(value['data']['response']['chats'].map((c) => Chat.fromJson(c)));
        conversationId(value['data']['response']['conversationId']);
        chatId(model.last.chatId);
        currentChatList.removeWhere((element) => element.uuid == uuid);
        currentChatList.addAll(model);
        _chatRepository.followup(conversationId.value, chatId.value).then((value) {
          if (value['success']) {
            final follow = List<String>.from(value['data']['questions'].map((q) => q));
            if(currentChatList.isNotEmpty){
              if(deleteChatId.value.isEmpty)currentChatList.last.followup.addAll(follow);
              scrollToBottom();
            }
          }
        });
      }else{
        currentChatList.last.isLoading = false;
        currentChatList.last.errorMessage = "Oops! Look's like our chat got lost!";
      }

      scrollToBottom();
      toBottom();
    }, onError: (e) {
      queryLoading(false);
      currentChatList.last.isLoading = false;
      currentChatList.last.errorMessage = "Oops! Look's like our chat got lost!";
      // ErrorHandle.error(e);
      update();
    });
  }

  void onRegenerate() async {

    if(isRegenerating.value) return;

    final connected = await AppRepository().isNetworkAvailable();

    if(!connected){
      ErrorHandle.error(AppDataProvider.connectionError);
      return;
    }

    isRegenerating(true);
    update();
    FirebaseAnalyticService.instance.logEvent("Click_Regenerate_Chat");
    _chatRepository.regenerate(conversationId.value).then((value) {
      isRegenerating(false);

      if (value['success']) {
        final model = List<Chat>.from(value['data']['response']['chats'].map((c) => Chat.fromJson(c)));
        conversationId(value['data']['response']['conversationId']);
        chatId(model.last.chatId);
        currentChatList.last.answers.addAll(model.first.answers);

        int lastIndex = currentChatList.last.answers.length - 1;

        currentChatList.last.currentChatStyle = (currentChatList.last.answers[lastIndex].style);
        currentChatList.last.currentIndex(currentChatList.last.answers.length - 1);

        regenerateKey = UniqueKey();
      }

      scrollToBottom();
      toBottom();
    }, onError: (e) {
      isRegenerating(false);
      update();
    });
  }

  void onDeleteChat(String conversationId, {bool back = true}) {
    if(queryLoading.value || isRegenerating.value){
      return;
    }

    ErrorHandle.qxLabConfirmationDialogue(
      message: "If you delete your conversation, you will not be able to read it later. Are you sure you want to delete the conversation?",
      title: "Warning",
      dialogueType: DialogueType.warning,
      cancelText: "No",
      confirmText: "Yes",
      actionColor: Colors.redAccent,
      onConfirm: () {
        if (back) Get.back();
        if (conversationId == this.conversationId.value) {
          onNewChat();
        }
        _chatRepository.delete(conversationId).then((value) {
          if (value['success']) {
            ErrorHandle.success("Chat deleted successfully");
            update();
          }
        });
      },
    );
  }

  void onRename(Item item) {
    renameLoading(true);
    update();
    _chatRepository.renameConversation(item.conversationId, renameController.text).then((value) {
      renameLoading(false);
      Get.back();
      if (value['success']) {
        FirebaseAnalyticService.instance.logEvent('Confirm_Rename');
        item.conversation = renameController.text;
        if(currentChatList.isNotEmpty)conversationName = (renameController.text);
        ErrorHandle.success('Chat renamed successfully');
      } else {
        ErrorHandle.error('Something went wrong, Please try after some time');
      }
      renameController.clear();
      update();
    }, onError: (e) {
      queryLoading(false);
      update();
    });
  }

  void handleDeepLink() async {
    shareChatList.clear();
    shareChatName("");
    if(!AppStorage.isLoggedIn()) return;
    if (FirebaseDynamicLinkService.link.receivedConversationShareId.isNotEmpty) {
      final id = FirebaseDynamicLinkService.link.receivedConversationShareId;
      Future.delayed(const Duration(milliseconds: 1000), () async {
        Loader.show();
        _shareChatRepository.conversationDetails(id).then((value) {
          Loader.hide();
          if (value['success']) {
            final map = value['data']['conversation']['chats'];
            shareChatSourceId(value["data"]['userId']);
            final list = List<Chat>.from(map.map((c) => Chat.fromJson(c)));
            shareChatList.clear();
            shareChatList.addAll(list);
            var name = value['data']['conversation']['conversation']??"";
            shareChatName(name.toString().isEmpty?shareChatList.first.query:name);
            Get.to(() => const ChatReadOnlyScreen(), fullscreenDialog: true,transition: Transition.downToUp)?.then((value) {
              if (value != null && value == 'continue') {
                shareChatList.clear();
                Loader.show();
                _shareChatRepository.shareConversationCopy(id,shareChatSourceId.value).then((value){
                  Loader.hide();
                  if(value['success']){
                    conversationId(value['data']['conversation']);
                    Future.delayed(const Duration(milliseconds: 300),chats);
                  }else{
                    Get.back();
                    final model = ErrorModel.fromJson(value['error']);
                    ErrorHandle.error(model.toString());
                  }
                },onError: (e){
                  Loader.hide();
                  ErrorHandle.error(e);
                });
              }
            });
            // scrollToBottom();
          }else{
            final error = ErrorModel.fromJson(value['error']);
            ErrorHandle.error(error.toString());
          }
        },onError: (e){
          Loader.hide();
        });
        FirebaseDynamicLinkService.link.receivedConversationShareId = "";
      });
    }
  }

  void archiveChat(conversationId){
    ErrorHandle.success("Chat archived successfully");

    if(conversationId == this.conversationId.value){
      onNewChat();
    }

    _chatRepository.archive(conversationId).then((value){
    },onError: (e){
      ErrorHandle.error(e);
    });
  }

  void pinChat(conversationId,pinned){
    _chatRepository.pin(conversationId,!pinned).then((value){
      FirebaseAnalyticService.instance.logEvent('Click_Chat_${!pinned?"Pin":"Unpin"}');
      history();
    },onError: (e){
      ErrorHandle.error(e);
    });
  }

  void deleteChat(Chat chat){
    deleteChatId(chat.chatId);
    if(chat.answers.length>1){
      _chatRepository.deleteAnswer(conversationId.value, chat.chatId, chat.answers.last.answerId);
      currentChatList.last.answers.removeLast();
      currentChatList.last.currentIndex(currentChatList.last.answers.length-1);
    }else{
      _chatRepository.deleteChat(conversationId.value, chat.chatId);
      currentChatList.removeLast();
    }
    timer?.cancel();
    if(currentChatList.isNotEmpty) {
      currentChatList.last.followup.clear();
      scrollToBottom();
    } else {
      onNewChat();
    }
  }

  void deleteAll(){
    _chatRepository.deleteAll();
    currentChatList.clear();
    recentChatList.clear();
    ErrorHandle.success("All chat deleted successfully");
    onNewChat();
  }


  var hasData = false.obs;
  Timer? timer;
  void toBottom(){

    timer?.cancel();

    timer = Timer.periodic(const Duration(milliseconds: 250), (timer) {

      if(currentChatList.isEmpty){
        hasData(false);
        timer.cancel();
      }

      if(currentChatList.last.answers.isNotEmpty && !showStopButton.value){
        hasData(false);
        timer.cancel();
      }

      hasData(chatScrollController.position.pixels<chatScrollController.position.maxScrollExtent);

    });
  }

  void toBottomTap(){
    timer?.cancel();

    if (currentChatList.isNotEmpty && currentChatList.last.answers.isNotEmpty) {
      currentChatList.last.answers.last.isAnimationCompleted = true;
    }

    hasData(false);

    scrollToBottom();
  }

  ///---------------------------STREAM FEATURE---------------------------
  ///Created & updated by @Deepak Gupta on 13 Feb 2024
  ///Do not delete any code here.
  StreamController<String> _streamController = StreamController();
  var showStopButton = false.obs;

  void onStreamQuery(q) async {

    if(isRegenerating.value) return;

    final connected = await AppRepository().isNetworkAvailable();

    if(!connected){
      ErrorHandle.error(AppDataProvider.connectionError);
      return;
    }

    if(currentChatList.isNotEmpty){
      currentChatList.last.followup.clear();
    }

    final uuid = AppUtil.uniqueId();
    final chat = Chat.Ask(q.trim(), uuid);
    currentChatList.add(chat);
    // TextToSpeechService.instance.stop();
    deleteChatId("");
    queryLoading(true);
    scrollToBottom();

    Map<String,dynamic> body  = {
      "data": {
        "conversationId":conversationId.value,
        "query": q,
        "style": AppStorage.getConversationStyle().name.capitalizeFirst,
        "platform": Platform.isAndroid ? "ANDROID" : "IOS"
      }
    };
    _streamController = StreamController();
    int count = 0;
    ApiClient.client.stream('stream/query',request: body,serverType: ServerType.askQx,stream: _streamController);
    _streamController.stream.listen((event){
      log("Query Data:$event");
      if(count==0){
        Map map = jsonDecode(event);
        conversationId(map['conversationId']);
        chatId(map['chats'][0]['chatId']);
        var ansId = (map['chats'][0]['answers'][0]['answerId']);
        currentChatList.last.chatId = chatId.value;
        final ans = Answer.fromStream("", ansId);
        currentChatList.last.answers.add(ans);
      }else if (!["[DONE]","[START]"].contains(event)){
        currentChatList.last.answers.last.isAnimationCompleted = true;
        currentChatList.last.answers.last.isTyping = true;
        currentChatList.last.isLoading = false;
        showStopButton(true);
        currentChatList.last.answers.last.obxAnswer.value += event;
        count == 2  ? scrollToBottom() : toBottom();
      }else if (event == '[DONE]'){
        showStopButton(false);
      }
      count++;
      // scrollToBottom();
      // update();
    },
      onDone: _onDone,
      onError: _onError,
    );
  }

  void onStreamRegenerate() async {
    if(isRegenerating.value) return;

    final connected = await AppRepository().isNetworkAvailable();

    if(!connected){
      ErrorHandle.error(AppDataProvider.connectionError);
      return;
    }

    // TextToSpeechService.instance.stop();
    isRegenerating(true);
    currentChatList.last.followup.clear();
    update();

    FirebaseAnalyticService.instance.logEvent("Click_Regenerate_Chat");
    Map<String,dynamic> body  = {
      "data": {
        "conversationId":conversationId.value,
        "style": AppStorage.getConversationStyle().name.capitalizeFirst,
      }
    };
    _streamController = StreamController();
    int count = 0;
    ApiClient.client.stream('stream/regenerate',request: body,serverType: ServerType.askQx,stream: _streamController);
    _streamController.stream.listen((event) {
      log("Regenerate Data:$event");
      if(count==0){
        Map map = jsonDecode(event);
        conversationId(map['conversationId']);
        chatId(map['chats'][0]['chatId']);
        var ansId = (map['chats'][0]['answers'][0]['answerId']);
        currentChatList.last.chatId = chatId.value;
        final ans = Answer.fromStream("", ansId);
        currentChatList.last.answers.add(ans);
        update();
      }else if (!["[DONE]","[START]"].contains(event)){
        currentChatList.last.answers.last.isAnimationCompleted = true;
        currentChatList.last.answers.last.isTyping = true;
        currentChatList.last.isLoading = false;
        showStopButton(true);
        isRegenerating(false);
        final lastIndex = currentChatList.last.answers.length-1;
        currentChatList.last.currentIndex(lastIndex);
        currentChatList.last.currentChatStyle = (currentChatList.last.answers[lastIndex].style);
        currentChatList.last.answers.last.obxAnswer.value += event;
       count == 2 ? scrollToBottom() : toBottom();
      }else if (event == '[DONE]'){
        showStopButton(false);
      }

      count++;
      // scrollToBottom();
      // update();
    },onError: _onError,
      onDone: _onDone
    );
  }

  void followupQuestions(){
    try {
      _chatRepository.followup(conversationId.value, chatId.value).then((value) {
        if (value['success']) {
          final follow = List<String>.from(value['data']['questions'].map((q) => q));
          if(currentChatList.isNotEmpty && deleteChatId.value.isEmpty){
            currentChatList.last.followup.clear();
            currentChatList.last.followup.addAll(follow);
          }
        }
        scrollToBottom();
      });
    }  catch (_) { }
  }

  void _onError(s1,s2){
    queryLoading(false);
    isRegenerating(false);
    currentChatList.last.isLoading = false;
    if(currentChatList.last.answers.isNotEmpty){
      currentChatList.last.answers.last.isTyping = false;
    }
    currentChatList.last.errorMessage = "Something went wrong";
    showStopButton(false);
    update();
  }

  void _onDone(){
    queryLoading(false);
    isRegenerating(false);

    if(currentChatList.isNotEmpty && currentChatList.last.answers.isNotEmpty){
      currentChatList.last.isLoading = false;
      currentChatList.last.answers.last.isTyping = false;
      showStopButton(false);
      followupQuestions();
    }

    // update();
  }

  void stopStream(){
    ApiClient.client.stopStream();
    _streamController.close();
    queryLoading(false);
    isRegenerating(false);
    showStopButton(false);
    if(currentChatList.isNotEmpty && currentChatList.last.answers.isNotEmpty  && currentChatList.last.answers.last.answerId.isNotEmpty) {
      Map<String,dynamic> request = {
      "message":currentChatList.last.answers.last.obxAnswer.value,
      "chatId":currentChatList.last.chatId,
      "conversationId":conversationId.value,
      "answerId":currentChatList.last.answers.last.answerId
    };
      _chatRepository.stop(request);
    }
    update();
  }

  checkFirstPrompt(){
    _profileRepository.userFirstpromptDetails().then((value) {
      isFirstPrompt = value;
    }
    );
    return isFirstPrompt ;
  }

}
