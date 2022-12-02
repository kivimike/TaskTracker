import 'package:flutter/material.dart';
import 'package:habit_tracker/components/date_picker.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/components/month_summary.dart';
import 'package:habit_tracker/components/my_fab.dart';
import 'package:habit_tracker/components/my_alert_box.dart';
import 'package:habit_tracker/components/navigation_bar.dart';
import 'package:habit_tracker/components/progress_bar.dart';
import 'package:habit_tracker/data/new_habit_database.dart';
import 'package:habit_tracker/notifications/local_notification_service.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:math' as math;


import '../components/task_view.dart';

class NewHomePage extends StatefulWidget {
  const NewHomePage({super.key});

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  NewHabitDatabase db = NewHabitDatabase();
  final _myBox = Hive.box("Habit_Database");
  late final LocalNotificationService service;

  @override
  void initState() {
    service = LocalNotificationService();
    service.intialize();

    // if there is no current habit list, then it is the 1st time ever opening the app
    // then create default data

    if (_myBox.get("VERSION") == null) {
      db.createDefaultData();
      _myBox.put('VERSION', '0.0.1');
    }
    // else if (_myBox.get('VERSION') == null){
    //   db.updateScript();
    //   db.loadData(_datetime);
    // }

    // there already exists data, this is not the first time
    else {
      // db.addYesterdaysTask();
      db.loadData(_datetime);
    }

    // update the database
    db.updateDatabase(_datetime);

    //db.getProgress();

    super.initState();
  }

  // checkbox was tapped
  void checkBoxTapped(bool? value, int index) {
    if (value == true &&
        db.todaysHabitList[index]['inProgressStatus'] == true) {
      changeProgressStatus(index);
    }
    setState(() {
      db.todaysHabitList[index]['taskCompleted'] = value;
    });
    db.updateDatabase(_sheetDateTime);
    //db.getProgress();
  }

  // create a new habit
  final _newHabitNameController = TextEditingController();
  final _newHabitDescriptionController = TextEditingController();

  DateTime _datetime = DateTime.now();
  DateTime _sheetDateTime = DateTime.now();
  bool dateChangedFlag = false;

  DateTime updateSheetDateTime() {
    DateTime now = DateTime.now();
    _sheetDateTime = DateTime(_sheetDateTime.year, _sheetDateTime.month,
        _sheetDateTime.day, now.hour, now.minute, now.second);
    return _sheetDateTime;
  }

