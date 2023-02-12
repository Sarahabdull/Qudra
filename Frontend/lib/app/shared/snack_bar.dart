import 'dart:async';
import 'package:qodra/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app_text.dart';

showSnackBar(String message, {bool popPage = false, int duration = 3}) {
  // ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
  // ScaffoldMessenger.of(Get.context!).showSnackBar(
  //   SnackBar(
  //     backgroundColor: kPrimaryColor,
  //     behavior: SnackBarBehavior.floating,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
  //     content: AppText(message, color: Colors.white,fontSize: 12,),
  //     action: SnackBarAction(
  //       label: '',
  //       onPressed: () {},
  //     ),
  //     duration: Duration(seconds: duration),
  //   ),
  // );
  // if (popPage) {
  //   Timer(
  //     const Duration(seconds: 5),
  //     () => Get.back(closeOverlays: true),
  //   );
  // }

  Get.snackbar(message, '',
    margin: EdgeInsets.all(20),
    padding: EdgeInsets.all(10),
    duration: Duration(seconds: 5),
    colorText: Colors.white,
    backgroundColor: kPurpleColor,
    borderRadius: 5,
    snackPosition: SnackPosition.BOTTOM,
  );
}
