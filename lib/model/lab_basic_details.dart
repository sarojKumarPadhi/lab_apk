





import 'package:cloud_firestore/cloud_firestore.dart';

class LabBasicDetailsModel {
  final bool accountStatus;
  Address? address;
  BankDetails? bankDetails;
  BasicDetails? basicDetails;
  String? phoneNumber;
  final String userId;

  LabBasicDetailsModel({
    this.accountStatus = false,
    this.basicDetails,
    this.address,
    this.bankDetails,
    this.phoneNumber = "8210109466",
    this.userId = "",
  });

  factory LabBasicDetailsModel.fromJson(Map<String, dynamic> json) {
    return LabBasicDetailsModel(
        basicDetails: BasicDetails.fromJson(json["basicDetails"]),
        accountStatus: json ["accountStatus"] ?? false,
        address: Address.fromJson(json["address"]),
        bankDetails: BankDetails.fromJson(json["bankDetails"]),
        phoneNumber: json["phoneNumber"],
        userId: json["userUid"] ?? "");
  }
}

class Address {
  final String city;
  final String state;
  final String country;
  final String pinCode;
  final String district;
  final String labLocation;
  final GeoPoint geoPoint;

  Address(
      {required this.city,
        required this.state,
        required this.country,
        required this.pinCode,
        required this.district,
        required this.labLocation,
        required this.geoPoint});

  factory Address.fromJson(Map<String, dynamic> json) {
    GeoPoint defaultGeoPoint = const GeoPoint(30.7117829, 76.84531799999999);

    return Address(
        city: json["city"],
        state: json["state"],
        country: json["country"],
        pinCode: json["pinCode"],
        district: json["district"],
        labLocation: json["labLocation"],
        geoPoint: json["latLong"] ?? defaultGeoPoint);
  }
}

class BankDetails {
  final String accountNumber;
  final String bankName;
  final String branchName;
  final String ifscCode;

  BankDetails(
      {required this.accountNumber,
        required this.bankName,
        required this.branchName,
        required this.ifscCode});

  factory BankDetails.fromJson(Map<String, dynamic> json) {
    return BankDetails(
        accountNumber: json["accountNumber"],
        bankName: json["bankName"],
        branchName: json["branchName"],
        ifscCode: json["ifscCode"]);
  }
}



class BasicDetails {
  final String labName;
  final String labOwnerName;
  final String labRegistrationNumber;

  BasicDetails(
      {this.labName = "Pratham lab",
        this.labOwnerName = "Kumar Biswas",
        this.labRegistrationNumber = "1234567"});

  factory BasicDetails.fromJson(Map<String, dynamic> json) {
    return BasicDetails(
        labName: json["labName"] ?? "Pratham lab",
        labOwnerName: json["labOwnerName"] ?? "Kumar Biswas",
        labRegistrationNumber: json["labRegistrationNumber"] ?? "1234567");
  }
}
