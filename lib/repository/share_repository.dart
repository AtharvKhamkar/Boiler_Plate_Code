


import '../network/api_client.dart';

class ShareChatRepository{

  ShareChatRepository();

  //this function return the share conversation details
  Future<dynamic> shareConversation(conversationId)async {
    try {
      final response = await ApiClient.client.getRequest("share/conversation/$conversationId",serverType: ServerType.askQx);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }
  //this function post the share conversation copy
  Future<dynamic> shareConversationCopy(shareConversationId,sourceUserId)async {
    try {
      Map<String, dynamic> body = {
        "data": {
          "userId":sourceUserId,
          "shareConversationId": shareConversationId,
        }
      };
      final response = await ApiClient.client.postRequest("share/conversation/copy",request: body,serverType: ServerType.askQx);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  //this function gives the conversation details about this is shared before or not
  Future<dynamic> getShareConversationId(conversationId)async {
    try {
      final response = await ApiClient.client.getRequest("share/conversations/$conversationId",serverType: ServerType.askQx);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  //this function gives the conversation details
  Future<dynamic> conversationDetails(shareConversationId)async {
    try {
      final response = await ApiClient.client.getRequest("share/conversation-details/$shareConversationId",serverType: ServerType.askQx,excludeHeader: ["x-user-id"]);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }


  //this function deletes the conversation copied link
  Future<dynamic> deleteConversations(conversationId,shareConversationId)async {
    try {
      final response = await ApiClient.client.deleteRequest("share/conversations/$conversationId/$shareConversationId",serverType: ServerType.askQx);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  //this function deletes all the conversation copied link
  Future<dynamic> deleteAllConversations()async {
    try {
      final response = await ApiClient.client.deleteRequest("share/conversations",serverType: ServerType.askQx);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }


  //this function post the share conversation copy button
  Future<dynamic> postShareConversation(conversationId)async {
    try {
      Map<String, dynamic> body = {};
      final response = await ApiClient.client.postRequest("share/conversations/$conversationId",request: body,serverType: ServerType.askQx);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }


  //this function patch the share conversation copy on update and copy button
  Future<dynamic> patchShareConversation(conversationId,shareConversationId)async {
    try {
      Map<String, dynamic> body = {};
      final response = await ApiClient.client.patchRequest("share/conversations/$conversationId/$shareConversationId",request: body,serverType: ServerType.askQx);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }


  //this function gives the shared conversation links details
  Future<dynamic> shareConversationLinks()async {
    try {
      final response = await ApiClient.client.getRequest("share/conversations",serverType: ServerType.askQx);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }


}