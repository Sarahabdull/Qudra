import 'package:get/get.dart';

class HomeController extends GetxController{
bool isLogin=true;
  setIsLogin(bool newVal){
    isLogin=newVal;
    update();
  }
}