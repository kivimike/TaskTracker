import 'package:flutter/material.dart';

class MyDateTimePicker extends StatefulWidget {
  late DateTime datetime;
  final Function(DateTime?)? getDate;

  MyDateTimePicker({
    super.key,
    required this.datetime,
    required this.getDate,
  });

  @override
  State<MyDateTimePicker> createState() => _MyDateTimePickerState();
}

class _MyDateTimePickerState extends State<MyDateTimePicker> {
  //DateTime dateTime = DateTime.now();

  Future<DateTime?> pickDate() => showDatePicker(
      context: context,
      initialDate: widget.datetime,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100));

  Future<TimeOfDay?> pickTime() => showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: widget.datetime.hour, minute: widget.datetime.minute),
      );

  @override
  Widget build(BuildContext context) {
    String hours = widget.datetime.hour.toString().padLeft(2, '0');
    String minutes = widget.datetime.minute.toString().padLeft(2, '0');

    return Container(
      padding: EdgeInsets.only(top: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              MaterialButton(
                elevation: 1,
                //was an Elevated Button
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  color: Colors.green,
                  onPressed: () async {
                    final date = await pickDate();
                    if (date == null) {
                      return; // cancelled
                    }

                    final newDateTime = DateTime(date.year, date.month,
                        date.day, widget.datetime.hour, widget.datetime.minute);

                    setState(() {
                      // dateTime = newDateTime;
                      // widget.datetime = dateTime;
                      widget.datetime = newDateTime;
                    });
                    widget.getDate!(widget.datetime);
                  },
                  child: Text(
                      '${widget.datetime.day}/${widget.datetime.month}/${widget.datetime.year}',
                  style: TextStyle(
                    color: Colors.grey[200]
                  ),)),
              Container(
                width: 10,
              ),
              MaterialButton(
                elevation: 1,
                //was an Elevated Button
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  color: Colors.green,

                  onPressed: () async {
                    final time = await pickTime();
                    if (time == null) {
                      return; // cancelled
                    }
                    final newDateTime = DateTime(widget.datetime.year, widget.datetime.month,
                        widget.datetime.day, time.hour, time.minute);
                    setState(() {
                      // dateTime = newDateTime;
                      // widget.datetime = dateTime;
                      widget.datetime = newDateTime;
                    });
                    widget.getDate!(widget.datetime);
                  },
                  child: Text('${hours}:${minutes}',
                  style: TextStyle(
                    color: Colors.grey[200],
                  ),)),
            ],
          )
        ],
      ),
    );
  }
}
