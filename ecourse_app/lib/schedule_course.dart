import 'dart:convert';
import 'package:ecourse_app/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScheduleCourseScreen extends StatefulWidget {
  final User? user;

   ScheduleCourseScreen({Key? key, required this.user}) : super(key: key);

  @override
  _ScheduleCourseScreenState createState() => _ScheduleCourseScreenState();
}

class _ScheduleCourseScreenState extends State<ScheduleCourseScreen> {
  late Future<List<dynamic>> _fetchScheduledCourses;

  @override
  void initState() {
    super.initState();
    _fetchScheduledCourses = _getScheduledCourses();
  }

  Future<List<dynamic>> _getScheduledCourses() async {
    final url = Uri.https(
      'e-course-app-645d2-default-rtdb.asia-southeast1.firebasedatabase.app',
      'users/${widget.user?.username ?? ''}/courses.json',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        if (response.body == 'null') {
          return []; // Return an empty list if data is null
        }

        final Map<String, dynamic> data = json.decode(response.body);

        if (data is Map<String, dynamic>) {
          return data.values.toList();
        } else {
          throw Exception('Unexpected data format');
        }
      } else {
        throw Exception('Failed to load scheduled courses. Status Code: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error: $error');
    }
  }

  Future<void> _refreshSchedule() async {
    setState(() {
      _fetchScheduledCourses = _getScheduledCourses();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scheduled Courses'),
        backgroundColor: const Color.fromARGB(255, 186, 140, 194),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshSchedule,
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _fetchScheduledCourses,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final List<dynamic> scheduledCourses = snapshot.data ?? [];

            return ListView.builder(
              itemCount: scheduledCourses.length,
              itemBuilder: (context, index) {
                final course = scheduledCourses[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  child: ListTile(
                    title: Text('Course: ${course['course']}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Subject: ${course['subject']}'),
                        Text('Date: ${course['date'] ?? 'N/A'}'),
                        //Text('Day: ${course['day'] ?? 'N/A'}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
