import 'dart:io';
import 'package:android_package_manager/android_package_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import 'package:yuyinting/utils/my_utils.dart';
import '../../bean/Common_bean.dart';
import '../../config/my_config.dart';
import '../../config/online_config.dart';
import '../../http/data_utils.dart';
import '../../main.dart';
import '../../utils/log_util.dart';
import '../../utils/my_ping.dart';
import '../navigator/tabnavigator.dart';

/// 启动页后展示的页面
class StarPage extends StatefulWidget {
  const StarPage({super.key});

  @override
  State<StarPage> createState() => _StarPageState();
}

class _StarPageState extends State<StarPage> {

  List<ApplicationInfo>? _applicationInfoList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      sp.setString('isEmulation', '0');
      sp.setString('mic_quren', '0');
      sp.setString('scIsOk', '0');
      sp.setString('userIP', '');
      sp.setInt('tjFirst', 0);
      sp.setString('isShouQi', '0');
      if (sp.getString('isFirstMessage').toString() == 'null' ||
          sp.getString('isFirstMessage').toString().isEmpty) {
        sp.setString('isFirstMessage', '1');
      }
      if (sp.getInt('user_level').toString() == 'null' ||
          sp.getInt('user_level').toString().isEmpty) {
        sp.setInt('user_level', 0);
      }
      if (sp.getInt('user_grLevel').toString() == 'null' ||
          sp.getInt('user_grLevel').toString().isEmpty) {
        sp.setInt('user_grLevel', 0);
      }
      sp.setString('sqRoomID', '');
    });
    if (Platform.isAndroid) {
      setState(() {
        sp.setString('myDevices', 'android');
      });
    } else if (Platform.isIOS) {
      setState(() {
        sp.setString('myDevices', 'ios');
      });
    }

    if (sp.getString('miyao').toString() == 'null' ||
        sp.getString('miyao').toString().isEmpty) {
      sp.setString('miyao', DateTime.now().millisecondsSinceEpoch.toString());
    }

    doPostAheadPunish();
    // doPostPdAddress();
    Future.delayed(const Duration(milliseconds: 2000), (() {
      sp.setBool('joinRoom', false);
      sp.setString('roomID', '');
      if (sp.getString('user_token').toString() == 'null') {
        sp.setString('userIP', '');
      }
      Navigator.pop(context);
      if (sp.getString('user_token').toString() == 'null') {
        //首次进入
        Navigator.pushNamed(context, 'LoginPage');
      } else if (MyConfig.issAdd == false &&
          sp.getString('user_token').toString().isNotEmpty) {
        //不是首次进入，登录过
        doGo();
      } else {
        LogE('用户token   ${sp.getString('user_token').toString()}');
        //登录过，但是退出了登录
        Navigator.pushNamed(context, 'LoginPage');
      }

    }));

    _getBatteryLevel();
  }


  final methodChannel = const MethodChannel('moniqi');

  Future<void> _getBatteryLevel() async {
    try {
      final result = await methodChannel.invokeMethod('getBatteryLevel');
      sp.setString('isEmulation', result.toString());
      LogE('返回结果== $result');
    } on PlatformException catch (e) {
      LogE('返回结果==2 ${e.toString()}');
    }

  }

  @override
  Widget build(BuildContext context) {
    //设置字体大小根据系统的“字体大小”辅助选项来进行缩放,默认为false : 字体随着系统的“字体大小”辅助选项来进行缩放
    ScreenUtil.init(context,
        designSize: const Size(750, 1334), splitScreenMode: false);
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          //设置Container修饰
          image: DecorationImage(
            //背景图片修饰
            image: AssetImage("assets/images/star_bg.png"),
            fit: BoxFit.fill, //覆盖
          ),
        ),
      ),
    );
  }

  Future<void> doGo() async {
    Future.delayed(const Duration(microseconds: 10), () {
      //跳转并关闭当前页面
      // ignore: use_build_context_synchronously
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Tab_Navigator(), settings: const RouteSettings(name: '回首页')),
        // ignore: unnecessary_null_comparison
        (route) => route == null,
      );
    });
  }

  // /// 判断当前网络，然后给返回适配的网络地址
  // Future<void> doPostPdAddress() async {
  //   try {
  //     // Map<String, dynamic> params = <String, dynamic>{'type': 'test'};
  //     // Map<String, dynamic> params = <String, dynamic>{'type': 'go'};
  //     var respons = await DataUtils.postPdAddress(OnlineConfig.pingParams);
  //     if (respons.code == 200) {
  //       setState(() {
  //         sp.setString('userIP', respons.address);
  //       });
  //       MyPing.checkIp(
  //         respons.ips,
  //         (ip) {
  //           if (mounted) {
  //             setState(() {
  //               // sp.setString('isDian', ip);
  //               // LogE('Ping 设置: ${sp.getString('isDian')}');
  //               // // MyHttpConfig.baseURL =
  //               // // "http://${sp.getString('isDian').toString()}:8081/api";
  //               // MyHttpConfig.baseURL =
  //               // "http://${sp.getString('isDian').toString()}:8080/api";
  //               OnlineConfig.updateIp(ip);
  //             });
  //           }
  //         },
  //       );
  //     } else if (respons.code == 401) {
  //       // ignore: use_build_context_synchronously
  //       MyUtils.jumpLogin(context);
  //     } else {
  //       MyToastUtils.showToastBottom('IP获取失败~');
  //     }
  //   } catch (e) {
  //     // MyToastUtils.showToastBottom(MyConfig.errorTitle);
  //     // MyToastUtils.showToastBottom(MyConfig.errorTitleFile);
  //   }
  // }

  /// 打开app
  Future<void> doPostAheadPunish() async {
    try {
      LogE('用户token ${sp.getString('user_token')}');
      CommonBean bean = await DataUtils.postAppOpen();
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
