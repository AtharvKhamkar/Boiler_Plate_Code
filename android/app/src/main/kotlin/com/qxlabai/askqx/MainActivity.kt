package com.qxlabai.askqx

import android.content.Intent
import android.net.Uri
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

    private val CHANNEL_NAME : String = "com.qxlabai"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL_NAME).setMethodCallHandler { call, result ->
            if(call.method.equals("open_setting")){
                val intent  = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                intent.flags = Intent.FLAG_ACTIVITY_NEW_TASK
                intent.data = Uri.fromParts("package",packageName,null)
                startActivity(intent)
                result.success(true);
            }else if(call.method.equals("build_flavour")){
                result.success(BuildConfig.FLAVOR)
            }else if(call.method.equals("version")){
                result.success("${BuildConfig.VERSION_NAME}+${BuildConfig.VERSION_CODE}")
            }else if(call.method.equals("launch_url")){
                val url = call.arguments as String
                val intent = Intent(Intent.ACTION_VIEW)
                intent.data = Uri.parse(url)
                startActivity(intent)
                result.success(true)
            }else{
                result.notImplemented();
            }
        }
    }

}
