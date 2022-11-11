import 'package:flutter/material.dart';
import 'package:habit_tracker/components/date_picker.dart';

class MyAlertBox extends StatelessWidget {
  final controllerName;
  final controllerDescription;
  final String taskName;
  final String taskDescription;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const MyAlertBox({
    super.key,
    required this.controllerName,
    required this.controllerDescription,
    required this.taskName,
    required this.taskDescription,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.grey[200],
      insetPadding: EdgeInsets.only(
          bottom: MediaQuery.of(context).size.height*0.1,
      left: 0),
      contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      content: Column(children: [
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: TextField(
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
        TextField(
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
        MyDatePicker(),
      ]),
      actions: [
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0,),
          child: MaterialButton(
            onPressed: onSave,
            child: Text(
              "Save",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.green,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 2, bottom: 8),
          child: MaterialButton(
            onPressed: onCancel,
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.green,
          ),
        ),
      ],
    );
  }
}
