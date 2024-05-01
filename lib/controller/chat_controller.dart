import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../model/chatModel.dart';

class GetAllChatController extends GetxController {
  RxList<ChatModel> getAllChat = <ChatModel>[].obs;
  var uuid = const Uuid();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    getData();
    super.onInit();
  }

  getData() async {
    String auth = FirebaseAuth.instance.currentUser!.uid;
    String adminId = "TPCMeIo01KT64JTTZZsHH347wCT2";
    List<String> ids = [auth, adminId];
    ids.sort();
    String docId = ids.join("_");
    Stream<QuerySnapshot> snapshot = FirebaseFirestore.instance
        .collection("chat_room")
        .doc(docId)
        .collection("messages")
        .orderBy("timeStamp",
        descending:
        false) // Order messages by timeStamp in descending order
        .snapshots();
    Set<String> allIds = <String>{};
    snapshot.listen((QuerySnapshot snapshot) {
      for (var documentSnapshot in snapshot.docs) {
        if (!allIds.contains(documentSnapshot.id)) {
          getAllChat.insert(
              0,
              ChatModel.fromJson(documentSnapshot.data() as Map<String,
                  dynamic>)); // Insert new messages at the beginning of the list
          allIds.add(documentSnapshot.id);
        }

      }
      isLoading.value=true;
    });
  }

  sendMessage(String message) async {
    String auth = FirebaseAuth.instance.currentUser!.uid;
    String adminId = "TPCMeIo01KT64JTTZZsHH347wCT2";
    List<String> ids = [auth, adminId];
    ids.sort();
    String docId = ids.join("_");
    await FirebaseFirestore.instance
        .collection("chat_room")
        .doc(docId)
        .collection("messages")
        .doc(uuid.v4())
        .set({
      "senderId": auth,
      "receiverId": "TPCMeIo01KT64JTTZZsHH347wCT2",
      "message": message,
      "timeStamp": Timestamp.now()
    });
  }

  sendPicture(String imageUrl) async {
    String auth = FirebaseAuth.instance.currentUser!.uid;
    String adminId = "TPCMeIo01KT64JTTZZsHH347wCT2";
    List<String> ids = [auth, adminId];
    ids.sort();
    String docId = ids.join("_");
    await FirebaseFirestore.instance
        .collection("chat_room")
        .doc(docId)
        .collection("messages")
        .doc(uuid.v4())
        .set({
      "senderId": auth,
      "receiverId": "TPCMeIo01KT64JTTZZsHH347wCT2",
      "imageUrl": imageUrl,
      "timeStamp": Timestamp.now()
    });
  }
}
