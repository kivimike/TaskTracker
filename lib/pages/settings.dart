import 'package:flutter/material.dart';
import 'package:habit_tracker/components/navigation_bar.dart';

class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //centerTitle: true,
        backgroundColor: Colors.green.shade400,
        title: Container(
            child: Text('Settings',
                style: TextStyle(
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w400,
                    fontSize: 28))),
      ),
      drawer: SideNavigationBar(),
      backgroundColor: Colors.grey[300],
    );
  }
}
