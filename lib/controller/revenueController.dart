
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../model/revenueModel.dart';

class RevenueController extends GetxController {
  Future<revenueModel?> fetchRevenue({required String userUid}) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;

    Logger logger = Logger();

    try {
      final DocumentSnapshot documentSnapshot = await firestore
          .collection('lab')
          .doc(userUid)
          .collection('labGenerate')
          .doc(userUid)
          .get();

      final data = documentSnapshot.data();
      if (data != null) {
        return revenueModel.fromJson(data as Map<String, dynamic>);
      } else {
        return null;
        // Handle scenario where data is null
      }
    } catch (e) {
      // Handle error while fetching data
      logger.d('Error fetching revenue: $e');
      return null;
    }
  }
}