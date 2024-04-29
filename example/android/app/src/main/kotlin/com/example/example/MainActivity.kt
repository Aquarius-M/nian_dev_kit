package com.example.example

import io.flutter.embedding.android.FlutterActivity

import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity(){
    private val Method_Channel = "nian_an/methodChannel"
    private var currentMethodChannel: MethodChannel? = null


    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        currentMethodChannel = MethodChannel(flutterEngine.dartExecutor, Method_Channel)
        currentMethodChannel?.setMethodCallHandler { call, result ->
            run {
                if(call.method.equals("testMethodCall")){
                    result.success(BuildConfig.DEBUG.toString() + " " +"yes")
                }
            }
        }
    }
}
