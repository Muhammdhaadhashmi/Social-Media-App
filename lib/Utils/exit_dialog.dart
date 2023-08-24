
import 'package:broaxsaxfy/Utils/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'my_button.dart';

Widget exitDialog(context){
  return Dialog(
    child:Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Confirm",style: TextStyle(color: Colors.blueGrey),),
        // "Confirm".text.fontFamily(bold).size(18).color(darkFontGrey).make(),
        Divider(),
        SizedBox(height: 10,),
        Text("Are You Sure You want Exit?",style: TextStyle(color: Colors.blueGrey,fontSize: 16,),),
        // "Are You Sure You want Exit?".text.size(16).color(darkFontGrey).make(),
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            myButton(color: Colors.red,onPress:(){
              SystemNavigator.pop();
            },textColor: Colors.white,title: "Yes"),
            myButton(color: Colors.red,onPress:(){
              Navigator.pop(context);
            },textColor: Colors.white,title: "No")
          ],
        )
      ],
    ).box.color(Colors.grey).padding(EdgeInsets.all(12)).roundedSM.make(),
  );
}