  void createNewHabit() {
    // show alert dialog for user to enter the new habit details
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controllerName: _newHabitNameController,
          controllerDescription: _newHabitDescriptionController,
          taskName: '',
          taskDescription: '',
          dateTime: updateSheetDateTime(),
          getDate: getDate,
          onSave: saveNewHabit,
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  // save new habit
  void saveNewHabit() async {
    updateSheetDateTime();

    late DateTime newDate;
    //print(dateChangedFlag);
    if (dateChangedFlag == true) {
      newDate = _datetime;
    } else {
      newDate = _sheetDateTime;
    }
    dateChangedFlag = false;

    int notification_id = math.Random().nextInt(1000000000);
    // add new habit to todays habit list
    setState(() {
      db.todaysHabitList.add({
        'taskName': _newHabitNameController.text,
        'taskCompleted': false,
        'taskDescription': _newHabitDescriptionController.text,
        'taskDateTime': newDate,
        'inProgressStatus': false,
        'notification_id': notification_id,
      });
      db.updateDatabase(_sheetDateTime);
    });
    if (newDate.isAfter(DateTime.now()) == true) {
      await service.showScheduledNotification(
          id: notification_id,
          title: 'Tasks',
          body: _newHabitNameController.text,
          dateTime: newDate.add(Duration(seconds: 10)));
    }

    // clear textfield
    _newHabitNameController.clear();
    _newHabitDescriptionController.clear();
    _datetime = DateTime.now();
    Navigator.of(context).pop();
  }

  // cancel new habit
  void cancelDialogBox() {
    // clear textfield
    _newHabitNameController.clear();
    _newHabitDescriptionController.clear();

    // pop dialog box
    Navigator.of(context).pop();
  }

  // open habit settings to edit
  void openHabitSettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controllerName: _newHabitNameController,
          controllerDescription: _newHabitDescriptionController,
          taskName: db.todaysHabitList[index]['taskName'],
          taskDescription: db.todaysHabitList[index]['taskDescription'],
          dateTime: db.todaysHabitList[index]['taskDateTime'],
          getDate: getDate,
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  void getDate(datetime) {
    dateChangedFlag = true;
    _datetime = datetime;
  }

  void setDate(datetime) {
    _sheetDateTime = datetime;
    setState(() {
      db.loadData(datetime);
    });
  }

  void readHabit(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return TaskView(
          taskName: db.todaysHabitList[index]['taskName'],
          taskContent: db.todaysHabitList[index]['taskDescription'],
          dateTime: db.todaysHabitList[index]['taskDateTime'],
          duration: db.todaysHabitList[index]['timeTaken'] ?? 0,
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  void rescheduleOne(index) async {
    DateTime oldDate = db.todaysHabitList[index]['taskDateTime'];
    DateTime newDate = oldDate.add(Duration(days: 1));
    await rescheduleNotification(index, newDate, db.todaysHabitList[index]['taskName']);
    setState(() {
      db.todaysHabitList[index]['taskDateTime'] = newDate;
    });
    db.updateDatabase(_sheetDateTime);
  }

  void rescheduleTwo(index) async {
    DateTime oldDate = db.todaysHabitList[index]['taskDateTime'];
    DateTime newDate = oldDate.add(Duration(days: 2));
    await rescheduleNotification(index, newDate, db.todaysHabitList[index]['taskName']);
    setState(() {
      db.todaysHabitList[index]['taskDateTime'] = newDate;
    });
    db.updateDatabase(_sheetDateTime);
  }

  Future<void> rescheduleNotification(index, DateTime newDate, String taskName) async {
    if (db.todaysHabitList[index]['notification_id'] == null) {
      int notification_id = math.Random().nextInt(1000000000);
      db.todaysHabitList[index]['notification_id'] = notification_id;
      if (newDate.isAfter(DateTime.now())) {
        await service.showScheduledNotification(
            id: notification_id,
            title: 'Tasks',
            body: taskName,
            dateTime: newDate);
      }
    } else {
      await service
          .deleteNotification(db.todaysHabitList[index]['notification_id']);
      if (newDate.isAfter(DateTime.now())) {
        await service.showScheduledNotification(
            id: db.todaysHabitList[index]['notification_id'],
            title: 'Tasks',
            body: taskName,
            dateTime: newDate);
      }
    }
  }

  // save existing habit with a new name
  void saveExistingHabit(int index) async {
    late DateTime newDate;
    //print(dateChangedFlag);
    if (dateChangedFlag == true) {
      newDate = _datetime;
    } else {
      newDate = db.todaysHabitList[index]['taskDateTime'];
    }
    await rescheduleNotification(index, newDate, _newHabitNameController.text);
    dateChangedFlag = false;
    setState(() {
      db.todaysHabitList[index]['taskName'] = _newHabitNameController.text;
      db.todaysHabitList[index]['taskDescription'] =
          _newHabitDescriptionController.text;
      db.todaysHabitList[index]['taskDateTime'] = newDate;
      db.updateDatabase(_sheetDateTime);
    });
    _newHabitNameController.clear();
    _newHabitDescriptionController.clear();
    _datetime = DateTime.now();
    Navigator.pop(context);
  }

  // delete habit
  void deleteHabit(int index) async {
    if (db.todaysHabitList[index]['notification_id'] != null &&
        db.todaysHabitList[index]['taskDateTime'].isAfter(DateTime.now())) {
      await service
          .deleteNotification(db.todaysHabitList[index]['notification_id']);
    }
    setState(() {
      db.todaysHabitList.removeAt(index);
      db.loadData(_sheetDateTime);
      //print(db.todaysHabitList);
    });
    db.updateDatabase(_sheetDateTime);
  }

  void writeTaskBeginDateTime(index) {
    if (db.todaysHabitList[index]['workPeriods'] == null) {
      db.todaysHabitList[index]['workPeriods'] = [
        [DateTime.now(), DateTime.now()]
      ];
    } else {
      db.todaysHabitList[index]['workPeriods']
          .add([DateTime.now(), DateTime.now()]);
    }
  }

  void writeTaskEndDateTime(index) {
    DateTime curStart = db.todaysHabitList[index]['workPeriods']
        [db.todaysHabitList[index]['workPeriods'].length - 1][0];
    DateTime curEnd = DateTime.now();

    db.todaysHabitList[index]['workPeriods']
        [db.todaysHabitList[index]['workPeriods'].length - 1][1] = curEnd;
    if (db.todaysHabitList[index]['timeTaken'] == null) {
      db.todaysHabitList[index]['timeTaken'] =
          curEnd.difference(curStart).inMinutes;
    } else {
      db.todaysHabitList[index]['timeTaken'] +=
          curEnd.difference(curStart).inMinutes;
    }
  }

  void changeProgressStatus(index) {
    if (db.todaysHabitList[index]['inProgressStatus'] == true) {
      setState(() {
        writeTaskEndDateTime(index);
        db.todaysHabitList[index]['inProgressStatus'] = false;
      });
    } else if (db.todaysHabitList[index]['inProgressStatus'] == false) {
      setState(() {
        writeTaskBeginDateTime(index);
        db.todaysHabitList[index]['inProgressStatus'] = true;
      });
    }
    db.updateDatabase(_sheetDateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        backgroundColor: Colors.green.shade400,
        title: Container(
            child: Text('Tasks',
                style: TextStyle(
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w400,
                    fontSize: 28))),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('${DateTime.now().day.toString().padLeft(2,'0')}.${DateTime.now().month.toString().padLeft(2,'0')}',
                style: TextStyle(
                  color: Colors.grey.shade200,
                  fontSize: 16
                ),),
                Container(
                  color: Colors.grey.shade200,
                  height: 1,
                  width: 36,
                ),
                Text('${DateTime.now().year}',
                  style: TextStyle(
                      color: Colors.grey.shade200,
                      fontSize: 16,
                    letterSpacing: 1.2
                  ),),
              ],
            ),
          )
        ],
      ),
      drawer: SideNavigationBar(),
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      body: ListView(
        children: [
          // monthly summary heat map
          MonthlySummary(
            datasets: db.heatMapDataSet,
            startDate: _myBox.get("START_DATE"),
            getDate: (value) => setDate(value),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                progressBar(
                    progress: db.progress,
                    length: db.todaysHabitList.length + 1),
                MyDatePicker(datetime: _sheetDateTime, getDate: setDate, color: Colors.grey.shade800,)
              ],
            ),
          ),

          // list of habits
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: db.todaysHabitList.length + 1,
            itemBuilder: (context, index) {
              if (index < db.todaysHabitList.length) {
                return GestureDetector(
                  onTap: () {
                    readHabit(index);
                  },
                  onLongPress: () {
                    changeProgressStatus(index);
                  },
                  child: HabitTile(
                    habitName: db.todaysHabitList[index]['taskName'],
                    habitCompleted: db.todaysHabitList[index]['taskCompleted'],
                    dateTime: db.todaysHabitList[index]['taskDateTime'],
                    onChanged: (value) => checkBoxTapped(value, index),
                    settingsTapped: (context) => openHabitSettings(index),
                    deleteTapped: (context) => deleteHabit(index),
                    plusOne:(context) => rescheduleOne(index),
                    plusTwo:(context) => rescheduleTwo(index),
                    inProgressStatus: db.todaysHabitList[index]
                        ['inProgressStatus'],
                    timesPostponed: db.todaysHabitList[index]['timesPostponed'],
                  ),
                );
              } else {
                return Container(
                    height: MediaQuery.of(context).size.height * 0.1);
              }
            },
          )
        ],
      ),
    );
  }
}
