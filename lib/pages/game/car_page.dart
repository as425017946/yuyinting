import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/widget_utils.dart';

/// 赛车游戏
class Carpage extends StatefulWidget {
  const Carpage({super.key});

  @override
  State<Carpage> createState() => _CarpageState();
}

class _CarpageState extends State<Carpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          WidgetUtils.commonSizedBox(100, 0),
          Stack(
            children: [
              WidgetUtils.showImages('assets/images/z_maliao.png',
                  ScreenUtil().setHeight(100), ScreenUtil().setHeight(200)),
              Positioned(
                  left: 25,
                  top: 45,
                  child: WidgetUtils.showImages('assets/images/z_wheel.gif',
                      ScreenUtil().setHeight(30), ScreenUtil().setHeight(30))),
              Positioned(
                  left: 72,
                  top: 52,
                  child: WidgetUtils.showImages('assets/images/z_wheel.gif',
                      ScreenUtil().setHeight(20), ScreenUtil().setHeight(20))),
            ],
          )
        ],
      ),
    );
  }
}
