import 'dart:convert';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';

import '../page/after_ride_accept_by_rider.dart';

class PushNotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  void requestNotificationsPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: true,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("user granted permission");
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print("user granted provisional permission");
    } else {
      print("user denied permission");
    }
  }

  ///--------------------Create the channel on the device for when app in foreground----------------

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  initLocalNotifications() async {
    var androidInitializationSettings =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitializationSettings = const DarwinInitializationSettings();

    var iniInitializationSettings = InitializationSettings(
        android: androidInitializationSettings, iOS: iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(
      iniInitializationSettings,
      onDidReceiveNotificationResponse: (payload) {},
    );
  }

  ///---------this will be called when app is in background or terminated ///

  void firebaseInit() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(message.notification!.title.toString());
      print(message.notification!.body.toString());
      showNotification(message);
    });
  }

  ///--------show the notification/

  Future showNotification(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(), // id
      'High Importance Notifications', // title
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
            channel.id.toString(), channel.name.toString(),
            channelDescription: 'your channel description',
            importance: Importance.high,
            priority: Priority.high,
            ticker: 'ticker');

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentSound: true,
      presentBadge: true,
      presentAlert: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);
    Future.delayed(
      Duration.zero,
      () {
        flutterLocalNotificationsPlugin.show(0, message.notification!.title,
            message.notification!.body, notificationDetails);
      },
    );
  }

  /// --------------------it is used for to get device token----------

  Future<String?> getDeviceToken() async {
    String? token = await _firebaseMessaging.getToken();
    print(
        "This is your device token===================================== :- \n$token");
    return token;
  }

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
        readLabRideRequestInformation(remoteMessage.data["rideRequestId"],
            context, remoteMessage.data["labUid"]);
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage remoteMessage) {
      readLabRideRequestInformation(remoteMessage.data["rideRequestId"],
          context, remoteMessage.data["labUid"]);
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage remoteMessage) {
      readLabRideRequestInformation(remoteMessage.data["rideRequestId"],
          context, remoteMessage.data["labUid"]);
    });
  }

  readLabRideRequestInformation(
      String requestId, BuildContext context, String labUid) {
    Get.offAll(() =>
        AfterAcceptanceRidePage(requestId: requestId, labUid: labUid));
  }
}
