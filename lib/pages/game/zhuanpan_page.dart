import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/game/zhuanpan_super_page.dart';
import 'package:yuyinting/pages/game/zhuanpan_xin_page.dart';

import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

/// 转盘主页
class ZhuanPanPage extends StatefulWidget {
  const ZhuanPanPage({super.key});

  @override
  State<ZhuanPanPage> createState() => _ZhuanPanPageState();
}

class _ZhuanPanPageState extends State<ZhuanPanPage> {
  int isCheck = 1;

  int _currentIndex = 0;
  late final PageController _controller;

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _controller = PageController(
      initialPage: 0,
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: (() {
                Navigator.pop(context);
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.transparent,
              ),
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(950),
            width: double.infinity,
            decoration: BoxDecoration(
              //设置Container修饰
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage(_currentIndex == 0 ? "assets/images/zhuanpan_tow_bg.png" : "assets/images/zhuanpan_one_bg.png"),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                // 头部信息
                Container(
                  height: ScreenUtil().setHeight(61),
                  margin: const EdgeInsets.only(top: 10),
                  alignment: Alignment.center,
                  child: Row(
                    children: [
                      WidgetUtils.commonSizedBox(0, 10),
                      Container(
                        height: ScreenUtil().setHeight(61),
                        width: ScreenUtil().setHeight(260),
                        //边框设置
                        decoration: const BoxDecoration(
                          //背景
                          color: MyColors.zpBG,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                                child: _currentIndex == 0
                                    ? GestureDetector(
                                        onTap: (() {
                                          setState(() {
                                            _currentIndex = 0;
                                            _controller.animateToPage(0,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.ease);
                                          });
                                        }),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                MyColors.zpBGJ1,
                                                MyColors.zpBGJ2,
                                              ],
                                            ),
                                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '心动转盘',
                                              style: TextStyle(
                                                  color: MyColors.zpWZ1,
                                                  fontSize:
                                                      ScreenUtil().setSp(22),
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: (() {
                                          setState(() {
                                            _currentIndex = 0;
                                            _controller.animateToPage(0,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.ease);
                                          });
                                        }),
                                        child: Center(
                                          child: Text(
                                            '心动转盘',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    ScreenUtil().setSp(22),
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      )),
                            Expanded(
                                child: _currentIndex == 1
                                    ? GestureDetector(
                                        onTap: (() {
                                          setState(() {
                                            _currentIndex = 1;
                                            _controller.animateToPage(1,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.ease);
                                          });
                                        }),
                                        child: Container(
                                          decoration: const BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.topCenter,
                                              end: Alignment.bottomCenter,
                                              colors: [
                                                MyColors.zpBGJ1,
                                                MyColors.zpBGJ2,
                                              ],
                                            ),
                                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(30.0)),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '超级转盘',
                                              style: TextStyle(
                                                  color: MyColors.zpWZ1,
                                                  fontSize:
                                                      ScreenUtil().setSp(22),
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: (() {
                                          setState(() {
                                            _currentIndex = 1;
                                            _controller.animateToPage(1,
                                                duration: const Duration(
                                                    milliseconds: 500),
                                                curve: Curves.ease);
                                          });
                                        }),
                                        child: Center(
                                          child: Text(
                                            '超级转盘',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                    ScreenUtil().setSp(22),
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                      )),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Container(
                        height: ScreenUtil().setHeight(45),
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 1, bottom: 1),
                        //边框设置
                        decoration: const BoxDecoration(
                          //背景
                          color: MyColors.zpBG,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(Radius.circular(30.0)),
                        ),
                        child: Row(
                          children: [
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.showImages(
                                'assets/images/room_liwu_dou.png',
                                ScreenUtil().setHeight(24),
                                ScreenUtil().setHeight(22)),
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.onlyTextCenter(
                                '10000',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(23),
                                    fontWeight: FontWeight.w600)),
                            WidgetUtils.commonSizedBox(0, 5),
                            Opacity(
                              opacity: 0.8,
                              child: Container(
                                height: ScreenUtil().setHeight(20),
                                width: ScreenUtil().setHeight(1),
                                color: MyColors.home_hx,
                              ),
                            ),
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.showImages(
                                'assets/images/room_liwu_zuan.png',
                                ScreenUtil().setHeight(30),
                                ScreenUtil().setHeight(30)),
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.onlyTextCenter(
                                '100',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(23),
                                    fontWeight: FontWeight.w600)),
                            WidgetUtils.commonSizedBox(0, 5),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(0, 10),
                    ],
                  ),
                ),
                Expanded(
                  child: PageView(
                    reverse: false,
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(() {
                        // 更新当前的索引值
                        _currentIndex = index;
                      });
                    },
                    children: const [
                      ZhuanPanXinPage(),
                      ZhuanPanSuperPage(),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
