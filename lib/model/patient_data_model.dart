class PatientDataModel {
  String? id;
  String? name;
  String? age;
  String? gender;
  String? phone;
  List<String>? samples;

  PatientDataModel(
      {required this.id,
        required this.name,
        required this.age,
        required this.gender,
        required this.phone,
        required this.samples});

  factory PatientDataModel.fromJson(Map<String, dynamic> json) {
    return PatientDataModel(
      id: json["customerId"],
      name: json["name"],
      age: json["age"],
      gender: json["gender"],
      phone: json["phoneNumber"],
      samples:List.from( json["samples"]),
    );
  }
}
