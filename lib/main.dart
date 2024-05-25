import 'dart:io';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:dart_ping_ios/dart_ping_ios.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bugly/flutter_bugly.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yuyinting/pages/login/star_page.dart';
import 'package:yuyinting/routes/routes.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:get/get.dart';

import 'utils/background_fetch_manager.dart';



//定义一个全局的存储对象
late SharedPreferences sp;
void main() async {
  // 确保初始化完成
  WidgetsFlutterBinding.ensureInitialized();

  //初始化存储
  sp = await SharedPreferences.getInstance();

  // 透明状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  } else {
    // ios 注册Ping
    DartPingIOS.register();
  }
  // 强制竖屏
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  /// 如果是全屏就切换竖屏
  AutoOrientation.portraitAutoMode();

  FlutterBugly.postCatchedException(() {
    // // 初始化 Bugly
    // FlutterBugly.init(
    //   androidAppId: "5a93eefd46",
    //   iOSAppId: "9402178c9d",
    //   customUpgrade: true, // 调用 Android 原生升级方式
    // ).then((_result) {
    //   LogE('Bugly 返回id ${_result.appId}');
    // });

    runApp(const MyApp());
  });

  backgroundFetchManager.register();
}

MaterialColor my_green = const MaterialColor(
  0xFF61dcde,
  <int, Color>{
    50: Color(0xFF61dcde),
    100: Color(0xFF61dcde),
    200: Color(0xFF61dcde),
    300: Color(0xFF61dcde),
    400: Color(0xFF61dcde),
    500: Color(0xFF61dcde),
    600: Color(0xFF61dcde),
    700: Color(0xFF61dcde),
    800: Color(0xFF61dcde),
    900: Color(0xFF61dcde),
  },
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '语音厅',
      theme: ThemeData(
        primarySwatch: my_green,
      ),
      debugShowCheckedModeBanner: false,
      home: const StarPage(),
      builder: EasyLoading.init(
        builder: (context, child) {
          return MediaQuery(
            // 设置字体不跟随系统变化
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child ?? Container(),
          );
        },
      ),
      //配置路由  -- map格式
      routes: staticRoutes,
      localizationsDelegates: const [
        // ... 其他本地化委托
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // 添加 Cupertino 的本地化委托
      ],
      supportedLocales: const [
        Locale('zh', 'CN'), // 设置支持的中文简体语言
      ],
      locale: const Locale('zh', 'CN'), // 设置默认的locale
    );
  }
}
