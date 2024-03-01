import 'dart:convert';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
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



  // Future<void> sendNotification(String deviceToken, String headerData,String bodyData) async {
  //   final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'key=AAAAa7EVXgo:APA91bHqWt8YtjjEdktLMKf33oI0jWRebAERJIeuDeIUtmwzpZLEjs_TFTDglQF0x2_YV8ja-bDQpN0NcH1RTrf-LKSCUX0Zmxbf3Ufnkrw6FyHo_segLClJsQ0sU98Kf3cElnegg4B1',
  //   };
  //   final body = jsonEncode({
  //     'notification': {
  //       'title': headerData,
  //       'body': bodyData,
  //     },
  //     "data":{
  //       "click_action":"FLUTTER_NOTIFICATION_CLICK",
  //       "id":"1",
  //       "status":"done",
  //       "rideRequestId":"152e9960-904c-1ee7-b7e4-77cc43f0c501"
  //     },
  //     'to': deviceToken,
  //   });
  //   final response = await http.post(url, headers: headers, body: body);
  //   if (response.statusCode == 200) {
  //     print('Notification sent successfully!');
  //   } else {
  //     print('Failed to send notification. Error code: ${response.statusCode}');
  //   }
  // }

   Future<void> sendPushNotification({
    required List<String> tokens,
    required String rideRequestId
  }) async {
    const String urlString = "https://fcm.googleapis.com/fcm/send";
    final Map<String, dynamic> requestBody = {
      "registration_ids": tokens,
      "notification": {"title": "You have a New Request", "body": "In Your App"},
      "data": {"rideRequestId": rideRequestId}
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
}
