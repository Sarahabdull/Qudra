import 'package:flutter/material.dart';

class AppElevatedButton extends StatelessWidget {
  final String text;
  final Color? textColor;
  final Color? backgroundColor;
  final bool? centerText;
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final VoidCallback onPressed;

  const AppElevatedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor,
    this.textColor,
    this.centerText,
    this.fontSize,
    this.fontFamily,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          textStyle: TextStyle(
              fontFamily: fontFamily,
              fontSize: fontSize,
              fontWeight: fontWeight),
          primary: backgroundColor ??
              Theme.of(context).primaryColor, //background color
          onPrimary: textColor ?? Colors.white),
      // text color
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
