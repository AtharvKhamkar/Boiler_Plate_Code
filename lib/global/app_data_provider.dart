import 'package:ask_qx/widgets/conversation_style_widget.dart';
import 'package:get/get.dart';

class AppDataProvider {

  static var devCount = 0;

  static var connectionError = "Look's like not connected to internet. Please try again";
  static var serverError = "Unable to process. Please try in sometime.";

  static List<String> suggestionBasedOnStyle(ConversationStyle style){
    switch(style){
      case ConversationStyle.creative:
        return creativeSuggestions;
      case ConversationStyle.balanced:
        return balancedSuggestions;
      case ConversationStyle.precise:
        return preciseSuggestions;
    }
  }

  static List<String> creativeSuggestions = [
    "Write instagram bio",
    "Give me a riddle to solve",
    "Let's write a beat poem",
    "Watch Classic Film",
    "Sing Happy Song",
    "Write Thank-You",
    "Read Bedtime Story",
    "Describe Dream Vacation",
    "Share Spooky Experience",
    "Discuss Favorite Myth",
    "Reveal Secret Talent",
    "Chat About Magic",
    "Discuss Unknown Planet",
    "Talk Future Tech",
    "Debate Robot Emotions",
    "Describe Cloud Shapes",
  ].obs;

  static List<String> balancedSuggestions = [
    "Act as a English Pronunciation Helper",
    "Write a Instagram bio",
    "Tell a fun Fact",
    "Act as a Spoken English Teacher",
    "Review A Movie",
    "Diet Plan",
    "Basic Workout",
    "Make a Grocery List",
    "Fitness Routine Suggestions",
  ].obs;

  static List<String> preciseSuggestions = [
    "Act as position Interviewer",
    "Creating a successful resume?",
    "Act as a Plagiarism Checker",
    "Managing work stress?",
    "Better decision-making?",
    "Ways to boost employee motivation.",
    "What is blockchain?",
    "Write an job application",
    "Talk Health Benefits",
    "How to improve time management?",
    "Tips for effective customer service.",
    "Explain Mathematical Theorem",
    "Review Book Briefly",
    "Break Down Recipe"
  ].obs;


  static var likeSuggestion = [
    "Thank you!",
    "Awesome",
    "Exact answers",
    "Exactly I want this",
  ];

  static var dislikeSuggestion = [
    "This is harmful/unsafe",
    "This isn't true",
    "This isn't helpful",
    "Not satisfied with provided answer",
  ];

  static var helpfulSuggestion = [
    "Better",
    "Need Improvements",
    "Same",
  ];
}
