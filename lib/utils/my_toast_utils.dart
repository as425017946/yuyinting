import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../colors/my_colors.dart';

class MyToastUtils{
  static void showWarnToast(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  static void showToastCenter(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: MyColors.translucence,
        textColor: Colors.white,
        fontSize: ScreenUtil().setSp(32)
    );
  }
  static void showToastBottom(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: MyColors.translucence,
        textColor: Colors.white,
        fontSize: ScreenUtil().setSp(32)
    );
  }
  static void showToastBottom2(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        backgroundColor: MyColors.translucence,
        textColor: Colors.white,
        fontSize: ScreenUtil().setSp(32)
    );
  }
}