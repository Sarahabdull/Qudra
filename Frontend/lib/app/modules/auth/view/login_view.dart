import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:qodra/app/core/get_binding.dart';
import 'package:qodra/app/data/models/login_model.dart';
import 'package:qodra/app/data/remote_data_source/auth_apis.dart';
import 'package:qodra/app/data/storage/local_storage.dart';
import 'package:qodra/app/modules/auth/controller/auth_controller.dart';
import 'package:get/get.dart';
import 'package:qodra/app/modules/auth/view/forget_password_view.dart';
import 'package:qodra/app/modules/auth/view/register_view.dart';
import 'package:qodra/app/modules/home/home_view.dart';
import 'package:qodra/app/modules/items/my_drawer.dart';
import 'package:qodra/app/shared/app_buttons/app_progress_button.dart';
import 'package:qodra/app/shared/app_text.dart';
import 'package:qodra/app/shared/app_text_field.dart';
import 'package:qodra/app/shared/snack_bar.dart';
import 'package:qodra/app/views/app_dialog.dart';
import 'package:qodra/app_constant.dart';

class LoginView extends GetView<AuthController> {
  final GlobalKey<FormState>  _formKey = GlobalKey<FormState>();
  @override
 final AuthController controller=Get.find();
  final GlobalKey<ScaffoldState> _key = GlobalKey();
  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      key: _key,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kBackgroundDarkColor,
          title:  AppText(
            'login'.tr,
            fontSize: 22,
            color:LocalStorage.isDArk?Colors.black:Colors.white,
          ),
          leading:  IconButton(
            icon: Icon(Icons.settings,color: LocalStorage.isDArk?kPurpleColor:Colors.white,size: 40,),
            onPressed: () => _key.currentState!.openDrawer(),
          ) ,
          centerTitle: true,
          actions: [

            // IconButton(
            //     onPressed: () {
            //       Get.off(() => const HomeView());
            //     },
            //     icon: const Icon(
            //       Icons.settings,
            //       color: Colors.black,
            //       size: 35,
            //     ))
          ],
        ),
        body: GetBuilder<AuthController>(
          builder: (context) {
            return Container(
              color: kBackgroundDarkColor,
              height: Get.height,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 20,),
                      Card(
                        elevation: 20,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),

                        ),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration:   const BoxDecoration(
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
                      const SizedBox(height: 25,),

                      CustomTextFormField(
                        hintText: 'email_hint'.tr,
                        controller: controller.emailController,
                        keyboardType: TextInputType.text,
                        validateEmptyText: 'empty'.tr,
                        prefixIcon: Icons.email_outlined,
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
                      const SizedBox(height: 20,),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Expanded(child:  AppProgressButton(onPressed: (AnimationController animationController)async{
                              if(_formKey.currentState!.validate()) {
                                animationController.forward();
                                await Future.delayed(const Duration(seconds: 2)).then((value) async{
                                  LoginModel model = await AuthApis().loginUser(
                                      email: controller.emailController.text,
                                      password: controller.codeController.text);
                                  if (model.expiresIn != null) {
                                    Get.offAll(() => const HomeView());
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
                              text: 'login'.tr,
                              radius: 20,)),
                            const SizedBox(width: 15,),
                            Expanded(child:  AppProgressButton(onPressed: (AnimationController animationController){


                              Get.off(()=>RegisterView(),binding: GetBinding());
                            },
                              backgroundColor: Colors.white,textColor: Colors.black,
                              text: 'register'.tr,
                              radius: 20,))
                          ],
                        ),
                      ),
                      const SizedBox(height: 20,),
                     InkWell(onTap: (){
                      showAppDialog(ctx, ForgetPasswordView());
                     },
                         child: AppText('forget_password'.tr,color:LocalStorage.isDArk?Colors.blueAccent:Colors.white,fontSize: 20,))

                    ],
                  ),
                ),
              ),
            );
          }
        ),drawer:  MyDrawer(1),);
  }
}
