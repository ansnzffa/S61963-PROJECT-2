import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController fullnameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  

  Future<void> signUp() async {
    final url = Uri.https(
      'e-course-app-645d2-default-rtdb.asia-southeast1.firebasedatabase.app',
      'users.json',
    );

    try {
      final response = await http.post(
        url,
        body: jsonEncode({
          'Username': usernameController.text,
          'Fullname': fullnameController.text,
          'EmailAddress': emailController.text,
          'Password': passwordController.text,
        
        }),
      );

      if (response.statusCode == 200) {
        // Registration successful
        _showRegistrationSuccessfulNotification();

        // Navigate to the welcome screen or any other screen
        Navigator.pushNamed(context, '/welcome');
      } else {
        // Registration failed, handle the error (you might want to show an error message)
        print('Failed to sign up. Status code: ${response.statusCode}');
      }
    } catch (error) {
      // Handle network or other errors
      print('Error during sign up: $error');
    }
  }

  void _showRegistrationSuccessfulNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Registration successful!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Widget _screen() {
    return Container(
      // decoration: BoxDecoration(
      //   image: DecorationImage(
      //     image: AssetImage("assets/images/back.jpeg"), // Change the path accordingly
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _inputField("Username", usernameController),
            const SizedBox(height: 10),
            _inputField("Fullname", fullnameController),
            const SizedBox(height: 10),
            _inputField("Email Address", emailController),
            const SizedBox(height: 10),
            _inputField("Password", passwordController, isPassword: true),
           
            const SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                signUp();
              },
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _inputField(String hintText, TextEditingController controller,
      {bool isPassword = false}) {
    var border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: Colors.white),
    );

    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: hintText,
        border: border,
        contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        labelText: hintText,
        labelStyle: TextStyle(
          fontWeight: FontWeight.bold,
        ),
        hintStyle: TextStyle(color: Colors.grey),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
        backgroundColor: Color.fromARGB(255, 196, 169, 215),
      ),
      body: _screen(),
    );
  }
}
