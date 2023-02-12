import 'package:flutter/material.dart';

class AppOutlinedButton extends StatelessWidget {
  final String text;
  final Color? textColor;
  final bool? centerText;
  final double? fontSize;
  final String? fontFamily;
  final FontWeight? fontWeight;
  final VoidCallback onPressed;

  const AppOutlinedButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.textColor,
    this.centerText,
    this.fontSize,
    this.fontFamily,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        textStyle: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          fontWeight: fontWeight,
        ),
        // padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        primary: textColor ?? Colors.white, //text color
        side: BorderSide(color: textColor ?? Colors.white, width: 2),
      ),
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
