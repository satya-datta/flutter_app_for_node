import 'package:flutter/material.dart';

class PhoneProvider with ChangeNotifier {
  String? _validationMessage;
  String? _phoneNumber;

  String? get validationMessage => _validationMessage;
  String? get phoneNumber => _phoneNumber;

  void setValidationMessage(String? message) {
    _validationMessage = message;
    notifyListeners();
  }

  void setPhoneNumber(String? number) {
    _phoneNumber = number;
    notifyListeners();
  }
}
