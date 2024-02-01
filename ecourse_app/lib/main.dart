import 'package:ecourse_app/signup.dart';
import 'package:ecourse_app/home._screen.dart';
import 'package:ecourse_app/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

void main() {
 WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
    return MaterialApp(
      
      debugShowCheckedModeBanner: false,
      title: 'E-Learning App',
      theme: ThemeData(
        
        primarySwatch: Colors.purple,
      ),
       routes: {
        '/welcome': (context) => WelcomeScreen(), 
      },
      home: WelcomeScreen(),
   // home: const HomeScreen(),
    );
  },
  
    );
  }
}