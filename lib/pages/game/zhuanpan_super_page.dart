import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';

import '../../utils/log_util.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../../widget/CircleProgressView.dart';
/// 超级转盘
class ZhuanPanSuperPage extends StatefulWidget {
  const ZhuanPanSuperPage({super.key});

  @override
  State<ZhuanPanSuperPage> createState() => _ZhuanPanSuperPageState();
}

class _ZhuanPanSuperPageState extends State<ZhuanPanSuperPage> with TickerProviderStateMixin {
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
  int cyclesNum = 6;

  int isCheck = 1;



  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 7000),
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
          curve: Curves.easeOutCubic,
        ),
      ),
    );
    // 创建一个从0到360弧度的补间动画 v * 2 * π
  }

  void start() {
    ///中奖编号
    int luckyName = Random().nextInt(20);
    // LogE('中奖号码$luckyName');
    startAnimation(29);
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
        // curve: Curves.easeOutQuad,
        // curve: Cubic(0.895, 0.03, 0.1, 1),
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
                      'assets/images/zhuanpan_one_baoxiang.png',
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
                        image: AssetImage(
                            "assets/images/zhuanpan_btn.png"),
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
                        image: AssetImage(
                            "assets/images/zhuanpan_btn.png"),
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
                top: ScreenUtil().setHeight(70),
                left: ScreenUtil().setWidth(30),
                width: ScreenUtil().setHeight(590),
                height: ScreenUtil().setHeight(590),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleProgressView(backgroundColor: Colors.transparent, progress: -5, progressWidth: ScreenUtil().setHeight(12), progressColor: MyColors.zpJD, width: ScreenUtil().setHeight(534), height: ScreenUtil().setHeight(534),),
                    WidgetUtils.showImages(
                        'assets/images/zhuanpan_one_bg2.png',
                        ScreenUtil().setHeight(560),
                        ScreenUtil().setHeight(560)),
                    RotationTransition(
                      turns: _animation,
                      child: WidgetUtils.showImages(
                          'assets/images/zhuanpan_one_bg3.png',
                          ScreenUtil().setHeight(400),
                          ScreenUtil().setHeight(400)),
                    ),
                    GestureDetector(
                      onTap: (() {
                        buttonOnClickStartRun();
                      }),
                      child: WidgetUtils.showImages(
                          'assets/images/zhuanpan_one_qidong.png',
                          ScreenUtil().setHeight(100),
                          ScreenUtil().setHeight(100)),
                    ),
                    Positioned(
                        top: ScreenUtil().setHeight(10),
                        child: WidgetUtils.showImages(
                            'assets/images/zhuanpan_one_zhizhen.png',
                            ScreenUtil().setHeight(120),
                            ScreenUtil().setHeight(90))),
                    // 欢乐值
                    Positioned(
                      left: ScreenUtil().setHeight(240),
                      top: ScreenUtil().setHeight(527),
                      child: Text(
                        '欢乐值：0/30',
                        style: StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(22)),
                      ),
                    ),

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
                        ? "assets/images/zhuanpan_one_zhuan_check.png"
                        : 'assets/images/zhuanpan_one_zhuan_no.png'),
                    fit: BoxFit.fill, //覆盖
                  ),
                ),
                child: Row(
                  children: [
                    WidgetUtils.commonSizedBox(
                        0, ScreenUtil().setHeight(55)),
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
                        ? "assets/images/zhuanpan_one_zhuan_check.png"
                        : 'assets/images/zhuanpan_one_zhuan_no.png'),
                    fit: BoxFit.fill, //覆盖
                  ),
                ),
                child: Row(
                  children: [
                    WidgetUtils.commonSizedBox(
                        0, ScreenUtil().setHeight(55)),
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
                        ? "assets/images/zhuanpan_one_zhuan_check.png"
                        : 'assets/images/zhuanpan_one_zhuan_no.png'),
                    fit: BoxFit.fill, //覆盖
                  ),
                ),
                child: Row(
                  children: [
                    WidgetUtils.commonSizedBox(
                        0, ScreenUtil().setHeight(55)),
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
