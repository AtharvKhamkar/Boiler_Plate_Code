import 'package:ask_qx/network/error_handler.dart';
import 'package:ask_qx/repository/app_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

import '../firebase/firebase_analytic_service.dart';
import '../themes/colors.dart';
import 'custom_button.dart';

class FeedBackScreen extends StatefulWidget {
  const FeedBackScreen({Key? key}) : super(key: key);

  @override
  State<FeedBackScreen> createState() => _FeedBackScreenState();
}

class _FeedBackScreenState extends State<FeedBackScreen> {
  final feedbackFormKey = GlobalKey<FormState>();
  var rating = 0.0;
  final feedbackController = TextEditingController();

  var errorMessage  = "";

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 14,vertical: 10),
      child: Column(
       mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Feedback",
            style:textStyle(size:20),
          ),
          const SizedBox(height: 10),
          Text(
            "Please rate us",
            style:textStyle(size:16,color: Get.isDarkMode?Colors.white:Colors.black),
          ),
          const SizedBox(height: 10),
          RatingBar.builder(
            initialRating: rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemSize: 30,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (val) {
            setState(() {
              errorMessage = "";
              rating = val;
            });
            },
          ),
          if(errorMessage.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                errorMessage,
                style:textStyle(size:10,color: Colors.red),
              ),
            ),
          const SizedBox(height: 20),
          Text(
            "Please write your feedback",
            style:textStyle(size:18,color: Get.isDarkMode?Colors.white:Colors.black),
          ),
          const SizedBox(height: 10),
          TextFormField(
            controller: feedbackController,
            maxLines: 4,
            validator: (value){
              return null;
            },
            decoration: InputDecoration(
              hintText: "Write your feedback",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              contentPadding: const EdgeInsets.all(10),
            ),
            maxLength: 500,
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: 'Submit',
            onPressed: () {
              if(rating<1){
                setState(() {
                  errorMessage = "Rating is required";
                });
                return;
              }
                Get.back();
                FirebaseAnalyticService.instance.logEvent("Feedback_Submitted");
                ErrorHandle.success('Thanks for your valuable feedback!');
                AppRepository().submitFeedBack(
                  rating,
                  feedbackController.text.trim(),
                );
            },
          ),
          TextButton(
            style: TextButton.styleFrom(
              minimumSize: const Size(double.infinity, 50),
            ),
            onPressed: () {
              Get.back();
            },
            child: Text(
              "Cancel",
              style: textStyle(),
            ),
          ),
        ],
      ),
    ) ;
  }

}
