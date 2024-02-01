import 'dart:convert';

import 'package:ecourse_app/schedule_course.dart';
import 'package:flutter/material.dart';
import 'package:ecourse_app/course_enrollment.dart';
import 'package:ecourse_app/exam_results.dart';
import 'package:ecourse_app/add_course.dart';
import 'package:ecourse_app/user.dart'; // Import the User class
import 'package:ecourse_app/welcome_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.username});

  static String routeName = 'HomeScreen';

  final String username;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String username;
  User? user;

  @override
  void initState() {
    super.initState();
    username = widget.username;
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    try {
      final url = Uri.https(
        'e-course-app-645d2-default-rtdb.asia-southeast1.firebasedatabase.app',
        'users.json',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['user'] != null) {
          setState(() {
            user = User(
              fullName: data['user']['fullName'],
              username: data['user']['username'],
              email: data['user']['email'],
              password: data['user']['password'],
            );
          });
        }
      }
    } catch (error) {
      print('Error fetching user data: $error');
    }
  }

  void _openDrawer() {
    Scaffold.of(context).openDrawer();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          // title: Text('Home'),
          // backgroundColor: Color.fromARGB(255, 196, 169, 215),
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'DASHBOARD',
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(
                                  fontSize: 34.0,
                                  color: Colors.purple,
                                ),
                            textAlign: TextAlign.center,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text(
                              'Welcome, $username!',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                     
                      InkWell(
                        onTap: () {
                          // Navigate to profile or perform any action on profile tap
                        },
                        child: Container(
                          width: 50.0,
                          height: 50.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: const DecorationImage(
                              image: AssetImage('assets/images/profile.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 136, 27, 156),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          StudentDataCard(
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScheduleCourseScreen(user: user),
                                ),
                              );
                            },
                            icon: 'assets/icons/fee.svg',
                            title: 'Course Schedule',
                          ),
                          StudentDataCard(
                            onPress: () {
                              // Navigate to Assignments screen
                            },
                            icon: 'assets/icons/assignment.svg',
                            title: 'Assignments',
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          StudentDataCard(
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ExamResultScreen(user: user),
                                ),
                              );
                            },
                            icon: 'assets/icons/result.svg',
                            title: 'Result',
                          ),
                          StudentDataCard(
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CourseEnrollmentScreen(user: user),
                                ),
                              );
                            },
                            icon: 'assets/icons/datesheet.svg',
                            title: 'Course Enrollment',
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          StudentDataCard(
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddCourseScreen(user: user),
                                ),
                              );
                            },
                            icon: 'assets/icons/resume.svg',
                            title: 'Add Course',
                          ),
                          StudentDataCard(
                            onPress: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => WelcomeScreen(),
                                ),
                              );
                            },
                            icon: 'assets/icons/logout.svg',
                            title: 'Logout',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  
}

class StudentDataCard extends StatelessWidget {
  const StudentDataCard({
    Key? key,
    required this.onPress,
    required this.icon,
    required this.title,
  }) : super(key: key);

  final VoidCallback onPress;
  final String icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPress,
      child: Container(
        margin: const EdgeInsets.only(top: 8.0),
        width: 150.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 222, 166, 231),
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset(
              icon,
              width: 50.0,
              height: 50.0,
            ),
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.subtitle2,
            ),
          ],
        ),
      ),
    );
  }
}