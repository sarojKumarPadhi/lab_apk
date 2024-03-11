package com.geteideas.jonk_lab

import android.annotation.TargetApi
import android.os.Build
import android.os.Bundle
import android.telephony.SmsManager
import android.telephony.SmsManager.getDefault
import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "methodChannel"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "sendSms" -> {
                    val arguments = call.arguments as? Map<String, String>
                    val number = arguments?.get("number")
                    val otp = arguments?.get("otp")
//                    val totalPrice = arguments?.get("totalPrice")
                    val message = "Jonk : Share This OTP $otp to Your Lab Sample Collecter Only and total price is  ₹" // Replace with your message
                    if (number != null) {
                        sendSms(number, message)
                        result.success("SMS sent successfully.")
                    }

                }
                else -> result.notImplemented()
            }

        }
    }

    @TargetApi(Build.VERSION_CODES.DONUT)
    private fun sendSms(number: String, message: String) {
        val smsManager = getDefault()
        smsManager.sendTextMessage(number, null, message, null, null)
        Toast.makeText(applicationContext, "Message Sent", Toast.LENGTH_LONG).show()
    }
}
