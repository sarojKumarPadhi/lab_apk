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



  getTestList() async {
    String auth = "6JedNJxfiaSrVtey9wk9cjGEIrp2";
    await FirebaseFirestore.instance
        .collection("admin")
        .doc(auth)
        .collection("samples")
        .get()
        .then((QuerySnapshot snapshot) {
      for (DocumentSnapshot snapshot in snapshot.docs) {
        Map<String, dynamic> mapData = snapshot.data() as Map<String, dynamic>;
        testMenuList.add(TestMenuModel.fromJson(mapData));
      }
    });
  }

// deleteTestMenu(int index) async {
//   List<TestMenuModel> newList = List.from(testMenuList); // Create a new list
//
//   newList.removeAt(index); // Remove item from the new list
//
//   String auth = FirebaseAuth.instance.currentUser!.uid;
//   await FirebaseFirestore.instance
//       .collection("lab")
//       .doc(auth)
//       .get()
//       .then((DocumentSnapshot snapshot) async {
//     if (snapshot.exists) {
//       await FirebaseFirestore.instance
//           .collection("lab")
//           .doc(auth)
//           .update({"test": newList.map((e) => e.toJson()).toList()}); // Convert list to JSON before updating
//     }
//   });
// }
}
