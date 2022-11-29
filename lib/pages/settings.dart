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
        body: Column(
          children: [
            GestureDetector(
              onTap: (){
              },
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                height: MediaQuery.of(context).size.height * 0.1,
                child: Row(
                  children: [
                    Text(
                      'Import data',
                      style: TextStyle(letterSpacing: 1.2, fontSize: 16),
                    ),
                    Spacer(),
                    Icon(Icons.upload,
                    color: Colors.grey.shade600,),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: (){print('object');},
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                child: Row(
                  children: [
                    Text(
                      'Export data',
                      style: TextStyle(letterSpacing: 1.2, fontSize: 16),
                    ),
                    Spacer(),
                    Icon(Icons.download,
                        color: Colors.grey.shade600),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
