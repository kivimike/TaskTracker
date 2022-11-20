import 'package:flutter/material.dart';
import 'package:habit_tracker/Formaters/fancy_date_string.dart';
import 'package:habit_tracker/Formaters/fancy_int_string.dart';
import 'package:habit_tracker/components/date_picker.dart';
import 'package:habit_tracker/components/navigation_bar.dart';
import 'package:habit_tracker/data/new_habit_database.dart';
import 'package:habit_tracker/datetime/date_time.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Task {
  Task(
      this.taskName, this.timeTaken, this.inProgressStatus, this.taskCompleted);

  final String taskName;
  final int timeTaken;
  final bool inProgressStatus;
  final bool taskCompleted;
}

class DayAnalysis extends StatefulWidget {
  @override
  State<DayAnalysis> createState() => _DayAnalysisState();
}

class _DayAnalysisState extends State<DayAnalysis> {
  NewHabitDatabase db = NewHabitDatabase();
  TooltipBehavior _tooltipBehavior = TooltipBehavior(header: 'Task');
  late SelectionBehavior _selectionBehavior;

  DateTime _dateTime = DateTime.now();
  late List<Task> dayList;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, header: 'Task');
    _selectionBehavior = SelectionBehavior(
        enable: true,
        selectedColor: Colors.green.shade200,
        unselectedColor: Colors.grey.shade400);
    db.loadData(_dateTime);
    dayList = getTasks();
  }

  void setDate(datetime) {
    setState(() {
      _dateTime = datetime;
    });
  }

  List<Task> getTasks() {
    db.loadData(_dateTime);
    List<Task> tasks = [];
    //print(dbTasks);
    for (int i = 0; i < db.todaysHabitList.length; ++i) {
      tasks.add(Task(
        db.todaysHabitList[i]['taskName'], //.replaceAll(' ', '\n'),
        db.todaysHabitList[i]['timeTaken'] ?? 0,
        db.todaysHabitList[i]['inProgressStatus'],
        db.todaysHabitList[i]['taskCompleted'],
      ));
      //print(dbTasks[i]);
    }
    tasks.sort((a, b) {
      return a.timeTaken.compareTo(b.timeTaken);
    });
    return tasks;
  }

  int getNumberOfCompletedTasks(List<Task> df) {
    int completed = 0;
    for (int i = 0; i < df.length; ++i) {
      if (df[i].taskCompleted == true) {
        completed += 1;
      }
    }
    return completed;
  }

  int getTimeSpent(List<Task> df) {
    int timeSpent = 0;
    for (int i = 0; i < df.length; ++i) {
      timeSpent += df[i].timeTaken;
    }
    return timeSpent;
  }

  @override
  Widget build(BuildContext context) {
    dayList = getTasks();
    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        backgroundColor: Colors.green.shade400,
        title: Container(
            child: Text('Day Analysis',
                style: TextStyle(
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w400,
                    fontSize: 28))),
        actions: [MyDatePicker(datetime: _dateTime, getDate: setDate, color: Colors.white,)],
      ),
      drawer: SideNavigationBar(),
      backgroundColor: Colors.grey[300],
      body: Column(
        children: [
          SfCartesianChart(
              enableMultiSelection: true,
              // Initialize category axis
              primaryXAxis: CategoryAxis(
                isVisible: false,
              ),
              primaryYAxis: NumericAxis(
                labelFormat: '{value} Min',
                isVisible: false,
              ),
              tooltipBehavior: _tooltipBehavior,
              series: <BarSeries<dynamic, String>>[
                BarSeries<dynamic, String>(
                  // Bind data source
                  dataSource: dayList,
                  xValueMapper: (var tasks, _) => tasks.taskName,
                  yValueMapper: (var tasks, _) => tasks.timeTaken,
                  dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      textStyle: TextStyle(color: Colors.grey.shade500)),
                  //selectionBehavior: _selectionBehavior,
                  color: Colors.green.shade300,
                )
              ]),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, bottom: 16.0, top: 48.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total tasks',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                          letterSpacing: 2),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${FancyIntString(dayList.length).toString()}',
                      style: TextStyle(
                          fontSize: 50,
                          color: Colors.grey.shade600,
                          letterSpacing: 2),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, bottom: 16.0, top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Tasks completed',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                          letterSpacing: 2),
                      textAlign: TextAlign.center,
                    ),
                    Text(
                      '${FancyIntString(getNumberOfCompletedTasks(dayList)).toString()}',
                      style: TextStyle(
                          fontSize: 50,
                          color: Colors.grey.shade600,
                          letterSpacing: 2),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, bottom: 8.0, top: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Total time spent',
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey.shade600,
                          letterSpacing: 2),
                    ),
                    Text(
                      FancyDateString(getTimeSpent(dayList)).toString(),
                      style: TextStyle(
                          fontSize: 26,
                          color: Colors.grey.shade600,
                          letterSpacing: 2),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
