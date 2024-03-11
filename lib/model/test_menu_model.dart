class TestMenuModel {
  String testSampleName;
  String imageUrl;

  TestMenuModel({
    required this.imageUrl,
    required this.testSampleName,
  });

  factory TestMenuModel.fromJson(Map<String, dynamic> json) {
    return TestMenuModel(
      testSampleName: json["sampleName"] ?? "testSampleName",
      imageUrl: json["iconLink"] ?? "testPrice",
    );
  }
}
