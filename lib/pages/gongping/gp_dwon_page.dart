import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:screen/screen.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import '../../colors/my_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import 'package:http/http.dart' as http;

/// 预下载资源图片
class GPDownPage extends StatefulWidget {
  const GPDownPage({super.key});

  @override
  State<GPDownPage> createState() => _GPDownPageState();
}

class _GPDownPageState extends State<GPDownPage> {
  double jindu = 0, jinduNum = 0;
  String jinduBaifeinbi = '';
  var listen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //保持屏幕常亮
    saveLiang();
  }
  saveLiang() async {
    // 获取屏幕亮度:
    double brightness = await Screen.brightness;
    // 设置亮度:
    Screen.setBrightness(0.5);
    // 检测屏幕是否常亮:
    bool isKeptOn = await Screen.isKeptOn;
    // 防止进入睡眠模式:
    Screen.keepOn(true);
    eventBus.fire(SubmitButtonBack(title: '资源开始下载'));
    listen = eventBus.on<DownLoadingBack>().listen((event) {
      setState(() {
        jinduNum = event.jinduNum;
        jindu = event.jindu;
      });
      if(jindu == 1){
        MyToastUtils.showToastBottom('资源更新完成');
        Navigator.pop(context);
      }
    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: WillPopScope(
        //不能点击返回消失页面
        onWillPop: () async {
          return Future.value(false);
        },
        child: Center(
          child: SizedBox(
            height: 600.h,
            width: 520.h,
            child: Stack(
              children: [
                WidgetUtils.showImages('assets/images/qx_bg1.png', 600.h, 520.h),
                Column(
                  children: [
                    WidgetUtils.commonSizedBox(230.h, 0),
                    WidgetUtils.onlyTextCenter(
                        '资源下载',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.homeTopBG,
                            fontSize: 42.sp,
                            fontWeight: FontWeight.w600)),
                    WidgetUtils.commonSizedBox(15.h, 0),
                    Padding(
                      padding: EdgeInsets.only(left: 40.h, right: 40.h),
                      child: Text(
                        '为了获得更好的体验，请下载最新的资源包，解锁全新版本和惊喜内容！',
                        maxLines: 5,
                        style: TextStyle(
                            height: 1.5,
                            color: MyColors.homeTopBG,
                            fontSize: 30.sp),
                      ),
                    ),
                    WidgetUtils.commonSizedBox(20.h, 0),
                    SizedBox(
                      height: 20.h,
                      width: 400.h,
                      // 圆角矩形剪裁（`ClipRRect`）组件，使用圆角矩形剪辑其子项的组件。
                      child: ClipRRect(
                        // 边界半径（`borderRadius`）属性，圆角的边界半径。
                        borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                        child: LinearProgressIndicator(
                          value: jindu,
                          backgroundColor: const Color(0xFFD8D8D8),
                          valueColor: const AlwaysStoppedAnimation<Color>(
                              Color(0xFF5b46b9)),
                        ),
                      ),
                    ),
                    WidgetUtils.commonSizedBox(15.h, 0),
                    SizedBox(
                      height: 30.h,
                      width: 400.h,
                      child: Row(
                        children: [
                          WidgetUtils.onlyText('已下载$jinduNum%',  StyleUtils.getCommonTextStyle(
                              color: MyColors.homeTopBG,
                              fontSize: 28.sp,)),
                          const Spacer(),
                          WidgetUtils.onlyText('总计100%',  StyleUtils.getCommonTextStyle(
                            color: MyColors.homeTopBG,
                            fontSize: 28.sp,))
                        ],
                      ),
                    ),
                    WidgetUtils.commonSizedBox(10.h, 0),
                    GestureDetector(
                      onTap: ((){
                        Navigator.pop(context);
                      }),
                      child: Container(
                        height: 70.h,
                        width: 400.h,
                        //边框设置
                        decoration: const BoxDecoration(
                          //背景
                          color: MyColors.homeTopBG,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(Radius.circular(25.0)),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          '后台下载',
                          style: TextStyle(
                            fontSize: 28.sp,
                            color: Colors.white
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


}
