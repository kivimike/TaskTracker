import 'package:flutter/material.dart';
import 'package:habit_tracker/components/MyFloatActionButton.dart';
import 'package:habit_tracker/components/habit_tile.dart';
import 'package:habit_tracker/components/month_summary.dart';
import 'package:habit_tracker/components/my_alert_box.dart';
import 'package:habit_tracker/components/task_view.dart';
import 'package:habit_tracker/data/habit_database.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box('Habit_Database');

  @override
  void initState() {
    db.createDefaultData();
    // if there is no current habit list, then its first time opening the app
    if (_myBox.get('CURRENT_HABIT_LIST') == null){
      db.createDefaultData();
    } else {
      db.loadData();
    }

    // update db
    db.updateDatabase();

    super.initState();
  }

  // habit name controller
  final _NewHabitNameController = TextEditingController();

  // habit description controller
  final _NewHabitDescriptionController = TextEditingController();

  // set value on checkbox tap
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todayHabitList[index][1] = value;
    });
    db.updateDatabase();
  }

  // create new habit item
  void creatNewHabbit() {
    // show alert dialog for creating a new habbit
    showDialog(
        context: context,
        builder: (context) {
          return MyAlertBox(
            controllerName: _NewHabitNameController,
            controllerDescription: _NewHabitDescriptionController,
            taskName: '',
            taskContent: '',
            onSave: saveNewHabit,
            onCancel: cancelDialogBox,
          );
        });
    db.updateDatabase();
  }

  // save new habit
  void saveNewHabit() {
    // add habit to the habit list
    setState(() {
      db.todayHabitList.add([_NewHabitNameController.text, false, _NewHabitDescriptionController.text]);
    });

    // clear textfield
    _NewHabitNameController.clear();
    _NewHabitDescriptionController.clear();

    // pop dialog box
    Navigator.of(context).pop();

    db.updateDatabase();
  }

  // cancel new habit

  void cancelDialogBox() {
    // clear textfield
    _NewHabitNameController.clear();
    _NewHabitDescriptionController.clear();
    // pop dialog box
    Navigator.of(context).pop();
  }

  // open edit habit settings
  void openHabitSettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controllerName: _NewHabitNameController,
          controllerDescription: _NewHabitDescriptionController,
          taskName: db.todayHabitList[index][0],
          taskContent: db.todayHabitList[index][2],
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  void readHabit(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return TaskView(
          taskName: db.todayHabitList[index][0],
          taskContent: db.todayHabitList[index][2],
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  void deleteHabit(int index) {
    setState(() {
      db.todayHabitList.removeAt(index);
    });
    db.updateDatabase();
  }

  void saveExistingHabit(int index) {
    setState(() {
      db.todayHabitList[index][0] = _NewHabitNameController.text;
      db.todayHabitList[index][2] = _NewHabitDescriptionController.text;

    });
    _NewHabitNameController.clear();
    _NewHabitDescriptionController.clear();
    Navigator.pop(context);
    db.updateDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: MyFloatingActionButton(
        onPressed: creatNewHabbit,
      ),
      body: ListView(
        children: [
          MonthlySymmary(datasets: db.heatMapDataSet, startDate: _myBox.get('START_DATE')),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: db.todayHabitList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onDoubleTap: (){
                  readHabit(index);
                },
                child: HabitTile(
                  habitName: db.todayHabitList[index][0],
                  habitCompleted: db.todayHabitList[index][1],
                  onChanged: (value) => checkBoxTapped(value, index),
                  settingsTapped: (context) => openHabitSettings(index),
                  deleteTapped: (context) => deleteHabit(index),
                ),
              );
            }),
        ]
      ),
    );
  }
}
