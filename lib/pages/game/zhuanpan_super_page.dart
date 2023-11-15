import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:soundpool/soundpool.dart';
import 'package:yuyinting/bean/commonStringBean.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/game/zhuanpan/zhuanpan_daoju_page.dart';
import 'package:yuyinting/pages/game/zhuanpan/zhuanpan_guize_page.dart';
import 'package:yuyinting/pages/game/zhuanpan/zhuanpan_jiangchi2_page.dart';
import 'package:yuyinting/pages/game/zhuanpan/zhuanpan_jilu_page.dart';
import 'package:yuyinting/widget/SVGASimpleImage.dart';

import '../../bean/CommonIntBean.dart';
import '../../bean/playRouletteBean.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/event_utils.dart';
import '../../utils/log_util.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../../widget/CircleProgressView.dart';
import '../../widget/xiazhu_queren_page.dart';
/// 超级转盘
class ZhuanPanSuperPage extends StatefulWidget {
  String roomId;
  ZhuanPanSuperPage({super.key, required this.roomId});

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

  bool isClose = false;
  // 转几次 要花费多少
  int cishu = 1, feiyong = 1000;
  var listen, listenZDY;
  // 当前欢乐值进度，展示值
  int huanlezhi = 0, zhanshizhi = 0;

  /// 播放音频
  Soundpool soundpool = Soundpool(streamType: StreamType.notification);
  Future<void> playSound() async {
    int soundId = await rootBundle.load('assets/audio/zhuanpan_jin.MP3').then(((ByteData soundDate){
      return soundpool.load(soundDate);
    }));
    await soundpool.play(soundId);
  }


