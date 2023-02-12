import 'package:qodra/app/core/values/assets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class NetworkError extends StatelessWidget {
  const NetworkError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            Assets.kConnectionError,
            width: Get.width,
            height: 329.h,
          ),
          Text(
            'no_internet'.tr,
            style: Get.textTheme.bodyText1,
          ),
        ],
      ),
    );
  }
}
