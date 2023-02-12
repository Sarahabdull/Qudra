
import 'package:flutter/material.dart';
import 'package:qodra/app/core/get_binding.dart';
import 'package:qodra/app/data/remote_data_source/auth_apis.dart';
import 'package:qodra/app/modules/auth/view/login_view.dart';
import 'package:qodra/app/shared/app_buttons/app_progress_button.dart';
import 'package:qodra/app/shared/app_text_field.dart';
import 'package:get/get.dart';
import 'package:qodra/app/shared/snack_bar.dart';
import 'package:qodra/app_constant.dart';
class ForgetPasswordView extends StatelessWidget {
  var emailController;
  final GlobalKey<FormState>  _formKey = GlobalKey<FormState>();
   ForgetPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    emailController=TextEditingController();
    return  Center(
      child: Column(
          children: [
            const SizedBox(height: 20,),
            Form(
              key:_formKey,child:
            CustomTextFormField(
              hintText: 'email'.tr,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.email,
              radius: 8,
              horizontalPadding: 12,
              controller: emailController,
            ),
            ),
            const SizedBox(height: 20,),
            AppProgressButton(
              width: 50,
              height: 50,
              radius: 100,
              onPressed: (AnimationController animationController) async{
                if(_formKey.currentState!.validate()){
                  animationController.forward();
                  await Future.delayed(const Duration(seconds: 2));
                    String  ? model=   await AuthApis().forgetPassword(
                         emailController.text).then((value){
                      Get.offAll(()=>LoginView(),binding: GetBinding());
                      Future.delayed(Duration.zero, () async {
                        showSnackBar('check_email'.tr);
                      });
                      animationController.reverse();
                    });

                  // Get.offAll(()=>HomeScreenView());
                }
              },
              child: Icon(
                Icons.arrow_forward,
                color: kPrimaryColor,
                size: 30,
              ),
            ),
          ],

      ),
    );
  }
}
