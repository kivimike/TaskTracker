import 'dart:math';

import 'package:flutter/material.dart';
import 'package:habit_tracker/components/routes.dart' as route;


class SideNavigationBar extends StatelessWidget {
  const SideNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          Material(
            elevation: 8,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.1015,
              color: Colors.green.shade400,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text(
              'Home',
              style: TextStyle(letterSpacing: 1.2, color: Colors.grey.shade600),
            ),
            onTap:() => Navigator.pushNamed(context, route.homePage),
          ),
          ListTile(
            leading: Transform.rotate(
                angle: pi / 2, child: Icon(Icons.bar_chart_outlined)),
            title: Text(
              'Day Analysis',
              style: TextStyle(letterSpacing: 1.2, color: Colors.grey.shade600),
            ),
            onTap:() => Navigator.pushNamed(context, route.dayAnalysis),
          ),
          ListTile(
            leading: Icon(Icons.show_chart),
            title: Text(
              'Global Analysis',
              style: TextStyle(letterSpacing: 1.2, color: Colors.grey.shade600),
            ),
            onTap:() => Navigator.pushNamed(context, route.globalAnalysis),
          ),
          ListTile(
            leading: Icon(Icons.list_alt_outlined),
            title: Text(
              'Pool',
              style: TextStyle(letterSpacing: 1.2, color: Colors.grey.shade600),
            ),
            onTap: () => Navigator.pushNamed(context, route.pool),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text(
              'Settings',
              style: TextStyle(letterSpacing: 1.2, color: Colors.grey.shade600),
            ),
            onTap: () => Navigator.pushNamed(context, route.settings),
          ),
        ],
      ),
    );
  }
}
