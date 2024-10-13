import 'package:ask_qx/controller/archive_chat_controller.dart';
import 'package:get/get.dart';

class ArchiveChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArchiveChatController>(() => ArchiveChatController());
  }
}