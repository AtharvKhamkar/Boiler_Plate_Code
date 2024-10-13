import 'package:ask_qx/model/conversation.dart';
import 'package:ask_qx/network/error_handler.dart';
import 'package:ask_qx/repository/chat_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ArchiveChatController extends GetxController with StateMixin<dynamic>{

  final _chatRepository = ChatRepository();

  var isLoading = true.obs;

  var archivedList = <Item>[].obs;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getArchive();
  }


  void getArchive(){
    ChatRepository().getArchive().then((value){
      isLoading(false);
      if(value['success']){
        final list  = List<Item>.from(value['data']['conversations'].map((a)=>Item.fromJson(a)));
        archivedList(list);
      }
      update();
    },onError: (e){
      isLoading(false);
      ErrorHandle.error(e);
      update();
    });
  }

  void unarchive(conversationId){
    ErrorHandle.success("Unarchived successfully");
    archivedList.removeWhere((element) => element.conversationId == conversationId);
    _chatRepository.archive(conversationId,false);
    update();
  }

  void deleteConversation(conversationId){
    ErrorHandle.qxLabConfirmationDialogue(
      message: "If you delete your conversation, you will not be able to read it later. Are you sure you want to delete the conversation?",
      title: "Warning",
      dialogueType: DialogueType.warning,
      cancelText: "No",
      confirmText: "Yes",
      actionColor: Colors.redAccent,
      onConfirm: () {
        ErrorHandle.success("Deleted successfully");
        archivedList.removeWhere((element) => element.conversationId == conversationId);
        _chatRepository.delete(conversationId);
        update();
      },
    );
  }

}