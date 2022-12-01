import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/components/navigation_bar.dart';
import 'package:habit_tracker/data/new_habit_database.dart';
import 'package:permission_handler/permission_handler.dart';


class Settings extends StatelessWidget {
  const Settings({Key? key}) : super(key: key);

  Future<String?> pickFile() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null) {
      return result.files.single.path;
    } else {
      return null;
    }
  }

  Future<String?> pickDir() async {
    String? result =
    await FilePicker.platform.getDirectoryPath();
    if (result != null) {
      print(result);
      return result;
    } else {
      return null;
    }
  }


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
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              height: MediaQuery.of(context).size.height * 0.1,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      String? filePath = await pickFile();
                      if (filePath != null) {
                        await restoreHiveBox(
                            filePath);
                      }
                    },
                    child: Text(
                      'Import data',
                      style: TextStyle(color: Colors.grey.shade600, letterSpacing: 1.2, fontSize: 16),
                    ),
                  ),
                  Spacer(),
                  Icon(
                    Icons.download,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 16, right: 16),
              child: Row(
                children: [
                  TextButton(
                    onPressed: () async {
                      var status = await Permission.storage.status;
                      if (!status.isGranted) {
                        await Permission.storage.request();
                      }
                      String? dirPath = await pickDir();
                      if (dirPath != null){
                        print(dirPath);
                        await backupHiveBox(dirPath+'/${DateTime.now().year}${DateTime.now().month}${DateTime.now().day}.hive');
                      }
                    },
                    child: Text(
                      'Export data',
                      style: TextStyle(color: Colors.grey.shade600, letterSpacing: 1.2, fontSize: 16),
                    ),
                  ),
                  Spacer(),
                  Icon(Icons.upload, color: Colors.grey.shade600),
                ],
              ),
            ),
          ],
        ));
  }
}
