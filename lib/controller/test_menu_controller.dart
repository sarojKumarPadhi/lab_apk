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
        .collection("test")
        .doc("1hJ7bmPKIEpNlhnY7L4J")
        .get()
        .then((DocumentSnapshot snapshot) {
      Map<String, dynamic> mapData = snapshot.data() as Map<String, dynamic>;
      testMenuList.addAll(
          (mapData["samples"] as List).map((e) => TestMenuModel.fromJson(e)));
    });
  }
}
