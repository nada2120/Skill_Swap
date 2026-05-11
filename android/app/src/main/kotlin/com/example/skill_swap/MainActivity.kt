package com.example.skill_swap

import android.content.Intent
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val channel = "skill_swap/screen_capture"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "startScreenCaptureService" -> {
                        val intent = Intent(this, ScreenCaptureService::class.java)
                        startForegroundService(intent)
                        result.success(null)
                    }

                    "stopScreenCaptureService" -> {
                        stopService(Intent(this, ScreenCaptureService::class.java))
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }
    }
}