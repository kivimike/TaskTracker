import 'package:flutter/material.dart';

class TaskView extends StatelessWidget {
  final String taskName;
  final String taskContent;
  final VoidCallback onCancel;

  const TaskView(
      {super.key,
      required this.taskName,
      required this.taskContent,
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
              width: MediaQuery.of(context).size.width*0.8,
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
                        children: [
                          Expanded(
                            child: SingleChildScrollView(
                              child: SelectableText(taskName,
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
                        ]
                      ),
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
                        children: [Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: SelectableText(
                              taskContent,
                              maxLines: 15,
                              style: const TextStyle(
                                  color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                        ]
                      ),
                    ),
                    Container(
                      height: 5,
                    ),
                  Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
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
