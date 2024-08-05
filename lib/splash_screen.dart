import 'dart:async';
import 'package:flutter/material.dart';
import 'package:login/home.dart';
import 'package:login/phone.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    wheretogo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Red',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.red,
                  ),
                ),
                TextSpan(
                  text: ' Cherry',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Cursive',
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> wheretogo() async {
    var prefs = await SharedPreferences.getInstance();
    var isloggedin = prefs.getBool("login");

    Timer(const Duration(seconds: 3), () {
      if (isloggedin != null) {
        if (isloggedin) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const MyPhone()));
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const MyPhone()));
      }
    });
  }
}
