import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LabProfilePage extends StatefulWidget {
  @override
  State<LabProfilePage> createState() => _LabProfilePageState();
}

class _LabProfilePageState extends State<LabProfilePage>{



  String? accountStatus;
  String? name;
  String? province;
  String? mobile;
  String email="hello.lab@gmail.com";
  String? landMark;
  String? city;
  String? pinCode;
  String? district;
  String? state;
  String? AC;
  String? IfscCode;
  String? bankName;
  String? branchName;

  String? auth = FirebaseAuth.instance.currentUser?.uid;
  Future FetchData() async {
    await FirebaseFirestore.instance.collection("laboratory").doc(auth).get().then((value){
      final data=value.data() as Map<String,dynamic>;
  setState(() {
  accountStatus=data["AacountStatus"].toString();
  name=data["LabDetails"]["labName"].toString();
  province=data["LabDetails"]["selectProvince"].toString();
  mobile=data["Number"].toString();

     });

    });
  }

  @override
  void initState() { FetchData();
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey,
        title: Text("Lab Profile",style: TextStyle(fontWeight: FontWeight.w100,fontSize: 35),),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Account Status",
                    style:
                    TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Text(accountStatus.toString(), style:
                TextStyle(fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.red)),
              ],

            ),
            Divider(),

            SizedBox(
              height: 10,
            ),
            Text(
              'Lab Details',
              style: TextStyle(
                fontSize: 21.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            _buildDetailRow('Name', name.toString()),
            _buildDetailRow('Province', province.toString()),
            _buildDetailRow('Mobile No', mobile.toString()),
            _buildDetailRow('Email id', email),
            SizedBox(height: 20.0),
            Text('Address',
              style: TextStyle(
                fontSize: 21.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            _buildDetailRow('Land Mark', 'Village'),
            _buildDetailRow('City', 'Panchkula'),
            _buildDetailRow('PinCode', '111213'),
            _buildDetailRow('District', 'Panchkula'),
            _buildDetailRow('State', 'Hriyana'),
            SizedBox(height: 20.0),
            Text(
              'Bank Details',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            _buildDetailRow('Account No', '9876543210'),
            _buildDetailRow('IFSC Code', 'ABCD1234567'),
            _buildDetailRow('Bank Name', 'Bank of Example'),
            _buildDetailRow('Branch Name', 'City Branch'),
          ],
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
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}