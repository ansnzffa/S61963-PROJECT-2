import 'dart:convert';
import 'package:ecourse_app/user.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class CourseEnrollmentScreen extends StatefulWidget {
  final User? user;

  CourseEnrollmentScreen({Key? key, required this.user}) : super(key: key);

  @override
  _CourseEnrollmentScreenState createState() =>
      _CourseEnrollmentScreenState();
}

class _CourseEnrollmentScreenState extends State<CourseEnrollmentScreen> {
  String? _selectedCourseId;
  String? _selectedCourseName;
  String? _selectedDate;
  String? _selectedDay;

  List<String> coursesId = [
    'CSM 3003',
    'CSF 3099',
    'CSF 2312'
  ];
  List<String> subjects = ['Object Oriented', 'Discrete Structure', 'Statistics'];

  Map<String, Map<String, String>> subjectDetails = {
    'Object Oriented': {'Time': '10:00 AM', 'Day': 'Monday'},
    'Discrete Structure': {'Time': '2:00 PM', 'Day': 'Wednesday'},
    'Statistics': {'Time': '4:00 PM', 'Day': 'Friday'},
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Course Enrollment'),
        backgroundColor: Color.fromARGB(255, 181, 130, 190),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedCourseId,
                hint: Text('Select Course Id'),
                items: coursesId.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCourseId = newValue;
                    _selectedCourseName= null;
                  });
                },
              ),
              SizedBox(height: 16.0),
              if (_selectedCourseId != null)
                DropdownButtonFormField<String>(
                  value: _selectedCourseName,
                  hint: Text('Select Course Name'),
                  items: subjects.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _selectedCourseName = newValue;
                      _selectedDate = subjectDetails[newValue!]!['Time'];
                      _selectedDay = subjectDetails[newValue!]!['Day'];
                    });
                    _showSubjectDetailsDialog();
                  },
                ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _addCourse,
                child: Text('Enroll'),
                style: ElevatedButton.styleFrom(
                  primary: const Color.fromARGB(255, 192, 122, 204),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addCourse() async {
    if (_selectedCourseId != null && _selectedCourseName != null) {
      final Map<String, dynamic> enrollmentData = {
        'course': _selectedCourseId,
        'subject': _selectedCourseName,
        'date': _selectedDate,
        'day': _selectedDay,
      };

      final url = Uri.https(
        'e-course-app-645d2-default-rtdb.asia-southeast1.firebasedatabase.app',
        'users/${widget.user?.username}/enrollments.json',
      );

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(enrollmentData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Enrollment successful!')),
          );
          setState(() {
            _selectedCourseId = null;
            _selectedCourseName = null;
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Failed to enroll. Status Code: ${response.statusCode}'),
            ),
          );
        }
      } catch (error) {
        print('Error: $error');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $error')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select both course and subject!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showSubjectDetailsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Subject Details'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailItem('Time', _selectedDate ?? 'N/A'),
              _buildDetailItem('Day', _selectedDay ?? 'N/A'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.0),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: '$label: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }
}
