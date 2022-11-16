import 'package:habit_tracker/datetime/date_time.dart';
import 'package:hive_flutter/hive_flutter.dart';

// reference our box
final _myBox = Hive.box("Habit_Database");

class NewHabitDatabase {
  List todaysHabitList = [];
  Map<DateTime, int> heatMapDataSet = {};
  double progress = 0;

  void sortList() {
    todaysHabitList.sort((a, b) {
      return a['taskDateTime'].compareTo(b['taskDateTime']);
    });
  }

  void getProgress(){
    double doneCounter = 0;
    for(int i = 0; i < todaysHabitList.length; ++i){
      if (todaysHabitList[i]['taskCompleted'] == true){
        doneCounter += 1;
      }
    }
    int length = todaysHabitList.length;
    if (todaysHabitList.length < 1){
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
        'inProgressStatus' : false,

      },
      {
        'taskName': "Tap me to open!",
        'taskCompleted': false,
        'taskDescription': "Tapping the tile will reveal information about the task",
        'taskDateTime': DateTime.now(),
        'inProgressStatus' : false,

      },
      {
        'taskName': "Swipe Left",
        'taskCompleted': false,
        'taskDescription': "Swipe left to edit or remove your task",
        'taskDateTime': DateTime.now(),
        'inProgressStatus' : false,

      },
      {
        'taskName': '"Plus" button',
        'taskCompleted': false,
        'taskDescription': 'Tap on a "plus" button to create your new task',
        'taskDateTime': DateTime.now(),
        'inProgressStatus' : false,

      },
      {
        'taskName': "Hold me!",
        'taskCompleted': false,
        'taskDescription': "Holding the task will change it's status to 'In Progress'",
        'taskDateTime': DateTime.now(),
        'inProgressStatus' : false,

      },
    ];

    _myBox.put("START_DATE", todaysDateFormatted());
  }

  // load data if it already exists
  void loadData(datetime) {
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
      if (dates.contains(convertDateTimeToString(todaysHabitList[i]['taskDateTime'])) ==
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
    calculateHabitPercentages();

    // load heat map
    loadHeatMap();
    getProgress();
  }

  void calculateHabitPercentages() {
    int countCompleted = 0;
    for (int i = 0; i < todaysHabitList.length; i++) {
      if (todaysHabitList[i]['taskCompleted'] == true) {
        countCompleted++;
      }
    }

    String percent = todaysHabitList.isEmpty
        ? '0.0'
        : (countCompleted / todaysHabitList.length).toStringAsFixed(1);

    // key: "PERCENTAGE_SUMMARY_yyyymmdd"
    // value: string of 1dp number between 0.0-1.0 inclusive
    _myBox.put("PERCENTAGE_SUMMARY_${todaysDateFormatted()}", percent);
  }

  void loadHeatMap() {
    DateTime startDate = createDateTimeObject(_myBox.get("START_DATE"));

    // count the number of days to load
    int daysInBetween = DateTime.now().difference(startDate).inDays;

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
      
      if (oldData != null){
        for (int j = 0; j < oldData.length; j++){
          newData.add({
            'taskName': oldData[j][0],
            'taskCompleted': oldData[j][1],
            'taskDescription': oldData[j][2],
            'taskDateTime': oldData[j][3],
            'inProgressStatus' : false,
          });
        }
        _myBox.put(yyyymmdd, newData);
      }

    }
    _myBox.put('VERSION', '0.0.1');
  }
}