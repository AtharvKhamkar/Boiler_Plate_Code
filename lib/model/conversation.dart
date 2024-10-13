
class Conversation {
  String duration;
  List<Item> item = const [];

  Conversation({
    required this.duration,
    required this.item,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) => Conversation(
    duration: json["duration"],
    item: List<Item>.from(json["conversations"].map((x) => Item.fromJson(x))),
  );

  factory Conversation.fromPin({
    Item? item,
  }){
    List<Item> temp = [];
    if(item!=null)temp.add(item);
    return Conversation(
      duration: "Pinned",
      item: temp,
  );}

  Map<String, dynamic> toJson() => {
    "duration": duration,
    "conversations": List<dynamic>.from(item.map((x) => x.toJson())),
  };

  bool get isPinned {
    return duration.toLowerCase() == "pinned";
  }
}

class Item {
  String conversationId;
  String conversation;
  DateTime createdAt;
  String style;

  Item({
    required this.conversationId,
    required this.conversation,
    required this.createdAt,
    required this.style,
  });

  factory Item.fromJson(Map<String, dynamic> json) => Item(
    conversationId: json["conversationId"],
    conversation: json["conversation"],
    createdAt: DateTime.parse(json["createdAt"]),
    style: json["style"],
  );

  Map<String, dynamic> toJson() => {
    "conversationId": conversationId,
    "conversation": conversation,
    "createdAt": createdAt.toIso8601String(),
    "style": style,
  };
}