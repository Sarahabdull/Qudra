import 'package:qodra/app/data/services/network_service.dart/dio_network_service.dart';
import 'package:qodra/app/data/storage/local_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

const String userAvatar =
    'https://t4.ftcdn.net/jpg/03/83/25/83/360_F_383258331_D8imaEMl8Q3lf7EKU2Pi78Cn0R7KkW9o.jpg';
NetworkService networkService = NetworkService(
  baseUrl: baseUrl,
  httpHeaders: {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    //'Authorization': 'Bearer ${SharedPrefService.getToken() ?? ''}',
    'Language': Get.locale?.languageCode ?? 'en',
  },
);



const String kApiKey='AIzaSyAOexIWk0Z2ijFeDyS54THCQfbJAYV1zME';
 const String baseUrl = 'https://crazy-65aca-default-rtdb.firebaseio.com';
// const String baseUrl='https://crazyfood-5f22c-default-rtdb.firebaseio.com';
 Color kPrimaryColor =LocalStorage.isDArk? const Color(0xffC0CCFF):const Color(0xff2A3164);
 Color kBackColor1 = const Color(0xffE9F8EE);
 Color kAccentColor = LocalStorage.isDArk?const Color(0xffDA00FF):const Color(0xff2A3164);
 Color kBackgroundColor =LocalStorage.isDArk? const Color(0xffD1DDFF):Color(0xff2A3164);
 Color kBackgroundDarkColor =LocalStorage.isDArk? const Color(0xffBFCCFF):Color(0xff2A3164);
 Color kUnSelectedColor = LocalStorage.isDArk?const Color(0xff757DB5):Color(0xff2A3164);
const Color kAuthGreyColor = Color(0xffF6F6F6);
 Color kPurpleColor =LocalStorage.isDArk? const Color(0xffB86AD6):const Color(0xff2A3164);
 Color kBlueLightColor =LocalStorage.isDArk? const Color(0xffE9F8EE):Colors.black;
const Color kGreyColor=Color(0xffDADADA);

const BoxDecoration kContainerDecoraction = BoxDecoration(
    image: DecorationImage(
        fit: BoxFit.fill,
        image: AssetImage(
          'assets/images/back.png',
        )));

const List<Color> colorsMenu = [
  Color(0xffBEE7CF),
  Color(0xffF4E3B2),
  Color(0xffD5BDE7),
  Color(0xffE7B2AA),
  Color(0xffB9D4E7),
  Color(0xffE6D2E7),
];

//  AppBar kAppBar(String title,Function onPress){
//   return AppBar(
//   title: AppText( title??'',color: Colors.white,),
// centerTitle: true,
// elevation: 0,
// leading: IconButton(
// onPressed:()=>onPress,
// icon: Icon(Icons.arrow_back_ios_sharp),
// ),
// );


