import 'package:cloud_firestore/cloud_firestore.dart';
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


}
