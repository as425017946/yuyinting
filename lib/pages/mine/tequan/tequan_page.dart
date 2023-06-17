import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/mine/tequan/diwang_page.dart';
import 'package:yuyinting/pages/mine/tequan/gongjue_page.dart';
import 'package:yuyinting/pages/mine/tequan/guowang_page.dart';
import 'package:yuyinting/pages/mine/tequan/houjue_page.dart';
import 'package:yuyinting/pages/mine/tequan/qishi_page.dart';
import 'package:yuyinting/pages/mine/tequan/yongshi_page.dart';

import '../../../colors/my_colors.dart';
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _currentIndex = 0;
    _controller = PageController(
      initialPage: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.zhuangbanBg,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Column(
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
                            fontWeight: FontWeight.bold)),
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
              WidgetUtils.commonSizedBox(20, 0),
              SizedBox(
                height: ScreenUtil().setHeight(60),
                child: Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          _currentIndex = 0;
                          _controller.jumpToPage(0);
                        });
                      }),
                      child: Column(
                        children: [
                          WidgetUtils.onlyText('勇士', StyleUtils.getCommonTextStyle(
                              color: _currentIndex == 0
                                  ? Colors.white
                                  : MyColors.zhuangbanWZ,
                              fontSize: ScreenUtil().setSp(29),
                              fontWeight: FontWeight.bold)),
                          _currentIndex == 0 ? WidgetUtils.showImages('assets/images/zhuxiao.jpg', ScreenUtil().setHeight(3), ScreenUtil().setHeight(65)) : const Text(''),
                        ],
                      ),
                    ),
                    WidgetUtils.commonSizedBox(0, 20),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          _currentIndex = 1;
                          _controller.jumpToPage(1);
                        });
                      }),
                      child: Column(
                        children: [
                          WidgetUtils.onlyText('骑士', StyleUtils.getCommonTextStyle(
                              color: _currentIndex == 1
                                  ? Colors.white
                                  : MyColors.zhuangbanWZ,
                              fontSize: ScreenUtil().setSp(29),
                              fontWeight: FontWeight.bold)),
                          _currentIndex == 1 ? WidgetUtils.showImages('assets/images/zhuxiao.jpg', ScreenUtil().setHeight(3), ScreenUtil().setHeight(65)) : const Text(''),
                        ],
                      ),
                    ),
                    WidgetUtils.commonSizedBox(0, 20),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          _currentIndex = 2;
                          _controller.jumpToPage(2);
                        });
                      }),
                      child: Column(
                        children: [
                          WidgetUtils.onlyText('伯爵', StyleUtils.getCommonTextStyle(
                              color: _currentIndex == 2
                                  ? Colors.white
                                  : MyColors.zhuangbanWZ,
                              fontSize: ScreenUtil().setSp(29),
                              fontWeight: FontWeight.bold)),
                          _currentIndex == 2 ? WidgetUtils.showImages('assets/images/zhuxiao.jpg', ScreenUtil().setHeight(3), ScreenUtil().setHeight(65)) : const Text(''),
                        ],
                      ),
                    ),
                    WidgetUtils.commonSizedBox(0, 20),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          _currentIndex = 3;
                          _controller.jumpToPage(3);
                        });
                      }),
                      child: Column(
                        children: [
                          WidgetUtils.onlyText('侯爵', StyleUtils.getCommonTextStyle(
                              color: _currentIndex == 3
                                  ? Colors.white
                                  : MyColors.zhuangbanWZ,
                              fontSize: ScreenUtil().setSp(29),
                              fontWeight: FontWeight.bold)),
                          _currentIndex == 3 ? WidgetUtils.showImages('assets/images/zhuxiao.jpg', ScreenUtil().setHeight(3), ScreenUtil().setHeight(65)) : const Text(''),
                        ],
                      ),
                    ),
                    WidgetUtils.commonSizedBox(0, 20),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          _currentIndex = 4;
                          _controller.jumpToPage(4);
                        });
                      }),
                      child: Column(
                        children: [
                          WidgetUtils.onlyText('公爵', StyleUtils.getCommonTextStyle(
                              color: _currentIndex == 4
                                  ? Colors.white
                                  : MyColors.zhuangbanWZ,
                              fontSize: ScreenUtil().setSp(29),
                              fontWeight: FontWeight.bold)),
                          _currentIndex == 4 ? WidgetUtils.showImages('assets/images/zhuxiao.jpg', ScreenUtil().setHeight(3), ScreenUtil().setHeight(65)) : const Text(''),
                        ],
                      ),
                    ),
                    WidgetUtils.commonSizedBox(0, 20),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          _currentIndex = 5;
                          _controller.jumpToPage(5);
                        });
                      }),
                      child: Column(
                        children: [
                          WidgetUtils.onlyText('国王', StyleUtils.getCommonTextStyle(
                              color: _currentIndex == 5
                                  ? Colors.white
                                  : MyColors.zhuangbanWZ,
                              fontSize: ScreenUtil().setSp(29),
                              fontWeight: FontWeight.bold)),
                          _currentIndex == 5 ? WidgetUtils.showImages('assets/images/zhuxiao.jpg', ScreenUtil().setHeight(3), ScreenUtil().setHeight(65)) : const Text(''),
                        ],
                      ),
                    ),
                    WidgetUtils.commonSizedBox(0, 20),
                    GestureDetector(
                      onTap: (() {
                        setState(() {
                          _currentIndex = 6;
                          _controller.jumpToPage(6);
                        });
                      }),
                      child: Column(
                        children: [
                          WidgetUtils.onlyText('帝王', StyleUtils.getCommonTextStyle(
                              color: _currentIndex == 6
                                  ? Colors.white
                                  : MyColors.zhuangbanWZ,
                              fontSize: ScreenUtil().setSp(29),
                              fontWeight: FontWeight.bold)),
                          _currentIndex == 6 ? WidgetUtils.showImages('assets/images/zhuxiao.jpg', ScreenUtil().setHeight(3), ScreenUtil().setHeight(65)) : const Text(''),
                        ],
                      ),
                    ),
                  ],
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
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(33))),
                        WidgetUtils.onlyText(
                            '36',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.guizuYellow,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(33))),
                        WidgetUtils.onlyText(
                            ' 元 / 月',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: ScreenUtil().setSp(33))),
                        WidgetUtils.commonSizedBox(0, 20),
                        WidgetUtils.onlyText(
                            '赠送 ',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.guizuGrey,
                                fontSize: ScreenUtil().setSp(25))),
                        WidgetUtils.onlyText(
                            '360',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.guizuYellow,
                                fontSize: ScreenUtil().setSp(25))),
                        WidgetUtils.onlyText(
                            ' 金豆',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.guizuGrey,
                                fontSize: ScreenUtil().setSp(25))),
                      ],
                    )),
                GestureDetector(
                  onTap: (() {}),
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
                    child: WidgetUtils.onlyTextCenter('开通贵族', StyleUtils.getCommonTextStyle(color: MyColors.guizuYellow2, fontSize: ScreenUtil().setSp(33), fontWeight: FontWeight.bold)),
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
