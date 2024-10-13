import 'package:ask_qx/model/share_chat.dart';
import 'package:ask_qx/network/loader.dart';
import 'package:ask_qx/repository/share_repository.dart';
import 'package:get/get.dart';

import '../model/error_model.dart';
import '../network/error_handler.dart';

class ShareChatLinkController extends GetxController with StateMixin<dynamic> {
  //Classes
  final _shareChatRepository = ShareChatRepository();

  //variables
  var isLoading = true.obs;
  var shareChatList = <ShareChat>[].obs;

  @override
  void onReady() {
    super.onReady();
    sharedChatLinks();
  }

  void sharedChatLinks() {
    _shareChatRepository.shareConversationLinks().then((value) {
      isLoading(false);
      if (value['success']) {
        final model = List<ShareChat>.from(value['data']['response'].map<ShareChat>((m) => ShareChat.fromJson(m)));
        shareChatList.addAll(model);
      }
      update();
    }, onError: (e) {
      isLoading(false);
      ErrorHandle.error(e);
      update();
    });
  }

  void deleteAllSharedLink() {
    Loader.show();
    _shareChatRepository.deleteAllConversations().then((value) {
      Loader.hide();
      if (value['success']) {
        ErrorHandle.success('All shared link deleted successfully');
        shareChatList.clear();
      } else {
        final model = ErrorModel.fromJson(value['error']);
        ErrorHandle.error("${model.toString()} Try Again");
      }
      update();
    }, onError: (e) {
      Loader.hide();
      ErrorHandle.error(e);
    });
  }

  void deleteSharedLink(ShareChat item) {
    Loader.show();
    _shareChatRepository.deleteConversations(item.shareConversation.conversationId, item.shareConversationId).then((value) {
      Loader.hide();
      if (value['success']) {
        ErrorHandle.success('Link deleted successfully');
        shareChatList.remove(item);
      } else {
        final model = ErrorModel.fromJson(value['error']);
        ErrorHandle.error("${model.toString()} Try Again");
      }
      update();
    }, onError: (e) {
      Loader.hide();
      ErrorHandle.error(e);
    });
  }
}
