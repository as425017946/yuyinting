import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:just_audio/just_audio.dart';
import 'package:soundpool/soundpool.dart';
import 'package:svgaplayer_flutter/parser.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import 'package:yuyinting/widget/queren_page.dart';
import '../../bean/balanceBean.dart';
import '../../bean/carTimerBean.dart';
import '../../bean/carYZBean.dart';
import '../../bean/luckUserBean.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/style_utils.dart';
import '../mine/qianbao/dou_pay_page.dart';
import 'car/car_guize_page.dart';
import 'car/car_shop_page.dart';
import 'car/lishi_page.dart';
import 'car/zhongjian_page.dart';

/// 赛车游戏
class Carpage extends StatefulWidget {
  const Carpage({super.key});

  @override
  State<Carpage> createState() => _CarpageState();
}

class _CarpageState extends State<Carpage> with TickerProviderStateMixin {
  // 下注区是否被选中
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
          if (sp.getBool('car_queren') == false ||
              sp.getBool('car_queren') == null) {
            MyUtils.goTransparentPageCom(
                context,
                QueRenPage(
                  title: '赛车下注',
                  jine: xiazhujine,
                  isDuiHuan: false,
                  index: i.toString(),
                ));
            return;
          }
          if (xiazhujine > double.parse(sp.getString('car_mogu').toString())) {
            if (xiazhujine >
                double.parse(sp.getString('car_jinbi').toString())) {
              MyToastUtils.showToastBottom('钱包余额不足');
              return;
            }
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
              70.h,
              double.infinity),
          i == 3
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
                listJL[i - 1].toString(),
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
          if (sp.getBool('car_queren') == false ||
              sp.getBool('car_queren') == null) {
            MyUtils.goTransparentPageCom(
                context,
                QueRenPage(
                    title: '赛车下注',
                    jine: xiazhujine,
                    isDuiHuan: false,
                    index: (6 + one).toString()));
            return;
          }
          if (xiazhujine > double.parse(sp.getString('car_mogu').toString())) {
            if (xiazhujine >
                double.parse(sp.getString('car_jinbi').toString())) {
              MyToastUtils.showToastBottom('钱包余额不足');
              return;
            }
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
                one == 1
                    ? listJL[6].toString()
                    : one == 2
                        ? listJL[7].toString()
                        : listJL[8].toString(),
                StyleUtils.getCommonTextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600)),
          ),
          SizedBox(
            height: 70.h,
            width: double.infinity,
            child: listA1[6 + one]
                ? const SVGASimpleImage(
                    assetsName: 'assets/svga/gp/star.svga',
                  )
                : const Text(''),
          ),
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
          if (sp.getBool('car_queren') == false ||
              sp.getBool('car_queren') == null) {
            MyUtils.goTransparentPageCom(
                context,
                QueRenPage(
                    title: '赛车下注',
                    jine: xiazhujine,
                    isDuiHuan: false,
                    index: (9 + one).toString()));
            return;
          }
          if (xiazhujine > double.parse(sp.getString('car_mogu').toString())) {
            if (xiazhujine >
                double.parse(sp.getString('car_jinbi').toString())) {
              MyToastUtils.showToastBottom('钱包余额不足');
              return;
            }
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
                one == 1 ? listJL[9].toString() : listJL[10].toString(),
                StyleUtils.getCommonTextStyle(
                    color: Colors.white,
                    fontSize: 17.sp,
                    fontWeight: FontWeight.w600)),
          ),
          SizedBox(
            height: 70.h,
            width: double.infinity,
            child: listA1[8 + one]
                ? const SVGASimpleImage(
                    assetsName: 'assets/svga/gp/star.svga',
                  )
                : const Text(''),
          ),
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
                            fontSize: isDevices == 'ios' ? 26.sp : 26.sp))),
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
    // soundpool.setVolume(volume: 0.2);
    await soundpool.play(soundId);
  }

  late final AudioPlayer _player2, _player3, _player4;
  Future<void> playSound2() async {
    try {
      // 加载并播放音频文件
      await _player2.setAsset('assets/audio/car_xiazhu.MP3');
      await _player2.play();
    } catch (e) {
      // 处理加载或播放音频时出现的错误
      print('音频播放错误: $e');
    } finally {
      // // 在不再需要播放器时释放资源
      // await _player2.dispose();
    }
  }

  Future<void> playSound3() async {
    try {
      // 加载并播放音频文件
      await _player3.setAsset('assets/audio/car_321.MP3');
      await _player3.play();
      // playSound4();
    } catch (e) {
      // 处理加载或播放音频时出现的错误
      print('音频播放错误: $e');
    } finally {
      // 在不再需要播放器时释放资源
      // await player3.dispose();
    }
  }

  Future<void> playSound4() async {
    try {
      // 加载并播放音频文件
      await _player4.setAsset('assets/audio/car_bg.MP3');
      await _player4.play();
    } catch (e) {
      // 处理加载或播放音频时出现的错误
      print('音频播放错误: $e');
    } finally {}
  }

  List<String> imagesa = [
    "assets/images/car_qidian.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_qidian.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
    "assets/images/car_bg.png",
  ];

  //赛车使用
  late AnimationController controller2;
  late Animation<Offset> animation2;

  //Go的动画
  late AnimationController controllerGO;
  late Animation<double> animationGO;

  late PageController _controller;
  Timer? _timer, _timer2, _timer3, _timer4;
  int _currentPage = 0;

  int luck = 0, sum = 20, sumBG = 0, playTime = 46;

  // 是否可以点击下注
  bool isShow = true;

  // 游戏是否开始了
  bool isStarGame = false;

  var a,
      a1,
      a2,
      a3,
      a4,
      a5,
      a6,
      b,
      b1,
      b2,
      b3,
      b4,
      b5,
      b6,
      c,
      c1,
      c2,
      c3,
      c4,
      c5,
      c6,
      d,
      d1,
      d2,
      d3,
      d4,
      d5,
      d6,
      e,
      e1,
      e2,
      e3,
      e4,
      e5,
      e6;
  var j, j1, j2, j3, j4, j5, j6;

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

  void suijishu() {
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

    j = Random().nextDouble() + Random().nextDouble();
    j1 = Random().nextDouble() + Random().nextDouble();
    j2 = Random().nextDouble() + Random().nextDouble();
    j3 = Random().nextDouble() + Random().nextDouble();
    j4 = Random().nextDouble() + Random().nextDouble();
    j5 = Random().nextDouble() + Random().nextDouble();
    j6 = Random().nextDouble() + Random().nextDouble();
  }

  List<int> listS = [];

  // 取3个随机数用于显示小车加速
  void carSJS() {
    //数组清空
    listS.clear();
    //小车状态全部变成false状态
    for (int i = 0; i < 7; i++) {
      setState(() {
        listCar[i] = false;
      });
    }
    Random random = Random();
    while (listS.length < 3) {
      int numbers = random.nextInt(7);
      listS.add(numbers);
      for (int i = 0; i < 7; i++) {
        if (numbers == i) {
          setState(() {
            listCar[i] = true;
          });
        }
      }
    }
  }

  // 赛车2秒一换
  void carTimer() {
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
          if (sumBG == 19) {
            MyUtils.goTransparentPageCom(
                context,
                ZhongJiangPage(
                  type: luck,
                  bean: beanLuck,
                ));
          }
          if (sumBG == 15) {
            doPostCarLuckyUser();
          }
        });
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
      setState(() {
        sum--;
      });
      LogE('当前秒数 $sum');
      if (sum == 0) {
        if (sp.getString('car_audio') == null ||
            sp.getString('car_audio').toString() == '开启') {
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
                  begin: Offset(e3, 0),
                  end: Offset(
                      luck == i ? 2.3 : (2 - double.parse(e3.toString())), 0)),
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
                  begin: Offset(e4, 0),
                  end: Offset(
                      luck == i ? 2.3 : (2 - double.parse(e4.toString())), 0)),
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
                  begin: Offset(e5, 0),
                  end: Offset(
                      luck == i ? 2.3 : (2 - double.parse(e5.toString())), 0)),
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
                  begin: Offset(e6, 0),
                  end: Offset(
                      luck == i ? 2.3 : (2 - double.parse(e6.toString())), 0)),
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
    // 清空接受的im下注信息
    listZDY.clear();
    Future.delayed(const Duration(seconds: 1), () {
      // 请求中奖赛道
      doPostGetWinTrack();
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isPlay = false;
        isGo = true;
        sum = 20;
        sumBG = 0;
        startTimer();
        controllerGO.forward();
        Future.delayed(const Duration(seconds: 1), () {
          for (int i = 0; i < 7; i++) {
            if (mounted) {
              setState(() {
                listCar[i] = true;
              });
            }
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
    // 监听动画_animListenerStar
    animationController?.addListener(_animListenerStar);
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
  // 设备是安卓还是ios
  String isDevices = 'android';
  @override
  void initState() {
    if (Platform.isAndroid) {
      setState(() {
        isDevices = 'android';
      });
    } else if (Platform.isIOS) {
      setState(() {
        isDevices = 'ios';
      });
    }
    super.initState();
    _player2 = AudioPlayer();
    _player3 = AudioPlayer();
    _player4 = AudioPlayer();
    // // 获取赛车倒计时
    doPostGetCarTimer();
    // 钱包余额
    doPostBalance();
    // 二次确认弹窗点击确认，开始下注
    listen = eventBus.on<QuerenBack>().listen((event) {
      if (event.title == '竖屏赛车') {
        if (xiazhujine > double.parse(sp.getString('car_mogu').toString())) {
          if (xiazhujine > double.parse(sp.getString('car_jinbi').toString())) {
            MyToastUtils.showToastBottom('钱包余额不足');
            return;
          }
        }
        doPostCarBet(event.index);
      }
    });
    suijishu();
    animationController = SVGAAnimationController(vsync: this);
    // 背景图滚动
    _controller = PageController(
      initialPage: imagesa.length - 1,
    )..addListener(_onPageChanged);
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _controller.jumpToPage(0);
    });
    //赛车动画使用
    controller2 =
        AnimationController(duration: const Duration(seconds: 20), vsync: this);
    // 监听动画
    controller2.addListener(_animListenerCar);

    // GO的动画
    controllerGO = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this)
      ..addStatusListener((status) {});
    animationGO = Tween<double>(begin: 0, end: 1).animate(controllerGO);
    controllerGO.addListener(_animListenerGo);

    // 接受下注的im信息
    listenZDY = eventBus.on<JoinRoomYBack>().listen((event) {
      if (event.type == '赛车押注') {
        if (event.map!['avatar'].toString().isNotEmpty && isShow) {
          if (listZDY.length < 6) {
            Map<dynamic, dynamic> map = {};
            map['avatar'] = event.map!['avatar'];
            map['amount'] = event.map!['amount'];
            setState(() {
              listZDY.add(map);
            });
          } else {
            for (int i = 0; i < 6; i++) {
              if (i == 5) {
                Map<dynamic, dynamic> map = {};
                map['avatar'] = event.map!['avatar'];
                map['amount'] = event.map!['amount'];
                setState(() {
                  listZDY[5] = map;
                });
              } else {
                Map<dynamic, dynamic> map = {};
                map['avatar'] = listZDY[i + 1]['avatar'];
                map['amount'] = listZDY[i + 1]['amount'];
                setState(() {
                  listZDY[i] = map;
                });
              }
            }
          }
          LogE('**********${listZDY.length}');
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
    if (sp.getString('car_queren_time') == null ||
        sp.getString('car_queren_time') != time) {
      sp.setBool('car_queren', false);
    }
  }

  //网络动画
  void _animListenerCar() {
    //TODO

    if (controller2.isCompleted) {
      LogE('当前时间**  ${DateTime.now()}');
      suijishu();
      controller2.reset();
      //背景暂停
      pauseTimer();
      _controller.jumpToPage(0);
      //小车状态全部变成false状态
      for (int i = 0; i < 7; i++) {
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
      // controllerZD.reset();
      //等1秒钟打开中奖页面
      // MyUtils.goTransparentPageCom(context, const ZhongJiangPage());
      // controller2.removeListener(_animListenerCar);
    }
  }

  //网络动画
  void _animListenerGo() {
    //TODO
    if (controllerGO.isCompleted) {
      setState(() {
        isGo = false;
      });
    }
  }

  //网络动画
  void _animListenerStar() {
    //TODO
    if (animationController!.currentFrame >= animationController!.frames - 1) {
      // 动画播放到最后一帧时停止播放
      animationController?.stop();
      // animationController?.removeListener(_animListenerStar);
      if (mounted) {
        setState(() {
          isStar = false;
        });
      }
    }
  }

  // Connectivity connectivity = Connectivity();
  // late StreamSubscription<ConnectivityResult> subscription;
  //
  // void startListening() {
  //   subscription =
  //       connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
  //     if (result == ConnectivityResult.none) {
  //       // 处理网络中断的逻辑
  //       MyToastUtils.showToastCenter('网络中断，游戏暂时退出!');
  //       Navigator.pop(context);
  //     } else {
  //       // 处理网络重连的逻辑
  //     }
  //   });
  // }

  @override
  void dispose() {
    _controller.dispose();
    controller2.dispose();
    controllerGO.dispose();
    _timer?.cancel();
    _timer2?.cancel();
    _timer3?.cancel();
    _timer4?.cancel();
    listen.cancel();
    listenZDY.cancel();
    // 在页面销毁时停止音频播放并释放资源
    _player2.stop();
    _player2.dispose();
    // 在页面销毁时停止音频播放并释放资源
    _player3.stop();
    _player3.dispose();
    // 在页面销毁时停止音频播放并释放资源
    _player4.stop();
    _player4.dispose();
    // subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: WillPopScope(
        onWillPop: () async {
          if (MyUtils.checkClick()) {
            bool isBack = false;
            for (int i = 0; i < listA.length; i++) {
              if (listA[i]) {
                setState(() {
                  isBack = true;
                });
                break;
              }
            }
            if (isBack) {
              MyToastUtils.showToastBottom('请等待您本轮竞猜结果后再离开~');
              // 阻止返回操作
              return false;
            }
            return true; // 允许正常的返回操作
          } else {
            // 阻止返回操作
            return false;
          }
        },
        child: Column(
          children: [
            GestureDetector(
              onTap: (() {
                if (MyUtils.checkClick()) {
                  bool isBack = false;
                  for (int i = 0; i < listA.length; i++) {
                    if (listA[i]) {
                      setState(() {
                        isBack = true;
                      });
                      break;
                    }
                  }
                  if (isBack) {
                    MyToastUtils.showToastBottom('请等待您本轮竞猜结果后再离开~');
                    return;
                  }
                  Navigator.pop(context);
                }
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // 顶部信息
                      SizedBox(
                        height: 240.h,
                        child: Row(
                          children: [
                            // 左侧按键
                            SizedBox(
                              height: 240.h,
                              child: Column(
                                children: [
                                  WidgetUtils.commonSizedBox(20.h, 0),
                                  // isShow ? GestureDetector(
                                  //   onTap: (() {
                                  //     if (MyUtils.checkClick()) {
                                  //       MyUtils.goTransparentPageCom(
                                  //           context,
                                  //           const CarLandScapePage());
                                  //       Navigator.pop(context);
                                  //     }
                                  //   }),
                                  //   child: Container(
                                  //     height: 38.h,
                                  //     width: 100.h,
                                  //     //边框设置
                                  //     decoration: const BoxDecoration(
                                  //         image: DecorationImage(
                                  //       //背景图片修饰
                                  //       image: AssetImage(
                                  //           "assets/images/car_anniu.png"),
                                  //       fit: BoxFit.fill, //覆盖
                                  //     )),
                                  //     child: WidgetUtils.onlyTextCenter(
                                  //         '横屏模式',
                                  //         StyleUtils.getCommonTextStyle(
                                  //             color: Colors.white,
                                  //             fontSize: 22.sp)),
                                  //   ),
                                  // ) : const Text(''),
                                  // WidgetUtils.commonSizedBox(10.h, 0),
                                  GestureDetector(
                                    onTap: (() {
                                      if (MyUtils.checkClick()) {
                                        MyUtils.goTransparentPageCom(
                                            context, const CarGuiZePage());
                                      }
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
                                          '游戏规则',
                                          StyleUtils.getCommonTextStyle(
                                              color: Colors.white,
                                              fontSize: 22.sp)),
                                    ),
                                  ),
                                  WidgetUtils.commonSizedBox(10.h, 0),
                                  isStarGame == false
                                      ? GestureDetector(
                                          onTap: (() {
                                            if (MyUtils.checkClick()) {
                                              MyUtils.goTransparentPageCom(
                                                  context, const LiShiPage());
                                            }
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
                                      : WidgetUtils.commonSizedBox(0, 0),
                                  isStarGame == false
                                      ? WidgetUtils.commonSizedBox(10.h, 0)
                                      : WidgetUtils.commonSizedBox(0, 0),
                                  GestureDetector(
                                    onTap: (() {
                                      if (sp.getString('car_audio') == null ||
                                          sp
                                                  .getString('car_audio')
                                                  .toString() ==
                                              '开启') {
                                        sp.setString('car_audio', '关闭');
                                      } else {
                                        sp.setString('car_audio', '开启');
                                      }
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
                                          sp.getString('car_audio') == null ||
                                                  sp
                                                          .getString(
                                                              'car_audio')
                                                          .toString() ==
                                                      '开启'
                                              ? '关闭音效'
                                              : '开启音效',
                                          StyleUtils.getCommonTextStyle(
                                              color: sp.getString(
                                                              'car_audio') ==
                                                          null ||
                                                      sp
                                                              .getString(
                                                                  'car_audio')
                                                              .toString() ==
                                                          '开启'
                                                  ? Colors.white
                                                  : MyColors.peopleYellow,
                                              fontSize: 22.sp)),
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
                                    WidgetUtils.commonSizedBox(20.h, 0),
                                    GestureDetector(
                                      onTap: (() {
                                        MyUtils.goTransparentPageCom(
                                            context,
                                            DouPayPage(
                                              shuliang: sp
                                                  .getString('car_jinbi2')
                                                  .toString(),
                                            ));
                                      }),
                                      child: Container(
                                        height: ScreenUtil().setHeight(45),
                                        margin: EdgeInsets.only(right: 10.h),
                                        padding: const EdgeInsets.only(
                                            left: 5,
                                            right: 5,
                                            top: 1,
                                            bottom: 1),
                                        //边框设置
                                        decoration: const BoxDecoration(
                                          //背景
                                          color: MyColors.zpJLHX,
                                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(30.0)),
                                        ),
                                        child: Row(
                                          children: [
                                            WidgetUtils.commonSizedBox(0, 5),
                                            WidgetUtils.showImages(
                                                'assets/images/car_mogubi.png',
                                                25.h,
                                                25.h),
                                            WidgetUtils.commonSizedBox(0, 5.h),
                                            WidgetUtils.onlyTextCenter(
                                                sp
                                                    .getString('car_mogu2')
                                                    .toString(),
                                                StyleUtils.getCommonTextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        ScreenUtil().setSp(23),
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            WidgetUtils.commonSizedBox(0, 10.h),
                                            Opacity(
                                              opacity: 0.8,
                                              child: Container(
                                                height:
                                                    ScreenUtil().setHeight(20),
                                                width:
                                                    ScreenUtil().setHeight(1),
                                                color: MyColors.home_hx,
                                              ),
                                            ),
                                            WidgetUtils.commonSizedBox(0, 10.h),
                                            WidgetUtils.showImages(
                                                'assets/images/mine_wallet_dd.png',
                                                ScreenUtil().setHeight(26),
                                                ScreenUtil().setHeight(24)),
                                            WidgetUtils.commonSizedBox(0, 10.h),
                                            WidgetUtils.onlyTextCenter(
                                                sp
                                                    .getString('car_jinbi2')
                                                    .toString(),
                                                StyleUtils.getCommonTextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        ScreenUtil().setSp(23),
                                                    fontWeight:
                                                        FontWeight.w600)),
                                            WidgetUtils.commonSizedBox(0, 5.w),
                                            Image(
                                              image: const AssetImage(
                                                  'assets/images/wallet_more.png'),
                                              width: 15.h,
                                              height: 15.h,
                                            ),
                                            WidgetUtils.commonSizedBox(0, 10.h),
                                            // 钻石处先隐藏
                                            // Opacity(
                                            //   opacity: 0.8,
                                            //   child: Container(
                                            //     height: ScreenUtil()
                                            //         .setHeight(20),
                                            //     width:
                                            //         ScreenUtil().setHeight(1),
                                            //     color: MyColors.home_hx,
                                            //   ),
                                            // ),
                                            // WidgetUtils.commonSizedBox(
                                            //     0, 10.h),
                                            // WidgetUtils.showImages(
                                            //     'assets/images/mine_wallet_zz.png',
                                            //     ScreenUtil().setHeight(26),
                                            //     ScreenUtil().setHeight(24)),
                                            // WidgetUtils.commonSizedBox(
                                            //     0, 10.h),
                                            // WidgetUtils.onlyTextCenter(
                                            //     sp.getString('car_zuanshi2').toString(),
                                            //     StyleUtils.getCommonTextStyle(
                                            //         color: Colors.white,
                                            //         fontSize: ScreenUtil()
                                            //             .setSp(23),
                                            //         fontWeight:
                                            //             FontWeight.w600)),
                                            // WidgetUtils.commonSizedBox(
                                            //     0, 10.h),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Positioned(
                                  right: 10.h,
                                  top: 80.h,
                                  child: GestureDetector(
                                      onTap: (() {
                                        if (MyUtils.checkClick()) {
                                          MyUtils.goTransparentPageCom(
                                              context, const CarShopPage());
                                        }
                                      }),
                                      child: WidgetUtils.showImages(
                                          'assets/images/car_shop.png',
                                          100.h,
                                          100.h)),
                                ),
                              ],
                            ),
                            WidgetUtils.commonSizedBox(0, 10.h),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(140.h, 0),
                    ],
                  ),
                  LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    final left = 71.h + (constraints.maxWidth - 741.h) / 2;
                    return Padding(
                      padding: EdgeInsets.only(left: max(left, 0)),
                      child: Stack(
                        children: [
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
                                          listCar[0]
                                              ? 'assets/images/car/xiaogui+.png'
                                              : 'assets/images/car/xiaogui.png',
                                          ScreenUtil().setHeight(102),
                                          ScreenUtil().setHeight(180)),
                                      isShow == false
                                          ? Positioned(
                                              left: 73.h,
                                              top: 78.h,
                                              child: WidgetUtils.showImages(
                                                  'assets/images/z_wheel.gif',
                                                  ScreenUtil().setHeight(15),
                                                  ScreenUtil().setHeight(15)))
                                          : const Text(''),
                                      isShow == false
                                          ? Positioned(
                                              left: 130.h,
                                              top: 78.h,
                                              child: WidgetUtils.showImages(
                                                  'assets/images/z_wheel.gif',
                                                  ScreenUtil().setHeight(15),
                                                  ScreenUtil().setHeight(15)))
                                          : const Text(''),
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
                                          listCar[1]
                                              ? 'assets/images/car/guigui+.png'
                                              : 'assets/images/car/guigui.png',
                                          ScreenUtil().setHeight(102),
                                          ScreenUtil().setHeight(180)),
                                      isShow == false
                                          ? Positioned(
                                              left: 66.h,
                                              top: 75.h,
                                              child: WidgetUtils.showImages(
                                                  'assets/images/z_wheel.gif',
                                                  ScreenUtil().setHeight(18),
                                                  ScreenUtil().setHeight(18)))
                                          : const Text(''),
                                      isShow == false
                                          ? Positioned(
                                              left: 120.h,
                                              top: 82.h,
                                              child: WidgetUtils.showImages(
                                                  'assets/images/z_wheel.gif',
                                                  ScreenUtil().setHeight(15),
                                                  ScreenUtil().setHeight(15)))
                                          : const Text(''),
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
                                          listCar[2]
                                              ? 'assets/images/car/lan+.png'
                                              : 'assets/images/car/lan.png',
                                          ScreenUtil().setHeight(102),
                                          ScreenUtil().setHeight(180)),
                                      isShow == false
                                          ? Positioned(
                                              left: 58.h,
                                              top: 72.h,
                                              child: WidgetUtils.showImages(
                                                  'assets/images/z_wheel.gif',
                                                  ScreenUtil().setHeight(20),
                                                  ScreenUtil().setHeight(20)))
                                          : const Text(''),
                                      isShow == false
                                          ? Positioned(
                                              left: 112.h,
                                              top: 72.h,
                                              child: WidgetUtils.showImages(
                                                  'assets/images/z_wheel.gif',
                                                  ScreenUtil().setHeight(22),
                                                  ScreenUtil().setHeight(22)))
                                          : const Text(''),
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
                                          listCar[3]
                                              ? 'assets/images/car/hou+.png'
                                              : 'assets/images/car/hou.png',
                                          ScreenUtil().setHeight(102),
                                          ScreenUtil().setHeight(180)),
                                      isShow == false
                                          ? Positioned(
                                              left: 54.h,
                                              top: 74.h,
                                              child: WidgetUtils.showImages(
                                                  'assets/images/z_wheel.gif',
                                                  ScreenUtil().setHeight(15),
                                                  ScreenUtil().setHeight(15)))
                                          : const Text(''),
                                      isShow == false
                                          ? Positioned(
                                              left: 128.h,
                                              top: 80.h,
                                              child: WidgetUtils.showImages(
                                                  'assets/images/z_wheel.gif',
                                                  ScreenUtil().setHeight(13),
                                                  ScreenUtil().setHeight(13)))
                                          : const Text(''),
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
                                          listCar[4]
                                              ? 'assets/images/car/fen+.png'
                                              : 'assets/images/car/fen.png',
                                          ScreenUtil().setHeight(102),
                                          ScreenUtil().setHeight(180)),
                                      isShow == false
                                          ? Positioned(
                                              left: 58.h,
                                              top: 75.h,
                                              child: WidgetUtils.showImages(
                                                  'assets/images/z_wheel.gif',
                                                  ScreenUtil().setHeight(18),
                                                  ScreenUtil().setHeight(18)))
                                          : const Text(''),
                                      isShow == false
                                          ? Positioned(
                                              left: 117.h,
                                              top: 78.h,
                                              child: WidgetUtils.showImages(
                                                  'assets/images/z_wheel.gif',
                                                  ScreenUtil().setHeight(18),
                                                  ScreenUtil().setHeight(18)))
                                          : const Text(''),
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
                                          listCar[5]
                                              ? 'assets/images/car/lv+.png'
                                              : 'assets/images/car/lv.png',
                                          ScreenUtil().setHeight(102),
                                          ScreenUtil().setHeight(180)),
                                      isShow == false
                                          ? Positioned(
                                              left: 60.h,
                                              top: 72.h,
                                              child: WidgetUtils.showImages(
                                                  'assets/images/z_wheel.gif',
                                                  ScreenUtil().setHeight(20),
                                                  ScreenUtil().setHeight(20)))
                                          : const Text(''),
                                      isShow == false
                                          ? Positioned(
                                              left: 114.h,
                                              top: 78.h,
                                              child: WidgetUtils.showImages(
                                                  'assets/images/z_wheel.gif',
                                                  ScreenUtil().setHeight(15),
                                                  ScreenUtil().setHeight(15)))
                                          : const Text(''),
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
                                          listCar[6]
                                              ? 'assets/images/car/maliao+.png'
                                              : 'assets/images/car/maliao.png',
                                          ScreenUtil().setHeight(102),
                                          ScreenUtil().setHeight(180)),
                                      isShow == false
                                          ? Positioned(
                                              left: 58.h,
                                              top: 67.h,
                                              child: WidgetUtils.showImages(
                                                  'assets/images/z_wheel.gif',
                                                  ScreenUtil().setHeight(22),
                                                  ScreenUtil().setHeight(22)))
                                          : const Text(''),
                                      isShow == false
                                          ? Positioned(
                                              left: 112.h,
                                              top: 75.h,
                                              child: WidgetUtils.showImages(
                                                  'assets/images/z_wheel.gif',
                                                  ScreenUtil().setHeight(18),
                                                  ScreenUtil().setHeight(18)))
                                          : const Text(''),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  // 倒计时闹钟

                  isShow
                      ? /*Positioned(
                          top: 280.h,
                          left: 215.h,
                          child: Stack(
                            children: [
                              WidgetUtils.showImages(
                                  'assets/images/car_jingcai.png',
                                  180.h,
                                  180.h),
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
                        )*/
                      Center(
                          child: Stack(
                            children: [
                              WidgetUtils.showImages(
                                  'assets/images/car_jingcai.png',
                                  180.h,
                                  180.h),
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
                      ? /*Positioned(
                          top: 50.h,
                          left: 0.h,
                          height: ScreenUtil().setHeight(600),
                          width: ScreenUtil().setHeight(600),
                          child: const SVGASimpleImage(
                            assetsName: 'assets/svga/gp/djs.svga',
                          ),
                        )*/
                      Center(
                          child: SizedBox(
                            height: ScreenUtil().setHeight(600),
                            width: ScreenUtil().setHeight(600),
                            child: const SVGASimpleImage(
                              assetsName: 'assets/svga/gp/djs.svga',
                            ),
                          ),
                        )
                      : const Text(''),
                  isGo
                      ? /*Positioned(
                          top: 230.h,
                          left: 180.h,
                          child: ScaleTransition(
                            scale: animationGO,
                            child: WidgetUtils.showImages(
                                'assets/images/car_go.png', 300.h, 260.h),
                          ),
                        )*/
                      Center(
                          child: ScaleTransition(
                            scale: animationGO,
                            child: WidgetUtils.showImages(
                                'assets/images/car_go.png', 300.h, 260.h),
                          ),
                        )
                      : const Text(''),
                  // 中途进来
                  isStarGame
                      ? Center(
                          child: SizedBox(
                            height: 450.h,
                            width: 350.h,
                            child: Stack(
                              children: [
                                WidgetUtils.showImages(
                                    'assets/images/car/car_star.png',
                                    450.h,
                                    350.h),
                                Container(
                                  height: 120.h,
                                  width: 350.h,
                                  margin: EdgeInsets.only(top: 320.h),
                                  child: WidgetUtils.onlyTextCenter(
                                      '本场竞赛已开始，请耐心等待~',
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.black87,
                                          fontSize: 28.sp,
                                          fontWeight: FontWeight.w600)),
                                )
                              ],
                            ),
                          ),
                        )
                      : const Text(''),
                  // 及时接受im下注信息
                  Container(
                    height: 100.h,
                    margin: EdgeInsets.only(top: 170.h),
                    width: double.infinity,
                    alignment: Alignment.center,
                    child: Row(
                      children: [
                        for (int i = 0; i < listZDY.length; i++)
                          Container(
                            height: 90.h,
                            width: 90.h,
                            margin: EdgeInsets.only(left: 10.h),
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                WidgetUtils.CircleHeadImage(
                                    90.h,
                                    90.h,
                                    listZDY[i]['avatar'].toString().isEmpty
                                        ? ''
                                        : listZDY[i]['avatar'].toString()),
                                Container(
                                  height: 25.h,
                                  width: 90.h,
                                  //边框设置
                                  decoration: const BoxDecoration(
                                      image: DecorationImage(
                                    //背景图片修饰
                                    image: AssetImage(
                                        "assets/images/car_btn2.png"),
                                    fit: BoxFit.fill, //覆盖
                                  )),
                                  child: WidgetUtils.onlyTextCenter(
                                      listZDY[i]['amount'].toString(),
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize: 22.sp)),
                                ),
                              ],
                            ),
                          )
                      ],
                    ),
                  )
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
                      SixInfo(1),
                      WidgetUtils.commonSizedBox(0, 5.h),
                      SixInfo(2),
                      WidgetUtils.commonSizedBox(0, 5.h),
                      SixInfo(3),
                      WidgetUtils.commonSizedBox(0, 5.h),
                      SixInfo(4),
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
                  //12倍
                  Row(
                    children: [
                      WidgetUtils.showImagesFill(
                          'assets/images/car_b8.png', 73.h, 69.h),
                      Expanded(
                          child: GestureDetector(
                        onTap: (() {
                          if (xiazhujine >
                              double.parse(
                                  sp.getString('car_mogu').toString())) {
                            if (xiazhujine >
                                double.parse(
                                    sp.getString('car_jinbi').toString())) {
                              MyToastUtils.showToastBottom('钱包余额不足');
                              return;
                            }
                          }
                          if (isShow) {
                            if (sp.getBool('car_queren') == false ||
                                sp.getBool('car_queren') == null) {
                              MyUtils.goTransparentPageCom(
                                  context,
                                  QueRenPage(
                                      title: '赛车下注',
                                      jine: xiazhujine,
                                      isDuiHuan: false,
                                      index: '12'));
                              return;
                            }
                            doPostCarBet('12');
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
                                  listJL[11].toString(),
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: 17.sp,
                                      fontWeight: FontWeight.w600)),
                            ),
                            SizedBox(
                              height: 70.h,
                              width: double.infinity,
                              child: listA1[11]
                                  ? const SVGASimpleImage(
                                      assetsName: 'assets/svga/gp/star.svga',
                                    )
                                  : const Text(''),
                            ),
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
      ),
    );
  }

  /// 赛车押注
  Future<void> doPostCarBet(String benSN) async {
    final betAmount = xiazhujine.toInt();
    Map<String, dynamic> params = <String, dynamic>{
      'bet_sn': benSN,
      'bet_amount': betAmount.toString()
    };
    try {
      carYZBean bean = await DataUtils.postCarBet(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          // setState(() {
          //   listJL[int.parse(benSN) - 1] =
          //       listJL[int.parse(benSN) - 1] + xiazhujine;
          //   if (sp.getString('car_audio') == null ||
          //       sp.getString('car_audio').toString() == '开启') {
          //     playSound2();
          //   }
          //   if (listA[int.parse(benSN) - 1] == false) {
          //     setState(() {
          //       listA[int.parse(benSN) - 1] = true;
          //     });
          //   }
          //   listA1[int.parse(benSN) - 1] = true;
          //   //点击播放点击特效
          //   Future.delayed(
          //       const Duration(
          //         milliseconds: 400,
          //       ), () {
          //     listA1[int.parse(benSN) - 1] = false;
          //   });
          //   // 更新余额
          //   LogE('更新余额 == ${bean.data!.curType == 1}');
          //   LogE('更新余额 == ${bean.data!.curType == 2}');
          //   LogE('更新余额 == ${bean.data!.curType == 3}');
          //   if (bean.data!.curType == 1) {
          //     if (double.parse(jinbi) > 10000) {
          //       jinbi = sp.getString('car_jinbi').toString();
          //       // 减去花费的金豆
          //       jinbi =
          //           '${(double.parse(jinbi) - int.parse(xiazhujine.toString()))}';
          //       if(double.parse(jinbi) > 10000){
          //         //保留2位小数
          //         jinbi2 = (double.parse(jinbi) / 10000).toString();
          //         if(jinbi2.split('.')[1].length >=2){
          //           jinbi2 = '${jinbi2.split('.')[0]}.${jinbi2.split('.')[1].substring(0,2)}w';
          //         }else{
          //           jinbi2 = '${jinbi2.split('.')[0]}.${jinbi2.split('.')[1]}w';
          //         }
          //       }else{
          //         jinbi2 = jinbi;
          //       }
          //     } else {
          //       jinbi = sp.getString('car_jinbi').toString();
          //       jinbi = (double.parse(jinbi) - int.parse(xiazhujine.toString()))
          //           .toString();
          //       jinbi2 = jinbi;
          //     }
          //     sp.setString('car_jinbi', jinbi);
          //     sp.setString('car_jinbi2', jinbi2);
          //   } else if (bean.data!.curType == 2) {
          //     if (double.parse(zuanshi) > 10000) {
          //       zuanshi = sp.getString('car_zuanshi').toString();
          //       // 减去花费的金豆
          //       zuanshi =
          //           '${(double.parse(zuanshi) - int.parse(xiazhujine.toString()))}';
          //       if(double.parse(zuanshi) > 10000){
          //         //保留2位小数
          //         zuanshi2 = (double.parse(zuanshi) / 10000).toString();
          //         if(zuanshi2.split('.')[1].length >=2){
          //           zuanshi2 = '${zuanshi2.split('.')[0]}.${zuanshi2.split('.')[1].substring(0,2)}w';
          //         }else{
          //           zuanshi2 = '${zuanshi2.split('.')[0]}.${zuanshi2.split('.')[1]}w';
          //         }
          //       }else{
          //         zuanshi2 = zuanshi;
          //       }
          //     } else {
          //       zuanshi = sp.getString('car_zuanshi').toString();
          //       zuanshi =
          //           (double.parse(zuanshi) - int.parse(xiazhujine.toString()))
          //               .toString();
          //       zuanshi2 = zuanshi;
          //     }
          //
          //     sp.setString('car_zuanshi', zuanshi);
          //     sp.setString('car_zuanshi2', zuanshi2);
          //   } else {
          //     if (double.parse(mogubi) > 10000) {
          //       mogubi = sp.getString('car_mogu').toString();
          //       // 减去花费的金豆
          //       mogubi =
          //           '${(double.parse(mogubi) - int.parse(xiazhujine.toString()))}';
          //       if(double.parse(mogubi) > 10000){
          //         //保留2位小数
          //         mogubi2 = (double.parse(mogubi) / 10000).toString();
          //         if(mogubi2.split('.')[1].length >=2){
          //           mogubi2 = '${mogubi2.split('.')[0]}.${mogubi2.split('.')[1].substring(0,2)}w';
          //         }else{
          //           mogubi2 = '${mogubi2.split('.')[0]}.${mogubi2.split('.')[1]}w';
          //         }
          //       }else{
          //         mogubi2 = mogubi;
          //       }
          //     } else {
          //       mogubi = sp.getString('car_mogu').toString();
          //       mogubi =
          //           (double.parse(mogubi) - int.parse(xiazhujine.toString()))
          //               .toString();
          //       mogubi2 = mogubi;
          //     }
          //     sp.setString('car_mogu', mogubi);
          //     sp.setString('car_mogu2', mogubi2);
          //   }
          // });
          setState(() {
            LogE('更新余额 == ${int.parse(benSN) - 1}');
            listJL[int.parse(benSN) - 1] =
                listJL[int.parse(benSN) - 1] + betAmount;
            if (sp.getString('car_audio') == null ||
                sp.getString('car_audio').toString() == '开启') {
              playSound2();
            }
            if (listA[int.parse(benSN) - 1] == false) {
              listA[int.parse(benSN) - 1] = true;
              //点击播放点击特效
              Future.delayed(
                  const Duration(
                    milliseconds: 400,
                  ), () {
                listA1[int.parse(benSN) - 1] = false;
              });
            }
            jinbi = bean.data!.goldBean!.toString();
            if (double.parse(bean.data!.goldBean!.toString()) > 10000) {
              jinbi2 = (double.parse(bean.data!.goldBean!.toString()) / 10000)
                  .toString();
              if (jinbi2.split('.')[1].length >= 2) {
                jinbi2 =
                    '${jinbi2.split('.')[0]}.${jinbi2.split('.')[1].substring(0, 2)}w';
              } else {
                jinbi2 = '${jinbi2.split('.')[0]}.${jinbi2.split('.')[1]}w';
              }
            } else {
              jinbi2 = bean.data!.goldBean!.toString();
            }
            zuanshi = bean.data!.diamond!.toString();
            if (double.parse(bean.data!.diamond!.toString()) > 10000) {
              zuanshi2 = (double.parse(bean.data!.diamond!.toString()) / 10000)
                  .toString();
              if (zuanshi2.split('.')[1].length >= 2) {
                zuanshi2 =
                    '${zuanshi2.split('.')[0]}.${zuanshi2.split('.')[1].substring(0, 2)}w';
              } else {
                zuanshi2 =
                    '${zuanshi2.split('.')[0]}.${zuanshi2.split('.')[1]}w';
              }
            } else {
              zuanshi2 = bean.data!.diamond!.toString();
            }
            mogubi = bean.data!.mushroom!.toString();
            if (double.parse(bean.data!.mushroom!.toString()) > 10000) {
              mogubi2 = (double.parse(bean.data!.mushroom!.toString()) / 10000)
                  .toString();
              if (mogubi2.split('.')[1].length >= 2) {
                mogubi2 =
                    '${mogubi2.split('.')[0]}.${mogubi2.split('.')[1].substring(0, 2)}w';
              } else {
                mogubi2 = '${mogubi2.split('.')[0]}.${mogubi2.split('.')[1]}w';
              }
            } else {
              mogubi2 = bean.data!.mushroom!.toString();
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

  /// 赛车倒计时
  Future<void> doPostGetCarTimer() async {
    try {
      LogE('请求接口时间==  ${DateTime.now()}');
      carTimerBean bean = await DataUtils.postGetCarTimer();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          LogE('请求接口响应时间==  ${DateTime.now()}');
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
              LogE('当前秒数 $sum');
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
            } else if (bean.data! == 0) {
              MyToastUtils.showToastBottom2("您的网络不佳，游戏即将关闭，稍后请在开奖记录查看！");
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            }
          });
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          MyToastUtils.showToastBottom2("您的网络不佳，游戏即将关闭，稍后请在开奖记录查看！");
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
      }
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  // 金币 钻石 蘑菇币
  String jinbi = '',
      zuanshi = '',
      mogubi = '',
      jinbi2 = '',
      zuanshi2 = '',
      mogubi2 = '';

  /// 钱包余额
  Future<void> doPostBalance() async {
    try {
      balanceBean bean = await DataUtils.postBalance();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            jinbi = bean.data!.goldBean!;
            if (double.parse(bean.data!.goldBean!) > 10000) {
              jinbi2 = (double.parse(bean.data!.goldBean!) / 10000).toString();
              if (jinbi2.split('.')[1].length >= 2) {
                jinbi2 =
                    '${jinbi2.split('.')[0]}.${jinbi2.split('.')[1].substring(0, 2)}w';
              } else {
                jinbi2 = '${jinbi2.split('.')[0]}.${jinbi2.split('.')[1]}w';
              }
            } else {
              jinbi2 = bean.data!.goldBean!;
            }
            zuanshi = bean.data!.diamond!;
            if (double.parse(bean.data!.diamond!) > 10000) {
              zuanshi2 = (double.parse(bean.data!.diamond!) / 10000).toString();
              if (zuanshi2.split('.')[1].length >= 2) {
                zuanshi2 =
                    '${zuanshi2.split('.')[0]}.${zuanshi2.split('.')[1].substring(0, 2)}w';
              } else {
                zuanshi2 =
                    '${zuanshi2.split('.')[0]}.${zuanshi2.split('.')[1]}w';
              }
            } else {
              zuanshi2 = bean.data!.diamond!;
            }
            mogubi = bean.data!.mushroom!;
            if (double.parse(bean.data!.mushroom!) > 10000) {
              mogubi2 = (double.parse(bean.data!.mushroom!) / 10000).toString();
              if (mogubi2.split('.')[1].length >= 2) {
                mogubi2 =
                    '${mogubi2.split('.')[0]}.${mogubi2.split('.')[1].substring(0, 2)}w';
              } else {
                mogubi2 = '${mogubi2.split('.')[0]}.${mogubi2.split('.')[1]}w';
              }
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

  /// 赛车中奖用户
  late luckUserBean beanLuck;

  Future<void> doPostCarLuckyUser() async {
    try {
      beanLuck = await DataUtils.postCarLuckyUser();
      switch (beanLuck.code) {
        case MyHttpConfig.successCode:
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
}
