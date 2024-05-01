class PatientDataModel {
  String id;
  String name;
  String age;
  String gender;
  String phone;
  List<String> sampleList;

  PatientDataModel(
      {required this.id,
        required this.name,
        required this.age,
        required this.gender,
        required this.phone,
        required this.sampleList
      });


}
