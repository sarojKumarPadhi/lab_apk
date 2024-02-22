import 'package:flutter/material.dart';
import 'package:colorful_safe_area/colorful_safe_area.dart';
import 'package:jonk_lab/drawer_item/payment/payment_details.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/global/globalData.dart';
import '../../Global/date_picker.dart';

class EarningsScreen extends StatefulWidget {
  @override
  _EarningsScreenState createState() => _EarningsScreenState();
}

class _EarningsScreenState extends State<EarningsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
              child: TabBar(

                tabs: [
                  SizedBox(
                     width: deviceWidth!*.5,
                      child: const Tab(text: 'Today')),
                  SizedBox(
                      width: deviceWidth!*.3,
                      child: const Tab(text: 'History')),
                ],
                unselectedLabelColor: Colors.blue,
                labelColor: Colors.white,
                indicator: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(deviceWidth!*.01),
                ),
                labelStyle: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.9,
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  EarningsTab(title: 'Today', earningsData: todayEarningsData),
                  EarningsTab(title: 'History', earningsData: historyEarningsData),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EarningsTab extends StatefulWidget {
  final String title;
  final List<EarningItem> earningsData;

  EarningsTab({required this.title, required this.earningsData});

  @override
  _EarningsTabState createState() => _EarningsTabState();
}

class _EarningsTabState extends State<EarningsTab> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        if (widget.title == 'History')
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Yesterday',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  selectDate(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.date_range_sharp,
                    size: 32.0,
                    color: Colors.blue,
                  ),
                ),
              )
            ],
          ),
        ListView.builder(
          itemCount: widget.earningsData.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final item = widget.earningsData[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => PaymentDetails(),));
                    },
                    title: Text(
                      'Patient Name: John Doe',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Location: Punchkula sector 22'),
                        Row(
                          children: [
                            Text('Earnings: \$${item.amount.toStringAsFixed(2)}'),
                            SizedBox(width: 10,),
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Icon(Icons.close, color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class EarningItem {
  final String date;
  final double amount;

  EarningItem({required this.date, required this.amount});
}

final todayEarningsData = [
  EarningItem(date: '2023-09-28', amount: 45.75),
  EarningItem(date: '2023-09-27', amount: 52.10),
];

final historyEarningsData = [
  EarningItem(date: '2023-09-26', amount: 37.50),
  EarningItem(date: '2023-09-25', amount: 60.25),
  // Add more items for earnings history
];
