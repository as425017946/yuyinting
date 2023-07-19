import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/login/login_page.dart';
import 'package:yuyinting/routes/routes.dart';
//定义一个全局的存储对象
late SharedPreferences sp;
void main() async{

  //加入后可正常使用
  WidgetsFlutterBinding.ensureInitialized();
  //初始化存储
  sp = await SharedPreferences.getInstance();

  // 透明状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(statusBarColor: Colors.transparent,statusBarIconBrightness: Brightness.dark,);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  // 强制竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(const MyApp());
}
MaterialColor my_green = const MaterialColor(
  0xFF5B46B9,
  <int, Color>{
    50: Color(0xFF5B46B9),
    100: Color(0xFF5B46B9),
    200: Color(0xFF5B46B9),
    300: Color(0xFF5B46B9),
    400: Color(0xFF5B46B9),
    500: Color(0xFF5B46B9),
    600: Color(0xFF5B46B9),
    700: Color(0xFF5B46B9),
    800: Color(0xFF5B46B9),
    900: Color(0xFF5B46B9),
  },
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '语音厅',
      theme: ThemeData(
        primarySwatch: my_green,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      builder: EasyLoading.init(),
      //配置路由  -- map格式
      routes: staticRoutes,
    );
  }
}

