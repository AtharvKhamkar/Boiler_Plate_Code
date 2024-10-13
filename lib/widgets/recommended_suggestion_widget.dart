
import 'package:ask_qx/controller/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../themes/colors.dart';
import '../utils/utils.dart';

class RecommendedSuggestionWidget extends StatelessWidget {
  const RecommendedSuggestionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (controller) {
      return Container(
        padding: const EdgeInsets.all(16.0),
        decoration:  BoxDecoration(
          color: context.theme.scaffoldBackgroundColor,
          borderRadius:  const BorderRadius.vertical(
            top: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recommended Suggestions",
                  style: TextStyle(
                    color: getTextColor(),
                    fontSize: 16,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.back();
                    HapticFeedback.lightImpact();
                  },
                  child: const Icon(Icons.highlight_remove),
                ),
              ],
            ),
            const SizedBox(height: 16,),
            const Divider(
              color: Colors.grey,
              height: 0,
              thickness: 0.5,
            ),
            const SizedBox(height: 4,),
            if(!controller.suggestionLoading.value && controller.suggestionList.isNotEmpty)...[
              TabBar(
                controller: controller.tabController,
                onTap:controller.onSuggestionTabChange,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.tab,
                automaticIndicatorColorAdjustment:true,
                tabAlignment: TabAlignment.start,
                unselectedLabelColor: Colors.grey,
                labelStyle: textStyle(color: controller.currentDarkColor.value,weight: FontWeight.w600,),
                indicator: BoxDecoration(
                  color: controller.currentDarkColor.value.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                dividerHeight: 0.0,
                indicatorWeight:0.0,
                indicatorPadding: const EdgeInsets.symmetric(vertical: 6),
                tabs: controller.suggestionList.map((element){
                  return Tab(
                    text: element.displayText,
                  );
                }).toList(),
              ),
              const Divider(
                color: Colors.grey,
                height: 8,
                thickness: 0.5,
              ),
              const SizedBox(height: 10,),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  children: controller.suggestionList[controller.tabController!.index].suggestions.map((element){
                    return InkWell(
                      borderRadius: BorderRadius.circular(8.0),
                      onTap: (){
                        Get.back(result: element);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: controller.currentDarkColor.value.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8.0),
                          // border: Border.all(color: Colors.grey,width: 0.4),
                        ),
                        alignment: Alignment.center,
                        child: Text(element.suggestion,maxLines: 2,textAlign: TextAlign.center,softWrap: true,),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],

            if(!controller.suggestionLoading.value && controller.suggestionList.isEmpty)
              const Expanded(
                child: Center(
                  child: Text("No suggestion found!",style: TextStyle(color: Colors.grey),)
                ),
              ),

            if(controller.suggestionLoading.value)
            Expanded(
              child: Center(
                child: LoadingAnimationWidget.fourRotatingDots(color: primaryColor, size: 34.0),
              ),
            ),
          ],
        ),
      );
    });
  }
}