  @override
  void initState() {
    super.initState();
    doPostGetGameLuck();
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
        // 通知用户游戏结束，可以离开页面
        eventBus.fire(ResidentBack(isBack: false));
        // 打开礼物结果
        MyUtils.goTransparentPageCom(context, ZhuanPanDaoJuPage(list: list, zonge: zonge, title: '超级转盘',));
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

    listen = eventBus.on<XZQuerenBack>().listen((event) {
      doPostPlayRoulette(event.cishu);
    });

    // 判断当前年月日是否为今天，如果不是，下注还是要提示
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;
    String time = '$year-$month-$day';
    if(sp.getString('zp2_queren_time') == null || sp.getString('zp2_queren_time') != time){
      sp.setBool('zp2_queren', false);
    }

    listenZDY = eventBus.on<ZDYBack>().listen((event) {
      LogE('****${event.map!['luck']}');
      setState(() {
        huanlezhi = int.parse(event.map!['luck'].toString()) ~/ 1.5;
        zhanshizhi = int.parse(event.map!['luck'].toString());
      });
    });
  }
  int luckyName = 0;
  void start() {
    if(!isClose){
      playSound();
    }
    // ///中奖编号
    // int luckyName = Random().nextInt(20);
    // LogE('中奖号码$luckyName');
    startAnimation(luckyName);
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
    listen.cancel();
    listenZDY.cancel();
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
                  child: GestureDetector(
                    onTap: ((){
                      MyUtils.goTransparentPage(context, const ZhuanPanJiangChi2Page());
                    }),
                    child: WidgetUtils.showImages(
                        'assets/images/zhuanpan_one_baoxiang.png',
                        ScreenUtil().setHeight(72),
                        ScreenUtil().setHeight(89)),
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
                    CircleProgressView(backgroundColor: Colors.transparent, progress: -huanlezhi.toDouble(), progressWidth: ScreenUtil().setHeight(12), progressColor: MyColors.zpJD, width: ScreenUtil().setHeight(534), height: ScreenUtil().setHeight(534),),
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
                      onTap: (() async {
                        if(sp.getBool('zp2_queren') == null || sp.getBool('zp2_queren') == false){
                          MyUtils.goTransparentPageCom(context, XiaZhuQueRenPage(cishu: cishu.toString(), feiyong: feiyong.toString(), title: '超级转盘',));
                        }else{
                          doPostPlayRoulette(cishu.toString());
                        }
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
                        '欢乐值：$zhanshizhi/30',
                        style: StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(21)),
                      ),
                    ),
                    // 满30显示
                    zhanshizhi == 30 ? Positioned(
                        right: ScreenUtil().setHeight(5),
                        top: ScreenUtil().setHeight(205),
                        child: SizedBox( height: 70.h, width: 70.h, child: const SVGASimpleImage(assetsName: 'assets/svga/s.svga',),)) : const Text('')
                  ],
                ),
              ),
              // 规则说明
              Positioned(
                  right: 0,
                  top: ScreenUtil().setHeight(15),
                  child: GestureDetector(
                    onTap: ((){
                      MyUtils.goTransparentPageCom(context, ZhuanPanGuiZePage(type: 1,));
                    }),
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
                    ),
                  )
              ),
              // 我的记录
              Positioned(
                  right: 0,
                  top: ScreenUtil().setHeight(70),
                  child: GestureDetector(
                    onTap: ((){
                      MyUtils.goTransparentPageCom(context, ZhuanPanJiLuPage(type: 1,));
                    }),
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
                    ),
                  )
              ),
              // 关闭音效
              Positioned(
                  right: 0,
                  top: ScreenUtil().setHeight(130),
                  child: GestureDetector(
                    onTap: ((){
                      setState(() {
                        isClose = !isClose;
                      });
                    }),
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
                        isClose == false ? '关闭音效' : '开启音效',
                        style: TextStyle(
                            color: isClose == false ? Colors.white : MyColors.paiduiBlue,
                            fontSize: ScreenUtil().setSp(22),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  )),
            ],
          ),
        ),
        // 花费多少v豆提示
        Row(
          children: [
            WidgetUtils.commonSizedBox(0, 20),
            Container(
              height: ScreenUtil().setHeight(40),
              width: ScreenUtil().setHeight(150),
              margin: EdgeInsets.only(left: 10.h, right: 10.h),
              decoration: const BoxDecoration(
                //背景
                color: Colors.black38,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Row(
                children: [
                  const Spacer(),
                  WidgetUtils.showImages('assets/images/mine_wallet_dd.png',
                      ScreenUtil().setHeight(26), ScreenUtil().setHeight(24)),
                  WidgetUtils.commonSizedBox(0, 5),
                  Transform.translate(
                    offset: Offset(0, -2.h),
                    child: WidgetUtils.onlyTextCenter(
                        '1000V豆',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(23),
                            fontWeight: FontWeight.w600)),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Spacer(),
            Container(
              height: ScreenUtil().setHeight(40),
              width: ScreenUtil().setHeight(150),
              margin: EdgeInsets.only(left: 10.h, right: 10.h),
              decoration: const BoxDecoration(
                //背景
                color: Colors.black38,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Row(
                children: [
                  const Spacer(),
                  WidgetUtils.showImages('assets/images/mine_wallet_dd.png',
                      ScreenUtil().setHeight(26), ScreenUtil().setHeight(24)),
                  WidgetUtils.commonSizedBox(0, 5),
                  Transform.translate(
                    offset: Offset(0, -2.h),
                    child: WidgetUtils.onlyTextCenter(
                        '10000V豆',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(23),
                            fontWeight: FontWeight.w600)),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            const Spacer(),
            Container(
              height: ScreenUtil().setHeight(40),
              width: ScreenUtil().setHeight(150),
              margin: EdgeInsets.only(left: 10.h, right: 10.h),
              decoration: const BoxDecoration(
                //背景
                color: Colors.black38,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              child: Row(
                children: [
                  const Spacer(),
                  WidgetUtils.showImages('assets/images/mine_wallet_dd.png',
                      ScreenUtil().setHeight(26), ScreenUtil().setHeight(24)),
                  WidgetUtils.commonSizedBox(0, 5),
                  Transform.translate(
                    offset: Offset(0, -2.h),
                    child: WidgetUtils.onlyTextCenter(
                        '30000V豆',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(23),
                            fontWeight: FontWeight.w600)),
                  ),
                  const Spacer(),
                ],
              ),
            ),
            WidgetUtils.commonSizedBox(0, 20),
          ],
        ),
        WidgetUtils.commonSizedBox(20.h, 0),
        // 转盘次数
        Row(
          children: [
            WidgetUtils.commonSizedBox(0, 20),
            GestureDetector(
              onTap: (() {
                setState(() {
                  isCheck = 1;
                  cishu = 1;
                  feiyong = 1000;
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
                        ? "assets/images/zhuanpan_one_11.png"
                        : 'assets/images/zhuanpan_one_1.png'),
                    fit: BoxFit.fill, //覆盖
                  ),
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: (() {
                setState(() {
                  isCheck = 2;
                  cishu = 10;
                  feiyong = 10000;
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
                        ? "assets/images/zhuanpan_one_101.png"
                        : 'assets/images/zhuanpan_one_10.png'),
                    fit: BoxFit.fill, //覆盖
                  ),
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: (() {
                setState(() {
                  isCheck = 3;
                  cishu = 30;
                  feiyong = 30000;
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
                        ? "assets/images/zhuanpan_one_1001.png"
                        : 'assets/images/zhuanpan_one_100.png'),
                    fit: BoxFit.fill, //覆盖
                  ),
                ),
              ),
            ),
            WidgetUtils.commonSizedBox(0, 20),
          ],
        ),
      ],
    );
  }


  List<Gifts> list = [];
  int zonge =0;
  /// 魔方转盘竞猜
  Future<void> doPostPlayRoulette(String number) async {
    Map<String, dynamic> params = <String, dynamic>{
      'number': number, //数量
      'room_id': widget.roomId, //房间id
      'game_id': '2', //1魔方 2转盘
      'price': '1000'
    };
    try {
      playRouletteBean bean = await DataUtils.postPlayRoulette(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
        // 通知用户游戏开始不能离开
          eventBus.fire(ResidentBack(isBack: true));
          // 发送要减多少V豆
          eventBus.fire(XiaZhuBack(jine: int.parse(number)*100));
          // 获取数据并赋值
          list.clear();
          list = bean.data!.gifts!;
          zonge = bean.data!.total as int;
          setState(() {
            switch(bean.data!.gifts![0].giftId){
              case 50: // 星之钥
                int randomNum = Random().nextInt(6);
                luckyName = randomNum;
                break;
              case 1300: // 瑞麟
                int min = 7;
                int max = 18; // 注意这里是 18 而不是 17，因为范围是左闭右开的
                int randomNumber = Random().nextInt(max - min) + min;
                luckyName = randomNumber;
                break;
              case 1880: // 情定埃菲尔
                int min = 19;
                int max = 30;
                int randomNumber = Random().nextInt(max - min) + min;
                luckyName = randomNumber;
                break;
              case 2660: // 霸下
                int min = 31;
                int max = 42;
                int randomNumber = Random().nextInt(max - min) + min;
                luckyName = randomNumber;
                break;
              case 5660: // 秒见财神
                int min = 43;
                int max = 54;
                int randomNumber = Random().nextInt(max - min) + min;
                luckyName = randomNumber;
                break;
              case 9990: // 宝象传说
                int min = 55;
                int max = 66;
                int randomNumber = Random().nextInt(max - min) + min;
                luckyName = randomNumber;
                break;
              case 12000: // 为爱起航
                int min = 67;
                int max = 78;
                int randomNumber = Random().nextInt(max - min) + min;
                luckyName = randomNumber;
                break;
              case 24880: // 北欧天马
                int min = 79;
                int max = 90;
                int randomNumber = Random().nextInt(max - min) + min;
                luckyName = randomNumber;
                break;
              case 188800: // 晚安
                int min = 91;
                int max = 102;
                int randomNumber = Random().nextInt(max - min) + min;
                luckyName = randomNumber;
                break;
              case 388800: // 远古巨鲲
                int min = 103;
                int max = 114;
                int randomNumber = Random().nextInt(max - min) + min;
                luckyName = randomNumber;
                break;
            }
          });
          LogE('中奖位置$luckyName');
          Vibrate.vibrate(); // 触发震动效果
          buttonOnClickStartRun();
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
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }

  /// 大转盘幸运值
  Future<void> doPostGetGameLuck() async {
    try {
      CommonIntBean bean = await DataUtils.postGetGameLuck();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            huanlezhi = int.parse(bean.data!) ~/ 1.5;
            zhanshizhi = int.parse(bean.data!);
            LogE('欢乐值$huanlezhi');
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
      LogE('错误提示$e');
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }
}
