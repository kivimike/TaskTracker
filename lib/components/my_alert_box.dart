import 'package:flutter/material.dart';
import 'package:habit_tracker/components/date_picker.dart';

class MyAlertBox extends StatelessWidget {
  final controllerName;
  final controllerDescription;
  final String taskName;
  final String taskDescription;
  late DateTime dateTime;
  final Function(DateTime?)? getDate;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  MyAlertBox({
    super.key,
    required this.controllerName,
    required this.controllerDescription,
    required this.taskName,
    required this.taskDescription,
    required this.dateTime,
    required this.getDate,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    void getTime(datetime) {
      dateTime = datetime;
      getDate!(datetime);
    }

    return AlertDialog(
      backgroundColor: Colors.grey[200],
      insetPadding: EdgeInsets.only(left: 0),
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Column(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: TextField(
            autofocus: true,
            minLines: 1,
            maxLines: 2,
            controller: controllerName..text = taskName,
            style: const TextStyle(color: Colors.black87),
            decoration: InputDecoration(
              hintText: 'Enter the task ...',
              hintStyle: TextStyle(color: Colors.grey[600]),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12)),
            ),
          ),
        ),
        Container(
          height: 6,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: TextField(
            autofocus: true,
            controller: controllerDescription..text = taskDescription,
            style: const TextStyle(color: Colors.black87),
            minLines: 1,
            maxLines: 10,
            decoration: InputDecoration(
              hintText: 'Describe ...',
              hintStyle: TextStyle(color: Colors.grey[600]),
              enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12)),
              focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12)),
            ),
          ),
        ),
        MyDatePicker(datetime: DateTime.now(), getDate: getTime),
      ]),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8.0,
          ),
          child: MaterialButton(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onPressed: onSave,
            child: Text(
              "Save",
              style: TextStyle(color: Colors.grey.shade200),
            ),
            color: Colors.green,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 2, bottom: 8),
          child: MaterialButton(
            elevation: 1,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onPressed: onCancel,
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.grey.shade200),
            ),
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
