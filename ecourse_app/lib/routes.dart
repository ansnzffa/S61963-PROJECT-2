import 'package:ecourse_app/login.dart';
// import 'package:flutter/cupertino.dart';
// import 'screens/assignment_screen/assignment_screen.dart';
// import 'screens/datesheet_screen/datesheet_screen.dart';
import 'package:ecourse_app/home._screen.dart';
import 'package:ecourse_app/course_enrollment.dart';
import 'package:ecourse_app/exam_results.dart';
import 'package:ecourse_app/add_course.dart';
import 'package:ecourse_app/user.dart';
import 'package:ecourse_app/welcome_screen.dart';
import 'package:flutter/material.dart';


Map<String, WidgetBuilder> routes = {
  //all screens will be registered here like manifest in android
  LoginScreen.routeName: (context) => LoginScreen(),
  HomeScreen.routeName: (context) =>  const HomeScreen(username: '',),
  // ProfileScreen.routeName: (context) => ProfileScreen(username: '',),
  // AssignmentScreen.routeName: (context) => AssignmentScreen(),
  // DateSheetScreen.routeName: (context) => DateSheetScreen(),
  WelcomeScreen.routeName:(context) => const WelcomeScreen(),
  //ExamResultScreen.routeName:(context) =>  ExamResultScreen(),
  

};
