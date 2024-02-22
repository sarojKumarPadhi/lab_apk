import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/global/globalData.dart';

import '../../controller/lab_basic_details.dart';
import '../../page/test_menu_page.dart';

class LabProfilePage extends StatefulWidget {
  const LabProfilePage({super.key});

  @override
  State<LabProfilePage> createState() => _LabProfilePageState();
}

class _LabProfilePageState extends State<LabProfilePage> {
  LabBasicDetailsController labBasicDetailsController = Get.find();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: Text(
          "Lab Profile",
          style: GoogleFonts.acme(color: Colors.black, letterSpacing: 1),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Account Status",
                      style: GoogleFonts.acme(fontSize: deviceWidth! * .07)),
                  labBasicDetailsController
                              .labBasicDetailsData.value.accountStatus ==
                          true
                      ? const Icon(
                          Icons.verified,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.cancel,
                          color: Colors.red,
                        )
                ],
              ),
              const Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Test Menu",
                    style: GoogleFonts.acme(
                        color: Colors.black, fontSize: deviceWidth! * .05),
                  ),
                  ElevatedButton(onPressed: (){
                    Get.to(()=>const TestMenuPage());
                  }, child: const Icon(Icons.menu_open),)
                ],
              ),
              const Divider(),
              Text(
                'Lab Details',
                style: GoogleFonts.acme(fontSize: deviceWidth! * .06),
              ),
              _buildDetailRow(
                  'Name',
                  labBasicDetailsController
                          .labBasicDetailsData.value.basicDetails?.labName ??
                      ""),
              _buildDetailRow(
                  'Mobile No',
                  labBasicDetailsController
                          .labBasicDetailsData.value.phoneNumber ??
                      ""),
              const SizedBox(height: 20.0),
              Text(
                'Address',
                style: GoogleFonts.acme(fontSize: deviceWidth! * .06),
              ),
              const Divider(),
              _buildDetailRow(
                  'Land Mark',
                  labBasicDetailsController
                          .labBasicDetailsData.value.address?.city ??
                      ""),
              _buildDetailRow(
                  'City',
                  labBasicDetailsController
                          .labBasicDetailsData.value.address?.city ??
                      ""),
              _buildDetailRow(
                  'PinCode',
                  labBasicDetailsController
                          .labBasicDetailsData.value.address?.pinCode ??
                      ""),
              _buildDetailRow(
                  'District',
                  labBasicDetailsController
                          .labBasicDetailsData.value.address?.district ??
                      ""),
              _buildDetailRow(
                  'State',
                  labBasicDetailsController
                          .labBasicDetailsData.value.address?.state ??
                      ""),
              const SizedBox(height: 20.0),
              Text(
                'Bank Details',
                style: GoogleFonts.acme(fontSize: deviceWidth! * .06),
              ),
              const Divider(),
              _buildDetailRow(
                  'Account No',
                  labBasicDetailsController.labBasicDetailsData.value
                          .bankDetails?.accountNumber ??
                      ""),
              _buildDetailRow(
                  'IFSC Code',
                  labBasicDetailsController
                          .labBasicDetailsData.value.bankDetails?.ifscCode ??
                      ""),
              _buildDetailRow(
                  'Bank Name',
                  labBasicDetailsController
                          .labBasicDetailsData.value.bankDetails?.bankName ??
                      ""),
              _buildDetailRow(
                  'Branch Name',
                  labBasicDetailsController
                          .labBasicDetailsData.value.bankDetails?.branchName ??
                      ""),
              _buildDetailRow(
                  'Latitude',
                  labBasicDetailsController
                          .labBasicDetailsData.value.address?.geoPoint.latitude
                          .toString() ??
                      ""),
              _buildDetailRow(
                  'Longitude',
                  labBasicDetailsController
                          .labBasicDetailsData.value.address?.geoPoint.longitude
                          .toString() ??
                      ""),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.acme(fontSize: deviceWidth! * .05)),
          Text(value),
        ],
      ),
    );
  }
}
