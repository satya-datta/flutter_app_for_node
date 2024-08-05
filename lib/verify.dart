import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login/config.dart';
import 'package:login/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pinput/pinput.dart';
import 'login_page.dart';

class MyVerify extends StatefulWidget {
  final String phoneNumber;
  final String data;

  const MyVerify({
    required this.phoneNumber,
    required this.data,
    Key? key,
  }) : super(key: key);

  @override
  State<MyVerify> createState() => _MyVerifyState();
}

class _MyVerifyState extends State<MyVerify> {
  String? validationMessage;
  bool isResending = false;
  final TextEditingController pinController = TextEditingController();
  late String code;

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_rounded,
            color: Colors.black,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipOval(
                child: Transform.scale(
                  scale: 1.5,
                  child: Image.asset(
                    'assets/img1.jpeg',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              Text(
                "Phone Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "We need to register your phone before getting started!",
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 30,
              ),
              Pinput(
                length: 4,
                controller: pinController,
                onChanged: (value) {
                  if (value.length == 4) {
                    code = value;
                  }
                },
                showCursor: true,
                onCompleted: (pin) {
                  code = pin;
                },
              ),
              SizedBox(
                height: 20,
              ),
              if (validationMessage != null)
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 5),
                  child: Text(
                    validationMessage!,
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(25),
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 240, 177, 88),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () async {
                            try {
                              var resbody = {
                                "phone": widget.phoneNumber,
                                "otp": code,
                                "hash": widget.data,
                              };
                              final url = '${Config.baseUrl}/verifyotp';
                              final response = await http.post(
                                Uri.parse(url),
                                headers: {
                                  'Content-Type': 'application/json',
                                },
                                body: jsonEncode(resbody),
                              );
                              if (response.statusCode == 200) {
                                print("phone number verified successfully");

                                var resbody = {
                                  "phone": widget.phoneNumber,
                                };
                                final url = '${Config.baseUrl}/checkuser';
                                try {
                                  var response = await http.post(
                                    Uri.parse(url),
                                    headers: {
                                      "Content-Type": "application/json"
                                    },
                                    body: jsonEncode(resbody),
                                  );
                                  if (response.statusCode == 200) {
                                    final Map<String, dynamic> responseBody =
                                        jsonDecode(response.body);
                                    final data = responseBody['data'];

                                    // Check if `data` is of type Map, meaning a user exists
                                    if (data is Map<String, dynamic>) {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      await prefs.setString('_id', data['_id']);
                                      await prefs.setString(
                                          'phonenumber', data['phonenumber']);
                                      await prefs.setString(
                                          'age', data['age'].toString());
                                      await prefs.setString(
                                          'city', data['city']);
                                      await prefs.setBool('login', true);
                                      print("home page");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage()),
                                      );
                                    } else {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => LoginPage(
                                            phoneNumber: widget.phoneNumber,
                                          ),
                                        ),
                                      );
                                    }
                                  }
                                } catch (err) {
                                  print(err);
                                }
                              } else {
                                setState(() {
                                  validationMessage =
                                      'Invalid OTP. Please try again.';
                                });
                              }
                            } catch (e) {
                              setState(() {
                                validationMessage =
                                    'Error verifying OTP. Please try again.';
                              });
                            }
                          },
                          child: const Text(
                            "Verify Phone Number",
                            style: TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        'phone',
                        (route) => false,
                      );
                    },
                    child: Text(
                      "Edit Phone Number?",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
