import 'dart:io';
import 'package:hive/hive.dart';

import 'package:habit_tracker/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

// reference our box
var _myBox = Hive.box("Habit_Database");

Future<void> backupHiveBox<T>(String backupPath) async {

  final boxPath = _myBox.path;


  try {
    File(boxPath!).copy(backupPath);
  } finally {

  }
}

Future<void> restoreHiveBox<T>(String backupPath) async {
  final boxPath = _myBox.path;
  await _myBox.close();
  try {
    File(backupPath).copy(boxPath!);
  } finally {
    await Hive.openBox('Habit_Database');
    _myBox = Hive.box('Habit_Database');
  }
}

class NewHabitDatabase {
  List todaysHabitList = [];
  List pool = [];
  Map<DateTime, int> heatMapDataSet = {};
  double progress = 0;

  void sortList() {
    todaysHabitList.sort((a, b) {
      return a['taskDateTime'].compareTo(b['taskDateTime']);
    });
  }

  void getProgress() {
    double doneCounter = 0;
    for (int i = 0; i < todaysHabitList.length; ++i) {
      if (todaysHabitList[i]['taskCompleted'] == true) {
        if (todaysHabitList[i]['timesPostponed'] != null){
          doneCounter += 1 * (1 + todaysHabitList[i]['timesPostponed'] * 0.3);
        } else {
          doneCounter += 1;
        }
      }
    }

    double length = 0;
    for (int i = 0; i < todaysHabitList.length; ++i){
      if (todaysHabitList[i]['timesPostponed'] != null){
        double multiplier = todaysHabitList[i]['timesPostponed'] * 0.3;
        length += 1 * (1 + multiplier);
      } else {
        length += 1;
      }
    }

    if (todaysHabitList.length < 1) {
      length = 1;
    }
    progress = doneCounter / length;
    //print(progress);
  }

  // create initial default data
  void createDefaultData() {
    todaysHabitList = [
      {
        'taskName': "Task Name",
        'taskCompleted': false,
        'taskDescription': "Information about the task",
        'taskDateTime': DateTime.now(),
        'inProgressStatus': false,
      },
      {
        'taskName': "Tap me to open!",
        'taskCompleted': false,
        'taskDescription':
            "Tapping the tile will reveal information about the task",
        'taskDateTime': DateTime.now(),
        'inProgressStatus': false,
      },
      {
        'taskName': "Swipe Left",
        'taskCompleted': false,
        'taskDescription': "Swipe left to edit or remove your task",
        'taskDateTime': DateTime.now(),
        'inProgressStatus': false,
      },
      {
        'taskName': '"Plus" button',
        'taskCompleted': false,
        'taskDescription': 'Tap on a "plus" button to create your new task',
        'taskDateTime': DateTime.now(),
        'inProgressStatus': false,
      },
      {
        'taskName': "Hold me!",
        'taskCompleted': false,
        'taskDescription':
            "Holding the task will change it's status to 'In Progress'",
        'taskDateTime': DateTime.now(),
        'inProgressStatus': false,
      },
    ];

    _myBox.put("START_DATE", todaysDateFormatted());
  }

  void addYesterdaysTask() {
    if (_myBox.get('LastUpdate') != convertDateTimeToString(DateTime.now())) {
      List yesterdayList = _myBox.get(convertDateTimeToString(
              DateTime.now().subtract(Duration(days: 1)))) ??
          [];


      List todaysList = _myBox.get(convertDateTimeToString(DateTime.now())) ?? [];
      for(int i = 0; i < yesterdayList.length; ++i){
        if (yesterdayList[i]['taskCompleted'] == false){
          Map taskCopy = {
            'taskName': yesterdayList[i]['taskName'],
            'taskCompleted': false,
            'taskDescription': yesterdayList[i]['taskDescription'],
            'taskDateTime': yesterdayList[i]['taskDateTime'].add(Duration(days: 1)),
            'inProgressStatus': false,
            'timesPostponed': 0,
          };
          if(yesterdayList[i]['timesPostponed'] == null){
            taskCopy['timesPostponed'] = 1;
          } else {
            taskCopy['timesPostponed']++;
          }
          todaysList.add(taskCopy);
        }
      }
      _myBox.put(convertDateTimeToString(DateTime.now()), todaysList);
      _myBox.put('LastUpdate', convertDateTimeToString(DateTime.now()));
    }
  }

  void loadPoolData(){
    if (_myBox.get('POOL') == null){
      pool = [];
    } else {
      pool = _myBox.get('POOL');
    }
  }

  void updatePoolDatabase(){
    _myBox.put('POOL', pool);
  }
  
  // load data if it already exists
  void loadData(datetime) {
    addYesterdaysTask();
    // if it's a new day, get habit list from database
    if (_myBox.get(convertDateTimeToString(datetime)) == null) {
      // todaysHabitList = _myBox.get("CURRENT_HABIT_LIST");
      todaysHabitList = [];
      // set all habit completed to false since it's a new day
      for (int i = 0; i < todaysHabitList.length; i++) {
        todaysHabitList[i]['taskCompleted'] = false;
      }
    }
    // if it's not a new day, load todays list
    else {
      todaysHabitList = _myBox.get(convertDateTimeToString(datetime));
    }
    sortList();
    getProgress();
  }

  List filterByDate(String date) {
    List res = [];
    for (int i = 0; i < todaysHabitList.length; ++i) {
      if (convertDateTimeToString(todaysHabitList[i]['taskDateTime']) == date) {
        res.add(todaysHabitList[i]);
      }
    }
    return res;
  }

