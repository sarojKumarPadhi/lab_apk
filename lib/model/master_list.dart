class MasterListModel {
  String? id;
  String? name;
  String? age;
  String? gender;
  String? phone;
  List<String>? samples;

  MasterListModel(
      {required this.id,
      required this.name,
      required this.age,
      required this.gender,
      required this.phone,
      required this.samples});

  factory MasterListModel.fromJson(Map<String, dynamic> json) {
    return MasterListModel(
      id: json["customerId"],
      name: json["name"],
      age: json["age"],
      gender: json["gender"],
      phone: json["phoneNumber"],
      samples:List.from( json["samples"]),
    );
  }
}
