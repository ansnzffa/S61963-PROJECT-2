import 'package:ecourse_app/user.dart';
import 'package:flutter/material.dart';
import 'package:ecourse_app/home._screen.dart'; // Adjust the import path as needed
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  static var routeName;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String _error = '';

  void loginUser() async {
    final url = Uri.https(
      'e-course-app-645d2-default-rtdb.asia-southeast1.firebasedatabase.app',
      'users.json',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        for (var user in data.keys) {
          if (data[user]['Username'] == usernameController.text &&
              data[user]['Password'] == passwordController.text) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomeScreen(username: usernameController.text),
              ),
            );
            return;
          }
        }

        setState(() {
          _error = 'The Email or Password is wrong';
        });
      }
    } catch (error) {
      print('Error during login request: $error');
      setState(() {
        _error =
            'An error occurred while trying to log in. Please try again later.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
        backgroundColor: Color.fromARGB(255, 196, 169, 215),
      ),
      // body: Container(
      //   decoration: BoxDecoration(
      //     image: DecorationImage(
      //       image: AssetImage("assets/images/back.jpeg"),
      //       fit: BoxFit.cover,
      //     ),
      //   ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16.0),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8.0),
              TextButton(
                onPressed: () {
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => ForgotPasswordScreen(),
                  //   ),
                  // );
                },
                child: Text('Forgot Password?'),
              ),
              SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: loginUser,
                child: Text('Login'),
              ),
              if (_error.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    _error,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              // Display entered username
              if (usernameController.text.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    'Entered Username: ${usernameController.text}',
                    style: TextStyle(fontSize: 16.0, color: Colors.black),
                  ),
                ),
            ],
          ),
        ),
      );
    
  }
}
