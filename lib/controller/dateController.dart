import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DateController extends GetxController {
  Rx<DateTime?> pickedDate = Rx<DateTime?>(null);

  void selectDate(BuildContext context) async {
    final DateTime now = DateTime.now().subtract(const Duration(days: 1));
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2000),
      lastDate: now, // Set lastDate to today's date
    );
    if (selectedDate != null) {
      pickedDate.value = selectedDate;
    }
  }
}