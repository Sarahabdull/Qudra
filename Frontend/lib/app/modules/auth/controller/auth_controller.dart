import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{
  TextEditingController nameController=TextEditingController();
  TextEditingController userNameController=TextEditingController();
  TextEditingController codeController=TextEditingController();
  TextEditingController emailController=TextEditingController();
  TextEditingController phoneController=TextEditingController();
  TextEditingController genderController=TextEditingController();

bool isLogin=true;
  setIsLogin(bool newVal){
    isLogin=newVal;
    update();
  }
}