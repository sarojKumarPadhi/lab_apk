import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:jonk_lab/model/test_menu_model.dart';

class TestMenuController extends GetxController {
  RxList<TestMenuModel> testMenuList = <TestMenuModel>[].obs;

  @override
  onInit() {
    super.onInit();
    getTestList();
  }

  addTestMenu(String testName, String testSample, String testPrice) async {
    String auth = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("lab")
        .doc(auth)
        .get()
        .then((DocumentSnapshot snapshot) async {
      if (snapshot.exists) {
        Map<String, dynamic> mapData = snapshot.data() as Map<String, dynamic>;
        List<dynamic> testList = mapData["test"] ?? [];
        testList.add({
          "testPrice": testPrice,
          "testSampleName": testSample,
          "testName": testName
        });
        await FirebaseFirestore.instance
            .collection("lab")
            .doc(auth)
            .update({"test": testList});
      }
    });
  }

  getTestList() async {
    String auth = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance
        .collection("lab")
        .doc(auth)
        .snapshots()
        .listen((event) {
      if (event.exists) {
        Map<String, dynamic> mapData = event.data() as Map<String, dynamic>;
        List<dynamic> testList = mapData["test"] ?? [];
        testMenuList.value =
            testList.map((e) => TestMenuModel.fromJson(e)).toList();
      }
    });
  }

  deleteTestMenu(int index) async {
    List<TestMenuModel> newList = List.from(testMenuList); // Create a new list

    newList.removeAt(index); // Remove item from the new list

    String auth = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection("lab")
        .doc(auth)
        .get()
        .then((DocumentSnapshot snapshot) async {
      if (snapshot.exists) {
        await FirebaseFirestore.instance
            .collection("lab")
            .doc(auth)
            .update({"test": newList.map((e) => e.toJson()).toList()}); // Convert list to JSON before updating
      }
    });
  }

}
