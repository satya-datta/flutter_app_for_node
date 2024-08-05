import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:login/config.dart';
import 'package:login/phone_provider.dart';
import 'package:login/verify.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class MyPhone extends StatefulWidget {
  const MyPhone({Key? key}) : super(key: key);

  static String verify = "";

  @override
  State<MyPhone> createState() => _MyPhoneState();
}

class _MyPhoneState extends State<MyPhone> {
  final TextEditingController phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String initialCountry = 'IN';
  PhoneNumber number = PhoneNumber(isoCode: 'IN');

  @override
  Widget build(BuildContext context) {
    final phoneProvider = Provider.of<PhoneProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
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
                    const SizedBox(height: 25),
                    const Text(
                      "Phone Verification",
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      "We need to register your phone before getting started!",
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Container(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 55,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 1, color: Colors.grey),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(width: 10),
                                Expanded(
                                  child: InternationalPhoneNumberInput(
                                    keyboardType: TextInputType.phone,
                                    onInputChanged: (PhoneNumber number) {
                                      phoneProvider
                                          .setPhoneNumber(number.phoneNumber);
                                    },
                                    selectorConfig: const SelectorConfig(
                                      selectorType:
                                          PhoneInputSelectorType.DROPDOWN,
                                    ),
                                    initialValue: number,
                                    textFieldController: phoneController,
                                    inputDecoration: const InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Phone',
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter your phone number';
                                      } else if (!RegExp(
                                              r'^\+[1-9]{1}[0-9]{3,14}$')
                                          .hasMatch(phoneProvider.phoneNumber ??
                                              '')) {
                                        return 'Please enter a valid phone number';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (phoneProvider.validationMessage != null)
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 5),
                              child: Text(
                                phoneProvider.validationMessage!,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(25),
              child: SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 240, 177, 88),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState?.validate() ?? false) {
                      phoneProvider.setValidationMessage(null);

                      // Send phone number to Node.js backend
                      try {
                        var resbody = {
                          "phone": phoneProvider.phoneNumber,
                        };
                        print(phoneProvider.phoneNumber);
                        final url =
                            'https://node3-flutter-server.onrender.com/send-otp';
                        final response = await http.post(
                          Uri.parse(url),
                          headers: {
                            'Content-Type': 'application/json',
                          },
                          body: jsonEncode(resbody),
                        );

                        if (response.statusCode == 200) {
                          final Map<String, dynamic> responseBody =
                              jsonDecode(response.body);
                          final String data = responseBody['data'];
                          MyPhone.verify = data;
                          // Uncomment the line bel you want to navigate to the verification screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MyVerify(
                                phoneNumber: phoneProvider.phoneNumber!,
                                data: data,
                              ),
                            ),
                          );
                        } else {
                          phoneProvider.setValidationMessage(
                              'Failed to send OTP. Please try again. ${response.statusCode}');
                        }
                      } catch (e) {
                        phoneProvider.setValidationMessage(
                            'An error occurred. Please try again. ${e}');
                        print(e);
                      }
                    } else {
                      phoneProvider.setValidationMessage(
                          "Please enter a valid phone number ");
                    }
                  },
                  child: const Text(
                    "Send the code",
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
