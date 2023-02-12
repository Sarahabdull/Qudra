import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class AppBarWidget extends PreferredSize {
  String ?title;
  Function ? onPress;
  AppBarWidget({required Widget child, required Size preferredSize,required title,required onPress}) :
        super(child: child, preferredSize: preferredSize);

  // String ? title;
  // Function ? onPress;
  // AppBarWidget(this.title, this.onPress) : super() ;
  @override
  Widget build(BuildContext context) {
   return PreferredSize(
     preferredSize: Size.fromHeight(10),
     child: AppBar(
       title: Text( title??'',style:TextStyle(color: Colors.white,)),
       centerTitle: true,
       elevation: 0,
       leading: IconButton(
         onPressed:()=>onPress,
         icon: Icon(Icons.arrow_back_ios_sharp),
       ),
     ),
   );
  }

}