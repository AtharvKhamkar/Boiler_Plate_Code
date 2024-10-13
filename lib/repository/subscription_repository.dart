
import 'package:ask_qx/model/subscription_model.dart';

import '../network/api_client.dart';

class SubscriptionRepository{
  SubscriptionRepository();

  //this function return the subscription plans details
  Future<dynamic> getSubscriptionPlans()async {
    try {
      final response = await ApiClient.client.getRequest("subscription/plans",serverType: ServerType.subscription);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  //this function return the user's subscription queue
  Future<dynamic> checkSubscription()async {
    try {
      final response = await ApiClient.client.getRequest("user/subscription-queue",serverType: ServerType.subscription);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }

  //this function post the user's subscription queue
  Future<dynamic> subscribe(SubscriptionPlan plan)async {
    try {
      Map<String,dynamic> body = {
        "data": {
          "planId": plan.planId,
          "planValidity": plan.planValidity,
          "planType": plan.planType,
        }
      };
      final response = await ApiClient.client.postRequest("user/subscription-queue",request: body,serverType: ServerType.subscription);
      return response;
    } catch (e) {
      return Future.error(e);
    }
  }



}