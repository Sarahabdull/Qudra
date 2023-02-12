import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qodra/app/core/get_binding.dart';
import 'package:qodra/app/data/storage/local_storage.dart';
import 'package:qodra/app/modules/auth/view/login_view.dart';
import 'package:qodra/app/modules/home/home_view.dart';
import 'package:qodra/app/shared/app_buttons/app_progress_button.dart';
import 'package:qodra/app/shared/app_text.dart';
import 'package:qodra/app/shared/app_text_field.dart';
import 'package:qodra/app_constant.dart';
import 'package:get/get.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';


class SendMessageView extends StatelessWidget{
final GlobalKey<FormState>  _formKey = GlobalKey<FormState>();
final TextEditingController fromController=TextEditingController();
final TextEditingController toController=TextEditingController();
final TextEditingController subjectController=TextEditingController();
int flag;
SendMessageView(this.flag);
  @override
  Widget build(BuildContext context) {
   return Scaffold(
     appBar: AppBar(
       elevation: 0,
       title:  AppText(
         'qodra'.tr,
         fontSize: 22,
           color:LocalStorage.isDArk?Colors.black:Colors.white,
       ),
       centerTitle: true,
       backgroundColor: kBackgroundDarkColor,
       leading:IconButton(
           onPressed: () {
             Get.log('flag  => '+flag.toString());
              flag==1? Get.offAll(() => LoginView(),binding: GetBinding()): Get.to(() =>  const HomeView(),binding: GetBinding());
             // flag==1? Navigator.of(context).push(MaterialPageRoute(builder: (_)=>LoginView())): Get.to(() =>  const HomeView());

             // Get.off(() =>  const HomeView());
           },
           icon:  Icon(
             Icons.arrow_back_rounded,
             color:LocalStorage.isDArk?Colors.black:Colors.white,
             size: 35,
           )) ,
       actions: [

       ],
     ),

     body: Container(
       height: Get.height,
         color: kBackgroundDarkColor,
       alignment: AlignmentDirectional.topCenter,
       child: SingleChildScrollView(
         child: Form(
           key: _formKey,
           child: Column(
             children: [
               const SizedBox(height: 20,),
               const SizedBox(height: 20,),
               CustomTextFormField(
                 hintText: 'to_hint'.tr,
                 controller: toController,
                 keyboardType: TextInputType.emailAddress,
                 validateEmptyText: 'empty'.tr,
                 prefixIcon: Icons.email_outlined,
                 radius: 15,
               ),
               CustomTextFormField(
                 hintText: 'from_hint'.tr,
                 controller: fromController,
                 keyboardType: TextInputType.emailAddress,
                 validateEmptyText: 'empty'.tr,
                 prefixIcon: Icons.email_outlined,
                 radius: 15,
               ),

               CustomTextFormField(
                 hintText: 'subject'.tr,
                 controller: subjectController,
                 keyboardType: TextInputType.text,
                 validateEmptyText: 'empty'.tr,
                 prefixIcon: Icons.edit_notifications,
                 radius: 15,
                 maxLines: 5,
               ),
               const SizedBox(height: 20,),
               Padding(
                 padding: const EdgeInsets.all(10.0),
                 child: Row(
                   children: [
                     Expanded(child: AppProgressButton(onPressed: (AnimationController animationController) async {
                       String platformResponse;
                       final Email email = Email(
                         body: 'Email body',
                         subject: 'Email subject',
                         recipients: ['reham.samy20122@gmail.com'],
                         // cc: ['cc@example.com'],
                         // cc:['reham.samy20122@gmail.com'],
                         // bcc: ['reham.samy20122@gmail.com'],
                         // attachmentPaths: ['/path/to/attachment.zip'],
                         isHTML: false,
                       );

                       try {
                         await FlutterEmailSender.send(email);
                         platformResponse = 'success';
                       } catch (error) {
                         print(error);
                         platformResponse = error.toString();
                       }
                       print('fffffff  $platformResponse');

                       // if (!mounted) return;

                       ScaffoldMessenger.of(context).showSnackBar(
                         SnackBar(
                           content: Text('platformResponse'),
                         ),
                       );
                       },
                       backgroundColor: Colors.white,textColor: Colors.black,
                       text: 'send'.tr,
                       radius: 20,)),
                     const SizedBox(width: 15,),
                     Expanded(child:  AppProgressButton(onPressed: (AnimationController animationController)async{


                     Get.off(()=>HomeView());
                     },
                       backgroundColor: Colors.white,textColor: Colors.black,
                       text: 'cancel'.tr,
                       radius: 20,)),
                   ],
                 ),
               ),
             ],
           ),
         ),
       )
     ),
   );
  }



}