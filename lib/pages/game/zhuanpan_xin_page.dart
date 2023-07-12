import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/log_util.dart';

import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';

/// 心动转盘
class ZhuanPanXinPage extends StatefulWidget {
  const ZhuanPanXinPage({super.key});

  @override
  State<ZhuanPanXinPage> createState() => _ZhuanPanXinPageState();
}

class _ZhuanPanXinPageState extends State<ZhuanPanXinPage>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> _animation;
  late Animation<double> _curveAnimation;

  //是否正在转动
  bool isRunning = false;

  //是否顺时针
  bool isClockwise = true;

  //奖品数量
  int prizeNum = 120;

  //最少转动圈数
  int cyclesNum = 5;

  int isCheck = 1;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 8000),
    );
    //动画监听
    animationController.addListener(() {
      if (animationController.status == AnimationStatus.completed) {
        LogE('停止了');
        setState(() {
          isRunning = false;
        });
        //结束了
      } else if (animationController.status == AnimationStatus.forward) {
        //动画正在从开始处运行到结束处（正向运行）
        // print('forward');
      } else if (animationController.status == AnimationStatus.reverse) {
        //动画正在从结束处运行到开始处（反向运行）。
        // print('reverse');
      }
    });
    //初始位置
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(
          0,
          1.0,
          curve: Curves.easeInOut,
        ),
      ),
    );
    // 创建一个从0到360弧度的补间动画 v * 2 * π
  }

  void start() {
    ///中奖编号
    int luckyName = Random().nextInt(20);
    // LogE('中奖号码$luckyName');
    startAnimation(41);
  }

  void buttonOnClickStartRun() {
    LogE('停止了$isRunning');

    if (isRunning == false) {
      setState(() {
        isRunning = true;
      });
    } else {
      return;
    }
    start();
  }

  void startAnimation(int index) {
    var timea = cyclesNum + (1 / prizeNum) * index;
    _animation = Tween<double>(
            begin: 0,
            end: timea)
        .animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(
        0,
        1.0,
        // curve: Curves.easeOutQuart,
        curve: Cubic(0.6, 0.03, 0.03, 1.0),
      ),
    ));
    setState(() {});
    animationController.reset();
    animationController.forward();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 转盘模块
        SizedBox(
          height: ScreenUtil().setHeight(700),
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 宝箱
              Positioned(
                  top: ScreenUtil().setHeight(30),
                  left: ScreenUtil().setHeight(20),
                  child: WidgetUtils.showImages(
                      'assets/images/zhuanpan_tow_baoxiang.png',
                      ScreenUtil().setHeight(72),
                      ScreenUtil().setHeight(89))),
              // 规则说明
              Positioned(
                  right: 0,
                  top: ScreenUtil().setHeight(15),
                  child: Container(
                    height: ScreenUtil().setHeight(45),
                    width: ScreenUtil().setHeight(120),
                    decoration: const BoxDecoration(
                      //设置Container修饰
                      image: DecorationImage(
                        //背景图片修饰
                        image: AssetImage("assets/images/zhuanpan_btn.png"),
                        fit: BoxFit.fill, //覆盖
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '规则说明',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(22),
                          fontWeight: FontWeight.w600),
                    ),
                  )),
              // 我的记录
              Positioned(
                  right: 0,
                  top: ScreenUtil().setHeight(70),
                  child: Container(
                    height: ScreenUtil().setHeight(45),
                    width: ScreenUtil().setHeight(120),
                    decoration: const BoxDecoration(
                      //设置Container修饰
                      image: DecorationImage(
                        //背景图片修饰
                        image: AssetImage("assets/images/zhuanpan_btn.png"),
                        fit: BoxFit.fill, //覆盖
                      ),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '我的记录',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: ScreenUtil().setSp(22),
                          fontWeight: FontWeight.w600),
                    ),
                  )),
              // 转盘
              Positioned(
                width: ScreenUtil().setHeight(590),
                height: ScreenUtil().setHeight(590),
                top: ScreenUtil().setHeight(70),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    WidgetUtils.showImages(
                        'assets/images/zhuanpan_tow_bg2.png',
                        ScreenUtil().setHeight(570),
                        ScreenUtil().setHeight(570)),
                    RotationTransition(
                      turns: _animation,
                      child: WidgetUtils.showImages(
                          'assets/images/zhuanpan_two_bg3.png',
                          ScreenUtil().setHeight(390),
                          ScreenUtil().setHeight(390)),
                    ),
                    GestureDetector(
                      onTap: (() {
                        buttonOnClickStartRun();
                      }),
                      child: WidgetUtils.showImages(
                          'assets/images/zhuanpan_tow_qidong.png',
                          ScreenUtil().setHeight(100),
                          ScreenUtil().setHeight(100)),
                    ),
                    Positioned(
                        top: ScreenUtil().setHeight(10),
                        child: WidgetUtils.showImages(
                            'assets/images/zhuanpan_zhizhen.png',
                            ScreenUtil().setHeight(125),
                            ScreenUtil().setHeight(100))),
                  ],
                ),
              ),
            ],
          ),
        ),
        WidgetUtils.commonSizedBox(20, 0),
        // 转盘次数
        Row(
          children: [
            WidgetUtils.commonSizedBox(0, 20),
            GestureDetector(
              onTap: (() {
                setState(() {
                  isCheck = 1;
                });
              }),
              child: Container(
                height: ScreenUtil().setHeight(60),
                width: ScreenUtil().setHeight(170),
                decoration: BoxDecoration(
                  //设置Container修饰
                  image: DecorationImage(
                    //背景图片修饰
                    image: AssetImage(isCheck == 1
                        ? "assets/images/zhuanpan_tow_zhuan_check.png"
                        : 'assets/images/zhuanpan_tow_zhuan_no.png'),
                    fit: BoxFit.fill, //覆盖
                  ),
                ),
                child: Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, ScreenUtil().setHeight(55)),
                    Column(
                      children: [
                        WidgetUtils.commonSizedBox(7, 0),
                        Text(
                          '转  1  次',
                          style: StyleUtils.getCommonTextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(28)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: (() {
                setState(() {
                  isCheck = 2;
                });
              }),
              child: Container(
                height: ScreenUtil().setHeight(60),
                width: ScreenUtil().setHeight(170),
                decoration: BoxDecoration(
                  //设置Container修饰
                  image: DecorationImage(
                    //背景图片修饰
                    image: AssetImage(isCheck == 2
                        ? "assets/images/zhuanpan_tow_zhuan_check.png"
                        : 'assets/images/zhuanpan_tow_zhuan_no.png'),
                    fit: BoxFit.fill, //覆盖
                  ),
                ),
                child: Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, ScreenUtil().setHeight(55)),
                    Column(
                      children: [
                        WidgetUtils.commonSizedBox(7, 0),
                        Text(
                          '转 10 次',
                          style: StyleUtils.getCommonTextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(28)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: (() {
                setState(() {
                  isCheck = 3;
                });
              }),
              child: Container(
                height: ScreenUtil().setHeight(60),
                width: ScreenUtil().setHeight(170),
                decoration: BoxDecoration(
                  //设置Container修饰
                  image: DecorationImage(
                    //背景图片修饰
                    image: AssetImage(isCheck == 3
                        ? "assets/images/zhuanpan_tow_zhuan_check.png"
                        : 'assets/images/zhuanpan_tow_zhuan_no.png'),
                    fit: BoxFit.fill, //覆盖
                  ),
                ),
                child: Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, ScreenUtil().setHeight(55)),
                    Column(
                      children: [
                        WidgetUtils.commonSizedBox(7, 0),
                        Text(
                          '转100次',
                          style: StyleUtils.getCommonTextStyle(
                              color: Colors.white,
                              fontSize: ScreenUtil().setSp(28)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            WidgetUtils.commonSizedBox(0, 20),
          ],
        ),
      ],
    );
  }
}
