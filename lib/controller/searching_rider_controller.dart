import 'package:get/get.dart';

class SearchingRideController extends GetxController {
  RxInt time = 0.obs;
  RxDouble firstPercentage = 1.0.obs;
  RxDouble secondPercentage = 0.0.obs;
  RxDouble thirdPercentage = 0.0.obs;
  RxInt textIndex = 0.obs;
  List<String> allSearchShowText = [
    "Searching..",
    "We are searching best rider",
     "✌️✌️✌️✌️",
    "Please wait ",
    "I am searching",
    "Finding",
    "Almost there",
    "👍👍👍👍",
  ];

  @override
  void onInit() {
    secondPercentageBar();
    super.onInit();
    startTextIndex();
  }

  startTextIndex() {
    Future.delayed(
      const Duration(seconds: 5),
      () {
        if (textIndex.value < 7) {
          textIndex.value+=1;
          startTextIndex();
        } else {
          textIndex.value = 0;
          startTextIndex();
        }
      },
    );
  }

  secondPercentageBar() {
    Future.delayed(
      const Duration(milliseconds: 10000),
      () {
        secondPercentage.value += 1.0;
        Future.delayed(
          const Duration(milliseconds: 10000),
          () {
            thirdPercentage.value += 1.0;
            Future.delayed(const Duration(milliseconds: 10000), () {
              firstPercentage.value = 0.0;
              secondPercentage.value = 0.0;
              thirdPercentage.value = 0.0;
              Future.delayed(const Duration(milliseconds: 100), () {
                firstPercentage.value = 1.0;
                secondPercentageBar();
              });
            });
          },
        );
      },
    );
  }
}
