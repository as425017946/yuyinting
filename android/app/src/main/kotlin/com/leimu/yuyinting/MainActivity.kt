package com.littledog.yyt

import io.flutter.embedding.android.FlutterActivity
import androidx.annotation.NonNull
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.snail.antifake.jni.EmulatorDetectUtil

class MainActivity: FlutterActivity() {
    private val CHANNEL = "moniqi"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            // This method is invoked on the main thread.
            // TODO

//            if(call.method.equals("getBatteryLevel")){
//                var a  = EmulatorDetectUtil.isEmulator(this@MainActivity)
//
//                if(a.toString() == "false"){
//                    result.success("0");
//                }else{
//                    result.success("1");
//                }
//            }

        }
    }
}

