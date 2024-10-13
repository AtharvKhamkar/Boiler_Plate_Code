
import 'package:ask_qx/global/app_storage.dart';

class SubscriptionPlan {
  String appId;
  String title;
  List<String> description = [];
  int amount;
  String planValidity;
  String planType;
  String planId;
  bool isSelected;
  String requestStatus;
  SubscriptionPlan({
    required this.appId,
    required this.title,
    required this.description,
    required this.amount,
    required this.planValidity,
    required this.planType,
    required this.planId,
    this.isSelected=false,
    this.requestStatus='pending'
  });

  factory SubscriptionPlan.fromJson(Map<String, dynamic> json) => SubscriptionPlan(
    appId: json["appId"],
    title: json["title"],
    description: List<String>.from(json["description"].map((x) => x)),
    amount: json["amount"],
    planValidity: json["planValidity"],
    planType: json["planType"],
    planId: json["planId"],
    isSelected: false,
  );

  Map<String, dynamic> toJson() => {
    "appId": appId,
    "title": title,
    "description": List<dynamic>.from(description.map((x) => x)),
    "amount": amount,
    "planValidity": planValidity,
    "planType": planType,
    "planId": planId,
  };
}


class Subscription {
  String planId;
  String planValidity;
  String planType;
  String status;
  String subscriptionQueueId;

  Subscription({
    required this.planId,
    required this.planValidity,
    required this.planType,
    required this.status,
    required this.subscriptionQueueId,
  });

  factory Subscription.fromJson(Map<String, dynamic> json) => Subscription(
    planId: json["planId"],
    planValidity: json["planValidity"],
    planType: json["planType"],
    status: json["status"],
    subscriptionQueueId: json["subscriptionQueueId"],
  );

  Map<String, dynamic> toJson() => {
    "planId": planId,
    "planValidity": planValidity,
    "planType": planType,
    "status": status,
    "subscriptionQueueId": subscriptionQueueId,
  };
}

class SubscriptionMessage {
  String requestPlan;
  String inQueue;

  SubscriptionMessage({
    required this.requestPlan,
    required this.inQueue,
  });

  factory SubscriptionMessage.fromJson(Map<String, dynamic> json) => SubscriptionMessage(
    requestPlan: json["request_plan"]??"",
    inQueue: json["in_queue"]??"",
  );

  factory SubscriptionMessage.def() => SubscriptionMessage(
    requestPlan: "Message",
    inQueue: "Message",
  );

  String get requestPlanWithEmailMessage {
    return requestPlan.replaceAll("\$EMAIL", AppStorage.getUserDetails().emailId);
  }
  String get inQueueWithEmailMessage {
    return inQueue.replaceAll("\$EMAIL", AppStorage.getUserDetails().emailId);
  }
}