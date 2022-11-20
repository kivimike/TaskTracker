import 'package:flutter/material.dart';
import 'package:habit_tracker/components/navigation_bar.dart';
import 'package:habit_tracker/data/new_habit_database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DayInfo {
  DayInfo(this.dateTime, this.completed, this.total, this.timeSpent);

  final DateTime dateTime;
  final int completed;
  final int total;
  final int timeSpent;
}

class FancyDateString {
  final int minutes;

  FancyDateString(this.minutes);

  @override
  String toString() {
    if (minutes < 60) {
      return '${minutes.toString()} min';
    } else if (minutes < 1440) {
      return '${minutes ~/ 60}h ${minutes % 60}m';
    } else if (minutes < 525600) {
      return '${minutes ~/ 1440}d ${(minutes % 1440) ~/ 60}h';
    } else {
      return '${minutes ~/ 525600}y ${(minutes % 525600) ~/ 1440}d';
    }
  }
}

class FancyIntString {
  final int value;

  FancyIntString(this.value);

  @override
  String toString() {
    if (value < 1000) {
      return value.toString();
    } else if (value >= 1000 && value < 1000000) {
      int factor = (value / 1000).floor();
      return '${factor}k';
    } else if (value >= 1000000 && value < 1000000000) {
      int factor = (value / 1000000).floor();
      return '${factor}M';
    } else if (value >= 1000000000) {
      int factor = (value / 1000000000).floor();
      return '${factor}B';
    } else {
      return super.toString();
    }
  }
}

class GlobalAnalysis extends StatefulWidget {
  const GlobalAnalysis({Key? key}) : super(key: key);

  @override
  State<GlobalAnalysis> createState() => _GlobalAnalysisState();
}

class _GlobalAnalysisState extends State<GlobalAnalysis> {
  NewHabitDatabase db = NewHabitDatabase();
  TooltipBehavior _tooltipBehavior =
      TooltipBehavior(header: 'How do you perform in a  long run?');
  late List<DayInfo> dayInfo;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(
        enable: true, header: 'How do you perform in a  long run?');
    dayInfo = getDayInfo(db.getDaysResult());
  }

  List<DayInfo> getDayInfo(List dayInfo) {
    List<DayInfo> df = [];
    for (int i = 0; i < dayInfo.length; ++i) {
      df.add(DayInfo(dayInfo[i]['date'], dayInfo[i]['completed'],
          dayInfo[i]['total'], dayInfo[i]['timeSpent']));
    }
    return df;
  }

  int getTotalNumberOfTasks(List<DayInfo> df) {
    int total = 0;
    for (int i = 0; i < df.length; ++i) {
      total += df[i].total;
    }
    return total;
  }

  int getNumberOfCompletedTasks(List<DayInfo> df) {
    int completed = 0;
    for (int i = 0; i < df.length; ++i) {
      completed += df[i].completed;
    }
    return completed;
  }

  int getTotalTimeSpent(List<DayInfo> df) {
    int minutes = 0;
    for (int i = 0; i < df.length; ++i) {
      minutes += df[i].timeSpent;
    }
    return minutes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //centerTitle: true,
          backgroundColor: Colors.green.shade400,
          title: Container(
              child: Text('Global Analysis',
                  style: TextStyle(
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.w400,
                      fontSize: 28))),
        ),
        drawer: SideNavigationBar(),
        backgroundColor: Colors.grey[300],
        body: Center(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16.0, bottom: 16.0, top: 48.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        '${FancyIntString(getTotalNumberOfTasks(dayInfo)).toString()}',
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
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Tasks completed',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            letterSpacing: 2),
                      ),
                      Text(
                        '${FancyIntString(getNumberOfCompletedTasks(dayInfo)).toString()}',
                        style: TextStyle(
                            fontSize: 50,
                            color: Colors.grey.shade600,
                            letterSpacing: 2),
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
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total time spent',
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            letterSpacing: 2),
                      ),
                      Text(
                        FancyDateString(getTotalTimeSpent(dayInfo)).toString(),
                        style: TextStyle(
                            fontSize: 36,
                            color: Colors.grey.shade600,
                            letterSpacing: 2),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            SfCartesianChart(
                title: ChartTitle(
                    text: "Let's see how do you perform in a long run",
                    textStyle:
                        TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                primaryXAxis: DateTimeAxis(isVisible: false),
                primaryYAxis: (NumericAxis(isVisible: false)),
                tooltipBehavior: _tooltipBehavior,
                series: <ChartSeries>[
                  SplineAreaSeries<DayInfo, DateTime>(
                      dataSource: dayInfo,
                      xValueMapper: (DayInfo data, _) => data.dateTime,
                      yValueMapper: (DayInfo data, _) => data.total,
                      color: Colors.grey.shade400),
                  SplineAreaSeries<DayInfo, DateTime>(
                    dataSource: dayInfo,
                    xValueMapper: (DayInfo data, _) => data.dateTime,
                    yValueMapper: (DayInfo data, _) => data.completed,
                    color: Colors.green.shade300,
                  ),
                ]),
          ],
        )));
  }
}
