import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    MethodChannel(messenger: controller.binaryMessenger)
    GeneratedPluginRegistrant.register(with: self)
    // let channel = FlutterMethodChannel(name: "nian_an/methodChannel", binaryMessenger: self)
    // channel.setMethodCallHandler { (call, result) in
    //   result("返回值")
    // }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}

public class MethodChannel {
    init(messenger: FlutterBinaryMessenger) {
        let channel = FlutterMethodChannel(name: "nian_an/methodChannel", binaryMessenger: messenger)
        channel.setMethodCallHandler { (call:FlutterMethodCall, result:@escaping FlutterResult) in
            // if (call.method == "sendData") {
            //     if let dict = call.arguments as? Dictionary<String, Any> {
            //         let name:String = dict["name"] as? String ?? ""
            //         let age:Int = dict["age"] as? Int ?? -1
            //         result(["name":"hello,\(name)","age":age])
            //     }
            // }
            result(" yes")
        }
    }
}