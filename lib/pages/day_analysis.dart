import 'package:flutter/material.dart';
import 'package:habit_tracker/components/date_picker.dart';
import 'package:habit_tracker/components/navigation_bar.dart';
import 'package:habit_tracker/data/new_habit_database.dart';
import 'package:habit_tracker/datetime/date_time.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Task {
  Task(this.taskName, this.timeTaken, this.inProgressStatus);

  final String taskName;
  final int timeTaken;
  final bool inProgressStatus;
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

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true, header: 'Task');
    _selectionBehavior = SelectionBehavior(enable: true, selectedColor: Colors.green.shade200, unselectedColor: Colors.grey.shade400);
    db.loadData(_dateTime);
  }

  void setDate(datetime){
    setState((){
      _dateTime = datetime;
    });
  }

  List<Task> getTasks() {
    db.loadData(_dateTime);
    List<Task> tasks = [];
    //print(dbTasks);
    for (int i = 0; i < db.todaysHabitList.length; ++i) {
      tasks.add(Task(
          db.todaysHabitList[i]['taskName'],//.replaceAll(' ', '\n'),
          db.todaysHabitList[i]['timeTaken'] ?? 0,
          db.todaysHabitList[i]['inProgressStatus']));
      //print(dbTasks[i]);
    }
    tasks.sort((a, b) {
      return a.timeTaken.compareTo(b.timeTaken);
    });
    return tasks;
  }

  @override
  Widget build(BuildContext context) {
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
          actions: [MyDatePicker(datetime: _dateTime, getDate: setDate)],
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
                    dataSource: getTasks(),
                    xValueMapper: (var tasks, _) => tasks.taskName,
                    yValueMapper: (var tasks, _) => tasks.timeTaken,
                    dataLabelSettings: DataLabelSettings(isVisible: true, textStyle: TextStyle(color: Colors.grey.shade500)),
                    //selectionBehavior: _selectionBehavior,
                    color: Colors.green.shade300,
                  )
                ]),
          ],
        ),
    );
  }
}
