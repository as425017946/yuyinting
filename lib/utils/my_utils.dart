import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:yuyinting/pages/game/mofang_page.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import '../main.dart';
import '../pages/login/login_page.dart';
import 'log_util.dart';
import 'my_toast_utils.dart';

class MyUtils {
  ///字符串比较,返回0相等，返回1不想等
  static int compare(String str1, String str2) {
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
    String regexPhoneNumber =
        "^((13[0-9])|(15[^4])|(166)|(17[0-8])|(18[0-9])|(19[8-9])|(147,145))\\d{8}\$";
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

  // 校验身份证合法性
  static bool verifyCardId(String cardId) {
    const Map city = {
      11: "北京",
      12: "天津",
      13: "河北",
      14: "山西",
      15: "内蒙古",
      21: "辽宁",
      22: "吉林",
      23: "黑龙江 ",
      31: "上海",
      32: "江苏",
      33: "浙江",
      34: "安徽",
      35: "福建",
      36: "江西",
      37: "山东",
      41: "河南",
      42: "湖北 ",
      43: "湖南",
      44: "广东",
      45: "广西",
      46: "海南",
      50: "重庆",
      51: "四川",
      52: "贵州",
      53: "云南",
      54: "西藏 ",
      61: "陕西",
      62: "甘肃",
      63: "青海",
      64: "宁夏",
      65: "新疆",
      71: "台湾",
      81: "香港",
      82: "澳门",
      91: "国外 "
    };
    String tip = '';
    bool pass = true;

    RegExp cardReg = RegExp(
        r'^\d{6}(18|19|20)?\d{2}(0[1-9]|1[012])(0[1-9]|[12]\d|3[01])\d{3}(\d|X)$');
    if (cardId == null || cardId.isEmpty || !cardReg.hasMatch(cardId)) {
      tip = '身份证号格式错误';
      print(tip);
      pass = false;
      return pass;
    }
    if (city[int.parse(cardId.substring(0, 2))] == null) {
      tip = '地址编码错误';
      print(tip);
      pass = false;
      return pass;
    }
    // 18位身份证需要验证最后一位校验位，15位不检测了，现在也没15位的了
    if (cardId.length == 18) {
      List numList = cardId.split('');
      //∑(ai×Wi)(mod 11)
      //加权因子
      List factor = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
      //校验位
      List parity = [1, 0, 'X', 9, 8, 7, 6, 5, 4, 3, 2];
      int sum = 0;
      int ai = 0;
      int wi = 0;
      for (var i = 0; i < 17; i++) {
        ai = int.parse(numList[i]);
        wi = factor[i];
        sum += ai * wi;
      }
      var last = parity[sum % 11];
      if (parity[sum % 11].toString() != numList[17]) {
        tip = "校验位错误";
        print(tip);
        pass = false;
      }
    } else {
      tip = '身份证号不是18位';
      print(tip);
      pass = false;
    }
//  print('证件格式$pass');
    return pass;
  }

// 根据身份证号获取年龄
  static int getAgeFromCardId(String cardId) {
    bool isRight = verifyCardId(cardId);
    if (!isRight) {
      return 0;
    }
    int len = (cardId).length;
    String strBirthday = "";
    if (len == 18) {
      //处理18位的身份证号码从号码中得到生日和性别代码
      strBirthday = "${cardId.substring(6, 10)}-${cardId.substring(10, 12)}-${cardId.substring(12, 14)}";
    }
    if (len == 15) {
      strBirthday = "19${cardId.substring(6, 8)}-${cardId.substring(8, 10)}-${cardId.substring(10, 12)}";
    }
    int age = getAgeFromBirthday(strBirthday);
    return age;
  }

// 根据出生日期获取年龄
  static int getAgeFromBirthday(String strBirthday) {
    if (strBirthday == null || strBirthday.isEmpty) {
      print('生日错误');
      return 0;
    }
    DateTime birth = DateTime.parse(strBirthday);
    DateTime now = DateTime.now();

    int age = now.year - birth.year;
    //再考虑月、天的因素
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }

// 根据身份证获取性别
  static String getSexFromCardId(String cardId) {
    String sex = "";
    bool isRight = verifyCardId(cardId);
    if (!isRight) {
      return sex;
    }
    if (cardId.length == 18) {
      if (int.parse(cardId.substring(16, 17)) % 2 == 1) {
        sex = "男";
      } else {
        sex = "女";
      }
    }
    if (cardId.length == 15) {
      if (int.parse(cardId.substring(14, 15)) % 2 == 1) {
        sex = "男";
      } else {
        sex = "女";
      }
    }
    return sex;
  }

  ///跳转到登录页面
  static void jumpLogin(BuildContext context) {
    sp.setString('user_token', '');
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

  /// 通用跳转到一个透明页面，从右到左滚出的方法
  static void goTransparentRFPage(BuildContext context, Widget page) {
    Future.delayed(const Duration(seconds: 0), () {
      Navigator.push(
        context,
        PageRouteBuilder(
          //自定义路由
          opaque: false,
          pageBuilder: (context, a, _) => page, //需要跳转的页面
          transitionsBuilder: (context, a, _, child) {
            const begin = Offset(1,
                0); //Offset是一个2D小部件，他将记录坐标轴的x,y前者为宽，后者为高 如果将begin =Offset(1,0)为从右到左 改为(0,1),效果则会变成从下到上
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
  static void goTransparentPage(BuildContext context, Widget page) {
    Future.delayed(const Duration(seconds: 0), () {
      Navigator.push(
        context,
        PageRouteBuilder(
          //自定义路由
          opaque: false,
          pageBuilder: (context, a, _) => page, //需要跳转的页面
          transitionsBuilder: (context, a, _, child) {
            const begin = Offset(0,
                1); //Offset是一个2D小部件，他将记录坐标轴的x,y前者为宽，后者为高 如果将begin =Offset(1,0)为从右到左 改为(0,1),效果则会变成从下到上
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

  /// 通用跳转到一个透明页面
  static void goTransparentPageCom(BuildContext context, Widget page) {
    Future.delayed(const Duration(seconds: 0), () {
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, animation, secondaryAnimation) {
            return page;
          }));
    });
  }

  static Widget myHeader() {
    return CustomHeader(
      builder: (BuildContext context, RefreshStatus? mode) {
        Widget headerBody;
        if (mode == RefreshStatus.idle) {
          headerBody = const Text('下拉刷新');
        } else if (mode == RefreshStatus.refreshing) {
          // headerBody = Text('刷新中...');
          headerBody = WidgetUtils.showImages('assets/images/a1.gif',
              ScreenUtil().setHeight(50), ScreenUtil().setHeight(50));
        } else if (mode == RefreshStatus.failed) {
          headerBody = const Text('刷新失败');
        } else if (mode == RefreshStatus.completed) {
          headerBody = const Text('刷新完成');
        } else if (mode == RefreshStatus.canRefresh) {
          headerBody = const Text('松手刷新');
        } else {
          headerBody = const Text("完成");
        }
        return SizedBox(
          height: ScreenUtil().setHeight(50),
          child: Center(child: headerBody),
        );
      },
    );
  }

  static Widget myFotter() {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = const Text("上拉加载");
        } else if (mode == LoadStatus.loading) {
          body = const Text("加载中");
        } else if (mode == LoadStatus.failed) {
          body = const Text("加载更多失败");
        } else if (mode == LoadStatus.canLoading) {
          body = const Text("松手加载更多");
        } else {
          body = const Text("没有更多");
        }
        return SizedBox(
          height: ScreenUtil().setHeight(50),
          child: Center(child: body),
        );
      },
    );
  }
}
