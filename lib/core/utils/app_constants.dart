import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:status_bluetooth/core/utils/app_colors.dart';

class AppConstants {
  static const int durationForAPI = 5;

  static void showToast({
    required String message,
    Color? color,
    ToastGravity? toastGravity,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: color ?? AppColors.hintColor,
      gravity: toastGravity ?? ToastGravity.BOTTOM,
    );
  }
}
