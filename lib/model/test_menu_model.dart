class TestMenuModel {
  String testName;
  String testSampleName;
  String testPrice;

  TestMenuModel(
      {required this.testName,
      required this.testSampleName,
      required this.testPrice});

  factory TestMenuModel.fromJson(Map<String, dynamic> json) {
    return TestMenuModel(
        testName: json["testName"] ?? "testName",
        testSampleName: json["testSampleName"] ?? "testSampleName",
        testPrice: json["testPrice"]??"testPrice",);
  }

  Map<String, dynamic> toJson() {
    return {
      'testName': testName,
      'testSampleName': testSampleName,
      'testPrice': testPrice,
    };
  }
}
