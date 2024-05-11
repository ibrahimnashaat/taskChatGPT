import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:sizer/sizer.dart';
import 'package:task_chatgpt_app/shared/colors/shared_colors.dart';

class Styles {


  static ThemeData darkTheme(BuildContext context) {


    return ThemeData(
      useMaterial3: true,


      scaffoldBackgroundColor:   homePageColor,
      secondaryHeaderColor: mainColor,


      primaryColor: HexColor('#10A37F'),


      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: const ColorScheme.light()),


      iconTheme: const IconThemeData(
          color: Colors.white
      ),


      textTheme:  TextTheme(
          titleLarge: TextStyle(fontSize: 12.sp,fontFamily: 'Raleway', fontWeight: FontWeight.w700, color: Colors.white),
          titleMedium: TextStyle(fontSize: 12.sp, fontFamily: 'Raleway',fontWeight: FontWeight.w500, color: Colors.white),
          bodyLarge: TextStyle(fontSize: 14.sp,fontFamily: 'Raleway', color:Colors.white, fontWeight: FontWeight.w500),
          bodyMedium: TextStyle(fontSize: 12.sp,fontFamily: 'Raleway', color:Colors.white, fontWeight: FontWeight.w600),
          labelMedium: TextStyle(fontSize: 14.sp,fontFamily: 'Raleway', color:Colors.white, fontWeight: FontWeight.w600),
          labelLarge: TextStyle(fontSize: 22.sp,fontFamily: 'Raleway', color:Colors.white, fontWeight: FontWeight.w700),
          displayMedium: TextStyle(fontSize: 13.sp,fontFamily: 'Raleway', color:Colors.white, fontWeight: FontWeight.w600),
          displayLarge: TextStyle(fontSize: 30.sp,fontFamily: 'Raleway', color:Colors.white, fontWeight: FontWeight.w700),
    ),
    );
  }


  static ThemeData lightTheme(BuildContext context) {

    return ThemeData(
      useMaterial3: true,


      scaffoldBackgroundColor:  Colors.white,
      secondaryHeaderColor: Colors.grey,

      primaryColor:  HexColor('#10A37F'),



      buttonTheme: Theme.of(context).buttonTheme.copyWith(
          colorScheme: const ColorScheme.light()),



      iconTheme: const IconThemeData(
          color: Colors.black
      ),


      textTheme:  TextTheme(
        titleLarge: TextStyle(fontSize: 12.sp,fontFamily: 'Raleway', fontWeight: FontWeight.w700, color: mainColor),
        titleMedium: TextStyle(fontSize: 12.sp, fontFamily: 'Raleway',fontWeight: FontWeight.w500, color: mainColor),
        bodyLarge: TextStyle(fontSize: 14.sp,fontFamily: 'Raleway', color:mainColor, fontWeight: FontWeight.w500),
        displayLarge: TextStyle(fontSize: 30.sp,fontFamily: 'Raleway', color:mainColor, fontWeight: FontWeight.w700),
        bodyMedium: TextStyle(fontSize: 12.sp,fontFamily: 'Raleway', color:mainColor, fontWeight: FontWeight.w600),
        labelMedium: TextStyle(fontSize: 14.sp,fontFamily: 'Raleway', color:mainColor, fontWeight: FontWeight.w600),
        labelLarge: TextStyle(fontSize: 22.sp,fontFamily: 'Raleway', color:mainColor, fontWeight: FontWeight.w700),
        displayMedium: TextStyle(fontSize: 13.sp,fontFamily: 'Raleway', color:Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}
