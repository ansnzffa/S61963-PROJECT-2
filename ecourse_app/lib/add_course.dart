import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Import for DateFormat
import 'package:ecourse_app/user.dart';

class AddCourseScreen extends StatefulWidget {
  final User? user;

  AddCourseScreen({Key? key, required this.user}) : super(key: key);

  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  late User? _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  final _formKey = GlobalKey<FormState>();

  late String _course = ''; // Initialize with default value
  late String _subject = ''; // Initialize with default value
  late String _date = ''; // Initialize with default value
  late String _time = ''; // Initialize with default value
  late String _lecturer = ''; // Initialize with default value
  late String _venue= ''; // Initialize with default value

  late DateTime _selectedDateTime = DateTime.now(); // Initialize with current date

  Future<void> _selectDateTime(BuildContext context) async {
    final DateTime? pickedDateTime = await showDatePicker(
      context: context,
      initialDate: _selectedDateTime,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDateTime != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(_selectedDateTime),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDateTime.year,
            pickedDateTime.month,
            pickedDateTime.day,
            pickedTime.hour,
            pickedTime.minute,
          );

          _date = DateFormat('yyyy-MM-dd').format(_selectedDateTime);
          _time = DateFormat('HH:mm').format(_selectedDateTime);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Course'),
        backgroundColor: Color.fromARGB(255, 204, 155, 213),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Course Id'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter course';
                  }
                  return null;
                },
                onSaved: (value) => _course = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Course Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter course name';
                  }
                  return null;
                },
                onSaved: (value) => _subject = value!,
              ),
              GestureDetector(
                onTap: () => _selectDateTime(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Date & Time'),
                    controller: TextEditingController(
                      text: _selectedDateTime.toString(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select date and time';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _addCourse();
                  }
                },
                child: Text('Add Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addCourse() async {
    final Map<String, dynamic> courseData = {
      'course': _course,
      'subject': _subject,
      'date': _date,
      'time': _time,
      'lecturer': _lecturer,
      'venue': _venue,
    };

    final url = Uri.https(
      'e-course-app-645d2-default-rtdb.asia-southeast1.firebasedatabase.app',
      'users/${widget.user?.username ?? ''}/courses.json',
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(courseData),
      );

      if (response.statusCode == 200) {
        print('Response Body: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Course added successfully!')),
        );

        _formKey.currentState!.reset();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Failed to add course. Status Code: ${response.statusCode}'),
          ),
        );
      }
    } catch (error) {
      print('Error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
    }
  }
}
