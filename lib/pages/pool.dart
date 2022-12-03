import 'dart:io';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:habit_tracker/components/my_alert_box.dart';
import 'package:habit_tracker/components/my_fab.dart';
import 'package:habit_tracker/components/navigation_bar.dart';
import 'package:habit_tracker/components/pool_habit_tile.dart';
import 'package:habit_tracker/components/task_view.dart';
import 'package:habit_tracker/data/new_habit_database.dart';
import 'package:habit_tracker/notifications/local_notification_service.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Pool extends StatefulWidget {
  const Pool({Key? key}) : super(key: key);

  @override
  State<Pool> createState() => _PoolState();
}

class _PoolState extends State<Pool> {

  NewHabitDatabase db = NewHabitDatabase();
  // final _myBox = Hive.box("Habit_Database");
  late final LocalNotificationService service;
  DateTime _datetime = DateTime.now();
  final _newHabitNameController = TextEditingController();
  final _newHabitDescriptionController = TextEditingController();
  int mode = 0;
  //bool dateChangedFlag = false;

  @override
  void initState() {

    db.loadPoolData();
    db.updatePoolDatabase();
    service = LocalNotificationService();
    service.intialize();

    super.initState();
  }

  void getDate(datetime) {
    // dateChangedFlag = true;
    _datetime = datetime;
  }

