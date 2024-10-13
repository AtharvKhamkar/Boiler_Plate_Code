
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MethodChannelService {
  MethodChannelService._();

  static final MethodChannelService _instance = MethodChannelService._();

  static MethodChannelService get instance => _instance;

  final _channel = const MethodChannel("com.qxlabai");


  //Open setting
  Future<void> openSetting() async{
    try{
      await _channel.invokeMethod("open_setting");
    }catch(e){
      debugPrint(e.toString());
    }
  }

  //Build Flavor
  Future<String> buildFlavor() async{
    try{
      final result = await _channel.invokeMethod("build_flavour");
      return "$result";
    }catch(e){
      debugPrint(e.toString());
      return "dev";
    }
  }

  //Build Flavor
  Future<String> version() async{
    try{
      final result = await _channel.invokeMethod("version");
      return  result;
    }catch(e){
      debugPrint(e.toString());
      return "1.0.0+1";
    }
  }

  //Launch Url
  Future<void> openUrl(String url) async{
    try{
      await _channel.invokeMethod("launch_url",url);
    }catch(e){
      debugPrint(e.toString());
    }
  }
}