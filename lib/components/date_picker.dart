import 'package:flutter/material.dart';

class MyDatePicker extends StatefulWidget {
  late DateTime datetime;
  final Function(DateTime?)? getDate;

  MyDatePicker({
    super.key,
    required this.datetime,
    required this.getDate,
  });

  @override
  State<MyDatePicker> createState() => _MyDatePickerState();
}

class _MyDatePickerState extends State<MyDatePicker> {
  DateTime dateTime = DateTime.now();

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));


  @override
  Widget build(BuildContext context) {

    return IconButton(
        onPressed: () async {
          final date = await pickDate();
          if (date == null) {
            return; // cancelled
          }

          final newDateTime = DateTime(date.year, date.month,
              date.day, dateTime.hour, dateTime.minute);

          setState(() {
            dateTime = newDateTime;
            widget.datetime = dateTime;
          });
          widget.getDate!(widget.datetime);
        },
        icon: Icon(
          Icons.calendar_today,
          color: Colors.black87,
        ));
  }
}
