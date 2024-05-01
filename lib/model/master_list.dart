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
      id: json["customerId"]??"404",
      name: json["name"]??"Amit",
      age: json["age"]??"25",
      gender: json["gender"]??"male",
      phone: json["phoneNumber"]??"8210109466",
      samples:List.from( json["samples"]??[]),
    );
  }
}
