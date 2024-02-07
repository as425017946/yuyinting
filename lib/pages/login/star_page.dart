import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:yuyinting/pages/login/login_page.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import 'package:yuyinting/utils/my_utils.dart';

import '../../bean/addressIPBean.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/log_util.dart';
import '../navigator/tabnavigator.dart';
/// 启动页后展示的页面
class StarPage extends StatefulWidget {
  const StarPage({super.key});

  @override
  State<StarPage> createState() => _StarPageState();
}

class _StarPageState extends State<StarPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      sp.setInt('tjFirst', 0);
    });
    if (Platform.isAndroid) {
      setState(() {
        sp.setString('myDevices', 'android');
      });
    }else if (Platform.isIOS){
      setState(() {
        sp.setString('myDevices', 'ios');
      });
    }
    doPostPdAddress();
    Future.delayed(const Duration(milliseconds: 2000), ((){
        sp.setBool('joinRoom', false);
        sp.setString('roomID', '');
        if (sp.getString('user_token').toString() == 'null') {
          sp.setString('userIP', '');
        }
        Navigator.pop(context);
        LogE('用户token   ${sp.getString('user_token').toString()}');
        LogE('用户token   ${sp.getString('user_token').toString().isNotEmpty}');
        if (sp.getString('user_token').toString() == 'null') {
          //首次进入
          MyUtils.goTransparentPageCom(context, const LoginPage());
        }else if(MyConfig.issAdd == false && sp.getString('user_token').toString().isNotEmpty){
          //不是首次进入，登录过
          doGo();
        }else{
          //登录过，但是退出了登录
          MyUtils.goTransparentPageCom(context, const LoginPage());
        }
        if(sp.getString('miyao').toString() != 'null' || sp.getString('miyao').toString().isEmpty){
          sp.setString('miyao',DateTime.now().millisecondsSinceEpoch.toString());
        }
    }));
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
        MaterialPageRoute(builder: (context) => const Tab_Navigator()),
        // ignore: unnecessary_null_comparison
            (route) => route == null,
      );
    });
  }

  /// 判断当前网络，然后给返回适配的网络地址
  Future<void> doPostPdAddress() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    sp.setString('myVersion2',version.toString());
    sp.setString('buildNumber',buildNumber);
    try {
      addressIPBean bean = await DataUtils.getPdAddress();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          if(bean.nodes!.isNotEmpty){
            setState(() {
              sp.setString('isDian', bean.nodes!);
              sp.setString('userIP', bean.address!);
            });
          }else{
            MyToastUtils.showToastBottom('IP为空');
          }
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorHttpTitle);
    }
  }
}
