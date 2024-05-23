import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/mine/tequan/diwang_page.dart';
import 'package:yuyinting/pages/mine/tequan/gongjue_page.dart';
import 'package:yuyinting/pages/mine/tequan/guowang_page.dart';
import 'package:yuyinting/pages/mine/tequan/houjue_page.dart';
import 'package:yuyinting/pages/mine/tequan/qishi_page.dart';
import 'package:yuyinting/pages/mine/tequan/shenhuang_page.dart';
import 'package:yuyinting/pages/mine/tequan/tequan_guize_page.dart';
import 'package:yuyinting/pages/mine/tequan/tequan_listofgods.dart';
import 'package:yuyinting/pages/mine/tequan/tequan_shuoming_page.dart';
import 'package:yuyinting/pages/mine/tequan/tianzun_page.dart';
import 'package:yuyinting/pages/mine/tequan/yongshi_page.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';

import '../../../bean/gzBean.dart';
import '../../../colors/my_colors.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../message/chat_page.dart';
import 'bojue_page.dart';
import 'chuanshuo_page.dart';

/// 特权
class TequanPage extends StatefulWidget {
  const TequanPage({Key? key}) : super(key: key);

  @override
  State<TequanPage> createState() => _TequanPageState();
}

class _TequanPageState extends State<TequanPage> {
  int _currentIndex = 0;
  late final PageController _controller;
  int priceDou = 360;
  int priceYue = 36;
  var listen;
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
    } else if (Platform.isIOS) {
      setState(() {
        isDevices = 'ios';
      });
    }
    doPostMyNoble();
    listen = eventBus.on<GuizuButtonBack>().listen((event) {
      if (event.title == '右') {
        setState(() {
          _currentIndex = event.index + 1;
          _controller.animateToPage(_currentIndex,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
          // _controller.jumpToPage(_currentIndex);
        });
      }
      if (event.title == '左') {
        setState(() {
          _currentIndex = event.index - 1;
          // _controller.jumpToPage(_currentIndex);
          _controller.animateToPage(_currentIndex,
              duration: const Duration(milliseconds: 500), curve: Curves.ease);
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
      body: isOK
          ? Stack(
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
                      WidgetUtils.commonSizedBox(isDevices == 'ios' ? 45 : 35, 0),

                      ///头部信息
                      Container(
                        padding: const EdgeInsets.only(left: 10, right: 10),
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
                              onTap: ((){
                                MyUtils.goTransparentPage(context, const TeQuanGuiZePage());
                              }),
                              child: Container(
                                width: ScreenUtil().setHeight(150),
                                alignment: Alignment.centerRight,
                                color: Colors.transparent,
                                child: Text(
                                  '规则',
                                  style: TextStyle(
                                    fontSize: 28.sp,
                                    color: MyColors.mineOrange,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(10, 0),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: SizedBox(
                          width: 850.h,
                          child: Row(
                            children: [
                              WidgetUtils.commonSizedBox(0, 10.h),
                              GestureDetector(
                                onTap: (() {
                                  setState(() {
                                    _currentIndex = 0;
                                    _controller.animateToPage(0,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease);

                                    priceDou = 360;
                                    priceYue = 36;
                                  });
                                }),
                                child: Column(
                                  children: [
                                    WidgetUtils.onlyText(
                                        '玄仙',
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
                                    _controller.animateToPage(1,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                    priceDou = 2800;
                                    priceYue = 280;
                                  });
                                }),
                                child: Column(
                                  children: [
                                    WidgetUtils.onlyText(
                                        '上仙',
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
                                    _controller.animateToPage(2,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                    priceDou = 9000;
                                    priceYue = 900;
                                  });
                                }),
                                child: Column(
                                  children: [
                                    WidgetUtils.onlyText(
                                        '金仙',
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
                                    _controller.animateToPage(3,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                    priceDou = 50000;
                                    priceYue = 5000;
                                  });
                                }),
                                child: Column(
                                  children: [
                                    WidgetUtils.onlyText(
                                        '仙帝',
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
                                    _controller.animateToPage(4,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                    priceDou = 120000;
                                    priceYue = 12000;
                                  });
                                }),
                                child: Column(
                                  children: [
                                    WidgetUtils.onlyText(
                                        '主神',
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
                                    _controller.animateToPage(5,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                    priceDou = 360000;
                                    priceYue = 36000;
                                  });
                                }),
                                child: Column(
                                  children: [
                                    WidgetUtils.onlyText(
                                        '天神',
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
                                    _controller.animateToPage(6,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                    priceDou = 580000;
                                    priceYue = 58000;
                                  });
                                }),
                                child: Column(
                                  children: [
                                    WidgetUtils.onlyText(
                                        '神王',
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
                              const Spacer(),
                              GestureDetector(
                                onTap: (() {
                                  setState(() {
                                    _currentIndex = 7;
                                    _controller.animateToPage(7,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                    priceDou = 580000;
                                    priceYue = 58000;
                                  });
                                }),
                                child: Column(
                                  children: [
                                    WidgetUtils.onlyText(
                                        '神皇',
                                        StyleUtils.getCommonTextStyle(
                                            color: _currentIndex == 7
                                                ? Colors.white
                                                : MyColors.zhuangbanWZ,
                                            fontSize: ScreenUtil().setSp(29),
                                            fontWeight: FontWeight.w600)),
                                    WidgetUtils.commonSizedBox(8, 0),
                                    _currentIndex == 7
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
                                    _currentIndex = 8;
                                    _controller.animateToPage(8,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                    priceDou = 580000;
                                    priceYue = 58000;
                                  });
                                }),
                                child: Column(
                                  children: [
                                    WidgetUtils.onlyText(
                                        '天尊',
                                        StyleUtils.getCommonTextStyle(
                                            color: _currentIndex == 8
                                                ? Colors.white
                                                : MyColors.zhuangbanWZ,
                                            fontSize: ScreenUtil().setSp(29),
                                            fontWeight: FontWeight.w600)),
                                    WidgetUtils.commonSizedBox(8, 0),
                                    _currentIndex == 8
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
                                    _currentIndex = 9;
                                    _controller.animateToPage(9,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                    priceDou = 580000;
                                    priceYue = 58000;
                                  });
                                }),
                                child: Column(
                                  children: [
                                    WidgetUtils.onlyText(
                                        '传说',
                                        StyleUtils.getCommonTextStyle(
                                            color: _currentIndex == 9
                                                ? Colors.white
                                                : MyColors.zhuangbanWZ,
                                            fontSize: ScreenUtil().setSp(29),
                                            fontWeight: FontWeight.w600)),
                                    WidgetUtils.commonSizedBox(8, 0),
                                    _currentIndex == 9
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
                        ),
                      ),
                      WidgetUtils.commonSizedBox(10, 0),
                      Expanded(
                        child: PageView(
                          controller: _controller,
                          onPageChanged: (index) {
                            setState(() {
                              // 更新当前的索引值
                              _currentIndex = index;
                              // if(index == 0){
                              //   priceDou=360;
                              //   priceYue=36;
                              // }else if(index == 1){
                              //   priceDou=2800;
                              //   priceYue=280;
                              // }else if(index == 2){
                              //   priceDou=9000;
                              //   priceYue=900;
                              // }else if(index == 3){
                              //   priceDou=50000;
                              //   priceYue=5000;
                              // }else if(index == 4){
                              //   priceDou=120000;
                              //   priceYue=12000;
                              // }else if(index == 5){
                              //   priceDou=360000;
                              //   priceYue=36000;
                              // }else if(index == 6){
                              //   priceDou=580000;
                              //   priceYue=58000;
                              // }
                            });
                          },
                          children: [
                            YongshiPage(
                              zhi: list[0].upValue!,
                            ),
                            QishiPage(
                              zhi: list[1].upValue!,
                            ),
                            BojuePage(
                              zhi: list[2].upValue!,
                            ),
                            HoujuePage(
                              zhi: list[3].upValue!,
                            ),
                            GongjuePage(
                              zhi: list[4].upValue!,
                            ),
                            GuowangPage(
                              zhi: list[5].upValue!,
                            ),
                            DiwangPage(
                              zhi: list[6].upValue!,
                            ),
                            ShenHuangPage(
                              zhi: list[7].upValue!,
                            ),
                            TianZunPage(
                              zhi: list[8].upValue!,
                            ),
                            ChuanShuoPage(
                              zhi: list[9].upValue!,
                            ),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(20.h, 0),
                    ],
                  ),
                ),
                Container(
                  height: ScreenUtil().setHeight(220),
                  width: double.infinity,
                  color: MyColors.guizuBlack,
                  child: Column(
                    children: [
                      WidgetUtils.commonSizedBox(70.h, 0),
                      Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 20),
                          gzID != '10'
                              ? WidgetUtils.onlyText(
                                  '还差 ',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: ScreenUtil().setSp(33)))
                              : WidgetUtils.commonSizedBox(0, 0),
                          gzID != '10'
                              ? WidgetUtils.onlyText(
                                  gzCha,
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.guizuYellow,
                                      fontWeight: FontWeight.w600,
                                      fontSize: ScreenUtil().setSp(33)))
                              : WidgetUtils.commonSizedBox(0, 0),
                          gzID != '10'
                              ? WidgetUtils.onlyText(
                                  ' 贵族值升$gzNextTitle',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: ScreenUtil().setSp(33)))
                              : WidgetUtils.commonSizedBox(0, 0),
                          const Spacer(),
                          GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                if (int.parse(gzID) < 7) {
                                  MyToastUtils.showToastBottom(
                                      '贵族等级达到神王即可开启专属客服功能~');
                                } else {
                                  MyUtils.goTransparentRFPage(
                                      context,
                                      ChatPage(
                                          nickName: '专属客服',
                                          otherUid: kefuUid,
                                          otherImg: kefuAvatar));
                                }
                              }
                            }),
                            child: WidgetUtils.onlyText(
                                '专属客服',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.guizuYellow,
                                    fontSize: ScreenUtil().setSp(25))),
                          ),
                          WidgetUtils.commonSizedBox(0, 5.w),
                          WidgetUtils.showImages(
                              'assets/images/tequan_right.png', 20.h, 10.w),
                          WidgetUtils.commonSizedBox(0, 20),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(20.h, 0),
                      WidgetUtils.bgLine(1.h),
                      const Spacer(),
                      Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 20),
                          WidgetUtils.onlyText(
                              gzTitle,
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.black_1,
                                  fontSize: ScreenUtil().setSp(26))),
                          const Spacer(),
                          WidgetUtils.onlyText(
                              '当前贵族值',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.black_1,
                                  fontSize: ScreenUtil().setSp(26))),
                          WidgetUtils.onlyText(
                              gzZhi,
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.guizuYellow,
                                  fontSize: ScreenUtil().setSp(26))),
                          const Spacer(),
                          GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                MyUtils.goTransparentPage(
                                    context,
                                    TeQuanShuoMingPage(
                                      title: '剩余时间说明',
                                    ));
                              }
                            }),
                            child: WidgetUtils.onlyText(
                                ' 剩余时间',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.black_1,
                                    fontSize: ScreenUtil().setSp(26))),
                          ),
                          GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                MyUtils.goTransparentPage(
                                    context,
                                    TeQuanShuoMingPage(
                                      title: '剩余时间说明',
                                    ));
                              }
                            }),
                            child: WidgetUtils.onlyText(
                                gzTime,
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.guizuYellow,
                                    fontSize: ScreenUtil().setSp(26))),
                          ),
                          WidgetUtils.commonSizedBox(0, 10.w),
                          GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                MyUtils.goTransparentPage(
                                    context,
                                    TeQuanShuoMingPage(
                                      title: '剩余时间说明',
                                    ));
                              }
                            }),
                            child: WidgetUtils.showImages(
                                'assets/images/tequan_wen1.png', 20.h, 20.h),
                          ),
                          WidgetUtils.commonSizedBox(0, 20),
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
                Positioned(
                  right: 20.w,
                  top: (180 * 1.25).w,
                  child: GestureDetector(
                    onTap: () {
                      if (MyUtils.checkClick()) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TequanListofgodsPage(),
                          ),
                        );
                      }
                    },
                    child: Container(
                      width: ScreenUtil().setWidth(150),
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        'assets/images/tequan_fengshen.png',
                        width: 43 * 3.w,
                        height: 15 * 3.w,
                      ),
                    ),
                  ),
                ),
                Positioned(
                    bottom: 180.h,
                    child: Container(
                      padding: EdgeInsets.only(left: 20.h, right: 20.h),
                      child: WidgetUtils.showImagesFill(
                          'assets/images/tequan_shenmiren.png', 100.h, 660.w),
                    )),
              ],
            )
          : const Text(''),
    );
  }

  bool isOK = false;
  String gzZhi = '',
      gzTime = '',
      gzTitle = '暂未成为贵族',
      gzNextTitle = '玄仙',
      gzCha = '',
      gzID = '0',
      kefuUid = '',
      kefuAvatar = '';
  List<Ls> list = [];

  /// 我的贵族
  Future<void> doPostMyNoble() async {
    Loading.show();
    try {
      gzBean bean = await DataUtils.postMyNoble();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            list.clear();
            isOK = true;
            gzZhi = bean.data!.my!.nobleValue!;
            gzTime = bean.data!.my!.nobleExpireTime!;
            gzID = bean.data!.my!.nobleId.toString();
            kefuUid = bean.data!.my!.kefuUid.toString();
            kefuAvatar = bean.data!.my!.kefuAvatar!;
            list.addAll(bean.data!.ls!);
            if ((bean.data!.my!.nobleId as int) > 0) {
              _currentIndex = (bean.data!.my!.nobleId as int) - 1;
              _controller = PageController(
                initialPage: _currentIndex,
              );
              if (bean.data!.my!.nobleId == 1) {
                gzTitle = '当前：玄仙';
                gzNextTitle = '上仙';
                gzCha = (int.parse(bean.data!.ls![1].upValue!) -
                        int.parse(bean.data!.my!.nobleValue!))
                    .toString();
              } else if (bean.data!.my!.nobleId == 2) {
                gzTitle = '当前：上仙';
                gzNextTitle = '金仙';
                gzCha = (int.parse(bean.data!.ls![2].upValue!) -
                        int.parse(bean.data!.my!.nobleValue!))
                    .toString();
              } else if (bean.data!.my!.nobleId == 3) {
                gzTitle = '当前：金仙';
                gzNextTitle = '仙帝';
                gzCha = (int.parse(bean.data!.ls![3].upValue!) -
                        int.parse(bean.data!.my!.nobleValue!))
                    .toString();
              } else if (bean.data!.my!.nobleId == 4) {
                gzTitle = '当前：仙帝';
                gzNextTitle = '主神';
                gzCha = (int.parse(bean.data!.ls![4].upValue!) -
                        int.parse(bean.data!.my!.nobleValue!))
                    .toString();
              } else if (bean.data!.my!.nobleId == 5) {
                gzTitle = '当前：主神';
                gzNextTitle = '天神';
                gzCha = (int.parse(bean.data!.ls![5].upValue!) -
                        int.parse(bean.data!.my!.nobleValue!))
                    .toString();
              } else if (bean.data!.my!.nobleId == 6) {
                gzTitle = '当前：天神';
                gzNextTitle = '神王';
                gzCha = (int.parse(bean.data!.ls![6].upValue!) -
                        int.parse(bean.data!.my!.nobleValue!))
                    .toString();
              } else if (bean.data!.my!.nobleId == 7) {
                gzTitle = '当前：神王';
                gzNextTitle = '神皇';
                gzCha = (int.parse(bean.data!.ls![7].upValue!) -
                        int.parse(bean.data!.my!.nobleValue!))
                    .toString();
              } else if (bean.data!.my!.nobleId == 8) {
                gzTitle = '当前：神皇';
                gzNextTitle = '天尊';
                gzCha = (int.parse(bean.data!.ls![8].upValue!) -
                        int.parse(bean.data!.my!.nobleValue!))
                    .toString();
              } else if (bean.data!.my!.nobleId == 9) {
                gzTitle = '当前：天尊';
                gzNextTitle = '传说';
                gzCha = (int.parse(bean.data!.ls![9].upValue!) -
                        int.parse(bean.data!.my!.nobleValue!))
                    .toString();
              } else {
                gzTitle = '当前：传说';
              }
            } else {
              _currentIndex = 0;
              _controller = PageController(
                initialPage: _currentIndex,
              );
              gzNextTitle = '玄仙';
              gzCha = (int.parse(bean.data!.ls![0].upValue!) -
                      int.parse(bean.data!.my!.nobleValue!))
                  .toString();
            }
          });
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
