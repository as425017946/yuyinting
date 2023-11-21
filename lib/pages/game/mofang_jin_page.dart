import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:soundpool/soundpool.dart';
import 'package:svgaplayer_flutter/parser.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:yuyinting/config/my_config.dart';

import '../../bean/balanceBean.dart';
import '../../bean/playRouletteBean.dart';
import '../../colors/my_colors.dart';
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
import 'mofang/mofang_beibao_page.dart';
import 'mofang/mofang_daoju_page.dart';
import 'mofang/mofang_guize_page.dart';
import 'mofang/mofang_jiangchi_page.dart';
import 'mofang/mofang_jilu_page.dart';

/// 金色魔方
class MofangJinPage extends StatefulWidget {
  String roomId;
  MofangJinPage({super.key, required this.roomId});

  @override
  State<MofangJinPage> createState() => _MofangJinPageState();
}

class _MofangJinPageState extends State<MofangJinPage> with AutomaticKeepAliveClientMixin,TickerProviderStateMixin{

  @override
  bool get wantKeepAlive => true;

  int isCheck = 1;

  //爆照动画是否在播放
  bool isShow = false;
  // 是否跳过动画
  bool isTiaoguo = false;
  // 是否跳过动画展示图片使用
  bool isTiaoguoLW = false;
  // 是否点击更多
  bool isMore = false;
  SVGAAnimationController? animationController;
  // 转几次 要花费多少
  int cishu = 1, feiyong = 500;
  // 监听
  var listenXZ;
  // 是否可以点击启动
  bool isXiazhu = true;

  @override
  void initState() {
    super.initState();
    animationController = SVGAAnimationController(vsync: this);
    loadAnimation();
    doPostWalletList();

    listenXZ = eventBus.on<XZQuerenBack>().listen((event) {
      doPostPlayRoulette(event.cishu);
    });

    // 判断当前年月日是否为今天，如果不是，下注还是要提示
    DateTime now = DateTime.now();
    int year = now.year;
    int month = now.month;
    int day = now.day;
    String time = '$year-$month-$day';
    if(sp.getString('mf2_queren_time') == null || sp.getString('mf2_queren_time') != time){
      sp.setBool('mf2_queren', false);
    }
  }

  /// 播放音频
  Soundpool soundpool = Soundpool(streamType: StreamType.notification);
  Future<void> playSound() async {
    int soundId = await rootBundle.load('assets/audio/mofang_jin.wav').then(((ByteData soundDate){
      return soundpool.load(soundDate);
    }));
    await soundpool.play(soundId);
  }

