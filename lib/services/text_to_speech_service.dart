// /*
//  * Created or updated by Deepak Gupta on 23/02/24, 12:45 pm
//  *  Copyright (c) 2024 . All rights reserved for Ask Qx Lab.
//  * Last modified 23/02/24, 12:45 pm
//  */
//
// import 'package:flutter_tts/flutter_tts.dart';
// import 'package:get/get.dart';
//
// class TextToSpeechService {
//   TextToSpeechService._() {
//     _setAwaitOptions();
//   }
//
//   static final TextToSpeechService _instance = TextToSpeechService._();
//
//   static TextToSpeechService get instance => _instance;
//
//   FlutterTts flutterTts = FlutterTts();
//
//
//   var isPlaying = false.obs;
//
//   void start(String data) async {
//     try {
//       // await flutterTts.stop();
//       await flutterTts.setVolume(1.0);
//       await flutterTts.setSpeechRate(0.5);
//       await flutterTts.setPitch(1.0);
//       await flutterTts.setVoice({"name": "hi-in-x-hid-network", "locale": "mr-IN"});
//       if (data.isNotEmpty) {
//         isPlaying(true);
//         await flutterTts.speak(data);
//       }
//
//       flutterTts.setStartHandler(() {
//         isPlaying(true);
//       });
//
//       flutterTts.setCompletionHandler(() {
//         isPlaying(false);
//       });
//
//
//     }  catch (_) {
//       isPlaying(false);
//     }
//   }
//
//   void stop() async {
//     try {
//       await flutterTts.stop();
//     } catch (_) {}
//     isPlaying(false);
//   }
//
//   void _setAwaitOptions() async {
//     await flutterTts.awaitSpeakCompletion(true);
//     _getDefaultEngine();
//     _getDefaultVoice();
//   }
//
//   void _getDefaultEngine() async {
//     var engine = await flutterTts.getDefaultEngine;
//     if (engine != null) {
//
//     }
//   }
//
//   void _getDefaultVoice() async {
//     var voice = await flutterTts.getDefaultVoice;
//     if (voice != null) {
//
//     }
//   }
// }
