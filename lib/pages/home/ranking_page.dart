import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/home/rank/rank_caifu_page.dart';
import 'package:yuyinting/pages/home/rank/rank_meili_page.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

/// 排行榜
class RankingPage extends StatefulWidget {
  const RankingPage({Key? key}) : super(key: key);

  @override
  State<RankingPage> createState() => _RankingPageState();
}

class _RankingPageState extends State<RankingPage> {
  int _currentIndex = 0;
  late final PageController _controller;
  // 设备是安卓还是ios
  String isDevices = 'android';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      setState(() {
        isDevices = 'android';
      });
    }else if (Platform.isIOS){
      setState(() {
        isDevices = 'ios';
      });
    }
    _controller = PageController(
      initialPage: _currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          //设置Container修饰
          image: isDevices == 'ios' ? DecorationImage(
            //背景图片修饰
            image: AssetImage(_currentIndex == 0 ? "assets/images/py_meili_ios_bg.png" :  "assets/images/py_caifu_ios_bg.png"),
            fit: BoxFit.fill, //覆盖
          ) : DecorationImage(
            //背景图片修饰
            image: AssetImage(_currentIndex == 0 ? "assets/images/py_meili_bg.png" :  "assets/images/py_caifu_bg.png"),
            fit: BoxFit.fill, //覆盖
          ),
        ),
        child: Column(
          children: [
            WidgetUtils.commonSizedBox(isDevices == 'ios' ? 90.h : 55.h, 0),

            ///头部
            SizedBox(
              height: ScreenUtil().setHeight(56),
              width: double.infinity,
              child: Row(
                children: [
                  WidgetUtils.commonSizedBox(0, 20),
                  GestureDetector(
                    onTap: (() {
                        if(MyUtils.checkClick()) {
                          Navigator.pop(context);
                        }
                    }),
                    child: WidgetUtils.showImages('assets/images/back.jpg',
                        ScreenUtil().setHeight(35), ScreenUtil().setHeight(25)),
                  ),
                  const Expanded(child: Text('')),
                  GestureDetector(
                    onTap: (() {
                      setState(() {
                        _currentIndex = 0;
                        _controller.jumpToPage(0);
                      });
                    }),
                    child: Container(
                      height: 100.h,
                      width: 135.h,
                      color: Colors.transparent,
                    ),
                  ),
                  WidgetUtils.commonSizedBox(0, 45.w),
                  GestureDetector(
                    onTap: (() {
                      setState(() {
                        _currentIndex = 1;
                        _controller.jumpToPage(1);
                      });
                    }),
                    child: Container(
                      height: 100.h,
                      width: 135.h,
                      color: Colors.transparent,
                    ),
                  ),
                  const Expanded(child: Text('')),
                  WidgetUtils.commonSizedBox(0, 45),
                ],
              ),
            ),

            Expanded(
              child: PageView(
                physics: const NeverScrollableScrollPhysics(), //禁止左右滑动
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    // 更新当前的索引值
                    _currentIndex = index;
                  });
                },
                children: const [
                  RankMeiLiPage(),
                  RankCaiFuPage()
                ],
              ),
            )
          ],
        ) /* add child content here */,
      ),
    );
  }
}
