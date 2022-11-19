import 'package:flutter/material.dart';

import 'package:habit_tracker/pages/settings.dart';
import 'package:habit_tracker/pages/day_analysis.dart';
import 'package:habit_tracker/pages/global_analysys.dart';
import 'package:habit_tracker/pages/new_home_page.dart';

const String homePage = 'home';
const String dayAnalysis = 'dayAnalysis';
const String globalAnalysis = 'globalAnalysis';
const String settings = 'settings';

Route<dynamic> controller(RouteSettings routeSettings){
  switch (routeSettings.name){
    case homePage:
      return MaterialPageRoute(builder: (context)=>NewHomePage());
    case dayAnalysis:
      return MaterialPageRoute(builder: (context)=>DayAnalysis());
    case globalAnalysis:
      return MaterialPageRoute(builder: (context)=>GlobalAnalysis());
    case settings:
      return MaterialPageRoute(builder: (context)=>Settings());
    default:
      throw('Path does not exist');
  }
}