  List getDates(date) {
    List dates = [];
    for (int i = 0; i < todaysHabitList.length; ++i) {
      if (dates.contains(convertDateTimeToString(
                  todaysHabitList[i]['taskDateTime'])) ==
              false &&
          convertDateTimeToString(todaysHabitList[i]['taskDateTime']) !=
              convertDateTimeToString(date)) {
        dates.add(convertDateTimeToString(todaysHabitList[i]['taskDateTime']));
      }
    }
    return dates;
  }

  // update database
  void updateDatabase(date) {
    sortList();
    List dates = getDates(date);
    for (int i = 0; i < dates.length; i++) {
      if (_myBox.get(dates[i]) == null) {
        _myBox.put(dates[i], filterByDate(dates[i]));
      } else {
        List habitList = _myBox.get(dates[i]);
        _myBox.put(dates[i], habitList + filterByDate(dates[i]));
      }
    }
    todaysHabitList = filterByDate(convertDateTimeToString(date));
    //print(todaysHabitList);
    // update todays entry
    _myBox.put(convertDateTimeToString(date), todaysHabitList);

    // update universal habit list in case it changed (new habit, edit habit, delete habit)
    _myBox.put("CURRENT_HABIT_LIST", todaysHabitList);

    // calculate habit complete percentages for each day
    calculateHabitPercentages(date);

    // load heat map
    loadHeatMap();
    getProgress();
  }

  void calculateHabitPercentages(date) {
    double countCompleted = 0;
    for (int i = 0; i < todaysHabitList.length; i++) {
      if (todaysHabitList[i]['taskCompleted'] == true) {
        if (todaysHabitList[i]['timesPostponed'] != null) {
          double multiplier = todaysHabitList[i]['timesPostponed'] * 0.3;
          countCompleted += 1 * (1 + multiplier);
        } else {
          countCompleted += 1;
        }
      }
    }

    double length = 0;
    for (int i = 0; i < todaysHabitList.length; ++i){
      if (todaysHabitList[i]['timesPostponed'] != null){
        double multiplier = todaysHabitList[i]['timesPostponed'] * 0.3;
        length += 1 * (1 + multiplier);
      } else {
        length += 1;
      }
    }

    String percent = todaysHabitList.isEmpty
        ? '0.0'
        : (countCompleted / length).toStringAsFixed(1);

    // key: "PERCENTAGE_SUMMARY_yyyymmdd"
    // value: string of 1dp number between 0.0-1.0 inclusive
    _myBox.put("PERCENTAGE_SUMMARY_${convertDateTimeToString(date)}", percent);
  }

  int getTimeSpent(List taskList) {
    int timeSpent = 0;
    for (int i = 0; i < taskList.length; ++i) {
      int curTime = taskList[i]['timeTaken'] ?? 0;
      timeSpent += curTime;
    }
    return timeSpent;
  }

  List getDaysResult() {
    List result = [];
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));
    print(startDate);
    int daysInBetween = DateTime.now().difference(startDate).inDays;
    for (int i = 0; i < daysInBetween + 1; ++i) {
      List taskList =
          _myBox.get(convertDateTimeToString(startDate.add(Duration(days: i))))??[];
      int done = 0;
      for (int j = 0; j < taskList.length; ++j) {
        if (taskList[j]['taskCompleted'] == true) {
          done += 1;
        }
      }
      result.add({
        'total': taskList.length,
        'completed': done,
        'date': startDate.add(Duration(days: i)),
        'timeSpent': getTimeSpent(taskList),
      });
    }
    return result;
  }

  void loadHeatMap() {
    //DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));
    DateTime now = DateTime.now();
    DateTime referenceDate = DateTime(now.year, now.month, 1);
    DateTime startDate = referenceDate.subtract(Duration(days: 40));
    DateTime endDate = referenceDate.add(Duration(days: 40));
    // count the number of days to load
    int daysInBetween = endDate.difference(startDate).inDays;

    // go from start date to today and add each percentage to the dataset
    // "PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      double strengthAsPercent = double.parse(
        _myBox.get("PERCENTAGE_SUMMARY_$yyyymmdd") ?? "0.0",
      );

      // split the datetime up like below so it doesn't worry about hours/mins/secs etc.

      // year
      int year = startDate.add(Duration(days: i)).year;

      // month
      int month = startDate.add(Duration(days: i)).month;

      // day
      int day = startDate.add(Duration(days: i)).day;

      final percentForEachDay = <DateTime, int>{
        DateTime(year, month, day): (10 * strengthAsPercent).toInt(),
      };

      heatMapDataSet.addEntries(percentForEachDay.entries);
      //print(heatMapDataSet);
    }
  }

  void updateScript() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));
    // count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays + 90;

    // go from start date to today and add each percentage to the dataset
    // "PERCENTAGE_SUMMARY_yyyymmdd" will be the key in the database
    for (int i = 0; i < daysInBetween + 1; i++) {
      String yyyymmdd = convertDateTimeToString(
        startDate.add(Duration(days: i)),
      );

      var oldData = _myBox.get(yyyymmdd);
      List newData = [];

      if (oldData != null) {
        for (int j = 0; j < oldData.length; j++) {
          newData.add({
            'taskName': oldData[j][0],
            'taskCompleted': oldData[j][1],
            'taskDescription': oldData[j][2],
            'taskDateTime': oldData[j][3],
            'inProgressStatus': false,
          });
        }
        _myBox.put(yyyymmdd, newData);
      }
    }
    _myBox.put('VERSION', '0.0.1');
  }
}
