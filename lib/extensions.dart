// datetime
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  // date only using dateformat
  String get dateOnly => DateFormat('yyyy-MM-dd').format(this);
}

// string
extension StringExtension on String {
  // is email
  bool get isEmail =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);

  // to datetime
  DateTime get toDateTime => DateTime.parse(this);
}

// buildcontext
extension BuildContextExtension on BuildContext {
  // show snackbar
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(content: Text(message)));
  }

  // error snackbar
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  // show loading circle
  void showLoadingCircle() {
    showDialog(
      context: this,
      barrierDismissible: false,
      builder: (context) => const PopScope(
        canPop: false,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  // navigator pop
  void pop() {
    Navigator.of(this).pop();
  }

  // dismiss keyboard
  void dismissKeyboard() {
    FocusScope.of(this).unfocus();
  }
}
