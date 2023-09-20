import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soundpool/soundpool.dart';
import 'package:svgaplayer_flutter/parser.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import 'package:yuyinting/widget/queren_page.dart';

import '../../utils/style_utils.dart';
import 'car/car_shop_page.dart';
import 'car/lishi_page.dart';
import 'car/zhongjian_page.dart';
import 'car_landscape_page.dart';

/// 赛车游戏
class Carpage extends StatefulWidget {
  const Carpage({super.key});

  @override
  State<Carpage> createState() => _CarpageState();
}

class _CarpageState extends State<Carpage> with TickerProviderStateMixin {
  bool tishi = true;
  List<bool> listA = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  List<bool> listA1 = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false,
    false
  ];
  //赛车是否加速使用
  List<bool> listCar = [
    false,
    false,
    false,
    false,
    false,
    false,
    false,
  ];
  List<bool> listB = [true, false, false, false];

  //6倍使用
  Widget SixInfo(int i) {
    return Expanded(
        child: GestureDetector(
      onTap: (() {
        if (isShow) {
          if(tishi){
            int jine = 0;
            for(int a = 0; a < 4; a++){
              if(listB[a]){
                if(a==0){
                  jine = 10;
                }else if(a==1){
                  jine = 100;
                }else if(a==2){
                  jine = 1000;
                }else if(a==3){
                  jine = 1000;
                }
              }
            }
            MyUtils.goTransparentPageCom(context, QueRenPage(title: '赛车下注', jine: jine.toString(), isDuiHuan: false));
            return;
          }
          playSound2();
          if (listA[i - 1] == false) {
            setState(() {
              listA[i - 1] = true;
            });
          }
          //点击播放点击特效
          if (listA1[i - 1] == false) {
            setState(() {
              listA1[i - 1] = true;
            });
            Future.delayed(
                const Duration(
                  milliseconds: 400,
                ), () {
              setState(() {
                listA1[i - 1] = false;
              });
            });
          }
        }
      }),
      child: Stack(
        children: [
          WidgetUtils.showImagesFill(
              listA[i - 1]
                  ? 'assets/images/car_jl_btn1.png'
                  : 'assets/images/car_jl_btn2.png',
              70.h,
              double.infinity),
          i == 4
              ? Positioned(
                  top: -2,
                  right: -20,
                  child: WidgetUtils.showImages(
                      'assets/images/car_jl_t$i.png', 70.h, 76.h))
              : i == 5
                  ? Positioned(
                      top: -1,
                      right: -20,
                      child: WidgetUtils.showImagesFill(
                          'assets/images/car_jl_t$i.png', 70.h, 70.h))
                  : Positioned(
                      top: 0,
                      right: -15,
                      child: WidgetUtils.showImages(
                          'assets/images/car_jl_t$i.png', 70.h, 76.h)),
          Positioned(
            left: 5.h,
            top: 10.h,
            child: WidgetUtils.onlyText(
                '10000',
                StyleUtils.getCommonTextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600)),
          ),
          SizedBox(
            height: 70.h,
            width: double.infinity,
            child: listA1[i - 1]
                ? const SVGASimpleImage(
                    assetsName: 'assets/svga/gp/star.svga',
                  )
                : const Text(''),
          ),
        ],
      ),
    ));
  }

  // 3倍使用
  Widget SixInfo2(int one) {
    return Expanded(
        child: GestureDetector(
      onTap: (() {
        if (isShow) {
          if(tishi){
            int jine = 0;
            for(int a = 0; a < 4; a++){
              if(listB[a]){
                if(a==0){
                  jine = 10;
                }else if(a==1){
                  jine = 100;
                }else if(a==2){
                  jine = 1000;
                }else if(a==3){
                  jine = 1000;
                }
              }
            }
            MyUtils.goTransparentPageCom(context, QueRenPage(title: '赛车下注', jine: jine.toString(), isDuiHuan: false));
            return;
          }
          playSound2();
          if (listA[5 + one] == false) {
            setState(() {
              listA[5 + one] = true;
            });
          }
        }
      }),
      child: Stack(
        children: [
          WidgetUtils.showImagesFill(
              listA[5 + one]
                  ? 'assets/images/car_jl_btn3.png'
                  : 'assets/images/car_jl_btn4.png',
              70.h,
              double.infinity),
          Positioned(
              top: 1.h,
              bottom: 2.h,
              right: 3.h,
              child: WidgetUtils.showImagesFill(
                  'assets/images/car_3_$one.png', 70.h, 110.h)),
          Positioned(
            left: 5.h,
            top: 10.h,
            child: WidgetUtils.onlyText(
                '10000',
                StyleUtils.getCommonTextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600)),
          )
        ],
      ),
    ));
  }

  // 2倍使用
  Widget SixInfo3(int one) {
    return Expanded(
        child: GestureDetector(
      onTap: (() {
        if (isShow) {
          if(tishi){
            int jine = 0;
            for(int a = 0; a < 4; a++){
              if(listB[a]){
                if(a==0){
                  jine = 10;
                }else if(a==1){
                  jine = 100;
                }else if(a==2){
                  jine = 1000;
                }else if(a==3){
                  jine = 1000;
                }
              }
            }
            MyUtils.goTransparentPageCom(context, QueRenPage(title: '赛车下注', jine: jine.toString(), isDuiHuan: false));
            return;
          }
          playSound2();
          if (one == 1) {
            setState(() {
              listA[9] = true;
            });
          } else {
            setState(() {
              listA[10] = true;
            });
          }
        }
      }),
      child: Stack(
        children: [
          WidgetUtils.showImagesFill(
              listA[8 + one]
                  ? 'assets/images/car_jl_btn5.png'
                  : 'assets/images/car_jl_btn6.png',
              70.h,
              double.infinity),
          Positioned(
              top: 1.h,
              bottom: 2.h,
              right: 3.h,
              child: WidgetUtils.showImagesFill(
                  'assets/images/car_2_$one.png', 70.h, 170.h)),
          Positioned(
            left: 5.h,
            top: 10.h,
            child: WidgetUtils.onlyText(
                '10000',
                StyleUtils.getCommonTextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600)),
          )
        ],
      ),
    ));
  }

  // 下注金额
  Widget jine(int i) {
    return Expanded(
        child: GestureDetector(
      onTap: (() {
        for (int i = 0; i < 4; i++) {
          setState(() {
            listB[i] = false;
          });
        }
        setState(() {
          listB[i] = !listB[i];
        });
        playSound();
      }),
      child: SizedBox(
        height: 47.h,
        child: Stack(
          children: [
            WidgetUtils.showImagesFill(
                listB[i] == false
                    ? 'assets/images/car_btn1.png'
                    : 'assets/images/car_btn2.png',
                60.h,
                150.h),
            Row(
              children: [
                WidgetUtils.commonSizedBox(0, 20.h),
                WidgetUtils.showImages(
                    'assets/images/car_mogubi.png', 30.h, 30.h),
                Expanded(
                    child: WidgetUtils.onlyTextCenter(
                        i == 0
                            ? '10'
                            : i == 1
                                ? '100'
                                : i == 2
                                    ? '1000'
                                    : '10000',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 28.sp))),
                WidgetUtils.commonSizedBox(0, 20.h),
              ],
            )
          ],
        ),
      ),
    ));
  }

  /// 播放音频
  Soundpool soundpool = Soundpool(streamType: StreamType.notification);

  Future<void> playSound() async {
    int soundId = await rootBundle
        .load('assets/audio/car_jine.wav')
        .then(((ByteData soundDate) {
      return soundpool.load(soundDate);
    }));
    soundpool.setVolume(volume: 0.5);
    await soundpool.play(soundId);
  }

  Future<void> playSound2() async {
    int soundId = await rootBundle
        .load('assets/audio/car_xiazhu.MP3')
        .then(((ByteData soundDate) {
      return soundpool.load(soundDate);
    }));
    await soundpool.play(soundId);
  }

  Future<void> playSound3() async {
    int soundId = await rootBundle
        .load('assets/audio/car_321.MP3')
        .then(((ByteData soundDate) {
      return soundpool.load(soundDate);
    }));
    await soundpool.play(soundId);
  }

  List<String> imagesa = [
    "assets/images/car_qidian.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_qidian.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
    "assets/images/car_bg.jpg",
  ];

  //赛车使用
  late AnimationController controller2;
  late Animation<Offset> animation2;

  //Go的动画
  late AnimationController controllerGO;
  late Animation<double> animationGO;

  late PageController _controller;
  Timer? _timer, _timer2, _timer3;
  int _currentPage = 0;

  int luck = 0, sum = 20, sumBG = 0;
  bool isShow = true;

  var a,a1,a2,a3,a4,a5,a6,b,b1,b2,b3,b4,b5,b6,c,c1,c2,c3,c4,c5,c6,d,d1,d2,d3,d4,d5,d6,e,e1,e2,e3,e4,e5,e6;
  var j,j1,j2,j3,j4,j5,j6;

  void suijishu(){
    a = Random().nextInt(10) / 10;
    b = Random().nextInt(10) / 10;
    c = Random().nextInt(10) / 10;
    d = Random().nextInt(10) / 10;
    e = Random().nextInt(10) / 10;

    a1 = Random().nextInt(10) / 10;
    b1 = Random().nextInt(10) / 10;
    c1 = Random().nextInt(10) / 10;
    d1 = Random().nextInt(10) / 10;
    e1 = Random().nextInt(10) / 10;

    a2 = Random().nextInt(10) / 10;
    b2 = Random().nextInt(10) / 10;
    c2 = Random().nextInt(10) / 10;
    d2 = Random().nextInt(10) / 10;
    e2 = Random().nextInt(10) / 10;

    a3 = Random().nextInt(10) / 10;
    b3 = Random().nextInt(10) / 10;
    c3 = Random().nextInt(10) / 10;
    d3 = Random().nextInt(10) / 10;
    e3 = Random().nextInt(10) / 10;

    a4 = Random().nextInt(10) / 10;
    b4 = Random().nextInt(10) / 10;
    c4 = Random().nextInt(10) / 10;
    d4 = Random().nextInt(10) / 10;
    e4 = Random().nextInt(10) / 10;

    a5 = Random().nextInt(10) / 10;
    b5 = Random().nextInt(10) / 10;
    c5 = Random().nextInt(10) / 10;
    d5 = Random().nextInt(10) / 10;
    e5 = Random().nextInt(10) / 10;

    a6 = Random().nextInt(10) / 10;
    b6 = Random().nextInt(10) / 10;
    c6 = Random().nextInt(10) / 10;
    d6 = Random().nextInt(10) / 10;
    e6 = Random().nextInt(10) / 10;

    j = Random().nextDouble()+Random().nextDouble();
    j1 = Random().nextDouble()+Random().nextDouble();
    j2 = Random().nextDouble()+Random().nextDouble();
    j3 = Random().nextDouble()+Random().nextDouble();
    j4 = Random().nextDouble()+Random().nextDouble();
    j5 = Random().nextDouble()+Random().nextDouble();
    j6 = Random().nextDouble()+Random().nextDouble();
  }

  List<int> listS = [];
  // 取3个随机数用于显示小车加速
  void carSJS(){
    //数组清空
    listS.clear();
    //小车状态全部变成false状态
    for(int i = 0; i < 7; i++){
      setState(() {
        listCar[i] = false;
      });
    }
    Random random = Random();
    while(listS.length < 3){
      int numbers = random.nextInt(7);
      listS.add(numbers);
      for(int i = 0; i < 7; i++){
        if(numbers == i){
          setState(() {
            listCar[i] = true;
          });
        }
      }
    }
  }
  // 赛车2秒一换
  void carTimer(){
    _timer3 = Timer.periodic(const Duration(seconds: 2), (timer) {
      carSJS();
    });
  }

  //背景图动画
  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_controller.hasClients) {
        setState(() {
          sumBG++;
          if(sumBG==19){
            MyUtils.goTransparentPageCom(context, ZhongJiangPage(type: luck));
          }
        });
        LogE('********');
        if (_controller.page!.round() >= imagesa.length - 1) {
          LogE('********------');
          _controller.jumpToPage(0);
        } else {
          _controller.nextPage(
            duration: const Duration(seconds: 1),
            curve: Curves.linear,
          );
        }
      }

    });
  }

  void pauseTimer() {
    _timer?.cancel();
  }

  void restartTimer() {
    _timer?.cancel();
    startTimer();
  }

  // 倒计时
  void starTimerDJS() {
    _timer2 = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (sum == 0) {
        playSound3();
        timer.cancel();
        setState(() {
          isShow = false;
          isPlay = true;
        });
        loadAnimation();
      } else {
        // 开始321的倒计时动画
        setState(() {
          sum--;
        });
      }
    });
  }

  // 赛车动画
  Animation<Offset> _carPlay(int i) {
    switch (i) {
      case 0:
        animation2 = TweenSequence([
          TweenSequenceItem(
              tween: Tween(begin: Offset.zero, end: Offset(a, 0)), weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(a, 0), end: Offset(b + 0.2, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(b + 0.2, 0), end: Offset(c, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(c, 0), end: Offset(d + 0.5, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(d + 0.5, 0), end: Offset(e - 0.5, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(
                  begin: Offset(e - 0.5, 0),
                  end: Offset(luck == i ? 2.3 : j, 0)),
              weight: 40),
        ]).animate(controller2);
        break;
      case 1:
        animation2 = TweenSequence([
          TweenSequenceItem(
              tween: Tween(begin: Offset.zero, end: Offset(a1, 0)), weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(a1, 0), end: Offset(b1 + 0.2, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(b1 + 0.2, 0), end: Offset(c1, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(c1, 0), end: Offset(d1 + 0.5, 0)),
              weight: 12),
          TweenSequenceItem(
              tween:
                  Tween(begin: Offset(d1 + 0.5, 0), end: Offset(e1 - 0.5, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(
                  begin: Offset(e1 - 0.5, 0),
                  end: Offset(luck == i ? 2.3 : j1, 0)),
              weight: 40),
        ]).animate(controller2);
        break;
      case 2:
        animation2 = TweenSequence([
          TweenSequenceItem(
              tween: Tween(begin: Offset.zero, end: Offset(a2, 0)), weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(a2, 0), end: Offset(b2 + 0.2, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(b2 + 0.2, 0), end: Offset(c2, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(c2, 0), end: Offset(d2 + 0.5, 0)),
              weight: 12),
          TweenSequenceItem(
              tween:
                  Tween(begin: Offset(d2 + 0.5, 0), end: Offset(e2 - 0.5, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(
                  begin: Offset(e2 - 0.5, 0),
                  end: Offset(luck == i ? 2.3 : j2, 0)),
              weight: 40),
        ]).animate(controller2);
        break;
      case 3:
        animation2 = TweenSequence([
          TweenSequenceItem(
              tween: Tween(begin: Offset.zero, end: Offset(a3, 0)), weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(a3, 0), end: Offset(b3 + 0.2, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(b3 + 0.2, 0), end: Offset(c3, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(c3, 0), end: Offset(d3 + 0.5, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(d3 + 0.5, 0), end: Offset(e3, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(
                  begin: Offset(e3, 0), end: Offset(luck == i ? 2.3 : (2-double.parse(e3.toString())), 0)),
              weight: 40),
        ]).animate(controller2);
        break;
      case 4:
        animation2 = TweenSequence([
          TweenSequenceItem(
              tween: Tween(begin: Offset.zero, end: Offset(a4, 0)), weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(a4, 0), end: Offset(b4 + 0.2, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(b4 + 0.2, 0), end: Offset(c4, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(c4, 0), end: Offset(d4 + 0.5, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(d4 + 0.5, 0), end: Offset(e4, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(
                  begin: Offset(e4, 0), end: Offset(luck == i ? 2.3 : (2-double.parse(e4.toString())), 0)),
              weight: 40),
        ]).animate(controller2);
        break;
      case 5:
        animation2 = TweenSequence([
          TweenSequenceItem(
              tween: Tween(begin: Offset.zero, end: Offset(a5, 0)), weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(a5, 0), end: Offset(b5 + 0.2, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(b5 + 0.2, 0), end: Offset(c5, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(c5, 0), end: Offset(d5 + 0.5, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(d5 + 0.5, 0), end: Offset(e5, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(
                  begin: Offset(e5, 0), end: Offset(luck == i ? 2.3 : (2-double.parse(e5.toString())), 0)),
              weight: 40),
        ]).animate(controller2);
        break;
      case 6:
        animation2 = TweenSequence([
          TweenSequenceItem(
              tween: Tween(begin: Offset.zero, end: Offset(a6, 0)), weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(a6, 0), end: Offset(b6 + 0.2, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(b6 + 0.2, 0), end: Offset(c6, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(c6, 0), end: Offset(d6 + 0.5, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(begin: Offset(d6 + 0.5, 0), end: Offset(e6, 0)),
              weight: 12),
          TweenSequenceItem(
              tween: Tween(
                  begin: Offset(e6, 0), end: Offset(luck == i ? 2.3 : (2-double.parse(e6.toString())), 0)),
              weight: 40),
        ]).animate(controller2);
        break;
    }
    return animation2;
  }

  // 背景使用
  void _onPageChanged() {
    int newIndex = _controller.page!.round() % imagesa.length;
    if (newIndex != _currentPage) {
      setState(() {
        _currentPage = newIndex;
      });
    }
  }

  //动画是否在播放
  bool isPlay = false, isGo = false;

  void loadAnimation() async {
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isPlay = false;
        isGo = true;
        sum = 20;
        sumBG = 0;
        startTimer();
        controllerGO.forward();
        Future.delayed(const Duration(seconds: 1), () {
          for(int i = 0; i < 7; i++){
            setState(() {
              listCar[i] = true;
            });
          }
          carTimer();
          controller2.forward();
        });
        _timer2?.cancel();
      });
    });
  }

  //点击出星星使用

  SVGAAnimationController? animationController;

  //动画是否在播放
  bool isStar = false;

  void showStar() async {
    final videoItem = await _loadSVGA(false, 'assets/svga/gp/star.svga');
    videoItem.autorelease = false;
    animationController?.videoItem = videoItem;
    animationController
        ?.repeat() // Try to use .forward() .reverse()
        .whenComplete(() => animationController?.videoItem = null);

    // 监听动画
    animationController?.addListener(() {
      if (animationController!.currentFrame >=
          animationController!.frames - 1) {
        // 动画播放到最后一帧时停止播放
        animationController?.stop();
        if (mounted) {
          setState(() {
            isStar = false;
          });
        }
      }
    });
  }

  Future _loadSVGA(isUrl, svgaUrl) {
    Future Function(String) decoder;
    if (isUrl) {
      decoder = SVGAParser.shared.decodeFromURL;
    } else {
      decoder = SVGAParser.shared.decodeFromAssets;
    }
    return decoder(svgaUrl);
  }


  @override
  void initState() {
    super.initState();
    suijishu();
    animationController = SVGAAnimationController(vsync: this);
    // 背景图滚动
    _controller = PageController(
      initialPage: imagesa.length-1,
    )..addListener(_onPageChanged);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _controller.jumpToPage(0);
    });
    //赛车动画使用
    controller2 =
        AnimationController(duration: const Duration(seconds: 20), vsync: this);
    // 监听动画
    controller2.addListener(() {
      if (controller2.isCompleted) {
        suijishu();
        controller2.reset();
        //背景暂停
        pauseTimer();
        _controller.jumpToPage(0);
        //小车状态全部变成false状态
        for(int i = 0; i < 7; i++){
          setState(() {
            listCar[i] = false;
          });
        }
        controllerGO.reset();
        _timer3?.cancel();
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isShow = true;
          });
          starTimerDJS();
        });
        // controllerZD.reset();
        //等1秒钟打开中奖页面
        // MyUtils.goTransparentPageCom(context, const ZhongJiangPage());
      }
    });
    //开启倒计时
    starTimerDJS();
    // GO的动画
    controllerGO =
    AnimationController(duration: const Duration(milliseconds: 1000), vsync: this)
      ..addStatusListener((status) {

      });
    animationGO = Tween<double>(begin: 0, end: 1).animate(controllerGO);
    controllerGO.addListener(() {
      if (controllerGO.isCompleted) {
        setState(() {
          isGo = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    controller2.dispose();
    controllerGO.dispose();
    _timer?.cancel();
    _timer2?.cancel();
    _timer3?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: Column(
        children: [
          GestureDetector(
            onTap: (() {
              Navigator.pop(context);
            }),
            child: Container(
              height: 150.h,
              width: double.infinity,
              color: Colors.transparent,
            ),
          ),
          SizedBox(
            height: 750.h,
            width: double.infinity,
            child: Stack(
              children: [
                //背景图
                SizedBox(
                  height: 750.h,
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _controller,
                    itemBuilder: (context, index) {
                      final imageIndex = index % imagesa.length;
                      return Image.asset(
                        imagesa[imageIndex],
                        width: double.infinity,
                        height: 750.h,
                        fit: BoxFit.fitHeight,
                        gaplessPlayback: true,
                      );
                    },
                  ),
                ),
                isShow
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          // 顶部信息
                          SizedBox(
                            height: 200.h,
                            child: Row(
                              children: [
                                // 左侧按键
                                SizedBox(
                                  height: 200.h,
                                  child: Column(
                                    children: [
                                      WidgetUtils.commonSizedBox(20.h, 0),
                                      GestureDetector(
                                        onTap: ((){
                                          MyUtils.goTransparentPageCom(context, const CarLandScapePage());
                                          Navigator.pop(context);
                                        }),
                                        child: Container(
                                          height: 38.h,
                                          width: 100.h,
                                          //边框设置
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                            //背景图片修饰
                                            image: AssetImage(
                                                "assets/images/car_anniu.png"),
                                            fit: BoxFit.fill, //覆盖
                                          )),
                                          child: WidgetUtils.onlyTextCenter(
                                              '横屏模式',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22.sp)),
                                        ),
                                      ),
                                      WidgetUtils.commonSizedBox(10.h, 0),
                                      Container(
                                        height: 38.h,
                                        width: 100.h,
                                        //边框设置
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                          //背景图片修饰
                                          image: AssetImage(
                                              "assets/images/car_anniu.png"),
                                          fit: BoxFit.fill, //覆盖
                                        )),
                                        child: WidgetUtils.onlyTextCenter(
                                            '游戏规则',
                                            StyleUtils.getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize: 22.sp)),
                                      ),
                                      WidgetUtils.commonSizedBox(10.h, 0),
                                      GestureDetector(
                                        onTap: ((){
                                          MyUtils.goTransparentPageCom(context, const LiShiPage());
                                        }),
                                        child: Container(
                                          height: 38.h,
                                          width: 100.h,
                                          //边框设置
                                          decoration: const BoxDecoration(
                                              image: DecorationImage(
                                                //背景图片修饰
                                                image: AssetImage(
                                                    "assets/images/car_anniu.png"),
                                                fit: BoxFit.fill, //覆盖
                                              )),
                                          child: WidgetUtils.onlyTextCenter(
                                              '开奖记录',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.white,
                                                  fontSize: 22.sp)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                                // 右侧按键
                                SizedBox(
                                  height: 200.h,
                                  width: 300.h,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      WidgetUtils.commonSizedBox(20.h, 10.h),
                                      Container(
                                        height: 38.h,
                                        constraints: BoxConstraints(
                                          minWidth: 100.h,
                                        ),
                                        margin: EdgeInsets.only(bottom: 10.h),
                                        //边框设置
                                        decoration: const BoxDecoration(
                                            image: DecorationImage(
                                          //背景图片修饰
                                          image: AssetImage(
                                              "assets/images/car_top_bg.png"),
                                          fit: BoxFit.fill, //覆盖
                                        )),
                                        child: GestureDetector(
                                          onTap: (() {}),
                                          child: Row(
                                            children: [
                                              const Spacer(),
                                              WidgetUtils.showImages(
                                                  'assets/images/car_mogubi.png',
                                                  25.h,
                                                  25.h),
                                              WidgetUtils.commonSizedBox(
                                                  0, 5.h),
                                              WidgetUtils.onlyText(
                                                  '10w+',
                                                  StyleUtils.getCommonTextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.sp)),
                                              WidgetUtils.commonSizedBox(
                                                  0, 10.h),
                                              Container(
                                                height: 22.h,
                                                width: 1.h,
                                                color: MyColors.CarXian,
                                              ),
                                              WidgetUtils.commonSizedBox(
                                                  0, 10.h),
                                              WidgetUtils.showImages(
                                                  'assets/images/mine_wallet_dd.png',
                                                  25.h,
                                                  25.h),
                                              WidgetUtils.commonSizedBox(
                                                  0, 5.h),
                                              WidgetUtils.onlyText(
                                                  '10w+',
                                                  StyleUtils.getCommonTextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.sp)),
                                              WidgetUtils.commonSizedBox(
                                                  0, 10.h),
                                              Container(
                                                height: 22.h,
                                                width: 1.h,
                                                color: MyColors.CarXian,
                                              ),
                                              WidgetUtils.commonSizedBox(
                                                  0, 10.h),
                                              WidgetUtils.showImages(
                                                  'assets/images/mine_wallet_zz.png',
                                                  25.h,
                                                  25.h),
                                              WidgetUtils.commonSizedBox(
                                                  0, 5.h),
                                              WidgetUtils.onlyText(
                                                  '10w+',
                                                  StyleUtils.getCommonTextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20.sp)),
                                              WidgetUtils.commonSizedBox(
                                                  0, 10.h),
                                              WidgetUtils.showImages(
                                                  'assets/images/car_more.png',
                                                  8.h,
                                                  14.h),
                                              const Spacer(),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Spacer(),
                                          GestureDetector(
                                            onTap: (() {
                                              MyUtils.goTransparentPageCom(context, const CarShopPage());
                                            }),
                                            child: WidgetUtils.showImages(
                                                'assets/images/car_shop.png',
                                                100.h,
                                                100.h),
                                          )
                                        ],
                                      ),
                                      const Spacer(),
                                    ],
                                  ),
                                ),
                                WidgetUtils.commonSizedBox(0, 10.h),
                              ],
                            ),
                          ),
                          WidgetUtils.commonSizedBox(140.h, 0),
                        ],
                      )
                    : const Text(''),
                Positioned(
                  top: 330.h,
                  left: 25.h,
                  child: SlideTransition(
                    position: _carPlay(0),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            WidgetUtils.showImages(
                                listCar[0] ? 'assets/images/car/xiaogui+.png' : 'assets/images/car/xiaogui.png',
                                ScreenUtil().setHeight(102),
                                ScreenUtil().setHeight(180)),
                            isShow == false ? Positioned(
                                left: 73.h,
                                top: 78.h,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    ScreenUtil().setHeight(15),
                                    ScreenUtil().setHeight(15))) : const Text(''),
                            isShow == false ? Positioned(
                                left: 130.h,
                                top: 78.h,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    ScreenUtil().setHeight(15),
                                    ScreenUtil().setHeight(15))) : const Text(''),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 380.h,
                  left: 12.h,
                  child: SlideTransition(
                    position: _carPlay(1),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            WidgetUtils.showImages(
                                listCar[1] ? 'assets/images/car/guigui+.png' : 'assets/images/car/guigui.png',
                                ScreenUtil().setHeight(102),
                                ScreenUtil().setHeight(180)),
                            isShow == false ? Positioned(
                                left: 66.h,
                                top: 75.h,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    ScreenUtil().setHeight(18),
                                    ScreenUtil().setHeight(18))) : const Text(''),
                            isShow == false ? Positioned(
                                left: 120.h,
                                top: 82.h,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    ScreenUtil().setHeight(15),
                                    ScreenUtil().setHeight(15))) : const Text(''),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 430.h,
                  left: 10.h,
                  child: SlideTransition(
                    position: _carPlay(2),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            WidgetUtils.showImages(
                                listCar[2] ? 'assets/images/car/lan+.png' : 'assets/images/car/lan.png',
                                ScreenUtil().setHeight(102),
                                ScreenUtil().setHeight(180)),
                            isShow == false ? Positioned(
                                left: 58.h,
                                top: 72.h,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    ScreenUtil().setHeight(20),
                                    ScreenUtil().setHeight(20))) : const Text(''),
                            isShow == false ? Positioned(
                                left: 112.h,
                                top: 72.h,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    ScreenUtil().setHeight(22),
                                    ScreenUtil().setHeight(22))) : const Text(''),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 485.h,
                  left: -5.h,
                  child: SlideTransition(
                    position: _carPlay(3),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            WidgetUtils.showImages(
                                listCar[3] ? 'assets/images/car/hou+.png' : 'assets/images/car/hou.png',
                                ScreenUtil().setHeight(102),
                                ScreenUtil().setHeight(180)),
                            isShow == false ? Positioned(
                                left: 54.h,
                                top: 74.h,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    ScreenUtil().setHeight(15),
                                    ScreenUtil().setHeight(15))) : const Text(''),
                            isShow == false ? Positioned(
                                left: 128.h,
                                top: 80.h,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    ScreenUtil().setHeight(13),
                                    ScreenUtil().setHeight(13))) : const Text(''),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 530.h,
                  left: -12.h,
                  child: SlideTransition(
                    position: _carPlay(4),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            WidgetUtils.showImages(
                                listCar[4] ? 'assets/images/car/fen+.png' : 'assets/images/car/fen.png',
                                ScreenUtil().setHeight(102),
                                ScreenUtil().setHeight(180)),
                            isShow == false ? Positioned(
                                left: 58.h,
                                top: 75.h,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    ScreenUtil().setHeight(18),
                                    ScreenUtil().setHeight(18))) : const Text(''),
                            isShow == false ? Positioned(
                                left: 117.h,
                                top: 78.h,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    ScreenUtil().setHeight(18),
                                    ScreenUtil().setHeight(18))) : const Text(''),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 585.h,
                  left: -30.h,
                  child: SlideTransition(
                    position: _carPlay(5),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            WidgetUtils.showImages(
                                listCar[5] ? 'assets/images/car/lv+.png' : 'assets/images/car/lv.png',
                                ScreenUtil().setHeight(102),
                                ScreenUtil().setHeight(180)),
                            isShow == false ? Positioned(
                                left: 60.h,
                                top: 72.h,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    ScreenUtil().setHeight(20),
                                    ScreenUtil().setHeight(20))) : const Text(''),
                            isShow == false ? Positioned(
                                left: 114.h,
                                top: 78.h,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    ScreenUtil().setHeight(15),
                                    ScreenUtil().setHeight(15))) : const Text(''),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 635.h,
                  left: -40.h,
                  child: SlideTransition(
                    position: _carPlay(6),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            WidgetUtils.showImages(
                                listCar[6] ? 'assets/images/car/maliao+.png' : 'assets/images/car/maliao.png',
                                ScreenUtil().setHeight(102),
                                ScreenUtil().setHeight(180)),
                            isShow == false ? Positioned(
                                left: 58.h,
                                top: 67.h,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    ScreenUtil().setHeight(22),
                                    ScreenUtil().setHeight(22))) : const Text(''),
                            isShow == false ? Positioned(
                                left: 112.h,
                                top: 75.h,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    ScreenUtil().setHeight(18),
                                    ScreenUtil().setHeight(18))) : const Text(''),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // 倒计时闹钟
                isShow
                    ? Positioned(
                        top: 280.h,
                        left: 215.h,
                        child: Stack(
                          children: [
                            WidgetUtils.showImages(
                                'assets/images/car_jingcai.png', 180.h, 180.h),
                            Container(
                              height: 160.h,
                              width: 180.h,
                              alignment: Alignment.center,
                              child: WidgetUtils.onlyTextCenter(
                                  sum.toString(),
                                  StyleUtils.getCommonTextStyle(
                                      color: MyColors.mineRed,
                                      fontSize: 50.sp,
                                      fontWeight: FontWeight.w600)),
                            )
                          ],
                        ),
                      )
                    : const Text(''),
                isPlay
                    ? Positioned(
                        top: 50.h,
                        left: 0.h,
                        height: ScreenUtil().setHeight(600),
                        width: ScreenUtil().setHeight(600),
                        child: const SVGASimpleImage(
                          assetsName: 'assets/svga/gp/djs.svga',
                        ),
                      )
                    : const Text(''),
                isGo ? Positioned(
                  top: 230.h,
                  left: 180.h,
                  child: ScaleTransition(
                    scale: animationGO,
                    child: WidgetUtils.showImages('assets/images/car_go.png', 300.h, 260.h),
                  ),
                ): const Text(''),

              ],
            ),
          ),
          //下注区域
          Expanded(
              child: Container(
            padding: EdgeInsets.only(left: 5.h, right: 10.h),
            color: MyColors.CarBG,
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(20.h, 0),
                //6倍
                Row(
                  children: [
                    WidgetUtils.showImagesFill(
                        'assets/images/car_b6.png', 73.h, 69.h),
                    SixInfo(2),
                    WidgetUtils.commonSizedBox(0, 5.h),
                    SixInfo(1),
                    WidgetUtils.commonSizedBox(0, 5.h),
                    SixInfo(4),
                    WidgetUtils.commonSizedBox(0, 5.h),
                    SixInfo(3),
                    WidgetUtils.commonSizedBox(0, 5.h),
                    SixInfo(5),
                    WidgetUtils.commonSizedBox(0, 5.h),
                    SixInfo(6),
                  ],
                ),
                WidgetUtils.commonSizedBox(4.h, 0),
                //3倍
                Row(
                  children: [
                    WidgetUtils.showImagesFill(
                        'assets/images/car_b3.png', 73.h, 69.h),
                    SixInfo2(1),
                    WidgetUtils.commonSizedBox(0, 4.h),
                    SixInfo2(2),
                    WidgetUtils.commonSizedBox(0, 4.h),
                    SixInfo2(3),
                  ],
                ),
                WidgetUtils.commonSizedBox(4.h, 0),
                //2倍
                Row(
                  children: [
                    WidgetUtils.showImagesFill(
                        'assets/images/car_b2.png', 73.h, 69.h),
                    SixInfo3(1),
                    WidgetUtils.commonSizedBox(0, 4.h),
                    SixInfo3(2),
                  ],
                ),
                WidgetUtils.commonSizedBox(4.h, 0),
                //8倍
                Row(
                  children: [
                    WidgetUtils.showImagesFill(
                        'assets/images/car_b8.png', 73.h, 69.h),
                    Expanded(
                        child: GestureDetector(
                      onTap: (() {
                        if (isShow) {
                          if(tishi){
                            int jine = 0;
                            for(int a = 0; a < 4; a++){
                              if(listB[a]){
                                if(a==0){
                                  jine = 10;
                                }else if(a==1){
                                  jine = 100;
                                }else if(a==2){
                                  jine = 1000;
                                }else if(a==3){
                                  jine = 1000;
                                }
                              }
                            }
                            MyUtils.goTransparentPageCom(context, QueRenPage(title: '赛车下注', jine: jine.toString(), isDuiHuan: false));
                            return;
                          }
                          playSound2();
                          setState(() {
                            listA[11] = true;
                          });
                        }
                      }),
                      child: Stack(
                        children: [
                          WidgetUtils.showImagesFill(
                              listA[11]
                                  ? 'assets/images/car_jl_8_yes.png'
                                  : 'assets/images/car_jl_8_no.png',
                              70.h,
                              double.infinity),
                          Positioned(
                            left: 5.h,
                            top: 10.h,
                            child: WidgetUtils.onlyText(
                                '10000',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.w600)),
                          )
                        ],
                      ),
                    ))
                  ],
                ),
                const Spacer(),
                //下注
                Row(
                  children: [
                    jine(0),
                    WidgetUtils.commonSizedBox(0, 10.h),
                    jine(1),
                    WidgetUtils.commonSizedBox(0, 10.h),
                    jine(2),
                    WidgetUtils.commonSizedBox(0, 10.h),
                    jine(3),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
