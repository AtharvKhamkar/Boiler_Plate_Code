import 'package:get/get.dart';

import '../controller/share_chat_link_controller.dart';

class ShareChatLinkBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ShareChatLinkController>(() => ShareChatLinkController());
  }
}
