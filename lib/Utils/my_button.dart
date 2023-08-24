

import 'package:broaxsaxfy/Utils/consts.dart';
import 'package:broaxsaxfy/Utils/styles.dart';
import 'package:flutter/material.dart';

Widget myButton({onPress,color,textColor,String? title}){
  return ElevatedButton(
    style: ElevatedButton.styleFrom(
      primary: color,
      padding: EdgeInsets.all(12),
    ),
      onPressed: onPress, child: title!.text.color(textColor).fontFamily(bold).make());
}