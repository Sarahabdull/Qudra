import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:qodra/app/data/storage/local_storage.dart';
import 'package:qodra/app/shared/app_text.dart';

class GenderView extends StatefulWidget {
  final Function(bool isMale) onGenderChanged;

  const GenderView({
    Key? key,
    required this.onGenderChanged,
  }) : super(key: key);

  @override
  State<GenderView> createState() => _GenderViewState();
}

class _GenderViewState extends State<GenderView> {
  bool isMale = true;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Radio(
            value: true,
            groupValue: isMale,
            onChanged: (value) {
              setState(() {
                isMale = true;
              });
              widget.onGenderChanged(true);
            }),
        const Icon(
          Icons.male,
          color: Colors.blue,
        ),
        AppText(
          'male'.tr,
          color: LocalStorage.isDArk?Colors.black:Colors.white,
        ),
        const SizedBox(width: 20),
        Radio(
            value: false,
            groupValue: isMale,
            onChanged: (value) {
              setState(() {
                isMale = false;
              });
              widget.onGenderChanged(false);
            }),
        const Icon(
          Icons.female,
          color: Colors.pink,
        ),
        AppText(
          'female'.tr,
          color: LocalStorage.isDArk?Colors.black:Colors.white,
        )
      ],
    );
  }
}
