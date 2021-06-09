import 'package:flutter/material.dart';

class CustomThemeData {
  static ThemeData get lightTheme {
    return ThemeData(
        primaryColor: Color(0xff333333),
        disabledColor: Color(0xffCCCCCC),
        primaryColorDark: Color(0xff663300),
        cardColor: Color(0xffFFFFFF),
        backgroundColor: Color(0xffCCCCCC),
        snackBarTheme: SnackBarThemeData(
          actionTextColor: Color(0xff99CCFF),
          backgroundColor: Color(0xff666666),
          behavior: SnackBarBehavior.floating,
        ),
        textTheme: TextTheme(
            headline1: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                fontFamily: 'Roboto',
                color: Color(0xff333333)),
            headline2: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 16,
                fontFamily: 'Roboto',
                color: Color(0xff333333)),
            headline3: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                fontFamily: 'Roboto',
                color: Color(0xff333333)),
            subtitle1: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                fontFamily: 'Roboto',
                color: Color(0xff333333))));
  }
}
