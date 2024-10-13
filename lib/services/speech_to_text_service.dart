import 'package:ask_qx/network/error_handler.dart';
import 'package:ask_qx/services/method_channel_service.dart';
import 'package:speech_to_text/speech_to_text.dart';

import '../firebase/firebase_analytic_service.dart';

class SpeechToTextService {
  SpeechToTextService._();

  static final SpeechToTextService _service = SpeechToTextService._();

  static SpeechToTextService get service => _service;

  final _errorMessage = "Sorry, AskQx Lab cannot access your device's audio capabilities at this time. Please ensure that the app has permission to use the microphone and audio settings in your device's settings";

  final _speechToText = SpeechToText();

  Future<void> initializeAndStart(Function(String result) onResult,Function(String state) onState,Function(String erro) onError) async {
    FirebaseAnalyticService.instance.logEvent("Click_Speaker");
   await _speechToText.initialize(
     finalTimeout: const Duration(seconds: 10),
      options: [
        SpeechToText.androidAlwaysUseStop,
        SpeechToText.androidIntentLookup,
      ],
      onStatus:(state){
        onState.call(state);
      },
      onError:(error)=>onError.call(error.errorMsg),
    ).then((value) {
      if(value){
        _start(onResult);
      }else{
        ErrorHandle.success(
          _errorMessage,
          onAction: () {
            // OpenSettings.openManageApplicationSetting();
            MethodChannelService.instance.openSetting();
          },
          actionName: "settings",
        );
        onError.call("Speech to text is not available");
      }
    });
  }

  Future<void> _start(onResult) async{
    await _speechToText.listen(
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.confirmation,
        cancelOnError: true,
      ),
      onResult: (value) {
        onResult.call(value.recognizedWords);
      },
    );
  }

  Future<void> stop() async{
    FirebaseAnalyticService.instance.logEvent("Speaker_Stop");
    if(_speechToText.isListening) await _speechToText.stop();
  }


}
