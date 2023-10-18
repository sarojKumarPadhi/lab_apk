import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PaymentDetails extends StatefulWidget {
  const PaymentDetails({Key? key}) : super(key: key);

  @override
  State<PaymentDetails> createState() => _PaymentDetailsState();
}

class _PaymentDetailsState extends State<PaymentDetails> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text('Payment Details'),
        backgroundColor: Colors.grey,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListTile(
                  title: Text(
                    'Patient Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Vikash Sharma'),
                ),
                ListTile(
                  title: Text(
                    'Address',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Punchkula sector 22'),
                ),
                ListTile(
                  title: Text(
                    'Distance',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('45 km'),
                ),
                ListTile(
                  title: Text(
                    'Earning',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('315 ₹', style: TextStyle(fontSize: 18)),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Lab',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Divish Clinical lab Zirakpur'),
                ),
                ListTile(
                  title: Text(
                    'Lab Address',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('Divish Clinical lab Zirakpur'),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Test Types',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('1. Urine Test'),
                      Text('2. Blood Test'),
                      Text('3. Stool test'),
                      Text('4. Biospy'),
                    ],
                  ),
                ),
                Divider(),
                ListTile(
                  title: Text(
                    'Total Transaction',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('7500 ₹', style: TextStyle(fontSize: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
