import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecourse_app/user.dart';

class ExamResultScreen extends StatefulWidget {
  final User? user;

  ExamResultScreen({Key? key, required this.user}) : super(key: key);
   static String routeName ="ExamResultScreen";

  @override
  _ExamResultScreenState createState() => _ExamResultScreenState();
}
class _ExamResultScreenState extends State<ExamResultScreen> {
  final _formKey = GlobalKey<FormState>();

  late String _subject;
  late double _marks;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Results'),
        backgroundColor: const Color.fromARGB(255, 186, 140, 194),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    ' Exam Result',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Subject'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter subject';
                      }
                      return null;
                    },
                    onSaved: (value) => _subject = value!,
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    decoration: InputDecoration(labelText: 'Marks'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter marks';
                      }
                      final marks = double.tryParse(value);
                      if (marks == null || marks < 0 || marks > 100) {
                        return 'Please enter valid marks between 0 and 100';
                      }
                      return null;
                    },
                    onSaved: (value) => _marks = double.parse(value!),
                  ),
                  SizedBox(height: 24.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextButton(
                        onPressed: _saveResult,
                        child: Text('Save Result', style: TextStyle(fontSize: 16)),
                      ),
                      TextButton(
                        onPressed: _resetForm,
                        child: Text('Reset', style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveResult() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final Map<String, dynamic> resultData = {
        'subject': _subject,
        'marks': _marks,
      };

      final url = Uri.https(
        'e-course-app-645d2-default-rtdb.asia-southeast1.firebasedatabase.app',
        'users/${widget.user?.username}/examResults.json',
      );

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(resultData),
        );

        if (response.statusCode == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Result saved successfully!')),
          );
          _formKey.currentState!.reset();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Failed to save result. Status Code: ${response.statusCode}'),
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

  void _resetForm() {
    _formKey.currentState!.reset();
  }
}

