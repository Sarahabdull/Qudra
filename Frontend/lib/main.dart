
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:qodra/app/core/get_binding.dart';
import 'package:qodra/app/core/values/localization/translation.dart';
import 'package:qodra/app/data/storage/local_storage.dart';
import 'package:qodra/app/modules/auth/controller/auth_controller.dart';
import 'package:qodra/app/modules/items/splash_screen.dart';
import 'package:qodra/app_constant.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.init();
  await Firebase.initializeApp();
  runApp(
    const CrazyApp(),
  );
}

class CrazyApp extends StatefulWidget {
  const CrazyApp({Key? key}) : super(key: key);

  @override
  State<CrazyApp> createState() => _CrazyAppState();
}

class _CrazyAppState extends State<CrazyApp> {
  @override
  Widget build(BuildContext context) {
    Get.lazyPut(()=>AuthController());
    final navigatorKey = GlobalKey<NavigatorState>();
    return Directionality(
      textDirection: LocalStorage.isAr ? TextDirection.rtl : TextDirection.ltr,
      child: GetMaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', 'US'), // include country code too
            Locale('ar', 'SA'), // include country code too
          ],
          // locale:  Locale('ar', 'EG'),
          defaultTransition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 500),
          translations: Translation(),
          initialBinding: GetBinding(),
          locale: LocalStorage.isAr ? const Locale('ar') : const Locale('en'),
          fallbackLocale: const Locale('en'),
          title: 'Qodra',
          themeMode: ThemeMode.light,
          home: const SplashScreen()),
    );
  }

  ThemeData lightThemeData(BuildContext context) {
    return ThemeData.light().copyWith(
        primaryColor: const Color(0xFF5B4B49),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: const Color(0xFF24A751)));
  }

// dark Theme
  ThemeData darkThemeData(BuildContext context) {
    return ThemeData.dark().copyWith(
        primaryColor: const Color(0xFFFF1D00),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: const Color(0xFF24A751)));
  }

  ThemeData getLightTheme() {
    return ThemeData(
      // fontFamily: FontFamily.regular,
      scaffoldBackgroundColor: kBackgroundDarkColor,
      platform: TargetPlatform.iOS,
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
              fontSize: 20.sp,
              // fontFamily: FontFamily.regular,
              color: Colors.white),
          errorStyle: TextStyle(
              fontSize: 18.sp,
              // fontFamily: FontFamily.regular,
              color: Colors.red)),
      primaryTextTheme: TextTheme(
          titleMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        // fontFamily: FontFamily.regular,
        // color: colorPrimary
      )),
      primarySwatch: Colors.green,
      elevatedButtonTheme: const ElevatedButtonThemeData(),
      appBarTheme: AppBarTheme(
          backgroundColor: kBackgroundDarkColor,
          centerTitle: true,
          elevation: 0),
      toggleableActiveColor: kPrimaryColor,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
    );
  }

  ThemeData getDarkTheme() {
    return ThemeData(
      // fontFamily: FontFamily.regular,
      scaffoldBackgroundColor: kBackgroundDarkColor,
      platform: TargetPlatform.iOS,
      inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
              fontSize: 20.sp,
              // fontFamily: FontFamily.regular,
              color: Colors.black),
          errorStyle: TextStyle(
              fontSize: 18.sp,
              // fontFamily: FontFamily.regular,
              color: Colors.black)),
      primaryTextTheme: TextTheme(
          titleMedium: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w700,
        // fontFamily: FontFamily.regular,
        // color: colorPrimary
      )),
      primarySwatch: Colors.orange,
      elevatedButtonTheme: const ElevatedButtonThemeData(),
      appBarTheme: AppBarTheme(
          backgroundColor: kBackgroundDarkColor,
          centerTitle: true,
          elevation: 0),
      toggleableActiveColor: kPrimaryColor,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
    );
  }
}
