import 'package:flutter/material.dart';

Future<void> showAppDialog(
  BuildContext context,
  //preferred as Column
  Widget child, {
  double? height,
  Color? backgroundColor,
  double horizontalPadding = 12.0,
  double radius = 12.0,
  bool barrierDismissible = false,
  EdgeInsets contentPadding = const EdgeInsets.all(12.0),
}) async {
  await showDialog(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (_) => AlertDialog(
      backgroundColor:
          backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      insetPadding:
          EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 0.0),
      contentPadding: contentPadding,
      content: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(radius),
          ),
          height: height,
          width: MediaQuery.of(context).size.width,
          child: child,
        ),
      ),
    ),
  );
}
