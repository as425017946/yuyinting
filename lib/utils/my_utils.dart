import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:yuyinting/pages/game/mofang_page.dart';
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

  /// 通用跳转到一个透明页面，从底部向上滚出的方法
  static void goTransparentPage(BuildContext context,Widget  page){
    Future.delayed(const Duration(seconds: 0), () {
      Navigator.push(
        context,
        PageRouteBuilder(//自定义路由
          opaque: false,
          pageBuilder: (context, a, _) =>  page,//需要跳转的页面
          transitionsBuilder: (context, a, _, child) {
            const begin =
            Offset(0, 1); //Offset是一个2D小部件，他将记录坐标轴的x,y前者为宽，后者为高 如果将begin =Offset(1,0)改为(0,1),效果则会变成从下到上
            const end = Offset.zero; //得到Offset.zero坐标值
            const curve = Curves.ease; //这是一个曲线动画
            var tween = Tween(begin: begin, end: end)
                .chain(CurveTween(curve: curve)); //使用补间动画转换为动画
            return SlideTransition(
              //转场动画//目前我认为只能用于跳转效果
              position: a.drive(tween), //这里将获得一个新的动画
              child: child,
            );
          },
        ),
      );
    });
  }


  /// 通用跳转到一个透明页面，从底部向上滚出的方法
  static void goTransparentPageCom(BuildContext context,Widget  page){
    Future.delayed(const Duration(seconds: 0), (){
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, animation, secondaryAnimation) {
            return page;
          }));
    });
  }

}