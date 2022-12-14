import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/material.dart';

class SingleDatetimePicker extends StatefulWidget {
  late DateTime datetime;
  final Function(DateTime?)? getDate;

  SingleDatetimePicker({
    super.key,
    required this.datetime,
    required this.getDate,
  });

  @override
  State<SingleDatetimePicker> createState() => _SingleDatetimePickerState();
}

class _SingleDatetimePickerState extends State<SingleDatetimePicker> {
  final TextEditingController _controller = TextEditingController();

  void showDateTimePicker() async {
    BottomPicker.dateTime(
      title: 'Set the task exact time and date',
      titleStyle: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 15,
        color: Colors.black,
      ),
      onSubmit: (date) {
        widget.datetime = date;
        widget.getDate!(widget.datetime);
        _controller.text =
            '${widget.datetime.day.toString().padLeft(2,'0')}/${widget.datetime.month.toString().padLeft(2,'0')}/${widget.datetime.year} ${widget.datetime.hour.toString().padLeft(2,'0')}:${widget.datetime.minute.toString().padLeft(2,'0')}';
        //print(widget.datetime);
      },
      onClose: () {
        //print('Picker closed');
      },
      pickerTextStyle: TextStyle(fontSize: 18, color: Colors.black87, letterSpacing: 2.0),
      use24hFormat: true,
      iconColor: Colors.black,
      minDateTime: DateTime(1900),
      maxDateTime: DateTime(2100),
      initialDateTime: widget.datetime,
      gradientColors: [Colors.green.shade200, Colors.green.shade200],
      backgroundColor: Colors.grey.shade200,
    ).show(context);
  }

  DateTime? dateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
        // ..text =
        //     'hh${widget.datetime.day.toString().padLeft(2,'0')}/${widget.datetime.month.toString().padLeft(2,'0')}/${widget.datetime.year} ${widget.datetime.hour.toString().padLeft(2,'0')}:${widget.datetime.minute.toString().padLeft(2,'0')}',
      textAlign: TextAlign.end,
      readOnly: true,
      onTap: showDateTimePicker,
      style: TextStyle(color: Colors.grey.shade600, letterSpacing: 1.1, fontSize: 14),
      decoration: InputDecoration(
        //contentPadding: EdgeInsets.all(0),
        hintText: '${widget.datetime.day.toString().padLeft(2,'0')}/${widget.datetime.month.toString().padLeft(2,'0')}/${widget.datetime.year} ${widget.datetime.hour.toString().padLeft(2,'0')}:${widget.datetime.minute.toString().padLeft(2,'0')}',
        hintStyle: TextStyle(color: Colors.grey.shade600, letterSpacing: 1.1, fontSize: 14),
        enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade200)),
        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.grey.shade200)),
      ),
    );
  }
}
