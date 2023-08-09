import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/home/paidui_page.dart';
import 'package:yuyinting/pages/home/shoucang_page.dart';
import 'package:yuyinting/pages/home/tuijian_page.dart';
import 'package:yuyinting/pages/home/youxi_page.dart';
import 'package:yuyinting/pages/home/zaixian_page.dart';
import 'package:yuyinting/pages/login/edit_info_page.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../main.dart';
import '../../utils/my_utils.dart';

///首页
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  int _currentIndex = 1;
  late final PageController _controller;

  bool isFirst = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex = 1;
    _controller = PageController(
      initialPage: 1,
    );
    LogE('是否第一次登录${sp.getBool('isFirst')}');
    if(sp.getBool('isFirst') == true){
      MyUtils.goTransparentPageCom(context, const EditInfoPage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            ///头部
            Container(
              color: MyColors.homeTopBG,
              height: ScreenUtil().setHeight(150),
              width: double.infinity,
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(35, 0),
                  Row(
                    children: [
                      WidgetUtils.commonSizedBox(0, 20),
                      Expanded(
                          child: Container(
                            width: double.infinity,
                            height: ScreenUtil().setHeight(67),
                            alignment: Alignment.bottomLeft,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Expanded(
                                    child: GestureDetector(
                                      onTap: (() {
                                        setState(() {
                                          _currentIndex = 0;
                                          _controller.jumpToPage(0);
                                        });
                                      }),
                                      child: WidgetUtils.onlyTextBottom(
                                          '收藏',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: _currentIndex == 0
                                                  ? ScreenUtil().setSp(38)
                                                  : ScreenUtil().setSp(32),
                                              fontWeight: _currentIndex == 0
                                                  ? FontWeight.w600
                                                  : FontWeight.normal)),
                                    )),
                                Expanded(
                                    child: GestureDetector(
                                      onTap: (() {
                                        setState(() {
                                          _currentIndex = 1;
                                          _controller.jumpToPage(1);
                                        });
                                      }),
                                      child: WidgetUtils.onlyTextBottom(
                                          '推荐',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: _currentIndex == 1
                                                  ? ScreenUtil().setSp(38)
                                                  : ScreenUtil().setSp(32),
                                              fontWeight: _currentIndex == 1
                                                  ? FontWeight.w600
                                                  : FontWeight.normal)),
                                    )),
                                Expanded(
                                    child: GestureDetector(
                                      onTap: (() {
                                        setState(() {
                                          _currentIndex = 2;
                                          _controller.jumpToPage(2);
                                        });
                                      }),
                                      child: WidgetUtils.onlyTextBottom(
                                          '派对',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: _currentIndex == 2
                                                  ? ScreenUtil().setSp(38)
                                                  : ScreenUtil().setSp(32),
                                              fontWeight: _currentIndex == 2
                                                  ? FontWeight.w600
                                                  : FontWeight.normal)),
                                    )),
                                Expanded(
                                    child: GestureDetector(
                                      onTap: (() {
                                        setState(() {
                                          _currentIndex = 3;
                                          _controller.jumpToPage(3);
                                        });
                                      }),
                                      child: Column(
                                        children: [
                                          const Spacer(),
                                          _currentIndex == 3
                                              ? WidgetUtils.showImages(
                                              'assets/images/home_yx2.png',
                                              ScreenUtil().setHeight(40),
                                              ScreenUtil().setHeight(75))
                                              : WidgetUtils.showImagesFill(
                                              'assets/images/home_yx1.png',
                                              ScreenUtil().setHeight(25),
                                              ScreenUtil().setHeight(62)),
                                          _currentIndex != 3
                                              ? WidgetUtils.commonSizedBox(3, 0)
                                              : WidgetUtils.commonSizedBox(0, 0)
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    child: GestureDetector(
                                      onTap: (() {
                                        setState(() {
                                          _currentIndex = 4;
                                          _controller.jumpToPage(4);
                                        });
                                      }),
                                      child: WidgetUtils.onlyTextBottom(
                                          '在线',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: _currentIndex == 4
                                                  ? ScreenUtil().setSp(38)
                                                  : ScreenUtil().setSp(32),
                                              fontWeight: _currentIndex == 4
                                                  ? FontWeight.w600
                                                  : FontWeight.normal)),
                                    )),
                              ],
                            ),
                          )),
                      Container(
                        width: ScreenUtil().setHeight(140),
                        height: ScreenUtil().setHeight(67),
                        padding: const EdgeInsets.only(right: 20),
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: (() {
                            Navigator.pushNamed(context, 'RankingPage');
                          }),
                          child: WidgetUtils.showImages(
                              "assets/images/b7y.png", 26, 30),
                        ),
                      ),
                    ],
                  ),
                  Container(
                    width: double.infinity,
                    height: ScreenUtil().setHeight(5),
                    margin: EdgeInsets.only(
                        left: 20, right: ScreenUtil().setHeight(140)),
                    child: Row(
                      children: [
                        _currentIndex == 0
                            ? Expanded(
                            child: Container(
                              width: ScreenUtil().setHeight(68),
                              height: ScreenUtil().setHeight(10),
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  Container(
                                    width: ScreenUtil().setHeight(20),
                                    height: ScreenUtil().setHeight(4),
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: Colors.white,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                  ),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            ))
                            : const Expanded(child: Text('')),
                        _currentIndex == 1
                            ? Expanded(
                            child: Container(
                              width: ScreenUtil().setHeight(68),
                              height: ScreenUtil().setHeight(10),
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  Container(
                                    width: ScreenUtil().setHeight(20),
                                    height: ScreenUtil().setHeight(4),
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: Colors.white,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                  ),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            ))
                            : const Expanded(child: Text('')),
                        _currentIndex == 2
                            ? Expanded(
                            child: Container(
                              width: ScreenUtil().setHeight(68),
                              height: ScreenUtil().setHeight(10),
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  Container(
                                    width: ScreenUtil().setHeight(20),
                                    height: ScreenUtil().setHeight(4),
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: Colors.white,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                  ),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            ))
                            : const Expanded(child: Text('')),
                        _currentIndex == 3
                            ? Expanded(
                            child: Container(
                              width: ScreenUtil().setHeight(68),
                              height: ScreenUtil().setHeight(10),
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  Container(
                                    width: ScreenUtil().setHeight(20),
                                    height: ScreenUtil().setHeight(4),
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: Colors.white,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                  ),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            ))
                            : const Expanded(child: Text('')),
                        _currentIndex == 4
                            ? Expanded(
                            child: Container(
                              width: ScreenUtil().setHeight(68),
                              height: ScreenUtil().setHeight(10),
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  Container(
                                    width: ScreenUtil().setHeight(20),
                                    height: ScreenUtil().setHeight(4),
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: Colors.white,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                  ),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            ))
                            : const Expanded(child: Text('')),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    // 更新当前的索引值
                    _currentIndex = index;
                  });
                },
                children: const [
                  ShoucangPage(),
                  TuijianPage(),
                  PaiduiPage(),
                  YouxiPage(),
                  ZaixianPage(),
                ],
              ),
            )
          ],
        )
    );
  }
}
