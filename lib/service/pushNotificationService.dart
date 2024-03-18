import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../page/after_ride_accept_by_rider.dart';

class PushNotificationService {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  ///-----------------------request notification permission -------------------
  Future<void> requestNotificationPermissions() async {
    NotificationSettings notificationSettings =
        await firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      print("notification settings is authorized");
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.denied) {
      print("notification settings is denied");
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("notification settings is provisional");
    }
  }

// It is assumed that all messages contain a data field with the key 'type'

  ///------------------send push notification------------------------
  Future<void> sendPushNotification(
      {required List<String> tokens,
      required String rideRequestId,
      required String labUid}) async {
    const String urlString = "https://fcm.googleapis.com/fcm/send";
    final Map<String, dynamic> requestBody = {
      "registration_ids": tokens,
      "notification": {
        "title": "You have a New Request",
        "body": "In Your App"
      },
      "data": {
        "rideRequestId": rideRequestId,
        "labUid": labUid,
      }
    };

    final http.Response response = await http.post(
      Uri.parse(urlString),
      headers: <String, String>{
        "Content-Type": "application/json",
        "Authorization":
            "key=AAAAa7EVXgo:APA91bHqWt8YtjjEdktLMKf33oI0jWRebAERJIeuDeIUtmwzpZLEjs_TFTDglQF0x2_YV8ja-bDQpN0NcH1RTrf-LKSCUX0Zmxbf3Ufnkrw6FyHo_segLClJsQ0sU98Kf3cElnegg4B1",
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print("Push notification sent successfully.");
    } else {
      print(
          "Failed to send push notification. Status code: ${response.statusCode}");
    }
  }

  static Future<void> requestNotificationPermission() async {
    // Check if permission is already granted
    var status = await Permission.notification.status;

    if (status.isDenied) {
      // Request permission if not granted
      status = await Permission.notification.request();

      if (status.isGranted) {
        Fluttertoast.showToast(msg: "Notification permission enabled");
      }
    } else if (status.isGranted) {
      // Permission already granted
      // You can now handle the notification logic here
    }
  }

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(BuildContext context) async {



    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        print("This is a remote message ");
        print(remoteMessage.data);

        if (remoteMessage.data["notificationType"] == "ride") {
          readLabRideRequestInformation(remoteMessage.data["rideRequestId"],
              context, remoteMessage.data["labUid"]);
        }
        print("App opened from background with notification");
        print(remoteMessage.data);

      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {


      print("App opened from background with notification");
      print(remoteMessage.data);
      if (remoteMessage.data["notificationType"] == "ride") {
        readLabRideRequestInformation(remoteMessage.data["rideRequestId"],
            context, remoteMessage.data["labUid"]);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {

      print("App opened from background with notification");
      print(remoteMessage.data);
      if (remoteMessage.data["notificationType"] == "ride") {
        readLabRideRequestInformation(remoteMessage.data["rideRequestId"],
            context, remoteMessage.data["labUid"]);
      }

    });
  }

  readLabRideRequestInformation(String requestId, BuildContext context, String labUid) {
    Get.offAll(
            () => AfterAcceptanceRidePage(requestId: requestId, labUid: labUid)
    );
  }
}