  void createNewHabit(){
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controllerName: _newHabitNameController,
          controllerDescription: _newHabitDescriptionController,
          taskName: '',
          taskDescription: '',
          dateTime: _datetime,
          getDate: getDate,
          onSave: globalSave,
          onCancel: cancelDialogBox,
          poolToggleMode: mode,
          getMode: getMode,
        );
      },
    );
  }

  void getMode(index){
    mode = index;
  }

  void globalSave(){
    if (mode == 0){
      saveNewHabitToPool();
    } else {
      saveNewHabitToCalendar();
    }
    mode = 0;
  }

  void saveNewHabitToCalendar() async {
    int notification_id = math.Random().nextInt(1000000000);
    db.loadData(_datetime);
    // add new habit to todays habit list
      db.todaysHabitList.add({
        'taskName': _newHabitNameController.text,
        'taskCompleted': false,
        'taskDescription': _newHabitDescriptionController.text,
        'taskDateTime': _datetime,
        'inProgressStatus': false,
        'notification_id': notification_id,
      });
      db.updateDatabase(_datetime);
    if (_datetime.isAfter(DateTime.now()) == true) {
      await service.showScheduledNotification(
          id: notification_id,
          title: 'Tasks',
          body: _newHabitNameController.text,
          dateTime: _datetime.add(Duration(seconds: 10)));
    }

    // clear textfield
    _newHabitNameController.clear();
    _newHabitDescriptionController.clear();
    _datetime = DateTime.now();
    Navigator.of(context).pop();
  }

  void saveNewHabitToPool() async {

    // add new habit to todays habit list
    setState(() {
      db.pool.add({
        'taskName': _newHabitNameController.text,
        'taskCompleted': false,
        'taskDescription': _newHabitDescriptionController.text,
        'inProgressStatus': false,
      });
      db.updatePoolDatabase();
    });

    // clear textfield
    _newHabitNameController.clear();
    _newHabitDescriptionController.clear();
    _datetime = DateTime.now();
    Navigator.of(context).pop();
  }


  void readHabit(index){
    showDialog(
      context: context,
      builder: (context) {
        return TaskView(
          taskName: db.pool[index]['taskName'],
          taskContent: db.pool[index]['taskDescription'],
          dateTime: db.pool[index]['taskDateTime']?? DateTime.now(),
          duration: db.pool[index]['timeTaken'] ?? 0,
          onCancel: cancelDialogBox,
          poolMode: true,
        );
      },
    );
  }

  void writeTaskBeginDateTime(index) {
    if (db.pool[index]['workPeriods'] == null) {
      db.pool[index]['workPeriods'] = [
        [DateTime.now(), DateTime.now()]
      ];
    } else {
      db.pool[index]['workPeriods']
          .add([DateTime.now(), DateTime.now()]);
    }
  }

  void writeTaskEndDateTime(index) {
    DateTime curStart = db.pool[index]['workPeriods']
    [db.pool[index]['workPeriods'].length - 1][0];
    DateTime curEnd = DateTime.now();

    db.pool[index]['workPeriods']
    [db.pool[index]['workPeriods'].length - 1][1] = curEnd;
    if (db.pool[index]['timeTaken'] == null) {
      db.pool[index]['timeTaken'] =
          curEnd.difference(curStart).inMinutes;
    } else {
      db.pool[index]['timeTaken'] +=
          curEnd.difference(curStart).inMinutes;
    }
  }

  void changeProgressStatus(index){
    if (db.pool[index]['inProgressStatus'] == true) {
      setState(() {
        writeTaskEndDateTime(index);
        db.pool[index]['inProgressStatus'] = false;
      });
    } else if (db.pool[index]['inProgressStatus'] == false) {
      setState(() {
        writeTaskBeginDateTime(index);
        db.pool[index]['inProgressStatus'] = true;
      });
    }
    db.updatePoolDatabase();

  }

  void checkBoxTapped(value, index){
    if (value == true &&
        db.pool[index]['inProgressStatus'] == true) {
      changeProgressStatus(index);
    }
    if (value == true){
      DateTime date = DateTime.now();
      db.loadData(date);
      db.todaysHabitList.add(
          {
            'taskName': db.pool[index]['taskName'],
            'taskCompleted': true,
            'taskDescription': db.pool[index]['taskDescription'],
            'taskDateTime': DateTime.now(),
            'inProgressStatus': false,
            'workPeriods': db.pool[index]['workPeriods'],
            'timeTaken': db.pool[index]['timeTaken'],
          }
      );
      db.updateDatabase(date);
    }
    setState(() {
      db.pool[index]['taskCompleted'] = value;
      // deleteHabit(index);
    });
    db.updatePoolDatabase();
  }

  void openHabitSettings(index){
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controllerName: _newHabitNameController,
          controllerDescription: _newHabitDescriptionController,
          taskName: db.pool[index]['taskName'],
          taskDescription: db.pool[index]['taskDescription'],
          dateTime: _datetime,
          getDate: getDate,
          onSave: () => globalEdit(index),
          onCancel: cancelDialogBox,
          poolToggleMode: mode,
          getMode: getMode,
        );
      },
    );
  }

  void globalEdit(index){
    if (mode == 0){
      saveExistingHabit(index);
    } else {
      sendTaskToCalendar(index);
    }
    mode = 0;
  }

  void sendTaskToCalendar(index) async {
    int notification_id = math.Random().nextInt(1000000000);
    db.loadData(_datetime);
    db.todaysHabitList.add(
        {
          'taskName': _newHabitNameController.text,
          'taskCompleted': false,
          'taskDescription': _newHabitDescriptionController.text,
          'taskDateTime': _datetime,
          'inProgressStatus': false,
          'workPeriods': db.pool[index]['workPeriods'],
          'timeTaken': db.pool[index]['timeTaken'],
          'notification_id': notification_id,
        }
    );
    if (_datetime.isAfter(DateTime.now()) == true) {
      await service.showScheduledNotification(
          id: notification_id,
          title: 'Tasks',
          body: _newHabitNameController.text,
          dateTime: _datetime.add(Duration(seconds: 10)));
    }
    db.updateDatabase(_datetime);
    _newHabitNameController.clear();
    _newHabitDescriptionController.clear();
    _datetime = DateTime.now();
    Navigator.pop(context);
  }

  void saveExistingHabit(int index) async {
    setState(() {
      db.pool[index]['taskName'] = _newHabitNameController.text;
      db.pool[index]['taskDescription'] =
          _newHabitDescriptionController.text;
      db.updatePoolDatabase();
    });
    _newHabitNameController.clear();
    _newHabitDescriptionController.clear();
    _datetime = DateTime.now();
    Navigator.pop(context);
  }


  void deleteHabit(index){
    setState(() {
      db.pool.removeAt(index);
      db.loadPoolData();
      //print(db.todaysHabitList);
    });
    db.updatePoolDatabase();
  }

  // cancel new habit
  void cancelDialogBox() {

    _newHabitNameController.clear();
    _newHabitDescriptionController.clear();
    mode = 0;
    // pop dialog box
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //centerTitle: true,
          backgroundColor: Colors.green.shade400,
          title: Container(
              child: Text('Pool',
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
          // list of habits
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: db.pool.length + 1,
            itemBuilder: (context, index) {
              if (index < db.pool.length) {
                return GestureDetector(
                  onTap: () {
                    readHabit(index);
                  },
                  onLongPress: () {
                    changeProgressStatus(index);
                  },
                  child: PoolHabitTile(
                    habitName: db.pool[index]['taskName'],
                    habitCompleted: db.pool[index]['taskCompleted'],
                    onChanged: (value) => checkBoxTapped(value, index),
                    settingsTapped: (context) => openHabitSettings(index),
                    deleteTapped: (context) => deleteHabit(index),
                    inProgressStatus: db.pool[index]
                    ['inProgressStatus'],
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
