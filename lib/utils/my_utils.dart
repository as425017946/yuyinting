import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../pages/login/login_page.dart';
import 'my_toast_utils.dart';

class MyUtils{
  ///字符串比较,返回0相等，返回1不想等
  static int compare(String str1, String str2){
    return Comparable.compare(str1, str2);
  }

  /// 防重复提交
  // ignore: prefer_typing_uninitialized_variables
  static var lastPopTime;
  static bool checkClick({int needTime = 1}) {
    if (lastPopTime == null ||
        DateTime.now().difference(lastPopTime) > Duration(seconds: needTime)) {
      lastPopTime = DateTime.now();
      return true;
    }
    return false;
  }

  ///禁止输入空格
  static const String regexFirstNotNull = r'^(\S){1}';

  ///手机正则验证
  static bool chinaPhoneNumber(String input) {
    if (input == null || input.isEmpty) return false;
    String regexPhoneNumber =  "^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$";
    return RegExp(regexPhoneNumber).hasMatch(input);
  }

  /// 检查邮箱格式
  static bool email(String input) {
    if (input == null || input.isEmpty) return false;
    // 邮箱正则
    String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
    return RegExp(regexEmail).hasMatch(input);
  }

  /// 点击任意位置关闭键盘
  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  ///跳转到登录页面
  static void jumpLogin(BuildContext context){
    MyToastUtils.showToastBottom('登录超时，请重新登录！');
    Future.delayed(Duration.zero, () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        // ignore: unnecessary_null_comparison
            (route) => route == null,
      );
    });
  }

}