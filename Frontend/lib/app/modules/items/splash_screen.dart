import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:qodra/app/core/get_binding.dart';
import 'package:qodra/app/data/storage/local_storage.dart';
import 'package:qodra/app/modules/auth/view/login_view.dart';
import 'package:qodra/app/modules/home/home_view.dart';
import 'package:qodra/app/shared/AnimatedWidgets.dart';
import 'package:qodra/app_constant.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 5), () {
      Get.log('user2 ${ LocalStorage.isLoggedIn}  is saved to local storage');
       Get.off(() => LocalStorage.isLoggedIn ? const HomeView() :  LoginView(),binding: GetBinding());
      // Get.off(()=>HomeView());
    });

    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: Container(
          height: height,
          alignment: AlignmentDirectional.topCenter,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/icon/back.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: AnimatedWidgets(
            duration: 2,
            horizontalOffset: 0,
            verticalOffset: 150,
            child: Align(
              alignment: Alignment.center,
              child: Card(
                elevation: 20,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),

                ),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration:   BoxDecoration(
                    gradient:LinearGradient(
                        colors: [
                          Color(0xffB86AD6),
                          Color(0xff757DB5)
                        ]
                    ),

                  ),
                  child:
                  Image.asset(
                    'assets/images/free_icon.png',
                    width: 160,
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

          ),
        ),
      ),
    );
  }
}
