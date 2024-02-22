import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Datepicker extends StatefulWidget {
  const Datepicker({Key? key}) : super(key: key);

  @override
  State<Datepicker> createState() => _DatepickerState();
}

class _DatepickerState extends State<Datepicker> {
  final TextEditingController _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _openDatePicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200, // Customize the height of the bottom sheet
          child: Column(
            children: [
              const Text(
                'Select a Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 100, // Adjust the height as needed
                child: ListView.builder(
                  scrollDirection: Axis.vertical, // Change to vertical scrolling
                  itemCount: null, // Set it to null for an infinite list
                  itemBuilder: (context, index) {
                    final currentDate = DateTime.now().add(Duration(days: index));
                    final formattedDate = DateFormat('EEEE, MMM d').format(currentDate);
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedDate = currentDate;
                          _dateController.text =
                          "$formattedDate, ${currentDate.year}";
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 80, // Adjust the width of each date
                        margin: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: _selectedDate.day == currentDate.day
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '${currentDate.day}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: _selectedDate.day == currentDate.day
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                            Text(
                              DateFormat('EEEE').format(currentDate), // Day name (e.g., Sunday, Monday)
                              style: TextStyle(
                                color: _selectedDate.day == currentDate.day
                                    ? Colors.blue
                                    : Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Date Picker Example'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _dateController,
            onTap: () {
              _openDatePicker(context);
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(23),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
