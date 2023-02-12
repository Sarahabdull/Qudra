import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:qodra/app/data/models/login_model.dart';
import 'package:qodra/app/data/remote_data_source/auth_apis.dart';
import 'package:qodra/app/data/storage/local_storage.dart';
import 'package:qodra/app/modules/auth/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:qodra/app/modules/auth/view/gender_view.dart';
import 'package:qodra/app/modules/auth/view/login_view.dart';
import 'package:qodra/app/modules/home/home_view.dart';
import 'package:qodra/app/shared/app_buttons/app_progress_button.dart';
import 'package:qodra/app/shared/app_text.dart';
import 'package:qodra/app/shared/app_text_field.dart';
import 'package:qodra/app/shared/snack_bar.dart';
import 'package:qodra/app_constant.dart';
import 'package:qodra/app/data/storage/local_storage.dart';


class RegisterView extends GetView<AuthController> {
  String gender = 'male';
  final GlobalKey<FormState>  _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          title:  AppText(
            'register'.tr,
            fontSize: 22,
            color: LocalStorage.isDArk?Colors.black:Colors.white,
          ),
          centerTitle: true,
          backgroundColor: kBackgroundDarkColor,
          leading:IconButton(
              onPressed: () {
                Get.off(() =>  LoginView());
              },
              icon:  Icon(
                Icons.arrow_back_rounded,
                color: LocalStorage.isDArk?Colors.black:Colors.white,
                size: 35,
              )) ,
          actions: [
            // IconButton(
            //     onPressed: () {
            //       Get.off(() => const HomeView());
            //     },
            //     icon: const Icon(
            //       Icons.settings,
            //       color: Colors.black,
            //       size: 35,
            //     )),

          ],
        ),
        body: Container(
          color: kBackgroundDarkColor,
          height: Get.height,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 20,),
                  CustomTextFormField(
                    hintText: 'user_hint'.tr,
                    controller: controller.nameController,
                    keyboardType: TextInputType.text,
                    validateEmptyText: 'empty'.tr,
                    prefixIcon: Icons.person_outline,
                    radius: 15,
                    backgroundColor: kGreyColor,
                    textColor: Colors.black,
                  ),
                  CustomTextFormField(
                    hintText: 'user_name_hint'.tr,
                    controller: controller.userNameController,
                    keyboardType: TextInputType.text,
                    validateEmptyText: 'empty'.tr,
                    prefixIcon: Icons.person_outline,
                    radius: 15,
                  ),
                  CustomTextFormField(
                    hintText: 'code_hint'.tr,
                    controller: controller.codeController,
                    keyboardType: TextInputType.text,
                    validateEmptyText: 'empty'.tr,
                    prefixIcon: Icons.lock,
                    radius: 15,
                  ),
                  CustomTextFormField(
                    hintText: 'email_hint'.tr,
                    controller: controller.emailController,
                    keyboardType: TextInputType.text,
                    validateEmptyText: 'empty'.tr,
                    prefixIcon: Icons.email_outlined,
                    radius: 15,
                  ),
                  CustomTextFormField(
                    hintText: 'phone_hint'.tr,
                    controller: controller.phoneController,
                    keyboardType: TextInputType.number,
                    validateEmptyText: 'empty'.tr,
                    prefixIcon: Icons.phone,
                    radius: 15,
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      AppText('gender'.tr,color: LocalStorage.isDArk?Colors.black:Colors.white,fontSize: 22,),
                      const SizedBox(width: 15,),
                      GenderView(onGenderChanged: (isMale) {
                        isMale ? gender = 'male' : gender = 'female';
                      }),
                    ],
                  ),
                  const SizedBox(height: 20,),
                  AppProgressButton(
                    onPressed: (AnimationController animationController) async{
                      if(_formKey.currentState!.validate()) {
                        animationController.forward();
                        await Future.delayed(const Duration(seconds: 2)).then((value) async{
                          LoginModel model = await AuthApis().registerUser(
                              name: controller.nameController.text,
                              email: controller.emailController.text,
                              password: controller.codeController.text);
                          if (model.expiresIn != null) {
                            Get.offAll(() => HomeView());
                            showSnackBar('login_success'.tr);
                            animationController.reverse();
                          } else if (model.error?.message != null) {
                            showSnackBar(
                                model.error?.message ?? 'general_error'.tr);
                            animationController.reverse();
                          }
                        });
                      }
                    },
                  backgroundColor: Colors.white,textColor: Colors.black,
                  text: 'register'.tr,
                  radius: 20,)
                ],
              ),
            ),
          ),
        ));
  }
}
