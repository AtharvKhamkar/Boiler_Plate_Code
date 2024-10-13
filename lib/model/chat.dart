import 'package:ask_qx/global/app_storage.dart';
import 'package:get/get.dart';

enum MessageType{string,code}

class Chat {
  String query;
  String style;
  List<Answer> answers = [];
  DateTime updatedAt;
  DateTime createdAt;
  String chatId;
  String _currentChatStyle='';
  bool isLoading = false;
  String uuid = "";
  String errorMessage = "";
  // ScrollController scrollController = ScrollController();
  var currentIndex = 0.obs;
  List<String> followup = [];

  Chat({
    required this.query,
    required this.style,
    required this.answers,
    required this.updatedAt,
    required this.createdAt,
    required this.chatId,
    this.isLoading = false,
    this.uuid = '',
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
    query: json["query"],
    style: json["style"],
    answers: List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x))),
    updatedAt: DateTime.parse(json["updatedAt"]),
    createdAt: DateTime.parse(json["createdAt"]),
    chatId: json["chatId"],
    isLoading: false,
    uuid: "",
  );

  factory Chat.fromRecentJson(Map<String, dynamic> json) => Chat(
    query: json["query"],
    style: json["style"],
    answers: List<Answer>.from(json["answers"].map((x) => Answer.fromJson(x,true))),
    updatedAt: DateTime.parse(json["updatedAt"]),
    createdAt: DateTime.parse(json["createdAt"]),
    chatId: json["chatId"],
    isLoading: false,
    uuid: "",
  );

  factory Chat.Ask(String q,String uuid) => Chat(
      query: q,
      style: AppStorage.getConversationStyle().name.capitalizeFirst??"",
      answers: [],
      updatedAt: DateTime.now(),
      createdAt: DateTime.now(),
      chatId: "",
      isLoading: true,
      uuid : uuid,
  );

  Map<String, dynamic> toJson() => {
    "query": query,
    "style": style,
    "answers": List<dynamic>.from(answers.map((x) => x.toJson())),
    "updatedAt": updatedAt.toIso8601String(),
    "createdAt": createdAt.toIso8601String(),
    "chatId": chatId,
  };

  set currentChatStyle(String style){
    _currentChatStyle = style;
  }

  String get currentChatStyle {
    if(_currentChatStyle.isEmpty && answers.isEmpty){
      return AppStorage.getConversationStyle().name;
    }if(_currentChatStyle.isEmpty && answers.isNotEmpty){
      return answers.first.style;
    }else if (_currentChatStyle.isEmpty){
      return AppStorage.getConversationStyle().name;
    }
    return _currentChatStyle;
  }

  String get data {
    try{
      String d = '';
      final model = answers[currentIndex.value];
      d = model.answer.isEmpty?model.obxAnswer.value:model.answer;
      return d.trim();
    }catch(_){
      return '';
    }
    // String d = '';
    // for (var element in answers) {
    //   d+=element.answer;
      // for (var e in element.messages) {
      //   d+=e.message;
      // }
    // }
    // return d;
  }
}

class Answer {
  Reaction reaction;
  String answer;
  String style;
  dynamic feedback;
  DateTime createdAt;
  DateTime updatedAt;
  String answerId;
  List<Message> messages = [];
  bool isAnimationCompleted = false;
  bool isTyping = false;

  Answer({
    required this.reaction,
    required this.answer,
    required this.style,
    required this.feedback,
    required this.createdAt,
    required this.updatedAt,
    required this.answerId,
    this.isAnimationCompleted = false,
  });

  factory Answer.fromJson(Map<String, dynamic> json,[bool isComplete = false]) {
    return Answer(
    reaction: Reaction.fromJson(json["reaction"]),
    answer: json["answer"],
    style: json["style"],
    feedback: json["feedback"],
    createdAt: DateTime.parse(json["createdAt"]),
    updatedAt: DateTime.parse(json["updatedAt"]),
    answerId: json["answerId"],
    isAnimationCompleted: isComplete,
  );
  }

  factory Answer.fromStream(String ans,String id) => Answer(
    reaction: Reaction.def(),
    answer: ans,
    style: AppStorage.getConversationStyle().name.capitalizeFirst??"",
    feedback: null,
    createdAt: DateTime.now(),
    updatedAt: DateTime.now(),
    answerId: id,
    isAnimationCompleted: false,
  );

  Map<String, dynamic> toJson() => {
    "reaction": reaction.toJson(),
    "answer": answer,
    "style": style,
    "feedback": feedback,
    "createdAt": createdAt.toIso8601String(),
    "updatedAt": updatedAt.toIso8601String(),
    "answerId": answerId,
  };

  // List<Message> formattedMessage(){
  //   messages.clear();
    // if (answer.contains("```")) {
    //   final list = answer.split("```");
    //   if (answer.startsWith("```")){
    //     for(int i = 0; i< list.length ; i++){
    //       messages.add(Message(list[i],i%2!=0?MessageType.string:MessageType.code));
    //     }
    //   }else{
    //     for(int i = 0; i< list.length ; i++){
    //       messages.add(Message(list[i],i%2==0?MessageType.string:MessageType.code));
    //     }
    //   }
    // } else {
    //   messages.add(Message(answer, MessageType.string));
    // }

  //   return messages;
  // }

  String get readAbleStyle {
    switch(style.toLowerCase()){
      case "precise":
        return "Professional";
      case "balanced":
        return "Standard";
      case "creative":
        return "Creative";
      default:
        return "";
    }
  }

  var obxAnswer = ''.obs;

}

class Reaction {
  dynamic isLiked;
  dynamic message;

  Reaction({
    required this.isLiked,
    required this.message,
  });

  factory Reaction.fromJson(Map<String, dynamic> json) => Reaction(
    isLiked: json["isLiked"],
    message: json["message"],
  );

  factory Reaction.def() => Reaction(
    isLiked: null,
    message: null,
  );

  Map<String, dynamic> toJson() => {
    "isLiked": isLiked,
    "message": message,
  };

  void like(){
    isLiked ??= true;
  }

  void dislike(){
    isLiked ??= false;
  }
}

class Message{
  String message;
  MessageType messageType = MessageType.string;

  Message(this.message, this.messageType);
}