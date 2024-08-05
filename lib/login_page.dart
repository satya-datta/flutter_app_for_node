// ignore_for_file: prefer_const_constructors
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:login/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  final String phoneNumber;

  const LoginPage({Key? key, required this.phoneNumber}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _nameController.text = prefs.getString('name') ?? '';
    _ageController.text = prefs.getString('age') ?? '';
    _cityController.text = prefs.getString('city') ?? '';

    setState(() {});
  }

  Future<void> _saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', _nameController.text);
    await prefs.setString('age', _ageController.text);
    await prefs.setString('city', _cityController.text);
    await prefs.setString('phone', widget.phoneNumber);

    // Save to Firestore (uncomment if you are using Firestore)
    // await FirebaseFirestore.instance.collection('users').doc().set({
    //   'name': _nameController.text,
    //   'age': _ageController.text,
    //   'city': _cityController.text,
    //   'phoneNumber': widget.phoneNumber,
    // });
    var resbody = {
      "username": _nameController.text,
      "phonenumber": widget.phoneNumber,
      "age": _ageController.text,
      "city": _cityController.text
    };

    try {
      final url = 'https://node3-flutter-server.onrender.com/signup';
      var response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(resbody),
      );

      if (response.statusCode == 200) {
        print("Signup successful");
        Navigator.pushNamed(context, '/login');
      } else {
        print("Signup failed with status: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("An error occurred: $e");
    }

    // Set login variable to true in SharedPreferences
    await prefs.setBool('login', true);
  }

  bool _isFormComplete() {
    return _nameController.text.isNotEmpty &&
        _ageController.text.isNotEmpty &&
        _cityController.text.isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 40), // For spacing
            Text(
              'Enter your details',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 245, 233, 123), // Text color
              ),
            ),
            SizedBox(height: 20), // For spacing
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon:
                    Icon(Icons.person, color: Colors.black), // Icon color
                labelText: 'Full Name',
                labelStyle: TextStyle(
                    color: Color.fromARGB(255, 245, 233, 123)), // Label color
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              style: TextStyle(color: Colors.black), // Text color
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 20), // For spacing
            TextField(
              controller: _ageController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(Icons.cake, color: Colors.black), // Icon color
                labelText: 'Age',
                labelStyle: TextStyle(
                    color: Color.fromARGB(255, 245, 233, 123)), // Label color
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              style: TextStyle(color: Colors.black), // Text color
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 20), // For spacing
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                fillColor: Colors.white,
                filled: true,
                prefixIcon: Icon(Icons.location_city,
                    color: Colors.black), // Icon color
                labelText: 'City',
                labelStyle: TextStyle(
                    color: Color.fromARGB(255, 245, 233, 123)), // Label color
                border: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.black),
                ),
              ),
              style: TextStyle(color: Colors.black), // Text color
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 20), // For spacing
            Spacer(), // Push the button to the bottom
            Center(
              child: Container(
                width: double.infinity, // Button width
                child: ElevatedButton(
                  onPressed: _isFormComplete()
                      ? () async {
                          await _saveUserData();
                          Navigator.pushNamed(context, 'home');
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _isFormComplete()
                        ? const Color.fromARGB(255, 244, 167, 59)
                        : Colors.grey, // Button color
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                        color: Color.fromARGB(255, 250, 250, 250),
                        fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20), // For spacing at the bottom
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _cityController.dispose();
    super.dispose();
  }
}
