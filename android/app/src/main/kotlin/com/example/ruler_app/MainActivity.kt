package com.example.ruler_app

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel


class MainActivity: FlutterActivity() {
    private val CHANNEL = "thpir/dpi"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            if (call.method == "getPhoneDpi") {
                val phoneDPI = getPhoneDpi()

                result.success(phoneDPI)
            } else {
                result.notImplemented()
            }
        }
    }

    private fun getPhoneDpi(): Double {
        val metrics = resources.displayMetrics
        val actualDPI = metrics.ydpi
        val dpi = metrics.densityDpi.toDouble()
        return actualDPI.toDouble()
    }
}
