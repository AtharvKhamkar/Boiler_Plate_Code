import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        let CHANNEL_NAME : String = "com.qxlabai"
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        
        let channel = FlutterMethodChannel(name: CHANNEL_NAME,binaryMessenger: controller.binaryMessenger)
        
        channel.setMethodCallHandler({(call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            
            if call.method == "open_setting" {
                
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    result(false)
                    return
                }
                
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                        print("Settings opened: \(success)") // Prints true
                    })
                }
                
                result(true)
            }else if call.method == "build_flavour" {
                #if dev
                    result(String("dev"))
                #elseif production
                    result(String("production"))
                #endif
            }else if call.method == "version" {
                let name = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
                let code = Bundle.main.infoDictionary?["CFBundleVersion"] as? String
                print("Version: \(name!)+\(code!)")
                result(String("\(name!)+\(code!)"))
            }else{
                result(FlutterMethodNotImplemented)
            }
            
        })
        
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}
