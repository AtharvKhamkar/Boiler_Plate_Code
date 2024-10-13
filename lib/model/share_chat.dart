
import 'package:get/get.dart';

class ShareChat {
  final String userId;
  final ShareConversation shareConversation;
  final String shareConversationId;
  final DateTime createdAt;

  ShareChat({
    required this.userId,
    required this.shareConversation,
    required this.shareConversationId,
    required this.createdAt,
  });

  factory ShareChat.fromJson(Map<String, dynamic> json) => ShareChat(
    userId: json["userId"],
    shareConversation: ShareConversation.fromJson(json["conversation"]),
    shareConversationId: json["shareConversationId"],
    createdAt: DateTime.parse(json["createdAt"]),
  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "conversation": shareConversation.toJson(),
    "shareConversationId": shareConversationId,
    "createdAt": createdAt.toIso8601String(),
  };
}

class ShareConversation {
  final String conversation;
  final String conversationId;
  final dynamic chat;

  ShareConversation({
    required this.conversation,
    required this.conversationId,
    this.chat,
  });

  factory ShareConversation.fromJson(Map<String, dynamic> json) => ShareConversation(
    conversation: json["conversation"].toString().isEmpty?json['chats'][0]['query']:json["conversation"],
    conversationId: json["conversationId"],
    chat: json['chats'],
  );

  Map<String, dynamic> toJson() => {
    "conversation": conversation,
    "conversationId": conversationId,
  };

  String get title {
    return '${conversation.capitalizeFirst}';
  }

}

