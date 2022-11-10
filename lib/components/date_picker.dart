import 'package:flutter/material.dart';

class MyDatePicker extends StatefulWidget {
  //final datetime;

  // const MyDatePicker({
  //   super.key,
  //   required this.datetime,
  // });

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

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: dateTime.hour, minute: dateTime.minute),
      );

  @override
  Widget build(BuildContext context) {
    String hours = dateTime.hour.toString().padLeft(2, '0');
    String minutes = dateTime.hour.toString().padLeft(2, '0');

    return Container(
      padding: EdgeInsets.only(top: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ElevatedButton(
                  onPressed: () async {
                    final date = await pickDate();
                    if (date == null) {
                      return; // cancelled
                    }

                    final newDateTime = DateTime(date.year, date.month,
                        date.day, dateTime.hour, dateTime.minute);

                    setState(() {
                      dateTime = newDateTime;
                    });
                  },
                  child: Text(
                      '${dateTime.day}/${dateTime.month}/${dateTime.year}')),
              Container(
                width: 10,
              ),
              ElevatedButton(
                  onPressed: () async {
                    final time = await pickTime();
                    if (time == null) {
                      return; // cancelled
                    }
                    final newDateTime = DateTime(dateTime.year, dateTime.month,
                        dateTime.day, time.hour, time.minute);
                    setState(() {
                      dateTime = newDateTime;
                    });
                  },
                  child: Text('${hours}:${minutes}')),
            ],
          )
        ],
      ),
    );
  }
}
