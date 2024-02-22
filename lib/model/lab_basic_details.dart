import 'package:cloud_firestore/cloud_firestore.dart';

class LabBasicDetailsModel {
  final bool accountStatus;
  Address? address;
  BankDetails? bankDetails;
  BasicDetails? basicDetails;
  DocumentUrl? documentUrl;
  String? phoneNumber;
  DocumentVerification? documentVerification;
  final String userId;

  LabBasicDetailsModel({
    this.accountStatus = false,
    this.basicDetails,
    this.address,
    this.bankDetails,
    this.documentUrl,
    this.phoneNumber = "8210109466",
    this.documentVerification,
    this.userId = "",
  });

  factory LabBasicDetailsModel.fromJson(Map<String, dynamic> json) {
    return LabBasicDetailsModel(
        basicDetails: BasicDetails.fromJson(json["basicDetails"]),
        accountStatus: json["accountStatus"] ?? false,
        address: Address.fromJson(json),
        bankDetails: BankDetails.fromJson(json),
        documentUrl: DocumentUrl.fromJson(json),
        phoneNumber: json["phoneNumber"],
        documentVerification: DocumentVerification.fromJson(json),
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
        city: json["city"] ?? "panchkula",
        state: json["state"] ?? "haryana",
        country: json["country"] ?? "india",
        pinCode: json["pinCode"] ?? "841460",
        district: json["district"] ?? "zirakpur",
        labLocation: json["labLocation"] ??
            "Pratham Clinical Laboratory And Diagnostic Centre NAC Manimajra, Manimajra, Chandigarh, India",
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
        accountNumber: json["accountNumber"] ?? "235689875421",
        bankName: json["bankName"] ?? "Allahabad Bank",
        branchName: json["branchName"] ?? "Allahabad main branch chapra",
        ifscCode: json["ifscCode"] ?? "2356898");
  }
}

class DocumentUrl {
  final String aadharUrl;
  final String bankPassBookUrl;
  final String labCertificateUrl;
  final String panCardUrl;
  final List<String> labPictureUrl;

  DocumentUrl(
      {required this.aadharUrl,
      required this.bankPassBookUrl,
      required this.labCertificateUrl,
      required this.panCardUrl,
      required this.labPictureUrl});

  factory DocumentUrl.fromJson(Map<String, dynamic> json) {
    return DocumentUrl(
        aadharUrl: json["aadharUrl"] ?? "",
        bankPassBookUrl: json["bankPassBookUrl"] ?? "",
        labCertificateUrl: json["labCertificateUrl"] ?? "",
        panCardUrl: json["panCardUrl"] ?? "",
        labPictureUrl: List.from(json["labPictureUrl"] ?? []));
  }
}

class DocumentVerification {
  final bool aadhar;
  final bool bankPassbook;
  final bool labCertificate;
  final bool labPicture;
  final bool panCard;

  DocumentVerification(
      {required this.aadhar,
      required this.bankPassbook,
      required this.labCertificate,
      required this.labPicture,
      required this.panCard});

  factory DocumentVerification.fromJson(Map<String, dynamic> json) {
    return DocumentVerification(
        aadhar: json["aadhar"] ?? false,
        bankPassbook: json["bankPassbook"] ?? false,
        labCertificate: json["labCertificate"] ?? false,
        labPicture: json["labPicture"] ?? false,
        panCard: json["panCard"] ?? false);
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
