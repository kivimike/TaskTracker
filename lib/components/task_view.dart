import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TaskView extends StatelessWidget {
  final String taskName;
  final String taskContent;
  final DateTime dateTime;
  final VoidCallback onCancel;

  const TaskView(
      {super.key,
      required this.taskName,
      required this.taskContent,
      required this.dateTime,
      required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: Padding(
        //padding: const EdgeInsets.only(top: 20, bottom: 100.0, left: 30, right: 30),
        padding: EdgeInsets.all(16),
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
                    elevation: 0,
                    color: Colors.grey[100],
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: SelectableText(
                                taskName,
                                minLines: 1,
                                maxLines: 5,
                                style: const TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    letterSpacing: 2),
                              ),
                            ),
                          ),
                          Material(
                            color: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Container(
                              margin: EdgeInsets.all(4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SelectableText(
                                    '${dateTime.day.toString().padLeft(2, '0')}.${dateTime.month.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                        color: Colors.grey.shade200),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        height: 1,
                                        width: 10,
                                        color: Colors.grey.shade200,
                                      ),
                                      SelectableText(
                                        '${dateTime.year}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400,
                                            letterSpacing: 2,
                                            color: Colors.grey.shade200),
                                      ),
                                      Container(
                                        height: 1,
                                        width: 10,
                                        color: Colors.grey.shade200,
                                      ),
                                    ],
                                  ),
                                  SelectableText(
                                    '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 2,
                                        color: Colors.grey.shade200),
                                  ),
                                ],
                              ),
                            ),
                          )
                        ]),
                  ),
                  Container(
                    height: 5,
                  ),
                  Container(
                    height: 1,
                    width: MediaQuery.of(context).size.width * 0.8,
                    color: Colors.black87,
                  ),
                  Container(
                    height: 5,
                  ),
                  Material(
                    borderRadius: BorderRadius.circular(12),
                    elevation: 0,
                    color: Colors.grey[100],
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: SelectableText(
                                taskContent,
                                maxLines: 15,
                                style: const TextStyle(
                                  color: Colors.black87,
                                  letterSpacing: 1,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ]),
                  ),
                  Container(
                    height: 5,
                  ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () async {
                          await Clipboard.setData(ClipboardData(
                              text: '${taskName}\n${taskContent}'));
                        },
                        icon: Icon(Icons.copy),
                      ),
                      MaterialButton(
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        onPressed: onCancel,
                        child: Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey.shade200),
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
