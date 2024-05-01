class TestMenuModel {
  final String? category;
  final String? imageUrl;
  final List<String>? subCategories;

  TestMenuModel({this.imageUrl, this.category, this.subCategories});

  factory TestMenuModel.fromJson(Map<String, dynamic> json) {
    List<String>? subCategoriesList =
        json["subCategory"] != null && json["subCategory"] is List
            ? List<String>.from(json["subCategory"])
            : [];

    return TestMenuModel(
      imageUrl: json["icon"] ?? "xyz",
      category: json["category"] ?? "",
      subCategories: subCategoriesList,
    );
  }
}
