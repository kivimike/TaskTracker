import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class MyAlertBox extends StatelessWidget {
  final controllerName;
  final controllerDescription;
  final String taskName;
  final String taskContent;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const MyAlertBox(
      {super.key,
      required this.controllerName,
      required this.controllerDescription,
      required this.taskName,
      required this.taskContent,
      required this.onSave,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Padding(
        padding:
            const EdgeInsets.only(top: 20, bottom: 400.0, left: 30, right: 30),
        child: Material(
          borderRadius: BorderRadius.circular(30),
          elevation: 1,
          color: Colors.grey[100],
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            margin: EdgeInsets.all(30),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Material(
                    borderRadius: BorderRadius.circular(12),
                    elevation: 1,
                    color: Colors.grey[100],
                    child: TextField(
                      controller: controllerName..text = taskName,
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                          hintText: 'Enter the task ...',
                          hintStyle: TextStyle(color: Colors.black87),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(12))),
                    ),
                  ),
                  Container(
                    height: 5,
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(12),
                    elevation: 1,
                    color: Colors.grey[100],
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      minLines: 1,
                      maxLines: 7,
                      controller: controllerDescription..text = taskContent,
                      style: const TextStyle(color: Colors.black87),
                      decoration: InputDecoration(
                          hintText: 'Describe ...',
                          hintStyle: TextStyle(color: Colors.black87),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12),
                              borderRadius: BorderRadius.circular(12))),
                    ),
                  ),
                  Container(
                    height: 5,
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                          onPressed: () {
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                theme: DatePickerTheme(
                                    backgroundColor: Colors.white,
                                    doneStyle: TextStyle(color: Colors.green),
                                    itemStyle: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 3.0)),
                                minTime: DateTime(2022, 1, 1),
                                //TODO write a custom and connect to the calendar
                                maxTime: DateTime(2100, 12, 31),
                                onChanged: (date) {
                            }, onConfirm: (date) {
                              print('confirm $date');
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                          },
                          child: Text(
                            'Select time',
                            style: TextStyle(color: Colors.black45),
                          )),
                      Spacer(),
                      MaterialButton(
                        onPressed: onSave,
                        child: Text(
                          'Save',
                          style: TextStyle(color: Colors.grey.shade100),
                        ),
                        color: Colors.green,
                      ),
                      Container(
                        width: 5,
                      ),
                      MaterialButton(
                        onPressed: onCancel,
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey.shade100),
                        ),
                        color: Colors.green,
                      )
                    ],
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