  void loadAnimation() async {
    final videoItem = await _loadSVGA(false, 'assets/svga/mofang_jin_baozha.svga');
    videoItem.autorelease = false;
    animationController?.videoItem = videoItem;
    animationController
        ?.repeat() // Try to use .forward() .reverse()
        .whenComplete(() => animationController?.videoItem = null);

    // 监听动画
    animationController?.addListener(() {
      if (animationController!.currentFrame >= animationController!.frames - 1) {
        LogE('播放完成');
        // 动画播放到最后一帧时停止播放
        animationController?.stop();
        setState(() {
          isShow = false;
          isTiaoguoLW = false;
          isXiazhu = true;
        });
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
  void dispose() {
    animationController?.dispose();
    animationController = null;
    listenXZ.cancel();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Stack(
          children: [
            SizedBox(
              height: ScreenUtil().setHeight(900),
              width: double.infinity,
              child: WidgetUtils.showImagesFill(
                  "assets/images/mofang_jin_bg.png",
                  ScreenUtil().setHeight(900),
                  double.infinity),
            ),
            Container(
              height: ScreenUtil().setHeight(900),
              width: double.infinity,
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Stack(
                children: [
                  Column(
                    children: [
                      WidgetUtils.commonSizedBox(ScreenUtil().setHeight(80), 0),
                      Row(
                        children: [
                          // 关闭
                          GestureDetector(
                            onTap: (() {
                              if(isShow){
                                return;
                              }
                              Navigator.pop(context);
                            }),
                            child: WidgetUtils.showImages(
                                'assets/images/mofang_jin_close.png',
                                ScreenUtil().setHeight(45),
                                ScreenUtil().setHeight(45)),
                          ),
                          const Spacer(),
                          // 更多
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                isMore = !isMore;
                              });
                            }),
                            child: WidgetUtils.showImages(
                                'assets/images/mofang_jin_dian.png',
                                ScreenUtil().setHeight(21),
                                ScreenUtil().setHeight(47)),
                          ),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(40.h, 0),
                      // 中奖信息滚动
                      // Stack(
                      //   children: [
                      //     Opacity(
                      //       opacity: 0.14,
                      //       child: Container(
                      //         width: ScreenUtil().setHeight(310),
                      //         height: ScreenUtil().setHeight(42),
                      //         decoration: const BoxDecoration(
                      //           //背景
                      //           color: Colors.white,
                      //           //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      //           borderRadius:
                      //           BorderRadius.all(Radius.circular(21)),
                      //         ),
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       width: ScreenUtil().setHeight(310),
                      //       height: ScreenUtil().setHeight(42),
                      //       child: Marquee(
                      //         speed: 10,
                      //         child: Text(
                      //           '恭喜某某用户单抽喜中价值500元的小柴一个',
                      //           style: TextStyle(
                      //               color: Colors.white,
                      //               fontSize: ScreenUtil().setSp(21)),
                      //         ),
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // 切换魔方svga图
                      Opacity(opacity: isShow == false ? 1 : 0 ,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            SizedBox(
                              height: ScreenUtil().setHeight(500),
                              width: ScreenUtil().setHeight(500),
                              child: const SVGASimpleImage(
                                  assetsName: 'assets/svga/mofang_jin_show.svga'),
                            ),
                            Opacity(
                              opacity: 0.4,
                              child: Container(
                                width: ScreenUtil().setHeight(120),
                                height: ScreenUtil().setHeight(50),
                                decoration: const BoxDecoration(
                                  //背景
                                  color: Colors.black54,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(21)),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: ((){
                                if(sp.getBool('mf2_queren') == null || sp.getBool('mf2_queren') == false){
                                  MyUtils.goTransparentPageCom(context, XiaZhuQueRenPage(cishu: cishu.toString(), feiyong: feiyong.toString(), title: '金星魔方',));
                                }else{
                                  if(MyUtils.checkClick() && isShow == false && isXiazhu) {
                                    doPostPlayRoulette(cishu.toString());
                                  }
                                }
                              }),
                              child: SizedBox(
                                width: ScreenUtil().setHeight(120),
                                height: ScreenUtil().setHeight(50),
                                child: WidgetUtils.onlyTextCenter(
                                    '点击转动',
                                    TextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(26),
                                        fontWeight: FontWeight.w600)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // 蓝色魔方和金色魔方按钮切换
                      GestureDetector(
                        onTap: ((){
                          eventBus.fire(MofangBack(info: 0));
                        }),
                        child: WidgetUtils.showImages('assets/images/mofang_jin.png', ScreenUtil().setHeight(75), ScreenUtil().setHeight(316)),
                      ),

                      const Spacer(),
                      // 花费多少v豆提示
                      Row(
                        children: [
                          Container(
                            height: ScreenUtil().setHeight(40),
                            width: ScreenUtil().setHeight(130),
                            margin: EdgeInsets.only(left: 20.h, right: 20.h),
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
                                      '500V豆',
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
                            width: ScreenUtil().setHeight(130),
                            margin: EdgeInsets.only(left: 20.h, right: 20.h),
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
                                      '5000V豆',
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
                            width: ScreenUtil().setHeight(130),
                            margin: EdgeInsets.only(left: 20.h, right: 20.h),
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
                                      '50000V豆',
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(23),
                                          fontWeight: FontWeight.w600)),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                        ],
                      ),
                      WidgetUtils.commonSizedBox(10.h, 0),
                      // 抽奖次数
                      Row(
                        children: [
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
                                      ? "assets/images/mofang_jin_btn.png"
                                      : 'assets/images/mofang_btn.png'),
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
                                  image: AssetImage(isCheck == 2
                                      ? "assets/images/mofang_jin_btn.png"
                                      : 'assets/images/mofang_btn.png'),
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
                                cishu = 100;
                                feiyong = 50000;
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
                                      ? "assets/images/mofang_jin_btn.png"
                                      : 'assets/images/mofang_btn.png'),
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
                        ],
                      ),
                      const Spacer(),
                    ],
                  ),
                  //奖池
                  Positioned(
                      right: ScreenUtil().setHeight(10),
                      top: ScreenUtil().setHeight(150),
                      child: GestureDetector(
                        onTap: ((){
                          MyUtils.goTransparentPage(context, MoFangJiangChiPage(type: '2',));
                        }),
                        child: Stack(
                          children: [
                            WidgetUtils.showImages(
                                'assets/images/mofang_jin_jiangchi.png',
                                ScreenUtil().setHeight(90),
                                ScreenUtil().setHeight(109)),
                            Container(
                              height: ScreenUtil().setHeight(90),
                              width: ScreenUtil().setHeight(109),
                              padding: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(58)),
                              child: WidgetUtils.onlyTextCenter(
                                  '魔方奖池',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(22))),
                            )
                          ],
                        ),
                      )),
                  // 显示余额
                  Positioned(
                    left: ScreenUtil().setHeight(6),
                    top: ScreenUtil().setHeight(140),
                    child: GestureDetector(
                      onTap: ((){
                      }),
                      child: Container(
                        height: ScreenUtil().setHeight(45),
                        child: Row(
                          children: [
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.showImages(
                                'assets/images/mine_wallet_dd.png',
                                ScreenUtil().setHeight(26),
                                ScreenUtil().setHeight(24)),
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.onlyTextCenter(
                                jinbi,
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(23),
                                    fontWeight: FontWeight.w600)),
                            WidgetUtils.commonSizedBox(0, 5),
                            Opacity(
                              opacity: 0.8,
                              child: Container(
                                height: ScreenUtil().setHeight(20),
                                width: ScreenUtil().setHeight(1),
                                color: MyColors.home_hx,
                              ),
                            ),
                            WidgetUtils.commonSizedBox(0, 10),
                            WidgetUtils.showImages(
                                'assets/images/mine_wallet_zz.png',
                                ScreenUtil().setHeight(26),
                                ScreenUtil().setHeight(24)),
                            WidgetUtils.commonSizedBox(0, 5),
                            WidgetUtils.onlyTextCenter(
                                zuanshi,
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontSize: ScreenUtil().setSp(23),
                                    fontWeight: FontWeight.w600)),
                            WidgetUtils.commonSizedBox(0, 5),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // 跳过动画
                  Positioned(
                    left: ScreenUtil().setHeight(15),
                    top: ScreenUtil().setHeight(210),
                    child: GestureDetector(
                      onTap: ((){
                        setState(() {
                          isTiaoguo = !isTiaoguo;
                        });
                      }),
                      child: Row(
                        children: [
                          WidgetUtils.showImages(isTiaoguo==false ? 'assets/images/mofang_check_no.png' : 'assets/images/mofang_check_yes.png', ScreenUtil().setHeight(24), ScreenUtil().setHeight(24)),
                          WidgetUtils.commonSizedBox(0, 5),
                          WidgetUtils.onlyText('跳过动画', StyleUtils.getCommonTextStyle(color: MyColors.roomTCWZ2, fontSize: ScreenUtil().setSp(20)))
                        ],
                      ),
                    ),
                  ),
                  // 右上角功能
                  isMore ? Positioned(
                    top: ScreenUtil().setHeight(120),
                    right: 0,
                    child: Stack(
                      children: [
                        Opacity(
                          opacity: 0.8,
                          child: Container(
                            height: ScreenUtil().setHeight(156),
                            width: ScreenUtil().setHeight(137),
                            //边框设置
                            decoration: const BoxDecoration(
                              //背景
                              color: Colors.black,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius:
                              BorderRadius.all(Radius.circular(12.0)),
                            ),
                          ),
                        ),
                        Container(
                          height: ScreenUtil().setHeight(156),
                          width: ScreenUtil().setHeight(137),
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              Expanded(
                                  child: GestureDetector(
                                    onTap: ((){
                                      MyUtils.goTransparentPageCom(context, const MoFangGuiZePage());
                                      setState(() {
                                        isMore = false;
                                      });
                                    }),
                                    child: WidgetUtils.onlyTextCenter(
                                        '玩法规则',
                                        StyleUtils.getCommonTextStyle(
                                            color: MyColors.roomTCWZ2,
                                            fontSize: ScreenUtil().setSp(21))),
                                  )),
                              Container(
                                width: double.infinity,
                                height: ScreenUtil().setHeight(1),
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setHeight(10),
                                    right: ScreenUtil().setHeight(10)),
                                color: MyColors.roomTCWZ1,
                              ),
                              Expanded(
                                  child: GestureDetector(
                                    onTap: ((){
                                      MyUtils.goTransparentPageCom(context, MoFangJiLuPage(type: 0,));
                                      setState(() {
                                        isMore = false;
                                      });
                                    }),
                                    child: WidgetUtils.onlyTextCenter(
                                        '我的记录',
                                        StyleUtils.getCommonTextStyle(
                                            color: MyColors.roomTCWZ2,
                                            fontSize: ScreenUtil().setSp(21))),
                                  )),
                              Container(
                                width: double.infinity,
                                height: ScreenUtil().setHeight(1),
                                margin: EdgeInsets.only(
                                    left: ScreenUtil().setHeight(10),
                                    right: ScreenUtil().setHeight(10)),
                                color: MyColors.roomTCWZ1,
                              ),
                              Expanded(
                                  child: GestureDetector(
                                    onTap: ((){
                                      MyUtils.goTransparentPageCom(context, const MoFangBeiBaoPage());
                                      setState(() {
                                        isMore = false;
                                      });
                                    }),
                                    child: WidgetUtils.onlyTextCenter(
                                        '我的背包',
                                        StyleUtils.getCommonTextStyle(
                                            color: MyColors.roomTCWZ2,
                                            fontSize: ScreenUtil().setSp(21))),
                                  )),
                            ],
                          ),
                        )
                      ],
                    ),
                  ) : const Text(''),

                  // 魔方爆炸效果
                  isShow == true ? Container(
                    height: ScreenUtil().setHeight(580),
                    width: ScreenUtil().setHeight(580),
                    margin: EdgeInsets.only(top: ScreenUtil().setHeight(140)),
                    alignment: Alignment.center,
                    child: SVGAImage(animationController!),
                  ) : WidgetUtils.commonSizedBox(0, 0),
                  // 如果没有跳过动画，则直接显示图片
                  isTiaoguoLW ? Center(
                    child: SizedBox(
                      height: 250.h,
                      width: 250.h,
                      child: Column(
                        children: [
                          WidgetUtils.commonSizedBox(30.h, 0),
                          WidgetUtils.showImagesNet(list[0].img!, 180.h, 180.h),
                        ],
                      ),
                    ),
                  ) : const Text('')
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 金币 钻石
  String jinbi = '', zuanshi = '';
  /// 钱包明细
  Future<void> doPostWalletList() async {
    try {
      balanceBean bean = await DataUtils.postBalance();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if(double.parse(bean.data!.goldBean!) > 10000){
              jinbi = '${(double.parse(bean.data!.goldBean!)/10000)}w';
            }else{
              jinbi = bean.data!.goldBean!;
            }
            if(double.parse(bean.data!.diamond!) > 10000){
              zuanshi = '${(double.parse(bean.data!.diamond!)/10000)}w';
            }else{
              zuanshi = bean.data!.diamond!;
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

  List<Gifts> list = [];
  int zonge =0;
  /// 魔方转盘竞猜
  Future<void> doPostPlayRoulette(String number) async {
    setState(() {
      isXiazhu = false;
    });
    Map<String, dynamic> params = <String, dynamic>{
      'number': number, //数量
      'room_id': widget.roomId, //房间id
      'game_id': '1', //1魔方 2转盘
      'price': '500'
    };
    try {
      playRouletteBean bean = await DataUtils.postPlayRoulette(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
        // 获取数据并赋值
          list.clear();
          list = bean.data!.gifts!;
          zonge = bean.data!.total as int;
          // 如果是跳过动画，直接展示数据
          if(isTiaoguo){
            setState(() {
              isTiaoguoLW = false;
            });
            // ignore: use_build_context_synchronously
            MyUtils.goTransparentPageCom(context, MoFangDaoJuPage(list: list, zonge: zonge, title: '金星魔方'));
          }else{
            Future.delayed(const Duration(milliseconds: 400), () {
              // 延迟执行的代码
              setState(() {
                isTiaoguoLW = true;
              });
            });
            playSound();
            setState(() {
              isShow = true;
            });
            animationController?.reset();
            animationController?.forward();
            Future.delayed(const Duration(milliseconds: 3000), () {
              // 延迟执行的代码
              MyUtils.goTransparentPageCom(context, MoFangDaoJuPage(list: list, zonge: zonge, title: '金星魔方'));
            });
          }
          // 更新余额
          setState(() {
            if(jinbi.contains('w')){
              // 目的是先把 1w 转换成 10000
              jinbi = (double.parse(jinbi.substring(0,jinbi.length - 1)) * 10000).toString();
              // 减去花费的V豆
              jinbi = '${(double.parse(jinbi) - int.parse(number)*20)/10000}w';
            }else{
              jinbi = (double.parse(jinbi) - int.parse(number)*20).toString();
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
}
