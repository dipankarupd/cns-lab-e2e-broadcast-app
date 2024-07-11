

import 'package:flutter/material.dart';

const colorPrimary = Color.fromARGB(255, 85, 195, 89);
const colorSecondary = Color(0xff8161d6);
const colorAccent = Color(0xfff5f5f5);
const colorNeutral = Color(0xffab47bc);
const colorBase = Color(0xffffffff);
const colorInfo = Color(0xfffa6900);
const colorSuccess = Color(0xff23b893);
const colorError = Color(0xffea535a);
const colorWarning = Color(0xfff79926);

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: colorPrimary,

  elevatedButtonTheme: ElevatedButtonThemeData(
  
    style: ButtonStyle(   
      
      padding: MaterialStateProperty.all<EdgeInsetsGeometry>(const EdgeInsets.fromLTRB(97, 18, 97, 18)),
      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
      backgroundColor: MaterialStateProperty.all(colorSecondary),
      
    )
  )
);