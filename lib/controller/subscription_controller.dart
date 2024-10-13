import 'dart:convert';

import 'package:ask_qx/firebase/firebase_analytic_service.dart';
import 'package:ask_qx/firebase/remote_config_service.dart';
import 'package:ask_qx/global/app_storage.dart';
import 'package:ask_qx/model/user_detail.dart';
import 'package:ask_qx/network/error_handler.dart';
import 'package:ask_qx/repository/subscription_repository.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../model/error_model.dart';
import '../model/subscription_model.dart';

class SubscriptionController extends GetxController with StateMixin<dynamic> {
  //Classes
  final SubscriptionRepository _subscriptionRepo = SubscriptionRepository();

  //Variables
  var isLoading = true.obs;
  var isRequestPlanLoading = false.obs;
  UserDetail userDetail = AppStorage.getUserDetails();
  List<SubscriptionPlan> subscriptionList = const [];
  List<String> description = [];

  Subscription? hasSubscription;
  SubscriptionPlan? subscriptionPlan;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    subscription();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  //methods

  void selectPlan(SubscriptionPlan plan) {
    HapticFeedback.lightImpact();
    for (var element in subscriptionList) {
      if (element.planId == plan.planId) {
        element.isSelected = true;
      } else {
        element.isSelected = false;
      }
    }
    description = plan.description;
    update();
  }

  void subscription() {

    if(AppStorage.subscriptionSyncDate() != null && AppStorage.subscriptionSyncDate()!.day == DateTime.now().day ){
      final data = AppStorage.subscriptionData();
      if(data.isNotEmpty){
        Map<String,dynamic> js = jsonDecode(data);
        hasSubscription = Subscription.fromJson(js['subscriptionQueueDetails']);
        subscriptionPlan = SubscriptionPlan.fromJson(js['plans']);
        isLoading(false);
        update();
      }
     return;
    }

    _subscriptionRepo.checkSubscription().then((value){
      if(value['success']){
        hasSubscription = Subscription.fromJson(value['data']['subscriptionQueueDetails']);
      }
      planes();
    },onError: (e){
      planes();
    });


  }

  void planes(){
    _subscriptionRepo.getSubscriptionPlans().then((value) {
      isLoading(false);
      update();
      if (value['success']) {
        subscriptionList = List<SubscriptionPlan>.from(value['data']['plans'].map((s) => SubscriptionPlan.fromJson(s)));

        if(hasSubscription!=null){
          AppStorage.setSubscriptionSyncDate();
          subscriptionPlan = subscriptionList.firstWhere((element) => element.planId == hasSubscription!.planId);
          cacheData(hasSubscription?.toJson(), subscriptionPlan?.toJson());
        }else{
          subscriptionList.first.isSelected = true;
          description = subscriptionList.first.description;
        }

        update();
      } else {
        final model = ErrorModel.fromJson(value['error']);
        ErrorHandle.error(model.toString());
      }
    },onError: (e){
      isLoading(false);
      update();
    });
  }

  void cacheData(dynamic data,dynamic plan){
    Map<String,dynamic> js = {
      'subscriptionQueueDetails':data,
      'plans':plan,
    };
    AppStorage.setSubscriptionData(jsonEncode(js));
  }

  void request(){
    final plan = subscriptionList.firstWhere((element) => element.isSelected);
    isRequestPlanLoading(true);
    update();
    _subscriptionRepo.subscribe(plan).then((value){

      _subscriptionRepo.checkSubscription().then((value){
        isRequestPlanLoading(false);
        if(value['success']){
          hasSubscription = Subscription.fromJson(value['data']['subscriptionQueueDetails']);
          subscriptionPlan = plan;
        }
        update();
      },onError: (e){
        isRequestPlanLoading(false);
        update();
      });


    },onError: (e){
      isRequestPlanLoading(false);
      update();
    });
  }



  ///Dialogue Boxes
  ///
  void requestPlan() {
    ErrorHandle.qxLabConfirmationDialogue(
      title: "Request Premium Plan",
      message: "Join the queue to become our premium member. We'll inform you via email as soon as you're approved to become our premium member. In the meantime, enjoy our free services. Thank you.\n\nEmail: ${userDetail.emailId}",
      dialogueType: DialogueType.info,
      onConfirm: () {
        FirebaseAnalyticService.instance.logEvent("Click_Request_Premium_Plan");
        request();
      },
    );
  }

  String message(){
    final model = RemoteConfigService.instance.subscriptionMessage();
    if(hasSubscription!=null){
      return model.inQueueWithEmailMessage;
    }
    return model.requestPlanWithEmailMessage;
  }
}
