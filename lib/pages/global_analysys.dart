import 'package:flutter/material.dart';
import 'package:habit_tracker/components/navigation_bar.dart';
import 'package:habit_tracker/data/new_habit_database.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DayInfo {
  DayInfo(this.dateTime, this.completed, this.total);

  final DateTime dateTime;
  final int completed;
  final int total;
}

class FancyIntString {
  final int value;
  FancyIntString(this.value);

  @override
  String toString() {
    if (value <  1000){
      return value.toString();
    } else if (value >= 1000 && value < 1000000) {
      int factor = (value / 1000).floor();
      return '${factor}k';
    } else if (value >= 1000000 && value < 1000000000){
      int factor = (value / 1000000).floor();
      return '${factor}M';
    } else if (value >= 1000000000){
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
    print('object');
  }

  List<DayInfo> getDayInfo(List dayInfo) {
    List<DayInfo> df = [];
    for (int i = 0; i < dayInfo.length; ++i) {
      df.add(DayInfo(
          dayInfo[i]['date'], dayInfo[i]['completed'], dayInfo[i]['total']));
    }
    return df;
  }
  
  int getTotalNumberOfTasks(List<DayInfo> df){
    int total = 0;
    for (int i = 0; i < df.length;++i){
      total += df[i].total;
    }
    return total;
  }

  int getNumberOfCompletedTasks(List<DayInfo> df){
    int completed = 0;
    for (int i = 0; i < df.length;++i){
      completed += df[i].completed;
    }
    return completed;
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
              crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 8.0, top: MediaQuery.of(context).size.height * 0.1),
              child: Text(
                'Total tasks: ${FancyIntString(getTotalNumberOfTasks(dayInfo)).toString()}',
                style: TextStyle(
                    fontSize: 32,
                  color: Colors.grey.shade600,
                  letterSpacing: 2
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: MediaQuery.of(context).size.height * 0.025),
              child: Text(
                'Tasks completed: ${FancyIntString(getNumberOfCompletedTasks(dayInfo)).toString()}',
                style: TextStyle(
                    fontSize: 32,
                    color: Colors.grey.shade600,
                  letterSpacing: 2
                ),
              ),
            ),
            Spacer(),
            SfCartesianChart(
              title: ChartTitle(text: "Let's see how do you perform in a long run", textStyle: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600
              )),
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
