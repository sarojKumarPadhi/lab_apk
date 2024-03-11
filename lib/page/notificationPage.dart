import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jonk_lab/global/color.dart';
import 'package:jonk_lab/global/globalData.dart';

import '../controller/test_menu_controller.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage>with SingleTickerProviderStateMixin {
  List<String> notifications =
      []; // Replace with your actual list of notifications
  TestMenuController testMenuController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: const Text('Notifications'),
        titleTextStyle: GoogleFonts.acme(
          fontSize: deviceWidth! * .07,
          color: Colors.black,
          letterSpacing: 1,
        ),
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.notifications_off,
                    size: 80.0,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'No notifications available',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Notification ${index + 1}'),
                  subtitle: Text(notifications[index]),
                  leading: const Icon(Icons.notifications),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
                 showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return Container(
                  padding: EdgeInsets.all(16.0),
                  child: ListView.builder(
                    itemCount: testMenuController.testMenuList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          ListTile(
                            leading: Image.network(
                              testMenuController.testMenuList[index].imageUrl,
                              width: deviceWidth! * 0.1,
                              height: deviceWidth! * 0.1,
                            ),
                            title: Text(
                              testMenuController.testMenuList[index].testSampleName,
                              style: TextStyle(fontSize: 16.0),
                            ),
                            trailing: Checkbox(
                              value: false,
                              onChanged: (value) {
                                // Handle checkbox change here
                              },
                            ),
                          ),
                          Divider(), // Add a divider between items
                        ],
                      );
                    },
                  ),
                );
              },
            );
          },


          child: Icon(Icons.add),
      ),
    );
  }
}
