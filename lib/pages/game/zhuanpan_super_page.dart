import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:marquee/marquee.dart';
import 'package:soundpool/soundpool.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/game/rank_page.dart';
import 'package:yuyinting/pages/game/zhuanpan/zhuanpan_daoju_page.dart';
import 'package:yuyinting/pages/game/zhuanpan/zhuanpan_guize_page.dart';
import 'package:yuyinting/pages/game/zhuanpan/zhuanpan_jilu_page.dart';
import 'package:yuyinting/pages/game/zhuanpan/zhuanpan_new_jc2_page.dart';
import '../../bean/CommonIntBean.dart';
import '../../bean/balanceBean.dart';
import '../../bean/luckInfoBean.dart';
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
import '../../widget/xiazhu_queren_page.dart';
import '../mine/qianbao/dou_pay_page.dart';
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
  //是否正在转动
  bool isRunning = false;

  //是否顺时针
  bool isClockwise = true;

  //奖品数量
  int prizeNum = 120;

  //最少转动圈数
  int cyclesNum = 6;
  int isCheck = 1;
  // 是否关闭了音效
  bool isClose = false;
  // 转几次 要花费多少
  int cishu = 1, feiyong = 500;
  var listen, listenZDY, listen2;
  // 展示值
  int zhanshizhi = 0;
  String imgUrl = 'assets/images/zhuanpan_1.png';
  // 是否可以点击启动
  bool isXiazhu = true;

  /// 播放音频
  Soundpool soundpool = Soundpool(streamType: StreamType.music);
  Future<void> playSound() async {
    int soundId = await rootBundle.load('assets/audio/zhuanpan_jin.MP3').then(((ByteData soundDate){
      return soundpool.load(soundDate);
    }));
    await soundpool.play(soundId);
  }


  @override
  void initState() {
    super.initState();
    // 更新音效关闭开启状态
    setState(() {
      isClose = sp.getBool('zp_super')!;
    });
    doPostBalance();
    doPostGameRanking();
    doPostGetGameLuck();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 7000),
    );
    // 监听动画
    animationController?.addListener(_animListener);
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
      if(event.title == '超级转盘') {
        doPostPlayRoulette(event.cishu);
      }else if(event.title == '大转盘'){
        if(double.parse(sp.getString('zp_jinbi').toString()) < 500 && cishu ==1 ){
          MyToastUtils.showToastBottom('钱包余额不足');
          return;
        }
        if(double.parse(sp.getString('zp_jinbi').toString()) < 2500 && cishu ==5 ){
          MyToastUtils.showToastBottom('钱包余额不足');
          return;
        }
        if(double.parse(sp.getString('zp_jinbi').toString()) < 5000 && cishu ==10 ){
          MyToastUtils.showToastBottom('钱包余额不足');
          return;
        }
        if(isRunning == false && isXiazhu) {
          eventBus.fire(GameBack(isBack: true));
          doPostPlayRoulette(cishu.toString());
        }
      }
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
      if(event.type == 'game_turntable_luck'){
        LogE('****${event.map!['luck']}');
        setState(() {
          zhanshizhi = int.parse(event.map!['luck'].toString());
          imgUrl = 'assets/images/zhuanpan_$zhanshizhi.png';
        });
      }
    });
  }

  //网络动画
  void _animListener() {
    //TODO
    if (animationController.status == AnimationStatus.completed) {
      LogE('停止了');
      if(mounted) {
        setState(() {
          isRunning = false;
          isXiazhu = true;
        });
      }
      // 通知用户游戏结束，可以离开页面
      eventBus.fire(GameBack(isBack: false));
      // 打开礼物结果
      MyUtils.goTransparentPageCom(context, ZhuanPanDaoJuPage(list: list, zonge: zonge, title: '超级转盘',));
      // 归位
      Future.delayed(const Duration(milliseconds: 500),((){
        animationController.reset();
        //结束了
        // animationController.removeListener(_animListener);
      }));
    } else if (animationController.status == AnimationStatus.forward) {
      //动画正在从开始处运行到结束处（正向运行）
      // print('forward');
    } else if (animationController.status == AnimationStatus.reverse) {
      //动画正在从结束处运行到开始处（反向运行）。
      // print('reverse');
    }
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
    LogE('====关闭2');
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
          height: ScreenUtil().setHeight(800),
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 余额
              Positioned(
                top: (25*1.25).w,
                right: 20.w,
                child: GestureDetector(
                  onTap: ((){
                    MyUtils.goTransparentPageCom(context, DouPayPage(shuliang: jinbi,));
                  }),
                  child: Container(
                    height: ScreenUtil().setHeight(45),
                    padding: const EdgeInsets.only(
                        left: 5, right: 5, top: 1, bottom: 1),
                    //边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: MyColors.zpBG,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    ),
                    child: Row(
                      children: [
                        WidgetUtils.commonSizedBox(0, 5),
                        WidgetUtils.showImages(
                            'assets/images/mine_wallet_dd.png',
                            ScreenUtil().setHeight(26),
                            ScreenUtil().setHeight(24)),
                        WidgetUtils.commonSizedBox(0, 5),
                        WidgetUtils.onlyTextCenter(
                            jinbi2,
                            StyleUtils.getCommonTextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(23),
                                fontWeight: FontWeight.w600)),
                        WidgetUtils.commonSizedBox(0, 5.w),
                        Image(
                          image: const AssetImage(
                              'assets/images/wallet_more.png'),
                          width: 15.h,
                          height: 15.h,
                        ),
                        WidgetUtils.commonSizedBox(0, 5),
                      ],
                    ),
                  ),
                ),
              ),
              // 宝箱
              Positioned(
                  top: (100*1.25).w,
                  left: ScreenUtil().setHeight(20),
                  child: GestureDetector(
                    onTap: ((){
                      MyUtils.goTransparentPage(context, const ZhuanPanNewJC2Page());
                    }),
                    child: WidgetUtils.showImages(
                        'assets/images/zhuanpan_one_baoxiang.png',
                        ScreenUtil().setHeight(72),
                        ScreenUtil().setHeight(89)),
                  )),
              // 中奖信息
              Positioned(
                top: (100*1.25).w,
                child: // 中奖信息滚动
                luckInfo.isNotEmpty ? Stack(
                  children: [
                    Opacity(
                      opacity: 0.14,
                      child: Container(
                        margin: EdgeInsets.only(left: 40.h, right: 40.h),
                        width: 300.h,
                        height: ScreenUtil().setHeight(42),
                        decoration: const BoxDecoration(
                          //背景
                          color: Colors.white,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius:
                          BorderRadius.all(Radius.circular(21)),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 40.h, right: 40.h),
                      padding: EdgeInsets.only(top: 10.h, left: 10.h, right: 10.h),
                      width: 300.h,
                      height: ScreenUtil().setHeight(42),
                      alignment: Alignment.center,
                      child: Marquee(
                        // 文本
                        text: luckInfo,
                        // 文本样式
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21.sp,
                          shadows: const [
                            Shadow(
                              color: Colors.black54,
                              offset: Offset(2, 2),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        // 滚动轴：水平或者竖直
                        scrollAxis: Axis.horizontal,
                        // 轴对齐方式start
                        crossAxisAlignment: CrossAxisAlignment.start,
                        // 空白间距
                        blankSpace: 0,
                        // 速度
                        velocity: 30.0,
                        // 暂停时长
                        pauseAfterRound: Duration(seconds: 1),
                        // startPadding
                        startPadding: 10.0,
                        // 加速时长
                        accelerationDuration: Duration(seconds: 1),
                        // 加速Curve
                        accelerationCurve: Curves.linear,
                        // 减速时长
                        decelerationDuration: Duration(milliseconds: 500),
                        // 减速Curve
                        decelerationCurve: Curves.easeOut,
                      ),
                    ),
                  ],
                ) :  WidgetUtils.commonSizedBox(0, 0),),
              // 转盘
              Positioned(
                top: (170*1.25).w,
                width: ScreenUtil().setHeight(590),
                height: ScreenUtil().setHeight(590),
                child: Container(
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // CircleProgressView(backgroundColor: Colors.transparent, progress: -huanlezhi.toDouble(), progressWidth: ScreenUtil().setHeight(12), progressColor: MyColors.zpJD, width: ScreenUtil().setHeight(534), height: ScreenUtil().setHeight(534),),
                      WidgetUtils.showImages(
                          imgUrl,
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
                          if(double.parse(sp.getString('zp_jinbi').toString()) < 500 && cishu ==1 ){
                            MyToastUtils.showToastBottom('钱包余额不足');
                            return;
                          }
                          if(double.parse(sp.getString('zp_jinbi').toString()) < 2500 && cishu ==5 ){
                            MyToastUtils.showToastBottom('钱包余额不足');
                            return;
                          }
                          if(double.parse(sp.getString('zp_jinbi').toString()) < 5000 && cishu ==10 ){
                            MyToastUtils.showToastBottom('钱包余额不足');
                            return;
                          }
                          if(sp.getBool('zp2_queren') == null || sp.getBool('zp2_queren') == false){
                            MyUtils.goTransparentPageCom(context, XiaZhuQueRenPage(cishu: cishu.toString(), feiyong: feiyong.toString(), title: '超级转盘',));
                          }else{
                            if(MyUtils.checkClick() && isRunning == false && isXiazhu) {
                              eventBus.fire(GameBack(isBack: true));
                              doPostPlayRoulette(cishu.toString());
                            }
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
                      // Positioned(
                      //   left: ScreenUtil().setHeight(225),
                      //   top: ScreenUtil().setHeight(515),
                      //   child: Text(
                      //     '欢乐值：$zhanshizhi/30',
                      //     style: StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(21)),
                      //   ),
                      // ),
                      // // 满30显示
                      // zhanshizhi == 30 ? Positioned(
                      //     right: ScreenUtil().setHeight(5),
                      //     top: ScreenUtil().setHeight(205),
                      //     child: SizedBox( height: 70.h, width: 70.h, child: const SVGASimpleImage(assetsName: 'assets/svga/s.svga',),)) : const Text('')
                    ],
                  ),
                ),
              ),
              // 规则说明
              Positioned(
                  right: 0,
                  top: (100*1.25).w,
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
                  top: (150*1.25).w,
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
                  top: (200*1.25).w,
                  child: GestureDetector(
                    onTap: ((){
                      setState(() {
                        isClose = !isClose;
                        if(isClose){
                          sp.setBool('zp_super', true);
                        }else{
                          sp.setBool('zp_super', false);
                        }
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
                        isClose == false ? '关闭动效' : '开启动效',
                        style: TextStyle(
                            color: isClose == false ? Colors.white : MyColors.paiduiBlue,
                            fontSize: ScreenUtil().setSp(22),
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                  )),
              // 榜单
              Positioned(
                  top: (180*1.25).w,
                  left: ScreenUtil().setHeight(20),
                  child: GestureDetector(
                    onTap: (() {
                      MyUtils.goTransparentPage(
                          context, const RankPage());
                    }),
                    child: WidgetUtils.showImages(
                        'assets/images/room_bd.png',
                        ScreenUtil().setHeight(72),
                        ScreenUtil().setHeight(89)),
                  )),
            ],
          ),
        ),
        // 花费多少金豆提示
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
                        '500金豆',
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
                        '2500金豆',
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
                        '5000金豆',
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
                  feiyong = 500;
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
                  cishu = 5;
                  feiyong = 2500;
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
                        ? "assets/images/zhuanpan_one_51.png"
                        : 'assets/images/zhuanpan_one_5.png'),
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
                  cishu = 10;
                  feiyong = 5000;
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
                        ? "assets/images/zhuanpan_one_101.png"
                        : 'assets/images/zhuanpan_one_10.png'),
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
    LogE('token  ${sp.getString('user_token')}');
    setState(() {
      isXiazhu = false;
    });
    Map<String, dynamic> params = <String, dynamic>{
      'number': number, //数量
      'room_id': widget.roomId, //房间id
      'game_id': '2', //1魔方 2转盘
      'price': '500'
    };
    try {
      playRouletteBean bean = await DataUtils.postPlayRoulette(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          // 通知用户游戏开始不能离开
          eventBus.fire(GameBack(isBack: true));
          // 发送要减多少金豆
          jinbi = bean.data!.balance.toString();
          if(double.parse(jinbi) > 10000){
            //保留2位小数
            jinbi2 = '${(double.parse(jinbi) / 10000)}';
            if(jinbi2.split('.')[1].length >=2){
              jinbi2 = '${jinbi2.split('.')[0]}.${jinbi2.split('.')[1].substring(0,2)}w';
            }else{
              jinbi2 = '${jinbi2.split('.')[0]}.${jinbi2.split('.')[1]}w';
            }
          }else{
            jinbi2 = jinbi;
          }
          sp.setString('zp_jinbi', jinbi);
          // 获取数据并赋值
          list.clear();
          list = bean.data!.gifts!;
          zonge = bean.data!.total as int;
          if(isClose){
            //关闭了动效，直接显示中奖信息
            // ignore: use_build_context_synchronously
            MyUtils.goTransparentPageCom(context, ZhuanPanDaoJuPage(list: list, zonge: zonge, title: '超级转盘',));
            // 通知用户可以离开
            eventBus.fire(GameBack(isBack: false));
            setState(() {
              isXiazhu = true;
              isRunning = false;
            });
          }else{
            setState(() {
              switch(bean.data!.gifts![0].giftId){
                case 1124: // 比翼鸟
                  int randomNum = Random().nextInt(6);
                  luckyName = randomNum;
                  break;
                case 1133: // 美杜莎
                  int min = 103;
                  int max = 114; // 注意这里是 18 而不是 17，因为范围是左闭右开的
                  int randomNumber = Random().nextInt(max - min) + min;
                  luckyName = randomNumber;
                  break;
                case 1125: // 林深见鹿
                  int min = 91;
                  int max = 102;
                  int randomNumber = Random().nextInt(max - min) + min;
                  luckyName = randomNumber;
                  break;
                case 1131: // 秒见财神
                  int min = 79;
                  int max = 90;
                  int randomNumber = Random().nextInt(max - min) + min;
                  luckyName = randomNumber;
                  break;
                case 1128: // 紫霞仙子
                  int min = 67;
                  int max = 78;
                  int randomNumber = Random().nextInt(max - min) + min;
                  luckyName = randomNumber;
                  break;
                case 1129: // 为爱起航
                  int min = 55;
                  int max = 66;
                  int randomNumber = Random().nextInt(max - min) + min;
                  luckyName = randomNumber;
                  break;
                case 1127: // 至尊宝
                  int min = 43;
                  int max = 54;
                  int randomNumber = Random().nextInt(max - min) + min;
                  luckyName = randomNumber;
                  break;
                case 1130: // 情定埃菲尔
                  int min = 31;
                  int max = 42;
                  int randomNumber = Random().nextInt(max - min) + min;
                  luckyName = randomNumber;
                  break;
                case 1126: // 独角兽
                  int min = 19;
                  int max = 30;
                  int randomNumber = Random().nextInt(max - min) + min;
                  luckyName = randomNumber;
                  break;
                case 1135: // 白龙
                  int min = 7;
                  int max = 18;
                  int randomNumber = Random().nextInt(max - min) + min;
                  luckyName = randomNumber;
                  break;
              }
            });
            if(isClose == false){
              Vibrate.vibrate(); // 触发震动效果
            }
            buttonOnClickStartRun();
          }
          break;
        case MyHttpConfig.errorloginCode:
        // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          eventBus.fire(GameBack(isBack: false));
          setState(() {
            isXiazhu = true;
          });
          MyToastUtils.showToastBottom(bean.msg!);
          doPostBalance();
          break;
      }
    } catch (e) {
      eventBus.fire(GameBack(isBack: false));
      setState(() {
        isXiazhu = true;
      });
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 大转盘幸运值
  Future<void> doPostGetGameLuck() async {
    try {
      CommonIntBean bean = await DataUtils.postGetGameLuck();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            zhanshizhi = int.parse(bean.data!);
            imgUrl = 'assets/images/zhuanpan_$zhanshizhi.png';
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }


  String luckInfo = '';
  /// 幸运榜单
  Future<void> doPostGameRanking() async {
    try {
      luckInfoBean bean = await DataUtils.postGameRanking();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if(bean.data!.isNotEmpty){
              for(int i = 0 ; i < bean.data!.length; i++){
                if(luckInfo.isEmpty){
                  luckInfo = '恭喜${bean.data![i].nickname}获得${bean.data![i].giftName}          ';
                }else{
                  luckInfo = '$luckInfo恭喜${bean.data![i].nickname}获得${bean.data![i].giftName}          ';
                }
              }
              LogE('记录=== $luckInfo');
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  // 金币 钻石
  String jinbi = '', jinbi2 = '', zuanshi = '', zuanshi2 = '';
  /// 钱包余额
  Future<void> doPostBalance() async {
    try {
      balanceBean bean = await DataUtils.postBalance();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            jinbi = bean.data!.goldBean!;
            sp.setString('zp_jinbi', jinbi);
            if(double.parse(bean.data!.goldBean!) > 10000){
              jinbi2 = '${(double.parse(bean.data!.goldBean!) / 10000)}';
              if(jinbi2.split('.')[1].length >=2){
                jinbi2 = '${jinbi2.split('.')[0]}.${jinbi2.split('.')[1].substring(0,2)}w';
              }else{
                jinbi2 = '${jinbi2.split('.')[0]}.${jinbi2.split('.')[1]}w';
              }
            }else{
              jinbi2 = bean.data!.goldBean!;
            }
            zuanshi = bean.data!.diamond!;
            if(double.parse(bean.data!.diamond!) > 10000){
              zuanshi2 = '${(double.parse(bean.data!.diamond!) / 10000)}';
              if(zuanshi2.split('.')[1].length >=2){
                zuanshi2 = '${zuanshi2.split('.')[0]}.${zuanshi2.split('.')[1].substring(0,2)}w';
              }else{
                zuanshi2 = '${zuanshi2.split('.')[0]}.${zuanshi2.split('.')[1]}w';
              }
            }else{
              zuanshi2 = bean.data!.diamond!;
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
