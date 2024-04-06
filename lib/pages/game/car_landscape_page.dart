import 'dart:async';
import 'dart:math';

import 'package:auto_orientation/auto_orientation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soundpool/soundpool.dart';
import 'package:svgaplayer_flutter/parser.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';

import '../../bean/Common_bean.dart';
import '../../bean/balanceBean.dart';
import '../../bean/carTimerBean.dart';
import '../../bean/carYZBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/event_utils.dart';
import '../../utils/log_util.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../../widget/OptionGridView.dart';
import '../../widget/queren_h_page.dart';
import '../mine/qianbao/dou_pay_page.dart';
import 'car/car_guize_h_page.dart';
import 'car/car_h_shop_page.dart';
import 'car/lishi_h_page.dart';
import 'car/zhongjian_h_page.dart';
import 'car_page.dart';
/// 横屏赛车游戏
class CarLandScapePage extends StatefulWidget {
  const CarLandScapePage({super.key});

  @override
  State<CarLandScapePage> createState() => _CarLandScapePageState();
}

class _CarLandScapePageState extends State<CarLandScapePage> with TickerProviderStateMixin{
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
              if (sp.getBool('car_queren_h') == false ||
                  sp.getBool('car_queren_h') == null) {
                MyUtils.goTransparentPageCom(context, QueRenHPage(title: '赛车下注横屏', jine: xiazhujine, isDuiHuan: false, index: i.toString(),));
                return;
              }
              doPostCarBet(i.toString());
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
                    listJL[i - 1].toString(),
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
              if (sp.getBool('car_queren_h') == false ||
                  sp.getBool('car_queren_h') == null) {
                MyUtils.goTransparentPageCom(context, QueRenHPage(title: '赛车下注横屏', jine: xiazhujine, isDuiHuan: false, index: (6 + one).toString(),));
                return;
              }
              doPostCarBet((6 + one).toString());
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
                    one == 1
                        ? listJL[6].toString()
                        : one == 2
                        ? listJL[7].toString()
                        : listJL[8].toString(),
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
              if (sp.getBool('car_queren_h') == false ||
                  sp.getBool('car_queren_h') == null) {
                MyUtils.goTransparentPageCom(context, QueRenHPage(title: '赛车下注横屏', jine: xiazhujine, isDuiHuan: false, index: (9 + one).toString(),));
                return;
              }
              doPostCarBet((9 + one).toString());
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
                    one == 1 ? listJL[9].toString() : listJL[10].toString(),
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
        for (int a = 0; a < 4; a++) {
          if (listB[a]) {
            setState(() {
              if (a == 0) {
                xiazhujine = 10;
              } else if (a == 1) {
                xiazhujine = 100;
              } else if (a == 2) {
                xiazhujine = 1000;
              } else if (a == 3) {
                xiazhujine = 10000;
              }
            });
          }
        }
        LogE('选中金额$xiazhujine');
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
  Timer? _timer, _timer2, _timer3,_timer4;
  int _currentPage = 0;

  int luck = 6, sum = 20, sumBG = 0, playTime = 46;
  // 是否可以点击下注
  bool isShow = true;
  // 游戏是否开始了
  bool isStarGame = false;

  var a,a1,a2,a3,a4,a5,a6,b,b1,b2,b3,b4,b5,b6,c,c1,c2,c3,c4,c5,c6,d,d1,d2,d3,d4,d5,d6,e,e1,e2,e3,e4,e5,e6,f,f1,f2,f3,f4,f5,f6,g,g1,g2,g3,g4,g5,g6;
  var j,j1,j2,j3,j4,j5,j6;


