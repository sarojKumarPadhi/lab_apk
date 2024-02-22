import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/global/globalData.dart';
import 'package:jonk_lab/global/shimmer.dart';

import '../controller/chat_controller.dart';
import '../global/progressIndicator.dart';

class ChatWithSupport extends StatelessWidget {
  const ChatWithSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text('Chat with Support',
            style: GoogleFonts.acme(letterSpacing: 1)),
      ),
      body: const ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  GetAllChatController getAllChatController = Get.put(GetAllChatController());

  File? imageFile;

  Future imagePicker() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
    }
    if (imageFile != null) {
      uploadToFirestore(imageFile!);
    }
  }

  uploadToFirestore(File imageFile) async {
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('chat_room')
        .child("${DateTime.now().toString()}.jpg");
    UploadTask uploadTask = ref.putFile(File(imageFile.path));
    TaskSnapshot snapshot = await uploadTask;
    String imageUrl = await snapshot.ref.getDownloadURL();
    getAllChatController.sendPicture(imageUrl);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => getAllChatController.isLoading.value == true
        ? Column(
            children: <Widget>[
              Flexible(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  reverse: true,
                  itemCount: getAllChatController.getAllChat.length,
                  itemBuilder: (_, int index) {
                    print(getAllChatController.getAllChat.length.toString());

                    return ChatMessage(
                      text: getAllChatController.getAllChat[index].message,
                      imageUrl: getAllChatController.getAllChat[index].imageUrl,
                      isUserMessage:
                          getAllChatController.getAllChat[index].senderId ==
                                  FirebaseAuth.instance.currentUser!.uid
                              ? true
                              : false,
                      time: formatTimestamp(
                          getAllChatController.getAllChat[index].timeStamp),
                    );
                  },
                ),
              ),
              const Divider(height: 1.0),
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: _buildTextComposer(),
              ),
            ],
          ):
    const CircularProgress()
    );

    }

  Widget _buildTextComposer() {
    return IconTheme(
      data: IconThemeData(color: Theme.of(context).primaryColor),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                cursorColor: Colors.black,
                controller: _textController,
                decoration: const InputDecoration.collapsed(
                  hintText: ' Send a message',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.add_a_photo,
                color: Colors.black,
              ),
              onPressed: () {
                imagePicker();
              },
            ),
            IconButton(
              icon: const Icon(
                Icons.send,
                color: Colors.blue,
              ),
              onPressed: () {
                if (_textController.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Enter a message");
                } else {
                  getAllChatController.sendMessage(_textController.text);
                  _textController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  const ChatMessage(
      {super.key,
      required this.text,
      required this.isUserMessage,
      required this.time, required this.imageUrl});

  final String text;
  final String time;
  final bool isUserMessage;
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment:
                isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              Text(
                time,
                style: TextStyle(
                    color: Colors.black, fontSize: deviceWidth! * .03),
              )
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment:
                isUserMessage ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child:text!=""? Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: isUserMessage ? Colors.blue[100] : Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(text),
                ):ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CachedNetworkImage(
                    height:deviceHeight!*.4 ,
                    width: deviceWidth!*.6,
                    imageUrl: imageUrl,
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                  
                        ),
                      ),
                    ),
                    placeholder: (context, url) => shimmer(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ],
          ),
        ),
    
      ],
    );
  }
}

String formatTimestamp(Timestamp timestamp) {
  // Convert Timestamp to DateTime object
  DateTime dateTime = timestamp.toDate();

  // Create a DateFormat instance
  DateFormat formatter =
      DateFormat.yMMMEd(); // 'yMMMEd' for format like "Tue, Feb 8, 2024"

  // Format the DateTime object using the formatter
  String formattedDate = formatter.format(dateTime);

  return formattedDate;
}
