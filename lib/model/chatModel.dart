import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String senderId;
  String receiverId;
  String message;
  String imageUrl;
 final Timestamp timeStamp;

  ChatModel({
    this.message = 'hello world',
    this.senderId = 'I6LGf370PzYr3SXawEktUtmqVUe2',
    this.receiverId = 'xn4LhPywoDdOJ0x53XHCoMTlW6E3',
    this.imageUrl = 'https://firebasestorage.googleapis.com/v0/b/jonk-amit.appspot.com/o/chat_room%2F2024-02-08%2016%3A42%3A24.625314.jpg?alt=media&token=e4f602a3-2ed0-4f72-a4b3-575635092934',
    required this.timeStamp,
  }) ;



factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
        message: json["message"]??"",
        imageUrl: json["imageUrl"]??"",
        senderId: json["senderId"],
        receiverId: json["receiverId"],
        timeStamp: json["timeStamp"]);
  }
}
