import 'dart:async';
import 'dart:math';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soundpool/soundpool.dart';
import 'package:svgaplayer_flutter/parser.dart';
import 'package:svgaplayer_flutter/player.dart';

import '../../colors/my_colors.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../../widget/queren_h_page.dart';
import '../../widget/queren_page.dart';
import 'car/car_h_shop_page.dart';
import 'car/car_shop_page.dart';
import 'car/lishi_h_page.dart';
import 'car/lishi_page.dart';
import 'car/zhongjian_h_page.dart';
import 'car/zhongjian_page.dart';
import 'car_page.dart';
/// 横屏赛车游戏
class CarLandScapePage extends StatefulWidget {
  const CarLandScapePage({super.key});

  @override
  State<CarLandScapePage> createState() => _CarLandScapePageState();
}

class _CarLandScapePageState extends State<CarLandScapePage> with TickerProviderStateMixin{
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
                MyUtils.goTransparentPageCom(context, QueRenHPage(title: '赛车下注横屏', jine: jine.toString(), isDuiHuan: false));
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
                  35,
                  double.infinity),
              i == 4
                  ? Positioned(
                  top: -3.5,
                  right: 0,
                  child: WidgetUtils.showImages(
                      'assets/images/car_jl_t$i.png', 40, 38))
                  : i == 5
                  ? Positioned(
                  top: 1,
                  right: 2,
                  child: WidgetUtils.showImagesFill(
                      'assets/images/car_jl_t$i.png', 32, 42))
                  : i == 3
                  ? Positioned(
                  top: -1,
                  right: 2,
                  child: WidgetUtils.showImagesFill(
                      'assets/images/car_jl_t$i.png', 35, 36))
                  :
                  Positioned(
                  top: -2,
                  right: 2,
                  child: WidgetUtils.showImages(
                      'assets/images/car_jl_t$i.png', 38, 33)),
              Positioned(
                left: 5,
                top: 5,
                child: WidgetUtils.onlyText(
                    '10000',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              ),
              SizedBox(
                height: 40,
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
                MyUtils.goTransparentPageCom(context, QueRenHPage(title: '赛车下注横屏', jine: jine.toString(), isDuiHuan: false));
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
                  35,
                  double.infinity),
              Positioned(
                  top: 1.h,
                  bottom: 2.h,
                  right: 3,
                  child: WidgetUtils.showImagesFill(
                      'assets/images/car_3_$one.png', 40, 70)),
              Positioned(
                left: 5,
                top: 5,
                child: WidgetUtils.onlyText(
                    '10000',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.white,
                        fontSize: 12,
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
                MyUtils.goTransparentPageCom(context, QueRenHPage(title: '赛车下注横屏', jine: jine.toString(), isDuiHuan: false));
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
                  35,
                  double.infinity),
              Positioned(
                  top: 1,
                  bottom: 1,
                  right: 1.5,
                  child: WidgetUtils.showImagesFill(
                      'assets/images/car_2_$one.png', 40, 100)),
              Positioned(
                left: 5,
                top: 5,
                child: WidgetUtils.onlyText(
                    '10000',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600)),
              )
            ],
          ),
        ));
  }

  // 下注金额
  Widget jine(int i) {
    return GestureDetector(
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
        height: 85,
        width: 75,
        child: Stack(
          children: [
            WidgetUtils.showImagesFill(
                listB[i] == false
                    ? 'assets/images/car_h_btn_no.png'
                    : 'assets/images/car_h_btn_yes.png',
                85,
                75),
            Column(
              children: [
                WidgetUtils.commonSizedBox(15,0),
                WidgetUtils.showImages(
                    'assets/images/car_mogubi.png', 20, 20),
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
                            fontSize: 16))),
                WidgetUtils.commonSizedBox(15,0),
              ],
            )
          ],
        ),
      ),
    );
  }

  /// 播放音频
  Soundpool soundpool = Soundpool(streamType: StreamType.notification);

  Future<void> playSound() async {
    int soundId = await rootBundle
        .load('assets/audio/car_jine.wav')
        .then(((ByteData soundDate) {
      return soundpool.load(soundDate);
    }));
    soundpool.setVolume(volume: 1);
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
    "assets/images/car_h_bg_qidian.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg_qidian.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg_qidian.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
    "assets/images/car_h_bg.jpg",
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

  var a,a1,a2,a3,a4,a5,a6,b,b1,b2,b3,b4,b5,b6,c,c1,c2,c3,c4,c5,c6,d,d1,d2,d3,d4,d5,d6,e,e1,e2,e3,e4,e5,e6,f,f1,f2,f3,f4,f5,f6,g,g1,g2,g3,g4,g5,g6;
  var j,j1,j2,j3,j4,j5,j6;

  void suijishu(){
    a = Random().nextInt(10) / 10;
    b = Random().nextInt(10) / 10;
    c = Random().nextInt(10) / 10;
    d = Random().nextInt(10) / 10;
    e = Random().nextInt(10) / 10;
    f = Random().nextInt(10) / 10;
    g = Random().nextInt(10) / 10;

    a1 = Random().nextInt(10) / 10;
    b1 = Random().nextInt(10) / 10;
    c1 = Random().nextInt(10) / 10;
    d1 = Random().nextInt(10) / 10;
    e1 = Random().nextInt(10) / 10;
    f1 = Random().nextInt(10) / 10;
    g1 = Random().nextInt(10) / 10;

    a2 = Random().nextInt(10) / 10;
    b2 = Random().nextInt(10) / 10;
    c2 = Random().nextInt(10) / 10;
    d2 = Random().nextInt(10) / 10;
    e2 = Random().nextInt(10) / 10;
    f2 = Random().nextInt(10) / 10;
    g2 = Random().nextInt(10) / 10;

    a3 = Random().nextInt(10) / 10;
    b3 = Random().nextInt(10) / 10;
    c3 = Random().nextInt(10) / 10;
    d3 = Random().nextInt(10) / 10;
    e3 = Random().nextInt(10) / 10;
    f3 = Random().nextInt(10) / 10;
    g3 = Random().nextInt(10) / 10;

    a4 = Random().nextInt(10) / 10;
    b4 = Random().nextInt(10) / 10;
    c4 = Random().nextInt(10) / 10;
    d4 = Random().nextInt(10) / 10;
    e4 = Random().nextInt(10) / 10;
    f4 = Random().nextInt(10) / 10;
    g4 = Random().nextInt(10) / 10;

    a5 = Random().nextInt(10) / 10;
    b5 = Random().nextInt(10) / 10;
    c5 = Random().nextInt(10) / 10;
    d5 = Random().nextInt(10) / 10;
    e5 = Random().nextInt(10) / 10;
    f5 = Random().nextInt(10) / 10;
    g5 = Random().nextInt(10) / 10;

    a6 = Random().nextInt(10) / 10;
    b6 = Random().nextInt(10) / 10;
    c6 = Random().nextInt(10) / 10;
    d6 = Random().nextInt(10) / 10;
    e6 = Random().nextInt(10) / 10;
    f6 = Random().nextInt(10) / 10;
    g6 = Random().nextInt(10) / 10;

    j = Random().nextDouble()+Random().nextDouble()+5;
    j1 = Random().nextDouble()+Random().nextDouble()+5;
    j2 = Random().nextDouble()+Random().nextDouble()+5;
    j3 = Random().nextDouble()+Random().nextDouble()+5;
    j4 = Random().nextDouble()+Random().nextDouble()+5;
    j5 = Random().nextDouble()+Random().nextDouble()+5;
    j6 = Random().nextDouble()+Random().nextDouble()+5;
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
    _timer = Timer.periodic(const Duration(milliseconds: 1500), (timer) {
      if (_controller.hasClients) {
        setState(() {
          sumBG++;
          if(sumBG==13){
            MyUtils.goTransparentPageCom(context, ZhongJiangHPage(type: luck));
          }
        });
        if (_controller.page!.round() >= imagesa.length - 1) {
          _controller.jumpToPage(0);
        } else {
          _controller.nextPage(
            duration: const Duration(milliseconds: 1500),
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
              tween: Tween(begin: Offset.zero, end: Offset(a+1.5, 0)), weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(a+1.5, 0), end: Offset(b +0.6, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(b + 0.6, 0), end: Offset(c+2, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(c+2, 0), end: Offset(d + 1, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(d + 1, 0), end: Offset(e +2.5, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(e + 2.5, 0), end: Offset(f +3.5, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(f + 3.5, 0), end: Offset(g +2, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(
                  begin: Offset(g + 2, 0),
                  end: Offset(luck == i ? 8 : j, 0)),
              weight: 30),
        ]).animate(controller2);
        break;
      case 1:
        animation2 = TweenSequence([
          TweenSequenceItem(
              tween: Tween(begin: Offset.zero, end: Offset(a1+1.5, 0)), weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(a1+1.5, 0), end: Offset(b1 +0.6, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(b1 + 0.6, 0), end: Offset(c1+2, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(c1+2, 0), end: Offset(d1 + 1, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(d1 + 1, 0), end: Offset(e1 +2.5, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(e1 + 2.5, 0), end: Offset(f1 +3.5, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(f1 + 3.5, 0), end: Offset(g1 +2, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(
                  begin: Offset(g1 + 2, 0),
                  end: Offset(luck == i ? 8 : j1, 0)),
              weight: 30),
        ]).animate(controller2);
        break;
      case 2:
        animation2 = TweenSequence([
          TweenSequenceItem(
              tween: Tween(begin: Offset.zero, end: Offset(a2+1.5, 0)), weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(a2+1.5, 0), end: Offset(b2 +0.6, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(b2 + 0.6, 0), end: Offset(c2+2, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(c2+2, 0), end: Offset(d2 + 1, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(d2 + 1, 0), end: Offset(e2 +2.5, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(e2 + 2.5, 0), end: Offset(f2 +3.5, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(f2 + 3.5, 0), end: Offset(g2 +2, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(
                  begin: Offset(g2 + 2, 0),
                  end: Offset(luck == i ? 8 : j2, 0)),
              weight: 30),
        ]).animate(controller2);
        break;
      case 3:
        animation2 = TweenSequence([
          TweenSequenceItem(
              tween: Tween(begin: Offset.zero, end: Offset(a3+1.5, 0)), weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(a3+1.5, 0), end: Offset(b3 +0.6, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(b3 + 0.6, 0), end: Offset(c3+2, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(c3+2, 0), end: Offset(d3 + 1, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(d3 + 1, 0), end: Offset(e3 +2.5, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(e3 + 2.5, 0), end: Offset(f3 +3.5, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(f3 + 3.5, 0), end: Offset(g3 +2, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(
                  begin: Offset(g3 + 2, 0),
                  end: Offset(luck == i ? 8 : j3, 0)),
              weight: 30),
        ]).animate(controller2);
        break;
      case 4:
        animation2 = TweenSequence([
          TweenSequenceItem(
              tween: Tween(begin: Offset.zero, end: Offset(a4+1.5, 0)), weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(a4+1.5, 0), end: Offset(b4 +0.6, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(b4 + 0.6, 0), end: Offset(c4+2, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(c4+2, 0), end: Offset(d4 + 1, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(d4 + 1, 0), end: Offset(e4 +2.5, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(e4 + 2.5, 0), end: Offset(f4 +3.5, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(f4 + 3.5, 0), end: Offset(g4 +2, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(
                  begin: Offset(g4 + 2, 0),
                  end: Offset(luck == i ? 8 : j4, 0)),
              weight: 30),
        ]).animate(controller2);
        break;
      case 5:
        animation2 = TweenSequence([
          TweenSequenceItem(
              tween: Tween(begin: Offset.zero, end: Offset(a5+1.5, 0)), weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(a5+1.5, 0), end: Offset(b5 +0.6, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(b5 + 0.6, 0), end: Offset(c5+2, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(c5+2, 0), end: Offset(d5 + 1, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(d5 + 1, 0), end: Offset(e5 +2.5, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(e5 + 2.5, 0), end: Offset(f5 +3.5, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(f5 + 3.5, 0), end: Offset(g5 +2, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(
                  begin: Offset(g5 + 2, 0),
                  end: Offset(luck == i ? 8 : j5, 0)),
              weight: 30),
        ]).animate(controller2);
        break;
      case 6:
        animation2 = TweenSequence([
          TweenSequenceItem(
              tween: Tween(begin: Offset.zero, end: Offset(a6+1.5, 0)), weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(a6+1.5, 0), end: Offset(b6 +0.6, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(b6 + 0.6, 0), end: Offset(c6+2, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(c6+2, 0), end: Offset(d6 + 1, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(d6 + 1, 0), end: Offset(e6 +2.5, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(e6 + 2.5, 0), end: Offset(f6 +3.5, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(begin: Offset(f6 + 3.5, 0), end: Offset(g6 +2, 0)),
              weight: 10),
          TweenSequenceItem(
              tween: Tween(
                  begin: Offset(g6 + 2, 0),
                  end: Offset(luck == i ? 8 : j6, 0)),
              weight: 30),
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
    Future.delayed(const Duration(milliseconds: 2500,),(){
      startTimer();
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isPlay = false;
        isGo = true;
        sum = 20;
        sumBG = 0;
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
    AutoOrientation.landscapeAutoMode();
    ///关闭状态栏，与底部虚拟操作按钮
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);//隐藏状态栏，底部按钮栏

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
    /// 如果是全屏就切换竖屏
    AutoOrientation.portraitAutoMode();
    ///显示状态栏，与底部虚拟操作按钮
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
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
      body: Column(
        children: [
          SizedBox(
            height: 240,
            width: double.infinity,
            child: Stack(
              children: [
                //背景图
                SizedBox(
                  height: double.infinity,
                  width: double.infinity,
                  child: PageView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: _controller,
                    itemBuilder: (context, index) {
                      final imageIndex = index % imagesa.length;
                      return Image.asset(
                        imagesa[imageIndex],
                        width: double.infinity,
                        height: double.infinity,
                        fit: BoxFit.fill,
                        gaplessPlayback: true,
                      );
                    },
                  ),
                ),

                Positioned(
                  top: 55,
                  left: 12,
                  child: SlideTransition(
                    position: _carPlay(0),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            WidgetUtils.showImages(
                                listCar[0] ? 'assets/images/car/xiaogui+.png' : 'assets/images/car/xiaogui.png',
                                60,
                                100),
                            isShow == false ? Positioned(
                                left: 41,
                                top: 45,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    8,
                                    8)) : const Text(''),
                            isShow == false ? Positioned(
                                left: 72,
                                top: 45,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    8,
                                    8)) : const Text(''),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 75,
                  left: 5,
                  child: SlideTransition(
                    position: _carPlay(1),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            WidgetUtils.showImages(
                                listCar[1] ? 'assets/images/car/guigui+.png' : 'assets/images/car/guigui.png',
                                60,
                                100),
                            isShow == false ? Positioned(
                                left: 37,
                                top: 43,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    10,
                                    10)) : const Text(''),
                            isShow == false ? Positioned(
                                left: 65,
                                top: 45,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    10,
                                    10)) : const Text(''),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 95,
                  left: 3,
                  child: SlideTransition(
                    position: _carPlay(2),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            WidgetUtils.showImages(
                                listCar[2] ? 'assets/images/car/lan+.png' : 'assets/images/car/lan.png',
                                60,
                                100),
                            isShow == false ? Positioned(
                                left: 33,
                                top: 42,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    10,
                                    10)) : const Text(''),
                            isShow == false ? Positioned(
                                left: 63,
                                top: 42,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    11,
                                    11)) : const Text(''),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 116,
                  left: -2,
                  child: SlideTransition(
                    position: _carPlay(3),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            WidgetUtils.showImages(
                                listCar[3] ? 'assets/images/car/hou+.png' : 'assets/images/car/hou.png',
                                60,
                                100),
                            isShow == false ? Positioned(
                                left: 30,
                                top: 43,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    7,
                                    7)) : const Text(''),
                            isShow == false ? Positioned(
                                left: 71,
                                top: 45.5,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    7,
                                    7)) : const Text(''),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 137,
                  left: -7,
                  child: SlideTransition(
                    position: _carPlay(4),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            WidgetUtils.showImages(
                                listCar[4] ? 'assets/images/car/fen+.png' : 'assets/images/car/fen.png',
                                60,
                                100),
                            isShow == false ? Positioned(
                                left: 33,
                                top: 43,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    9,
                                    9)) : const Text(''),
                            isShow == false ? Positioned(
                                left: 65,
                                top: 45,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    9,
                                    9)) : const Text(''),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 160,
                  left: -14,
                  child: SlideTransition(
                    position: _carPlay(5),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            WidgetUtils.showImages(
                                listCar[5] ? 'assets/images/car/lv+.png' : 'assets/images/car/lv.png',
                                60,
                                100),
                            isShow == false ? Positioned(
                                left: 34,
                                top: 41,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    10,
                                    10)) : const Text(''),
                            isShow == false ? Positioned(
                                left: 64,
                                top: 45,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    8,
                                    8)) : const Text(''),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 182,
                  left: -20,
                  child: SlideTransition(
                    position: _carPlay(6),
                    child: Row(
                      children: [
                        Stack(
                          children: [
                            WidgetUtils.showImages(
                                listCar[6] ? 'assets/images/car/maliao+.png' : 'assets/images/car/maliao.png',
                                60,
                                100),
                            isShow == false ? Positioned(
                                left: 33,
                                top: 40,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    11,
                                    11)) : const Text(''),
                            isShow == false ? Positioned(
                                left: 63,
                                top: 42.5,
                                child: WidgetUtils.showImages(
                                    'assets/images/z_wheel.gif',
                                    9,
                                    9)) : const Text(''),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // 倒计时闹钟
                isShow
                    ? Positioned(
                  top: 30,
                  left: 355,
                  child: Stack(
                    children: [
                      WidgetUtils.showImages(
                          'assets/images/car_jingcai.png', 80, 80),
                      Container(
                        height: 70,
                        width: 80,
                        alignment: Alignment.center,
                        child: WidgetUtils.onlyTextCenter(
                            sum.toString(),
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.mineRed,
                                fontSize: 20,
                                fontWeight: FontWeight.w600)),
                      )
                    ],
                  ),
                )
                    : const Text(''),
                //倒计时svga
                isPlay
                    ? const Positioned(
                  top: -30,
                  left: 305,
                  height: 175,
                  width: 180,
                  child: SVGASimpleImage(
                    assetsName: 'assets/svga/gp/djs.svga',
                  ),
                )
                    : const Text(''),
                isGo? Positioned(
                  top: 0,
                  left: 325,
                  child: ScaleTransition(
                    scale: animationGO,
                    child: WidgetUtils.showImages('assets/images/car_go.png', 130, 130),
                  ),
                ): const Text(''),

                //下注金额
                isShow ? Positioned(
                  top: 110,
                  left: 200,
                  child:  Row(
                  children: [
                    jine(0),
                    WidgetUtils.commonSizedBox(0, 30),
                    jine(1),
                    WidgetUtils.commonSizedBox(0, 30),
                    jine(2),
                    WidgetUtils.commonSizedBox(0, 30),
                    jine(3),
                  ],
                ),) : const Text(''),

                //左侧按钮
                isShow
                    ? SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      // 左侧按键
                      SizedBox(
                        height: 100,
                        child: Column(
                          children: [
                            WidgetUtils.commonSizedBox(10, 0),
                            GestureDetector(
                              onTap: ((){
                                MyUtils.goTransparentPageCom(context, const Carpage());
                                /// 如果是全屏就切换竖屏
                                AutoOrientation.portraitAutoMode();
                                ///显示状态栏，与底部虚拟操作按钮
                                SystemChrome.setEnabledSystemUIOverlays(
                                    [SystemUiOverlay.top, SystemUiOverlay.bottom]);
                                Navigator.pop(context);
                              }),
                              child: Container(
                                height: 20,
                                width: 55,
                                //边框设置
                                decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      //背景图片修饰
                                      image: AssetImage(
                                          "assets/images/car_anniu.png"),
                                      fit: BoxFit.fill, //覆盖
                                    )),
                                child: WidgetUtils.onlyTextCenter(
                                    '竖屏模式',
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.white,
                                        fontSize: 11)),
                              ),
                            ),
                            WidgetUtils.commonSizedBox(2.5, 0),
                            Container(
                              height: 20,
                              width: 55,
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
                                      fontSize: 11)),
                            ),
                            WidgetUtils.commonSizedBox(2.5, 0),
                            GestureDetector(
                              onTap: ((){
                                MyUtils.goTransparentPageCom(context, const LiShiHPage());
                              }),
                              child: Container(
                                height: 20,
                                width: 55,
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
                                        fontSize: 11)),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      // 右侧按键
                      SizedBox(
                        height: 100,
                        width: 180,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            WidgetUtils.commonSizedBox(10, 5),
                            Container(
                              height: 20,
                              width: 180,
                              margin: const EdgeInsets.only(bottom: 5),
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
                                        12,
                                        12),
                                    WidgetUtils.commonSizedBox(
                                        0, 2.5),
                                    WidgetUtils.onlyText(
                                        '10w+',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: 10)),
                                    WidgetUtils.commonSizedBox(
                                        0, 5),
                                    Container(
                                      height: 11,
                                      width: 1,
                                      color: MyColors.CarXian,
                                    ),
                                    WidgetUtils.commonSizedBox(
                                        0, 5),
                                    WidgetUtils.showImages(
                                        'assets/images/mine_wallet_dd.png',
                                        12,
                                        12),
                                    WidgetUtils.commonSizedBox(
                                        0, 2.5),
                                    WidgetUtils.onlyText(
                                        '10w+',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: 10)),
                                    WidgetUtils.commonSizedBox(
                                        0, 5),
                                    Container(
                                      height: 11,
                                      width: 1,
                                      color: MyColors.CarXian,
                                    ),
                                    WidgetUtils.commonSizedBox(
                                        0, 5),
                                    WidgetUtils.showImages(
                                        'assets/images/mine_wallet_zz.png',
                                        12,
                                        12),
                                    WidgetUtils.commonSizedBox(
                                        0, 2.5),
                                    WidgetUtils.onlyText(
                                        '10w+',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: 10)),
                                    WidgetUtils.commonSizedBox(
                                        0, 5),
                                    WidgetUtils.showImages(
                                        'assets/images/car_more.png',
                                        4,
                                        7),
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
                                    MyUtils.goTransparentPageCom(context, const CarHShopPage());
                                  }),
                                  child: WidgetUtils.showImages(
                                      'assets/images/car_shop.png',
                                      50,
                                      50),
                                )
                              ],
                            ),
                            const Spacer(),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(0, 5),
                    ],
                  ),
                )
                    : const Text(''),
              ],
            ),
          ),
          //下注区域
          Expanded(
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.only(left: 10, right: 5),
              color: MyColors.CarBG,
              child: Row(
                children: [
                  Expanded(child: Column(
                    children: [
                      const Spacer(),
                      //6倍
                      SizedBox(
                        height: 35,
                        child: Row(
                          children: [
                            WidgetUtils.showImagesFill(
                                'assets/images/car_b6.png', 35, 40),
                            SixInfo(2),
                            WidgetUtils.commonSizedBox(0, 2.5),
                            SixInfo(1),
                            WidgetUtils.commonSizedBox(0, 2.5),
                            SixInfo(4),
                            WidgetUtils.commonSizedBox(0, 2.5),
                            SixInfo(3),
                            WidgetUtils.commonSizedBox(0, 2.5),
                            SixInfo(5),
                            WidgetUtils.commonSizedBox(0, 2.5),
                            SixInfo(6),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(2, 0),
                      //3倍
                      SizedBox(
                        height: 35,
                        child: Row(
                          children: [
                            WidgetUtils.showImagesFill(
                                'assets/images/car_b3.png', 35, 40),
                            SixInfo2(1),
                            WidgetUtils.commonSizedBox(0, 2.5),
                            SixInfo2(2),
                            WidgetUtils.commonSizedBox(0, 2.5),
                            SixInfo2(3),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(2, 0),
                      //2倍
                      SizedBox(
                        height: 35,
                        child: Row(
                          children: [
                            WidgetUtils.showImagesFill(
                                'assets/images/car_b2.png', 35, 40),
                            SixInfo3(1),
                            WidgetUtils.commonSizedBox(0, 2.5),
                            SixInfo3(2),
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  )),
                  WidgetUtils.commonSizedBox(0, 2.5),
                  //8倍
                  Column(
                    children: [
                      WidgetUtils.commonSizedBox(5, 0),
                      Expanded(child: GestureDetector(
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
                              MyUtils.goTransparentPageCom(context, QueRenHPage(title: '赛车下注横屏', jine: jine.toString(), isDuiHuan: false));
                              return;
                            }
                            playSound2();
                            setState(() {
                              listA[11] = true;
                            });
                          }
                        }),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            WidgetUtils.showImagesFill(
                                listA[11]
                                    ? 'assets/images/car_h_jl_8_yes.png'
                                    : 'assets/images/car_h_jl_8_no.png',
                                double.infinity,
                                50),
                            WidgetUtils.onlyText(
                                '10000',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600))
                          ],
                        ),
                      )),
                      WidgetUtils.commonSizedBox(5, 0),
                    ],
                  ),
                  WidgetUtils.commonSizedBox(0, 5),
                  Column(
                    children: [
                      WidgetUtils.commonSizedBox(5, 0),
                      Expanded(child: Container(
                        height: double.infinity,
                        width: 240,
                        decoration: BoxDecoration(
                          //背景
                          color: MyColors.CarBG,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: const BorderRadius.all(
                              Radius.circular(11)),
                          //设置四周边框
                          border: Border.all(width: 1, color: Colors.white),
                        ),
                        child: Text('1111'),
                      )),
                      WidgetUtils.commonSizedBox(5, 0),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
