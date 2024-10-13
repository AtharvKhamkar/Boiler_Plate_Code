import 'package:animate_do/animate_do.dart';
import 'package:ask_qx/controller/subscription_controller.dart';
import 'package:ask_qx/themes/colors.dart';
import 'package:ask_qx/widgets/chat_ai_custom_header.dart';
import 'package:ask_qx/widgets/qx_branding_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

import '../../utils/utils.dart';
import '../../widgets/custom_form_button.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SubscriptionController>(
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: context.theme.scaffoldBackgroundColor,
            title: const Row(
              children: [
                QxBrandingWidget(scaleFactor: .6 ),
                SizedBox(width: 4,),
                Text(
                  " Plus",
                  style: TextStyle(fontSize: 38 * 0.6, fontWeight:FontWeight.bold),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
            child: Column(
              children: [
                const SizedBox(height: 24),
                ImageAnimateRotate(
                  child: Image.asset(
                    "assets/QX_logo-02.png",
                    height: 130,
                    width: 130,
                    color: primaryColor,
                  ),
                ),
                const SizedBox(height: 15),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Plans",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
                if(controller.isLoading.value)
                 SubscriptionPlaceholder(),
               if(controller.hasSubscription!=null)...[
                 SizedBox(
                   width: 160,
                   height: 160,
                   child: Stack(
                     children: [
                       Container(
                         width: 160,
                         height: 160,
                         padding: const EdgeInsets.all(8.0),
                         decoration: BoxDecoration(
                           borderRadius:BorderRadius.circular(12.0),
                           border: Border.all(color: kThird,width: 2),
                         ),
                         child: Column(
                           mainAxisSize: MainAxisSize.min,
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Flexible(
                               child: Text(
                                 controller.subscriptionPlan!.title,
                                 style: const TextStyle(
                                   fontSize: 18,
                                   fontWeight: FontWeight.bold,
                                 ),
                               ),
                             ),
                             RichText(
                               text: TextSpan(
                                 text: "\$",
                                 style: TextStyle(
                                   fontSize: 20,
                                   color: getSubTitleColor(),
                                 ),
                                 children: [
                                   TextSpan(
                                     text: controller.subscriptionPlan!.amount.toString(),
                                     style: textStyle(size: 50, weight: FontWeight.bold, color: getTextColor()),
                                   ),
                                   TextSpan(
                                     text: " /${controller.subscriptionPlan!.planValidity.capitalizeFirst}",
                                     style: textStyle(
                                       size: 14,
                                       color: getSubTitleColor(),
                                     ),
                                   ),
                                 ],
                               ),
                             ),
                           ],
                         ),
                       ),
                       Align(
                         alignment: Alignment.bottomRight,
                         child: Container(
                            width: 160,
                            height: 40,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.all(2),
                            decoration: const BoxDecoration(
                              color: kSecondary,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                           child: Text("SUBSCRIBED",style: textStyle(color: Colors.white),),
                          ).animate(
                           onPlay: (controller) {
                             controller.repeat();
                           },
                         ).shimmer(
                           duration: const Duration(milliseconds: 2000),
                           color: Colors.amber,
                         ),
                       ),
                      ],
                   ),
                 ),
                 const SizedBox(height: 20),
                 DescriptionWidget(controller.subscriptionPlan!.description),
                 const SizedBox(height: 20),
                 FadeInUp(
                   delay: const Duration(milliseconds: 1000),
                   child: const CustomFormButton(
                     innerText: "In Queue",
                     onPressed: null,
                     isLoading: false,
                   ),
                 ),
                  const SizedBox(height: 20),
               ],
                if(!controller.isLoading.value && controller.hasSubscription==null)...[
                   const SizedBox(height: 10),
                  Container(
                  alignment: Alignment.centerLeft,
                  height: context.height * .2,
                  child: ListView.builder(
                    itemCount: controller.subscriptionList.length,
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemBuilder: (_, index) {
                      final model =controller.subscriptionList[index];
                      return SizedBox(
                        width: context.width > 600 ? context.width * 0.3 : context.width * 0.43,
                        child: GestureDetector(
                          onTap: () => controller.selectPlan(model),
                          child: Card(
                            elevation: 1,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: model.isSelected
                                  ? BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        width: 2,
                                        color: kThird,
                                      ),
                                    )
                                  : BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(height: 2),
                                    Flexible(
                                      child: Text(
                                        model.title,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: "\$",
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: getSubTitleColor(),
                                        ),
                                        children: [
                                          TextSpan(
                                            text: model.amount.toString(),
                                            style: textStyle(size: 50, weight: FontWeight.bold, color: getTextColor()),
                                          ),
                                          TextSpan(
                                            text: " /${model.planValidity.capitalizeFirst}",
                                            style: textStyle(
                                              size: 14,
                                              color: getSubTitleColor(),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (controller.subscriptionList[index].amount.toString() == "0")
                                      Text(
                                        "Current Plan",
                                        style: TextStyle(
                                          color: getSubTitleColor(),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                  const SizedBox(height: 10),
                  if (controller.description.isNotEmpty)
                    DescriptionWidget(controller.description),
                  const SizedBox(height: 20),
                  if (controller.description.isNotEmpty)
                    FadeInUp(
                    delay: const Duration(milliseconds: 1000),
                    child: CustomFormButton(
                      isLoading: controller.isRequestPlanLoading.value,
                      innerText: "Request Plan",
                      onPressed: ()=>controller.requestPlan(),
                    ),
                  ),
                ],
                if(!controller.isLoading.value)
                FadeInUp(
                  key: UniqueKey(),
                  delay: const Duration(milliseconds: 1200),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        color: kPrimaryLight.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    child: Text(
                      controller.message(),
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Get.isDarkMode?Colors.white54:Colors.black54,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class DescriptionWidget extends StatelessWidget{

  final List<String> description;

  const DescriptionWidget(this.description, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width * .9,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ...description.map((e) {
            var descIndex = description.indexOf(e);
            return FadeInUp(
              delay: Duration(milliseconds: descIndex * 100),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 3.0),
                      child: Icon(
                        Icons.check_circle,
                        color: kSecondary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        e,
                        style: const TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          })
        ],
      ),
    );
  }
}

class SubscriptionPlaceholder extends StatelessWidget {
  SubscriptionPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      key: UniqueKey(),
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: decoration,
          margin: const EdgeInsets.symmetric(vertical: 20),
        ),
        Container(
          decoration: decoration,
          height: 24,
          width: context.width*0.85,
          margin: const EdgeInsets.only(bottom: 10),
        ),
        Container(
          decoration: decoration,
          height: 24,
          width: context.width*0.85,
          margin: const EdgeInsets.only(bottom: 10),
        ),
        Container(
          decoration: decoration,
          height: 24,
          width: context.width*0.85,
          margin: const EdgeInsets.only(bottom: 40),
        ),

        Container(
          decoration: decoration,
          height: 60,
          width: context.width*0.85,
          margin: const EdgeInsets.only(bottom: 0),
        ),
      ],
    ).animate(
      onPlay: (controller) {
        controller.repeat();
      },
    ).shimmer(
      color: Colors.grey,
      duration: const Duration(milliseconds: 1500),
      angle:120,
    );
  }

  final decoration = BoxDecoration(
    color: Colors.black38,
    borderRadius: BorderRadius.circular(10.0),
  );
}