  // 记录下注情况
  List<int> listJL = [
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
  ];


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
      setState(() {
        sum--;
      });
      if (sum == 0) {
        if(sp.getString('car_audio') == null || sp.getString('car_audio').toString() == '开启') {
          playSound3();
        }
        _timer2!.cancel();
        setState(() {
          isShow = false;
          isPlay = true;
        });
        // 开始倒计时动画
        loadAnimation();
      }
    });
  }

  // 游戏进行中游戏的倒计时
  void starTimerPlay() {
    _timer4 = Timer.periodic(const Duration(seconds: 1), (timer) {
      //游戏结束了
      if (playTime == 0) {
        _timer4!.cancel();
        setState(() {
          isShow = true;
          isStarGame = false;
        });
        starTimerDJS();
      } else {
        // 游戏进行中的倒计时
        setState(() {
          playTime--;
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
    // 请求中奖赛道
    doPostGetWinTrack();

    Future.delayed(const Duration(milliseconds: 2500,),(){
      startTimer();
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        // 清空接受的im下注信息
        listZDY.clear();
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
  // 监听弹窗返回的数据
  var listen;
  // 下注金额
  int xiazhujine = 10;
  // 及时展示im使用
  var listenZDY;
  List<Map> listZDY = [];
  // 选择了哪个赛道
  String chooseWho = '';

  // 下注记录
  Widget _initlistdata(context, index) {
    return Container(
      height: 150.h,
      width: 150.h,
      margin: EdgeInsets.only(left: 10.h, top: 25.h),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          WidgetUtils.CircleHeadImage(
              150.h, 150.h, listZDY[index]['avatar']),
          Container(
            height: 40.h,
            width: 150.h,
            //边框设置
            decoration: const BoxDecoration(
                image: DecorationImage(
                  //背景图片修饰
                  image:
                  AssetImage("assets/images/car_btn2.png"),
                  fit: BoxFit.fill, //覆盖
                )),
            child: WidgetUtils.onlyTextCenter(
                listZDY[index]['amount'],
                StyleUtils.getCommonTextStyle(
                    color: Colors.white, fontSize: 8.sp)),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    // 获取账户余额
    doPostBalance();
    // 获取赛车倒计时
    doPostGetCarTimer();
    // 二次确认弹窗点击确认，开始下注
    listen = eventBus.on<QuerenBack>().listen((event) {
      if(event.title == '横屏赛车') {
        doPostCarBet(event.index);
      }
    });
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
        //下注状态
        for (int i = 0; i < listA.length; i++) {
          setState(() {
            listA[i] = false;
          });
        }
        // 下注记录清空
        for (int i = 0; i < listJL.length; i++) {
          setState(() {
            listJL[i] = 0;
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

    // 接受下注的im信息
    listenZDY = eventBus.on<JoinRoomYBack>().listen((event) {
      if (event.map!['avatar'].toString().isNotEmpty && isShow) {
        if (listZDY.length < 8) {
          Map<dynamic, dynamic> map = {};
          map['avatar'] = event.map!['avatar'];
          map['amount'] = event.map!['amount'];
          setState(() {
            listZDY.add(map);
          });
        } else {
          setState(() {
            for (int i = 0; i < 7; i++) {
              listZDY[i] = listZDY[1 + 1];
            }
            Map<dynamic, dynamic> map = {};
            map['avatar'] = event.map!['avatar'];
            map['amount'] = event.map!['amount'];
            listZDY[7] = map;
          });
        }
      }
    });

    // 监听网络状态变化
    // startListening();

    // 判断当前年月日是否为今天，如果不是，下注还是要提示
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;
    String time = '$year-$month-$day';
    if(sp.getString('car_queren_time_h') == null || sp.getString('car_queren_time_h') != time){
      sp.setBool('car_queren_h', false);
    }
  }
  // Connectivity connectivity = Connectivity();
  // late StreamSubscription<ConnectivityResult> subscription;
  //
  // void startListening() {
  //   subscription = connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
  //     if (result == ConnectivityResult.none) {
  //       // 处理网络中断的逻辑
  //       MyToastUtils.showToastCenter('网络中断，游戏暂时退出!');
  //       Navigator.pop(context);
  //     } else {
  //       // 处理网络重连的逻辑
  //
  //     }
  //   });
  // }

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
    _timer4?.cancel();
    listen.cancel();
    listenZDY.cancel();
    // subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          //这里可以响应物理返回键
          /// 如果是全屏就切换竖屏
          AutoOrientation.portraitAutoMode();
          Navigator.pop(context);
          return false;
        },
        child:Column(
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
                  SizedBox(
                    height: 100,
                    child: Row(
                      children: [
                        // 左侧按键
                        SizedBox(
                          height: 100,
                          child: Column(
                            children: [
                              WidgetUtils.commonSizedBox(10, 0),
                              isShow ?  GestureDetector(
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
                              ) : const Text(''),
                              WidgetUtils.commonSizedBox(2.5, 0),
                              GestureDetector(
                                onTap: (() {
                                  if (MyUtils.checkClick()) {
                                    MyUtils.goTransparentPageCom(
                                        context, const CarGuiZeHPage());
                                  }
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
                                      '游戏规则',
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize: 11)),
                                ),
                              ),
                              WidgetUtils.commonSizedBox(2.5, 0),
                              GestureDetector(
                                onTap: ((){
                                  if(sp.getString('car_audio') == null || sp.getString('car_audio').toString() == '开启'){
                                    sp.setString('car_audio', '关闭');
                                  }else{
                                    sp.setString('car_audio', '开启');
                                  }
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
                                      sp.getString('car_audio') == null || sp.getString('car_audio').toString() == '开启' ? '关闭音效' : '开启音效',
                                      StyleUtils.getCommonTextStyle(
                                          color: sp.getString('car_audio') == null || sp.getString('car_audio').toString() == '开启' ? Colors.white :  MyColors.peopleYellow,
                                          fontSize: 11)),
                                ),
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
                        Stack(
                          children: [
                            Column(
                              children: [
                                WidgetUtils.commonSizedBox(10, 0),
                                GestureDetector(
                                  onTap: ((){
                                    // MyUtils.goTransparentPageCom(context, DouPayPage(shuliang: sp.getString('car_jinbi2').toString(),));
                                  }),
                                  child: Container(
                                    height: 20,
                                    margin: const EdgeInsets.only(right: 5),
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5, top: 1, bottom: 1),
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: MyColors.zpJLHX,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                                    ),
                                    child: Row(
                                      children: [
                                        WidgetUtils.commonSizedBox(0, 5),
                                        WidgetUtils.showImages(
                                            'assets/images/car_mogubi.png',
                                            12,
                                            12),
                                        WidgetUtils.commonSizedBox(
                                            0, 2),
                                        WidgetUtils.onlyTextCenter(
                                            sp.getString('car_mogu2').toString(),
                                            StyleUtils.getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600)),
                                        WidgetUtils.commonSizedBox(
                                            0, 5),
                                        Opacity(
                                          opacity: 0.8,
                                          child: Container(
                                            height: 10,
                                            width: 1,
                                            color: MyColors.home_hx,
                                          ),
                                        ),
                                        WidgetUtils.commonSizedBox(
                                            0, 5),
                                        WidgetUtils.showImages(
                                            'assets/images/mine_wallet_dd.png',
                                            12,
                                            12),
                                        WidgetUtils.commonSizedBox(
                                            0, 5),
                                        WidgetUtils.onlyTextCenter(
                                            sp.getString('car_jinbi2').toString(),
                                            StyleUtils.getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600)),
                                        // WidgetUtils.commonSizedBox(0, 2),
                                        // const Image(
                                        //   image: AssetImage(
                                        //       'assets/images/wallet_more.png'),
                                        //   width: 8,
                                        //   height: 8,
                                        // ),
                                        WidgetUtils.commonSizedBox(
                                            0, 5),
                                        // 钻石处先隐藏
                                        // Opacity(
                                        //   opacity: 0.8,
                                        //   child: Container(
                                        //     height: 10,
                                        //     width: 1,
                                        //     color: MyColors.home_hx,
                                        //   ),
                                        // ),
                                        // WidgetUtils.commonSizedBox(
                                        //     0, 5),
                                        // WidgetUtils.showImages(
                                        //     'assets/images/mine_wallet_zz.png',
                                        //     12,
                                        //     12),
                                        // WidgetUtils.commonSizedBox(
                                        //     0, 5),
                                        // WidgetUtils.onlyTextCenter(
                                        //     sp.getString('car_zuanshi2').toString(),
                                        //     StyleUtils.getCommonTextStyle(
                                        //         color: Colors.white,
                                        //         fontSize: 10,
                                        //         fontWeight: FontWeight.w600)),
                                        // WidgetUtils.commonSizedBox(
                                        //     0, 5),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              right: 10.h,
                              top: 100.h,
                              child: GestureDetector(
                                  onTap: (() {
                                    MyUtils.goTransparentPageCom(
                                        context, const CarHShopPage());
                                  }),
                                  child: WidgetUtils.showImages(
                                      'assets/images/car_shop.png',
                                      50,
                                      50)
                              ),
                            ),
                          ],
                        ),
                        WidgetUtils.commonSizedBox(0, 5),
                      ],
                    ),
                  )
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
                              SixInfo(1),
                              WidgetUtils.commonSizedBox(0, 2.5),
                              SixInfo(2),
                              WidgetUtils.commonSizedBox(0, 2.5),
                              SixInfo(3),
                              WidgetUtils.commonSizedBox(0, 2.5),
                              SixInfo(4),
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
                    //12倍
                    Column(
                      children: [
                        WidgetUtils.commonSizedBox(5, 0),
                        Expanded(child: GestureDetector(
                          onTap: (() {
                            if (isShow) {
                              if (sp.getBool('car_queren_h') == false ||
                                  sp.getBool('car_queren_h') == null) {
                                MyUtils.goTransparentPageCom(context, QueRenHPage(title: '赛车下注横屏', jine: xiazhujine, isDuiHuan: false, index: '12',));
                                return;
                              }
                              doPostCarBet('12');
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
                                  listJL[11].toString(),
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
                          child: OptionGridView(
                            itemCount: listZDY.length,
                            rowCount: 4,
                            mainAxisSpacing: 20.h,
                            // 上下间距
                            crossAxisSpacing: 20.h,
                            //左右间距
                            itemBuilder: _initlistdata,
                          ),
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
      ),
    );
  }


  /// 赛车押注
  Future<void> doPostCarBet(String benSN) async {
    setState(() {
      chooseWho = benSN;
    });
    Map<String, dynamic> params = <String, dynamic>{
      'bet_sn': benSN,
      'bet_amount': xiazhujine.toString()
    };
    try {
      carYZBean bean = await DataUtils.postCarBet(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            listJL[int.parse(benSN) - 1] =
                listJL[int.parse(benSN) - 1] + xiazhujine;
            if(sp.getString('car_audio') == null || sp.getString('car_audio').toString() == '开启') {
              playSound2();
            }
            if (listA[int.parse(benSN) - 1] == false) {
              setState(() {
                listA[int.parse(benSN) - 1] = true;
              });
            }
            listA1[int.parse(benSN) - 1] = true;
            //点击播放点击特效
            Future.delayed(
                const Duration(
                  milliseconds: 400,
                ), () {
              listA1[int.parse(benSN) - 1] = false;
            });

            // 更新余额
            if (bean.data!.curType == 1) {
              if (double.parse(jinbi) > 10000) {
                jinbi = sp.getString('car_jinbi').toString();
                // 减去花费的金豆
                jinbi =
                '${(double.parse(jinbi) - int.parse(xiazhujine.toString()))}';
                if(double.parse(jinbi) > 10000){
                  //保留2位小数
                  jinbi2 = '${(double.parse(jinbi) / 10000)}';
                  jinbi2 = '${jinbi2.substring(0,jinbi2.lastIndexOf('.')+3)}w';
                }else{
                  jinbi2 = jinbi;
                }
              } else {
                jinbi = sp.getString('car_jinbi').toString();
                jinbi = (double.parse(jinbi) - int.parse(xiazhujine.toString()))
                    .toString();
                jinbi2 = jinbi;
              }
              sp.setString('car_jinbi', jinbi);
              sp.setString('car_jinbi2', jinbi2);
            } else if (bean.data!.curType == 2) {
              if (double.parse(zuanshi) > 10000) {
                zuanshi = sp.getString('car_zuanshi').toString();
                // 减去花费的金豆
                zuanshi =
                '${(double.parse(zuanshi) - int.parse(xiazhujine.toString()))}';
                if(double.parse(zuanshi) > 10000){
                  //保留2位小数
                  zuanshi2 = '${(double.parse(zuanshi) / 10000)}';
                  zuanshi2 = '${zuanshi2.substring(0,zuanshi2.lastIndexOf('.')+3)}w';
                }else{
                  zuanshi2 = zuanshi;
                }
              } else {
                zuanshi = sp.getString('car_zuanshi').toString();
                zuanshi =
                    (double.parse(zuanshi) - int.parse(xiazhujine.toString()))
                        .toString();
                zuanshi2 = zuanshi;
              }

              sp.setString('car_zuanshi', zuanshi);
              sp.setString('car_zuanshi2', zuanshi2);
            } else {
              if (double.parse(mogubi) > 10000) {
                mogubi = sp.getString('car_mogu').toString();
                // 减去花费的金豆
                mogubi =
                '${(double.parse(mogubi) - int.parse(xiazhujine.toString()))}';
                if(double.parse(mogubi) > 10000){
                  //保留2位小数
                  mogubi2 = '${(double.parse(mogubi) / 10000)}';
                  mogubi2 = '${mogubi2.substring(0,mogubi2.lastIndexOf('.')+3)}w';
                }else{
                  mogubi2 = mogubi;
                }
              } else {
                mogubi = sp.getString('car_mogu').toString();
                mogubi =
                    (double.parse(mogubi) - int.parse(xiazhujine.toString()))
                        .toString();
                mogubi2 = mogubi;
              }
              sp.setString('car_mogu', mogubi);
              sp.setString('car_mogu2', mogubi2);
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
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 赛车倒计时
  Future<void> doPostGetCarTimer() async {
    try {
      carTimerBean bean = await DataUtils.postGetCarTimer();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            //
            if (bean.data! >= 20) {
              playTime = playTime - bean.data!;
              isShow = false;
              isStarGame = true;
              sum = 20;
              starTimerPlay();
            } else {
              sum = 20 - bean.data!;
              //开启倒计时
              starTimerDJS();
              isShow = true;
              isStarGame = false;
            }
          });
          break;
        case MyHttpConfig.errorloginCode:
        // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
      }
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 赛车中奖赛道
  Future<void> doPostGetWinTrack() async {
    try {
      carTimerBean bean = await DataUtils.postGetWinTrack();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (bean.data! == 7) {
              //更新
              luck = 0;
            } else if (bean.data! == 6) {
              //更新
              luck = 1;
            } else if (bean.data! == 5) {
              //更新
              luck = 2;
            } else if (bean.data! == 4) {
              //更新
              luck = 3;
            } else if (bean.data! == 3) {
              //更新
              luck = 4;
            } else if (bean.data! == 2) {
              //更新
              luck = 5;
            } else if (bean.data! == 1) {
              //更新
              luck = 6;
            }
          });
          break;
        case MyHttpConfig.errorloginCode:
        // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom("数据异常,游戏即将关闭，稍后请在开奖记录查看！");
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
      }
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  // 金币 钻石 蘑菇币
  String jinbi = '', zuanshi = '', mogubi = '', jinbi2 = '', zuanshi2 = '', mogubi2 = '';
  /// 钱包余额
  Future<void> doPostBalance() async {
    try {
      balanceBean bean = await DataUtils.postBalance();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            jinbi = bean.data!.goldBean!;
            if (double.parse(bean.data!.goldBean!) > 10000) {
              jinbi2 = '${(double.parse(bean.data!.goldBean!) / 10000)}';
              jinbi2 = '${jinbi2.substring(0,jinbi2.lastIndexOf('.')+3)}w';
            } else {
              jinbi2 = bean.data!.goldBean!;
            }
            zuanshi = bean.data!.diamond!;
            if (double.parse(bean.data!.diamond!) > 10000) {
              zuanshi2 = '${(double.parse(bean.data!.diamond!) / 10000)}';
              zuanshi2 = '${zuanshi2.substring(0,zuanshi2.lastIndexOf('.')+3)}w';
            } else {
              zuanshi2 = bean.data!.diamond!;
            }
            mogubi = bean.data!.mushroom!;
            if (double.parse(bean.data!.mushroom!) > 10000) {
              mogubi2 = '${(double.parse(bean.data!.mushroom!) / 10000)}';
              mogubi2 = '${mogubi2.substring(0,mogubi2.lastIndexOf('.')+3)}w';
            } else {
              mogubi2 = bean.data!.mushroom!;
            }
            sp.setString('car_jinbi', jinbi);
            sp.setString('car_zuanshi', zuanshi);
            sp.setString('car_mogu', mogubi);
            sp.setString('car_jinbi2', jinbi2);
            sp.setString('car_zuanshi2', zuanshi2);
            sp.setString('car_mogu2', mogubi2);
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
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
