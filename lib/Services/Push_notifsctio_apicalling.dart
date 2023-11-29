import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
class PushNotification {
  final httpClient = HttpClient();

  sendNotification(String title, String body1, String id,
      List<String> to) async {
    const notificationUrl = 'https://fcm.googleapis.com/fcm/send';

    Map<String, dynamic> notificationData = {

      //["e-foWACcSh2XyPG8RLT2_k:APA91bHmQGU_cGvUNxBFJRb0R9Aa20VIEI-ZKLX7AniXra2-PkgYVggJy_707hgZdELuhwNA4AL1Zecf6mFvdGAsZpOTH7lNydrpUchxDazqDj1sgk87hWxZSxN2__GBBPAv9d0cezQH"],
      "registration_ids": to,
      "notification": {
        "body": body1,
        "title": title,
        "android_channel_id": "zonk_rider",
        "sound": false
      },
      // "data": {"_id": id, "_type": ""}
    };

    Map<String, String> headers1 = {
      'Content-Type': "application/json",
      'Authorization': "key=AAAAa7EVXgo:APA91bHqWt8YtjjEdktLMKf33oI0jWRebAERJIeuDeIUtmwzpZLEjs_TFTDglQF0x2_YV8ja-bDQpN0NcH1RTrf-LKSCUX0Zmxbf3Ufnkrw6FyHo_segLClJsQ0sU98Kf3cElnegg4B1"
    };

    String requestBody = jsonEncode(
        notificationData);


    var response = await http.post(
        Uri.parse(notificationUrl), body: requestBody, headers: headers1);
    if (response.statusCode == 200){
      print("Notification is sent");
      print("Notification is sent");
      print("Notification is sent");
    } else {
      print("Notification is not sent");
      print("Notification is not sent");
      print("Notification is not sent");
    }
  }

}
