import 'dart:io';

import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/network/api_client.dart';
import 'package:get/get.dart';

class ChatRepository{


  ChatRepository();

  //This function will return the chat suggestions which are coming for new chat
  Future<dynamic> suggestions() async {
    try{
      final response = await  ApiClient.client.getRequest("app/suggestions/details");
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  //This function will return the chat history
  Future<dynamic> history() async {
    try{
      final response = await  ApiClient.client.getRequest("conversations",serverType: ServerType.askQx);
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  //This function will return the chat/conversations
  Future<dynamic> getChats(dynamic id) async {
    try{
      final response = await  ApiClient.client.getRequest("conversations/$id",serverType: ServerType.askQx);
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  //This function will post the query
  Future<dynamic> query(String q,dynamic cId) async {
    try{
      Map<String,dynamic> body  = {
        "data": {
          "conversationId": "$cId",
          "query": q,
          "style": AppStorage.getConversationStyle().name.capitalizeFirst,
          "platform": Platform.isAndroid ? "ANDROID" : "IOS"
        }
      };
      final response = await  ApiClient.client.postRequest("query",request: body,serverType: ServerType.askQx);
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  //This function will post the query for regenerate the chat
  Future<dynamic> regenerate(dynamic cId) async {
    try{
      Map<String,dynamic> body  = {
        "data": {
          "conversationId": "$cId",
          "style": AppStorage.getConversationStyle().name.capitalizeFirst,
        }
      };
      final response = await  ApiClient.client.postRequest("regenerate",request: body,serverType: ServerType.askQx);
      return response;
    }catch(e){
      return Future.error(e);
    }
  }


  //This function will return the chat followup which are coming for every chat
  Future<dynamic> followup(dynamic conversationId,dynamic chatId) async {
    try{
      final response = await  ApiClient.client.getRequest("folloup/questions/$conversationId/$chatId",serverType: ServerType.askQx);
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  //This function will rename the chat conversation name
  Future<dynamic> renameConversation(dynamic conversationId,dynamic conversation ) async {
    try{
      Map<String,dynamic> body  = {
        "data": {
          "conversation": "$conversation"
        }
      };
      final response = await  ApiClient.client.patchRequest("conversations/$conversationId",request: body,serverType: ServerType.askQx);
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  //This function will delete chat/conversations for particular conversationId
  Future<dynamic> delete(dynamic conversationId) async {
    try{
      final response = await  ApiClient.client.deleteRequest("conversations/$conversationId",serverType: ServerType.askQx);
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  //This function will post the chat reaction
  Future<dynamic> reaction(dynamic body,dynamic conversationId) async {
    try{
      final response = await  ApiClient.client.postRequest("conversations/chat-reaction/$conversationId",request: body,serverType: ServerType.askQx);
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  //This function will post the chat feedback
  Future<dynamic> chatFeedback(dynamic body,dynamic conversationId) async {
    try{
      final response = await  ApiClient.client.postRequest("conversations/chat-feedback/$conversationId",request: body,serverType: ServerType.askQx);
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  //This function post the archive chat
  Future<dynamic> archive(dynamic conversationId,[bool isArchive = true]) async {
    try{
      Map<String,dynamic> body = {
        "data": {
          "isArchived": isArchive
        }
      };
      final response = await  ApiClient.client.putRequest("conversations/$conversationId",request: body,serverType: ServerType.askQx);
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  //This function will return all the archived chats
  Future<dynamic> getArchive() async {
    try{
      final response = await  ApiClient.client.getRequest("conversations/archived/details",serverType: ServerType.askQx);
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  //This function will post the chat which is pinned
  Future<dynamic> pin(dynamic conversationId,[bool isPinned = true]) async {
    try{
      Map<String,dynamic> body = {
        "data": {
          "isPinned": isPinned
        }
      };
      final response = await  ApiClient.client.postRequest("conversations/$conversationId",request: body,serverType: ServerType.askQx);
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  //delete chat the particular chat
  Future<dynamic> deleteChat(conversationId,chatId) async{
    try{

      final response = await ApiClient.client.deleteRequest("conversations/chat/$conversationId/$chatId",serverType: ServerType.askQx);
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  //delete chat the particular chat
  Future<dynamic> deleteAll() async{
    try{

      final response = await ApiClient.client.deleteRequest("conversations",serverType: ServerType.askQx);
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  //delete the particular answer
  Future<dynamic> deleteAnswer(conversationId,chatId,answerId) async{
    try{

      final response = await ApiClient.client.deleteRequest("conversations/chat-answer/$conversationId/$chatId/$answerId",serverType: ServerType.askQx);
      return response;
    }catch(e){
      return Future.error(e);
    }
  }

  ///This function will update the response in server
  ///Suppose use press the stop button in between the received data
  ///We have to update the response on server
  Future<dynamic> stop(Map<String,dynamic> b) async {
    var url  = 'conversations/chat-answer/${b['conversationId']}/${b['chatId']}/${b['answerId']}';
    try{
      Map<String,dynamic> body = {
        "data": {
          "answer": b['message']
        }
      };
      final response = await ApiClient.client.patchRequest(url,serverType: ServerType.askQx,request: body);
      return response;
    }catch(e){
      return Future.error(e);
    }
  }



}