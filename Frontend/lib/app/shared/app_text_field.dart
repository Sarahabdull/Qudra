import 'package:qodra/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class CustomTextFormField extends StatefulWidget {
  final Color? backgroundColor;
  final bool isPassword;
  final String hintText;
  final String? text;
  final String? validateEmptyText;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final int? maxLines;
  final int? maxLength;
  final String? labelText;
  final String? suffixText;
  final bool? required;
  final bool? showLabel;
  final Color? hintColor;
  final Color? labelColor;
  final Color? textColor;
  final IconData? suffixIcon;
  final IconData? prefixIcon;
  final Color? suffixIconColor;
  final Color? prefixIconColor;
  final bool enabled;
  final List<String>? autoFillHints;
  final double? radius;
  final double horizontalPadding;
  final double verticalPadding;
  final Function(String value)? onChanged;
  final Function()? onTapped;
  final Function(String value)? onFieldSubmitted;

  const CustomTextFormField({
    Key? key,
    this.backgroundColor,
    this.isPassword = false,
    required this.hintText,
    this.text,
    this.validateEmptyText,
    required this.controller,
    required this.keyboardType,
    this.maxLines,
    this.maxLength,
    this.labelText,
    this.suffixText,
    this.required = true,
    this.hintColor,
    this.labelColor,
    this.textColor,
    this.enabled = true,
    this.onChanged,
    this.onTapped,
    this.onFieldSubmitted,
    this.autoFillHints,
    this.suffixIcon,
    this.prefixIcon,
    this.radius = 30,
    this.showLabel = false,
    this.suffixIconColor,
    this.horizontalPadding = 24,
    this.verticalPadding = 12,
    this.prefixIconColor,
  }) : super(key: key);

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool isSecure = false;

  @override
  void initState() {
    super.initState();
    isSecure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: widget.horizontalPadding,
        vertical: widget.verticalPadding,
      ),
      child: TextFormField(
        obscureText: isSecure,
        onTap:widget.onTapped ,
        style: TextStyle(
          fontSize: 12,
          fontFamily: 'Monaco',
          color: widget.textColor ?? Theme.of(context).textTheme.subtitle1!.color,
        ),
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: widget.onFieldSubmitted,
        autofillHints: widget.autoFillHints,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.start,
        validator: widget.required ?? true
            ? (String? value) {
                if (value != null) {
                  if (value.isEmpty) {
                    return widget.validateEmptyText;
                  } else if (widget.keyboardType == TextInputType.emailAddress) {
                    return Validations.email(value);
                  } else if (widget.keyboardType == TextInputType.phone) {
                    return Validations.phone(value);
                  }
                } else {
                  return null;
                }
              }
            : null,
        maxLines: widget.isPassword ? 1 : widget.maxLines,
        maxLength: widget.maxLength,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          labelText: widget.showLabel! ? widget.hintText : null,
          hintText: widget.hintText,
          hintStyle: TextStyle(
            fontSize: 15,
            color:Colors.black ,
            //widget.hintColor ?? const Color(0xFF929292),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          alignLabelWithHint: true,
          prefixIcon: widget.prefixIcon != null
              ? Icon(
                  widget.prefixIcon,
                  size: 20,
                  color: widget.prefixIconColor ?? kAccentColor,
                )
              : null,
          suffixText: widget.suffixText ?? '',
          suffixStyle:  TextStyle(
            color: kAccentColor,
            fontSize: 12,
          ),
          suffixIcon: widget.suffixIcon != null || widget.isPassword
              ? InkWell(
                  onTap: widget.isPassword ? _toggle : null,
                  child: Icon(
                    widget.isPassword
                        ? isSecure
                            ? Icons.remove_red_eye
                            : Icons.visibility_off
                        : widget.suffixIcon,
                    size: 20,
                    color: widget.suffixIconColor ?? kPurpleColor,
                  ),
                )
              : null,
          enabled: widget.enabled,
          errorStyle: const TextStyle(
            color: Colors.red,
            fontSize: 12,
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              width: 0.2,
              color: Theme.of(context).primaryColor,
            ),
            borderRadius: BorderRadius.circular(widget.radius ?? 8),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(widget.radius ?? 8),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 0.1,
            ),
          ),
        ),

      ),
    );
  }

  void _toggle() {
    setState(() {
      isSecure = !isSecure;
    });
  }
}

class Validations {
  static String? email(String value) {
    if (value.isEmpty) {
      return 'empty'.tr;
    } else if (!value.contains('@') || !value.contains('.')) {
      return 'EX: example@mail.com';
    } else {
      return null;
    }
  }

  static String? phone(String value) {
    if (value.isEmpty) {
      return 'empty'.tr;
    } else {
      return null;
    }
  }
}
