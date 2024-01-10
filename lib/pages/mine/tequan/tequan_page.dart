import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/mine/tequan/diwang_page.dart';
import 'package:yuyinting/pages/mine/tequan/gongjue_page.dart';
import 'package:yuyinting/pages/mine/tequan/guowang_page.dart';
import 'package:yuyinting/pages/mine/tequan/houjue_page.dart';
import 'package:yuyinting/pages/mine/tequan/qishi_page.dart';
import 'package:yuyinting/pages/mine/tequan/yongshi_page.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import 'bojue_page.dart';

/// 特权
class TequanPage extends StatefulWidget {
  const TequanPage({Key? key}) : super(key: key);

  @override
  State<TequanPage> createState() => _TequanPageState();
}

class _TequanPageState extends State<TequanPage> {
  int _currentIndex = 0;
  late final PageController _controller;
  int priceDou=360;
  int priceYue=36;
  var listen;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex = 0;
    _controller = PageController(
      initialPage: 0,
    );
    listen = eventBus.on<GuizuButtonBack>().listen((event) {
      if(event.title == '右'){
        setState(() {
          _currentIndex = event.index+1;
          _controller.animateToPage(_currentIndex, duration: const Duration(milliseconds: 500), curve: Curves.ease);
          // _controller.jumpToPage(_currentIndex);
        });
      }
      if(event.title == '左'){
        setState(() {
          _currentIndex = event.index-1;
          // _controller.jumpToPage(_currentIndex);
          _controller.animateToPage(_currentIndex, duration: const Duration(milliseconds: 500), curve: Curves.ease);
        });
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
      backgroundColor: MyColors.zhuangbanBg,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            decoration: const BoxDecoration(
              //设置Container修饰
              image: DecorationImage(
                //背景图片修饰
                image: AssetImage("assets/images/guizu_bg.jpg"),
                fit: BoxFit.fill, //覆盖
              ),
            ),
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(35, 0),

                ///头部信息
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 20),
                  height: ScreenUtil().setHeight(60),
                  width: double.infinity,
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Container(
                        width: ScreenUtil().setHeight(150),
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          color: Colors.white,
                          onPressed: (() {
                            Navigator.of(context).pop();
                            MyUtils.hideKeyboard(context);
                          }),
                        ),
                      ),
                      const Expanded(child: Text('')),
                      WidgetUtils.onlyTextCenter(
                          '贵族',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(34),
                              fontWeight: FontWeight.w600)),
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: (() {}),
                        child: Container(
                          width: ScreenUtil().setWidth(150),
                          alignment: Alignment.centerRight,
                          child: Text(
                            '',
                            style: StyleUtils.getCommonTextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(25),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(10, 0),
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 10.h),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          _currentIndex = 0;
                          _controller.animateToPage(0, duration: const Duration(milliseconds: 500), curve: Curves.ease);

                          priceDou=360;
                          priceYue=36;
                        });
                      }),
                      child: Column(
                        children: [
                          WidgetUtils.onlyText(
                              '勇士',
                              StyleUtils.getCommonTextStyle(
                                  color: _currentIndex == 0
                                      ? Colors.white
                                      : MyColors.zhuangbanWZ,
                                  fontSize: ScreenUtil().setSp(29),
                                  fontWeight: FontWeight.w600)),
                          WidgetUtils.commonSizedBox(8, 0),
                          _currentIndex == 0
                              ? WidgetUtils.showImages(
                                  'assets/images/guizu_xian.png',
                                  ScreenUtil().setHeight(3),
                                  ScreenUtil().setHeight(65))
                              : WidgetUtils.commonSizedBox(
                                  ScreenUtil().setHeight(3),
                                  ScreenUtil().setHeight(65)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          _currentIndex = 1;
                          _controller.animateToPage(1, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                          priceDou=2800;
                          priceYue=280;
                        });
                      }),
                      child: Column(
                        children: [
                          WidgetUtils.onlyText(
                              '骑士',
                              StyleUtils.getCommonTextStyle(
                                  color: _currentIndex == 1
                                      ? Colors.white
                                      : MyColors.zhuangbanWZ,
                                  fontSize: ScreenUtil().setSp(29),
                                  fontWeight: FontWeight.w600)),
                          WidgetUtils.commonSizedBox(8, 0),
                          _currentIndex == 1
                              ? WidgetUtils.showImages(
                                  'assets/images/guizu_xian.png',
                                  ScreenUtil().setHeight(3),
                                  ScreenUtil().setHeight(65))
                              : WidgetUtils.commonSizedBox(
                                  ScreenUtil().setHeight(3),
                                  ScreenUtil().setHeight(65)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          _currentIndex = 2;
                          _controller.animateToPage(2, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                          priceDou=9000;
                          priceYue=900;
                        });
                      }),
                      child: Column(
                        children: [
                          WidgetUtils.onlyText(
                              '伯爵',
                              StyleUtils.getCommonTextStyle(
                                  color: _currentIndex == 2
                                      ? Colors.white
                                      : MyColors.zhuangbanWZ,
                                  fontSize: ScreenUtil().setSp(29),
                                  fontWeight: FontWeight.w600)),
                          WidgetUtils.commonSizedBox(8, 0),
                          _currentIndex == 2
                              ? WidgetUtils.showImages(
                                  'assets/images/guizu_xian.png',
                                  ScreenUtil().setHeight(3),
                                  ScreenUtil().setHeight(65))
                              : WidgetUtils.commonSizedBox(
                                  ScreenUtil().setHeight(3),
                                  ScreenUtil().setHeight(65)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          _currentIndex = 3;
                          _controller.animateToPage(3, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                          priceDou=50000;
                          priceYue=5000;
                        });
                      }),
                      child: Column(
                        children: [
                          WidgetUtils.onlyText(
                              '侯爵',
                              StyleUtils.getCommonTextStyle(
                                  color: _currentIndex == 3
                                      ? Colors.white
                                      : MyColors.zhuangbanWZ,
                                  fontSize: ScreenUtil().setSp(29),
                                  fontWeight: FontWeight.w600)),
                          WidgetUtils.commonSizedBox(8, 0),
                          _currentIndex == 3
                              ? WidgetUtils.showImages(
                                  'assets/images/guizu_xian.png',
                                  ScreenUtil().setHeight(3),
                                  ScreenUtil().setHeight(65))
                              : WidgetUtils.commonSizedBox(
                                  ScreenUtil().setHeight(3),
                                  ScreenUtil().setHeight(65)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          _currentIndex = 4;
                          _controller.animateToPage(4, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                          priceDou=120000;
                          priceYue=12000;
                        });
                      }),
                      child: Column(
                        children: [
                          WidgetUtils.onlyText(
                              '公爵',
                              StyleUtils.getCommonTextStyle(
                                  color: _currentIndex == 4
                                      ? Colors.white
                                      : MyColors.zhuangbanWZ,
                                  fontSize: ScreenUtil().setSp(29),
                                  fontWeight: FontWeight.w600)),
                          WidgetUtils.commonSizedBox(8, 0),
                          _currentIndex == 4
                              ? WidgetUtils.showImages(
                                  'assets/images/guizu_xian.png',
                                  ScreenUtil().setHeight(3),
                                  ScreenUtil().setHeight(65))
                              : WidgetUtils.commonSizedBox(
                                  ScreenUtil().setHeight(3),
                                  ScreenUtil().setHeight(65)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          _currentIndex = 5;
                          _controller.animateToPage(5, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                          priceDou=360000;
                          priceYue=36000;
                        });
                      }),
                      child: Column(
                        children: [
                          WidgetUtils.onlyText(
                              '国王',
                              StyleUtils.getCommonTextStyle(
                                  color: _currentIndex == 5
                                      ? Colors.white
                                      : MyColors.zhuangbanWZ,
                                  fontSize: ScreenUtil().setSp(29),
                                  fontWeight: FontWeight.w600)),
                          WidgetUtils.commonSizedBox(8, 0),
                          _currentIndex == 5
                              ? WidgetUtils.showImages(
                                  'assets/images/guizu_xian.png',
                                  ScreenUtil().setHeight(3),
                                  ScreenUtil().setHeight(65))
                              : WidgetUtils.commonSizedBox(
                                  ScreenUtil().setHeight(3),
                                  ScreenUtil().setHeight(65)),
                        ],
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          _currentIndex = 6;
                          _controller.animateToPage(6, duration: const Duration(milliseconds: 500), curve: Curves.ease);
                          priceDou=580000;
                          priceYue=58000;
                        });
                      }),
                      child: Column(
                        children: [
                          WidgetUtils.onlyText(
                              '帝王',
                              StyleUtils.getCommonTextStyle(
                                  color: _currentIndex == 6
                                      ? Colors.white
                                      : MyColors.zhuangbanWZ,
                                  fontSize: ScreenUtil().setSp(29),
                                  fontWeight: FontWeight.w600)),
                          WidgetUtils.commonSizedBox(8, 0),
                          _currentIndex == 6
                              ? WidgetUtils.showImages(
                                  'assets/images/guizu_xian.png',
                                  ScreenUtil().setHeight(3),
                                  ScreenUtil().setHeight(65))
                              : WidgetUtils.commonSizedBox(
                                  ScreenUtil().setHeight(3),
                                  ScreenUtil().setHeight(65)),
                        ],
                      ),
                    ),
                    WidgetUtils.commonSizedBox(0, 10.h),
                  ],
                ),
                WidgetUtils.commonSizedBox(10, 0),
                Expanded(
                  child: PageView(
                    controller: _controller,
                    onPageChanged: (index) {
                      setState(() {
                        // 更新当前的索引值
                        _currentIndex = index;
                        if(index == 0){
                          priceDou=360;
                          priceYue=36;
                        }else if(index == 1){
                          priceDou=2800;
                          priceYue=280;
                        }else if(index == 2){
                          priceDou=9000;
                          priceYue=900;
                        }else if(index == 3){
                          priceDou=50000;
                          priceYue=5000;
                        }else if(index == 4){
                          priceDou=120000;
                          priceYue=12000;
                        }else if(index == 5){
                          priceDou=360000;
                          priceYue=36000;
                        }else if(index == 6){
                          priceDou=580000;
                          priceYue=58000;
                        }
                      });
                    },
                    children: const [
                      YongshiPage(),
                      QishiPage(),
                      BojuePage(),
                      HoujuePage(),
                      GongjuePage(),
                      GuowangPage(),
                      DiwangPage()
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(80, 0),
              ],
            ),
          ),
          Container(
            height: ScreenUtil().setHeight(206),
            width: double.infinity,
            color: MyColors.guizuBlack,
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(10, 0),
                Expanded(
                    child: Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20),
                    WidgetUtils.onlyText(
                        '开通 ',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(33))),
                    WidgetUtils.onlyText(
                        priceYue.toString(),
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.guizuYellow,
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(33))),
                    WidgetUtils.onlyText(
                        ' 元 / 月',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: ScreenUtil().setSp(33))),
                    WidgetUtils.commonSizedBox(0, 20),
                    WidgetUtils.onlyText(
                        '赠送 ',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.guizuGrey,
                            fontSize: ScreenUtil().setSp(25))),
                    WidgetUtils.onlyText(
                        priceDou.toString(),
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.guizuYellow,
                            fontSize: ScreenUtil().setSp(25))),
                    WidgetUtils.onlyText(
                        ' V豆',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.guizuGrey,
                            fontSize: ScreenUtil().setSp(25))),
                  ],
                )),
                GestureDetector(
                  onTap: (() {
                    MyToastUtils.showToastBottom('荣誉升级，敬请期待');
                  }),
                  child: Container(
                    height: ScreenUtil().setHeight(74),
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    width: double.infinity,
                    //边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: MyColors.guizuYellow,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.all(Radius.circular(37.0)),
                    ),
                    child: WidgetUtils.onlyTextCenter(
                        '开通贵族',
                        StyleUtils.getCommonTextStyle(
                            color: MyColors.guizuYellow2,
                            fontSize: ScreenUtil().setSp(33),
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                WidgetUtils.commonSizedBox(20, 0),
              ],
            ),
          )
        ],
      ),
    );
  }
}
