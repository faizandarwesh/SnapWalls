package com.example.snap_walls

import android.content.Intent
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val channel = "versionChannel"
    private val downloadServiceChannel = "DownloadServiceChannel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            downloadServiceChannel
        ).setMethodCallHandler { call, result ->
            if (call.method == "getPlatformVersion") {
                val version = "ANDROID ${Build.VERSION.RELEASE}"
                result.success(version)
            }
            if (call.method == "startForegroundService") {
                val intent = Intent(this, DownloadService::class.java)
                startService(intent)
                result.success("Service started")
            }
            if (call.method == "stopForegroundService") {
                val intent = Intent(this, DownloadService::class.java)
                stopService(intent)
                result.success("Service ended")
            } else {
                result.notImplemented()
            }

        }
    }
}

