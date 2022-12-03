import 'package:flutter/material.dart';
import 'package:habit_tracker/components/date_time_picker.dart';
import 'package:habit_tracker/components/single_date_time_picker.dart';
import 'package:toggle_switch/toggle_switch.dart';

class MyAlertBox extends StatelessWidget {
  final controllerName;
  final controllerDescription;
  String taskName;
  String taskDescription;
  late DateTime dateTime;
  final Function(DateTime?)? getDate;
  final VoidCallback onSave;
  final VoidCallback onCancel;
  int poolToggleMode;
  final Function(int?) getMode;


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
    required this.poolToggleMode,
    required this.getMode,
  });

  @override
  Widget build(BuildContext context) {
    void getTime(datetime) {
      dateTime = datetime;
      print(dateTime);
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
            onChanged: (text){taskName = controllerName.text;},
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
            onChanged: (text){taskDescription = controllerDescription.text;},
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
       Container(height: 6,),
        Row(
          children: [ Spacer(),
            ToggleSwitch(
              minWidth: 78,
              initialLabelIndex: poolToggleMode,
              cornerRadius: 12.0,
              activeFgColor: Colors.grey.shade600,
              inactiveBgColor: Colors.grey.shade400,
              inactiveFgColor: Colors.grey.shade600,
              totalSwitches: 2,
              fontSize: 12,
              labels: ['Pool', 'Schedule'],
              activeBgColors: [[Colors.green.shade200],[Colors.green.shade200]],
              onToggle: (index) {
                getMode(index);
              },
            ),
          ],
        ),
       // MyDateTimePicker(datetime: dateTime, getDate: getTime),
        SingleDatetimePicker(datetime: dateTime, getDate: getDate),
      ]),
      actions: [
        Padding(
          padding: const EdgeInsets.only(
            bottom: 8.0,
          ),
          child: IconButton(
            // elevation: 1,
            // shape:
            //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onPressed: onSave,
            // child: Text(
            //   "Save",
            //   style: TextStyle(color: Colors.grey.shade200),
            // ),
            icon: Icon(Icons.save_outlined),
            color: Colors.green.shade400,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8.0, left: 2, bottom: 8),
          child: IconButton(
            // elevation: 1,
            // shape:
            //     RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            onPressed: onCancel,
            icon: Icon(Icons.cancel_outlined),
            // child: Text(
            //   "Cancel",
            //   style: TextStyle(color: Colors.grey.shade200),
            // ),
            color: Colors.red.shade400,
          ),
        ),
      ],
    );
  }
}
