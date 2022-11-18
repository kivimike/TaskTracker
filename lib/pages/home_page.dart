import 'package:flutter/material.dart';
import 'package:habit_tracker/components/date_picker.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/components/month_summary.dart';
import 'package:habit_tracker/components/my_fab.dart';
import 'package:habit_tracker/components/my_alert_box.dart';
import 'package:habit_tracker/components/progress_bar.dart';
import 'package:habit_tracker/data/habit_database.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../components/task_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");

  @override
  void initState() {
    // if there is no current habit list, then it is the 1st time ever opening the app
    // then create default data
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    }

    // there already exists data, this is not the first time
    else {
      db.loadData(_datetime);
    }

    // update the database
    db.updateDatabase(_datetime);

    //db.getProgress();

    super.initState();
  }

  // checkbox was tapped
  void checkBoxTapped(bool? value, int index) {
    if (value == true && db.todaysHabitList[index][4] == true){
      changeProgressStatus(index);

    }
    setState(() {
      db.todaysHabitList[index][1] = value;
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
  void saveNewHabit() {
    updateSheetDateTime();

    late DateTime newDate;
    //print(dateChangedFlag);
    if (dateChangedFlag == true) {
      newDate = _datetime;
    } else {
      newDate = _sheetDateTime;
    }
    dateChangedFlag = false;

    // add new habit to todays habit list
    setState(() {
      db.todaysHabitList.add([
        _newHabitNameController.text,
        false,
        _newHabitDescriptionController.text,
        newDate, false,
      ]);
    });

    // clear textfield
    _newHabitNameController.clear();
    _newHabitDescriptionController.clear();
    _datetime = DateTime.now();
    //print(_datetime);
    // pop dialog box
    Navigator.of(context).pop();
    db.updateDatabase(_sheetDateTime);
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
          taskName: db.todaysHabitList[index][0],
          taskDescription: db.todaysHabitList[index][2],
          dateTime: db.todaysHabitList[index][3],
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
          taskName: db.todaysHabitList[index][0],
          taskContent: db.todaysHabitList[index][2],
          dateTime: db.todaysHabitList[index][3],
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  // save existing habit with a new name
  void saveExistingHabit(int index) {
    late DateTime newDate;
    //print(dateChangedFlag);
    if (dateChangedFlag == true) {
      newDate = _datetime;
    } else {
      newDate = db.todaysHabitList[index][3];
    }
    dateChangedFlag = false;
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
      db.todaysHabitList[index][2] = _newHabitDescriptionController.text;
      db.todaysHabitList[index][3] = newDate;
    });
    _newHabitNameController.clear();
    _newHabitDescriptionController.clear();
    _datetime = DateTime.now();
    Navigator.pop(context);
    db.updateDatabase(_sheetDateTime);
  }

  // delete habit
  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
      db.loadData(_sheetDateTime);
      //print(db.todaysHabitList);
    });
    db.updateDatabase(_sheetDateTime);
  }

  void changeProgressStatus(index) {
    if (db.todaysHabitList[index].length < 5) {
      setState(() {
        db.todaysHabitList[index].add(true);
      });
    } else if (db.todaysHabitList[index][4] == true) {
      setState(() {
        db.todaysHabitList[index][4] = false;
      });
    } else if (db.todaysHabitList[index][4] == false) {
      setState(() {
        db.todaysHabitList[index][4] = true;
      });
    }
    db.updateDatabase(_sheetDateTime);
    //print(db.todaysHabitList[index][4]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(onPressed: createNewHabit),
      body: ListView(
        children: [
          // monthly summary heat map
          MonthlySummary(
            datasets: db.heatMapDataSet,
            startDate: _myBox.get("START_DATE"),
            getDate: setDate,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                progressBar(
                    progress: db.progress,
                    length: db.todaysHabitList.length + 1),
                MyDatePicker(datetime: _sheetDateTime, getDate: setDate)
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
                    habitName: db.todaysHabitList[index][0],
                    habitCompleted: db.todaysHabitList[index][1],
                    dateTime: db.todaysHabitList[index][3],
                    onChanged: (value) => checkBoxTapped(value, index),
                    settingsTapped: (context) => openHabitSettings(index),
                    deleteTapped: (context) => deleteHabit(index),
                    inProgressStatus: db.todaysHabitList[index][4],
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
