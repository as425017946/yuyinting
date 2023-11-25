import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/login/login_page.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../config/my_config.dart';
import '../../main.dart';
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
    Future.delayed(const Duration(milliseconds: 2000), ((){
        Navigator.pop(context);
        if (sp.getString('user_token').toString().isNotEmpty &&
            MyConfig.issAdd == false) {
          doGo();
        }else{
          MyUtils.goTransparentPageCom(context, const LoginPage());
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
}
