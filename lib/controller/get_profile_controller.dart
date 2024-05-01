import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class GetProfileImageController extends GetxController {
  RxString profileUrl = "".obs;

  @override
  onInit() {
    super.onInit();

    getProfileImage();
  }

  Future<void> getProfileImage() async {
    String auth = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("lab")
        .doc(auth)
        .get()
        .then((DocumentSnapshot snapshot) {
      Map<String, dynamic> mapData = snapshot.data() as Map<String, dynamic>;
      profileUrl.value = mapData["profileImage"]??"";
    });
  }
}
