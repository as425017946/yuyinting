import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/pages/message/care_home_page.dart';
import 'package:yuyinting/pages/mine/setting/setting_page.dart';
import 'package:yuyinting/pages/mine/tequan/tequan_page.dart';
import 'package:yuyinting/pages/mine/zhuangban/zhuangban_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/widget/SVGASimpleImage.dart';

import '../../bean/kefuBean.dart';
import '../../bean/myInfoBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/loading.dart';
import '../../utils/my_utils.dart';
import '../../utils/widget_utils.dart';
import '../../widget/Marquee.dart';
import 'gonghui/gonghui_home_page.dart';
import 'gonghui/my_gonghui_page.dart';
import 'mine_smz_page.dart';
import 'my/my_info_page.dart';
import 'my_kefu_page.dart';

///我的
class MinePage extends StatefulWidget {
  const MinePage({Key? key}) : super(key: key);

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  var guizuType = 0, isFirst = 0;
  var listen;
  int level = 0; //用户等级
  int isAgent = 0; //是否有代理权限 0无1有
  int isNew = 0; // 是否萌新
  int isNewNoble = 0; // 是否新贵
  int isPretty = 0; // 是否靓号
  String userNumber = '',
      care = '',
      beCare = '',
      lookMe = '',
      identity = '',
      avatarFrameImg = '',
      avatarFrameGifImg = '',
      kefuUid = '',
      kefuAvatar = '';

  // 是否有入住审核信息
  bool isShenHe = false;
  var listenSH;

  // 设备是安卓还是ios
  String isDevices = 'android';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      setState(() {
        isDevices = 'android';
      });
    } else if (Platform.isIOS) {
      setState(() {
        isDevices = 'ios';
      });
    }
    listen = eventBus.on<SubmitButtonBack>().listen((event) {
      if (event.title == '我的装扮') {
        // Navigator.pushNamed(context, 'JiesuanPage');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ZhuangbanPage(),
          ),
        ).then((value) {
          doPostMyIfon();
        });
      } else if (event.title == '公会中心') {
        if (sp.getString('shimingzhi').toString() == '2' ||
            sp.getString('shimingzhi').toString() == '3') {
          // isShiMing(context);
          MyUtils.goTransparentPageCom(context, const MineSMZPage());
        } else if (sp.getString('shimingzhi').toString() == '1') {
          //身份 user普通用户，未加入公会 streamer主播 leader会长
          if (identity == 'user') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GonghuiHomePage(),
              ),
            ).then((value) {
              // doPostMyIfon();
            });
          } else {
            if (mounted) {
              Future.delayed(const Duration(seconds: 0), () {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return MyGonghuiPage(
                        type: identity,
                      );
                    }));
              }).then((value) {
                // doPostMyIfon();
              });
            }
          }
        } else if (sp.getString('shimingzhi').toString() == '0') {
          MyToastUtils.showToastBottom('实名审核中，请耐心等待');
        }
      } else if (event.title == '全民代理') {
        if (mounted) {
          Navigator.pushNamed(context, 'DailiHomePage');
        }
      } else if (event.title == '等级成就') {
        if (mounted) {
          Navigator.pushNamed(context, 'ChengJiuPage');
        }
      } else if (event.title == '联系客服') {
        if (mounted) {
          // Navigator.pushNamed(context, 'KefuPage');
          Future.delayed(const Duration(seconds: 0), () {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return MyKeFuPage(kefuUid: kefuUid, kefuAvatar: kefuAvatar);
                }));
          });
        }
      }
    });

    listenSH = eventBus.on<SubmitButtonBack>().listen((event) {
      if (event.title == '审核全部完成') {
        setState(() {
          isShenHe = false;
        });
      }
    });
    doPostMyIfon();
    doPostKefu();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
    listenSH.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(left: 20, right: 20),
        decoration: const BoxDecoration(
          //设置Container修饰
          image: DecorationImage(
            //背景图片修饰
            image: AssetImage("assets/images/mine_bg.jpg"),
            fit: BoxFit.fill, //覆盖
          ),
        ),
        child: Column(
          children: [
            WidgetUtils.commonSizedBox(isDevices == 'ios' ? 80.h : 60.h, 0),
            GestureDetector(
              onTap: (() {
                if (MyUtils.checkClick()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SettingPage(),
                    ),
                  ).then((value) {
                    doPostMyIfon();
                  });
                }
              }),
              child: Row(
                children: [
                  const Expanded(child: Text('')),
                  WidgetUtils.showImages('assets/images/mine_icon_setting.png',
                      ScreenUtil().setHeight(40), ScreenUtil().setHeight(40)),
                ],
              ),
            ),

            ///头像等信息
            Row(
              children: [
                GestureDetector(
                  onTap: (() {
                    if (MyUtils.checkClick()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyInfoPage(),
                        ),
                      ).then((value) {
                        doPostMyIfon();
                      });
                    }
                  }),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      WidgetUtils.CircleHeadImage(
                          ScreenUtil().setHeight(90),
                          ScreenUtil().setHeight(90),
                          sp.getString('user_headimg').toString()),
                      // 头像框静态图
                      avatarFrameImg.isNotEmpty
                          ? WidgetUtils.CircleHeadImage(
                              ScreenUtil().setHeight(120),
                              ScreenUtil().setHeight(120),
                              avatarFrameImg)
                          : const Text(''),
                      // 头像框动态图
                      avatarFrameGifImg.isNotEmpty
                          ? SizedBox(
                              height: 120.h,
                              width: 120.h,
                              child: SVGASimpleImage(
                                resUrl: avatarFrameGifImg,
                              ),
                            )
                          : const Text(''),
                    ],
                  ),
                ),
                WidgetUtils.commonSizedBox(0, 15),
                Expanded(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.bottomLeft,
                        child: Row(
                          children: [
                            sp.getString('nickname').toString().length > 12
                                ? SizedBox(
                                    width: 260.w,
                                    child: Marquee(
                                      speed: 20,
                                      child: Text(
                                        "${sp.getString('nickname')}    ${sp.getString('nickname')}",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(35),
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                  )
                                : Text(
                                    sp.getString('nickname').toString(),
                                    style: StyleUtils.getCommonTextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: ScreenUtil().setSp(38)),
                                  ),
                            WidgetUtils.commonSizedBox(0, 5),
                            // 只有不是新贵或者新锐的时候展示萌新
                            (isNew == 1 && isNewNoble == 0)
                                ? WidgetUtils.showImages(
                                    'assets/images/dj/room_role_common.png',
                                    30.h,
                                    50.h)
                                : const Text(''),
                            (isNew == 1 && isNewNoble == 0)
                                ? WidgetUtils.commonSizedBox(0, 5)
                                : const Text(''),
                            // 展示新贵或者新锐图标
                            isNewNoble == 1
                                ? WidgetUtils.showImages(
                                    'assets/images/dj/room_rui.png', 30.h, 50.h)
                                : isNewNoble == 2
                                    ? WidgetUtils.showImages(
                                        'assets/images/dj/room_gui.png',
                                        30.h,
                                        50.h)
                                    : isNewNoble == 3 ? WidgetUtils.showImages(
                                        'assets/images/dj/room_gui.png',
                                        30.h,
                                        50.h) : const Text(''),
                            isNewNoble != 0
                                ? WidgetUtils.commonSizedBox(0, 5)
                                : const Text(''),
                            isPretty == 1
                                ? WidgetUtils.showImages(
                                    'assets/images/dj/lianghao.png', 30.h, 30.h)
                                : const Text(''),
                          ],
                        ),
                      ),
                      WidgetUtils.commonSizedBox(10, 0),
                      Row(
                        children: [
                          Container(
                            height: ScreenUtil().setHeight(25),
                            width: ScreenUtil().setWidth(50),
                            alignment: Alignment.center,
                            //边框设置
                            decoration: BoxDecoration(
                              //背景
                              color: sp.getInt('user_gender') == 1
                                  ? MyColors.dtBlue
                                  : MyColors.dtPink,
                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(20.0)),
                            ),
                            child: WidgetUtils.showImages(
                                sp.getInt('user_gender') == 1
                                    ? 'assets/images/nan.png'
                                    : 'assets/images/nv.png',
                                12,
                                12),
                          ),
                          WidgetUtils.commonSizedBox(0, 5),
                          // 用户等级
                          level != 0
                              ? Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    WidgetUtils.showImagesFill(
                                        (level >= 1 && level <= 10)
                                            ? 'assets/images/dj/dj_c_1-10.png'
                                            : (level >= 11 && level <= 15)
                                                ? 'assets/images/dj/dj_c_11-15.png'
                                                : (level >= 16 && level <= 20)
                                                    ? 'assets/images/dj/dj_c_16-20.png'
                                                    : (level >= 21 &&
                                                            level <= 25)
                                                        ? 'assets/images/dj/dj_c_21-25.png'
                                                        : (level >= 26 &&
                                                                level <= 30)
                                                            ? 'assets/images/dj/dj_c_26-30.png'
                                                            : (level >= 31 &&
                                                                    level <= 35)
                                                                ? 'assets/images/dj/dj_c_31-35.png'
                                                                : (level >= 36 &&
                                                                        level <=
                                                                            40)
                                                                    ? 'assets/images/dj/dj_c_36-40.png'
                                                                    : (level >= 41 &&
                                                                            level <=
                                                                                45)
                                                                        ? 'assets/images/dj/dj_c_41-45.png'
                                                                        : 'assets/images/dj/dj_c_46-50.png',
                                        ScreenUtil().setHeight(30),
                                        ScreenUtil().setHeight(85)),
                                    Positioned(
                                        left: 45.w,
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Text(
                                              'LV.${level.toString()}',
                                              style: TextStyle(
                                                  fontSize:
                                                      ScreenUtil().setSp(18),
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'ARIAL',
                                                  foreground: Paint()
                                                    ..style =
                                                        PaintingStyle.stroke
                                                    ..strokeWidth = 2
                                                    ..color = (level >= 1 &&
                                                            level <= 10)
                                                        ? MyColors.djOneM
                                                        : (level >= 11 &&
                                                                level <= 15)
                                                            ? MyColors.djTwoM
                                                            : (level >= 16 &&
                                                                    level <= 20)
                                                                ? MyColors
                                                                    .djThreeM
                                                                : (level >= 21 &&
                                                                        level <=
                                                                            25)
                                                                    ? MyColors
                                                                        .djFourM
                                                                    : (level >= 26 &&
                                                                            level <=
                                                                                30)
                                                                        ? MyColors
                                                                            .djFiveM
                                                                        : (level >= 31 &&
                                                                                level <= 35)
                                                                            ? MyColors.djSixM
                                                                            : (level >= 36 && level <= 40)
                                                                                ? MyColors.djSevenM
                                                                                : (level >= 41 && level <= 45)
                                                                                    ? MyColors.djEightM
                                                                                    : MyColors.djNineM),
                                            ),
                                            Text(
                                              'LV.${level.toString()}',
                                              style: TextStyle(
                                                  color: MyColors.djOne,
                                                  fontSize:
                                                      ScreenUtil().setSp(18),
                                                  fontWeight: FontWeight.w600,
                                                  fontFamily: 'ARIAL'),
                                            ),
                                          ],
                                        ))
                                  ],
                                )
                              : const Text(''),
                          WidgetUtils.commonSizedBox(0, 5),
                          GestureDetector(
                            onTap: (() {
                              Clipboard.setData(ClipboardData(
                                text: userNumber,
                              ));
                              MyToastUtils.showToastBottom('已成功复制到剪切板');
                            }),
                            child: Row(
                              children: [
                                Text(
                                  'ID:$userNumber',
                                  style: StyleUtils.getCommonTextStyle(
                                      color: MyColors.mineGrey,
                                      fontSize: ScreenUtil().setSp(25)),
                                ),
                                WidgetUtils.commonSizedBox(0, 10),
                                WidgetUtils.showImages(
                                    'assets/images/mine_fuzhi.png',
                                    ScreenUtil().setHeight(20),
                                    ScreenUtil().setHeight(20))
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: (() {
                    if (MyUtils.checkClick()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyInfoPage(),
                        ),
                      ).then((value) {
                        doPostMyIfon();
                      });
                    }
                  }),
                  child: Container(
                    color: Colors.transparent,
                    height: 50.h,
                    width: 80.h,
                    alignment: Alignment.centerRight,
                    child: Row(
                      children: [
                        const Spacer(),
                        WidgetUtils.onlyText(
                            '主页',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.mineGrey,
                                fontWeight: FontWeight.w600,
                                fontSize: ScreenUtil().setSp(25))),
                        WidgetUtils.commonSizedBox(0, 5),
                        WidgetUtils.showImages(
                            'assets/images/mine_more.png',
                            ScreenUtil().setHeight(22),
                            ScreenUtil().setHeight(10))
                      ],
                    ),
                  ),
                )
              ],
            ),
            WidgetUtils.commonSizedBox(18, 0),

            /// 升级贵族
            SizedBox(
              width: double.infinity,
              height: ScreenUtil().setHeight(200),
              child: Stack(
                children: [
                  WidgetUtils.showImagesFill('assets/images/mine_gz_bg.png',
                      ScreenUtil().setHeight(130), double.infinity),
                  GestureDetector(
                    onTap: (() {
                      if (MyUtils.checkClick()) {
                        MyUtils.goTransparentPageCom(
                            context, const TequanPage());
                      }
                    }),
                    child: Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(100),
                      padding: const EdgeInsets.only(right: 10),
                      color: Colors.transparent,
                      alignment: Alignment.centerRight,
                      child: guizuType == 1
                          ? WidgetUtils.myContainer(
                              ScreenUtil().setHeight(45),
                              ScreenUtil().setHeight(100),
                              Colors.transparent,
                              MyColors.mineOrange,
                              '已开通',
                              ScreenUtil().setSp(21),
                              MyColors.mineOrange)
                          : SizedBox(
                              width: ScreenUtil().setHeight(116),
                              height: ScreenUtil().setHeight(45),
                              child: const SVGASimpleImage(
                                assetsName: 'assets/svga/guizu_kt.svga',
                              )),
                    ),
                  ),
                  Container(
                      height: ScreenUtil().setHeight(150),
                      margin: EdgeInsets.only(top: ScreenUtil().setHeight(100)),
                      decoration: const BoxDecoration(
                        //背景
                        color: Colors.white,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child:

                          /// 关注
                          Row(
                        children: [
                          const Expanded(child: Text('')),
                          GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return CareHomePage(index: 0);
                                })).then((value) {
                                  doPostMyIfon();
                                });
                              }
                            }),
                            child: Column(
                              children: [
                                // Container(
                                //   width: ScreenUtil().setHeight(80),
                                //   alignment: Alignment.topRight,
                                //   child: Text(
                                //       '+1',
                                //       style : StyleUtils.getCommonTextStyle(
                                //           color: MyColors.mineRed,
                                //           fontSize: ScreenUtil().setSp(25))),
                                // ),
                                const Expanded(child: Text('')),
                                WidgetUtils.onlyText(
                                    care,
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenUtil().setSp(38),
                                        fontWeight: FontWeight.w600)),
                                WidgetUtils.onlyText(
                                    '关注',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.mineGrey,
                                        fontSize: ScreenUtil().setSp(21))),
                                const Expanded(child: Text('')),
                              ],
                            ),
                          ),
                          const Expanded(flex: 2, child: Text('')),
                          GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return CareHomePage(index: 1);
                                })).then((value) {
                                  doPostMyIfon();
                                });
                              }
                            }),
                            child: Column(
                              children: [
                                // Container(
                                //   width: ScreenUtil().setHeight(80),
                                //   alignment: Alignment.topRight,
                                //   child: Text(
                                //       '+1',
                                //       style : StyleUtils.getCommonTextStyle(
                                //           color: MyColors.mineRed,
                                //           fontSize: ScreenUtil().setSp(25))),
                                // ),
                                const Expanded(child: Text('')),
                                WidgetUtils.onlyText(
                                    beCare,
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenUtil().setSp(38),
                                        fontWeight: FontWeight.w600)),
                                WidgetUtils.onlyText(
                                    '被关注',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.mineGrey,
                                        fontSize: ScreenUtil().setSp(21))),
                                const Expanded(child: Text('')),
                              ],
                            ),
                          ),
                          const Expanded(flex: 2, child: Text('')),
                          GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return CareHomePage(index: 2);
                                })).then((value) {
                                  doPostMyIfon();
                                });
                              }
                            }),
                            child: Column(
                              children: [
                                // Container(
                                //   width: ScreenUtil().setHeight(80),
                                //   alignment: Alignment.topRight,
                                //   child: Text(
                                //       '+1',
                                //       style : StyleUtils.getCommonTextStyle(
                                //           color: MyColors.mineRed,
                                //           fontSize: ScreenUtil().setSp(25))),
                                // ),
                                const Expanded(child: Text('')),
                                WidgetUtils.onlyText(
                                    lookMe,
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.black,
                                        fontSize: ScreenUtil().setSp(38),
                                        fontWeight: FontWeight.w600)),
                                WidgetUtils.onlyText(
                                    '看过我',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.mineGrey,
                                        fontSize: ScreenUtil().setSp(21))),
                                const Expanded(child: Text('')),
                              ],
                            ),
                          ),
                          const Expanded(child: Text('')),
                        ],
                      ))
                ],
              ),
            ),
            WidgetUtils.commonSizedBox(18, 0),

            /// 展示信息
            WidgetUtils.containerNo(
                pad: 20,
                height: 670.h,
                width: double.infinity,
                color: Colors.white,
                ra: 20,
                w: Column(
                  children: [
                    /// 钱包 礼物记录
                    Row(
                      children: [
                        Expanded(
                            child: GestureDetector(
                          onTap: (() {
                            if (MyUtils.checkClick()) {
                              Navigator.pushNamed(context, 'WalletPage');
                            }
                          }),
                          child: WidgetUtils.containerNo(
                              height: ScreenUtil().setHeight(110),
                              width: double.infinity,
                              color: MyColors.mineYellow,
                              ra: 10,
                              w: Row(
                                children: [
                                  WidgetUtils.commonSizedBox(0, 10),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        const Expanded(child: Text('')),
                                        WidgetUtils.onlyText(
                                            '我的钱包',
                                            StyleUtils.getCommonTextStyle(
                                                color: Colors.black,
                                                fontSize:
                                                    ScreenUtil().setSp(32),
                                                fontWeight: FontWeight.w600)),
                                        WidgetUtils.onlyText(
                                            '充值、兑换',
                                            StyleUtils.getCommonTextStyle(
                                                color: MyColors.mineGrey,
                                                fontSize:
                                                    ScreenUtil().setSp(22))),
                                        const Expanded(child: Text('')),
                                      ],
                                    ),
                                  ),
                                  WidgetUtils.showImages(
                                      'assets/images/mine_qianbao.png',
                                      ScreenUtil().setHeight(67),
                                      ScreenUtil().setHeight(67)),
                                  WidgetUtils.commonSizedBox(0, 10),
                                ],
                              )),
                        )),
                        WidgetUtils.commonSizedBox(0, 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: (() {
                              if (MyUtils.checkClick()) {
                                Navigator.pushNamed(context, 'LiwuPage');
                              }
                            }),
                            child: WidgetUtils.containerNo(
                                height: ScreenUtil().setHeight(110),
                                width: double.infinity,
                                color: MyColors.minePink,
                                ra: 10,
                                w: Row(
                                  children: [
                                    WidgetUtils.commonSizedBox(0, 10),
                                    Expanded(
                                      child: Column(
                                        children: [
                                          const Expanded(child: Text('')),
                                          WidgetUtils.onlyText(
                                              '礼物记录',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.black,
                                                  fontSize:
                                                      ScreenUtil().setSp(32),
                                                  fontWeight: FontWeight.w600)),
                                          WidgetUtils.onlyText(
                                              '收送礼物明细',
                                              StyleUtils.getCommonTextStyle(
                                                  color: MyColors.mineGrey,
                                                  fontSize:
                                                      ScreenUtil().setSp(22))),
                                          const Expanded(child: Text('')),
                                        ],
                                      ),
                                    ),
                                    WidgetUtils.showImages(
                                        'assets/images/mine_liwu.png',
                                        ScreenUtil().setHeight(67),
                                        ScreenUtil().setHeight(67)),
                                    WidgetUtils.commonSizedBox(0, 10),
                                  ],
                                )),
                          ),
                        ),
                      ],
                    ),
                    WidgetUtils.commonSizedBox(20, 0),
                    WidgetUtils.whiteKuang(
                        'assets/images/mine_zhuangban.png', '我的装扮', false),
                    WidgetUtils.whiteKuang(
                        'assets/images/mine_gonghui.png', '公会中心', isShenHe),
                    isAgent == 1
                        ? WidgetUtils.whiteKuang(
                            'assets/images/mine_quan.png', '全民代理', false)
                        : WidgetUtils.commonSizedBox(0, 0),
                    WidgetUtils.whiteKuang(
                        'assets/images/mine_daili.png', '等级成就', false),
                    WidgetUtils.whiteKuang(
                        'assets/images/mine_kefu.png', '联系客服', false),
                  ],
                ))
          ],
        ) /* add child content here */,
      ),
    );
  }

  /// 我的详情
  Future<void> doPostMyIfon() async {
    Loading.show();
    var type;
    // 透明状态栏
    if (Platform.isAndroid) {
      type = '2';
    }
    if (Platform.isIOS) {
      type = '1';
    }

    // Map<String, dynamic> params = <String, dynamic>{
    //   'system': type,
    //   'version': sp.getString('myVersion1')
    // };
    try {
      MyInfoBean bean = await DataUtils.postMyIfon();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            sp.setString('shimingzhi', bean.data!.auditStatus.toString());
            sp.setString("user_headimg", bean.data!.avatar!);
            sp.setInt("user_gender", bean.data!.gender!);
            sp.setString("nickname", bean.data!.nickname!);
            sp.setString('user_id', bean.data!.uid.toString());
            userNumber = bean.data!.number.toString();
            care = bean.data!.followNum.toString();
            beCare = bean.data!.isFollowNum.toString();
            lookMe = bean.data!.lookNum.toString();
            guizuType = bean.data!.nobleId as int;
            identity = bean.data!.identity!;
            isAgent = bean.data!.isAgent as int;
            isNew = bean.data!.isNew as int;
            isNewNoble = bean.data!.newNoble as int;
            isPretty = bean.data!.isPretty as int;
            // 如果身份变了
            if (sp.getString('user_identity').toString() != identity) {
              eventBus.fire(SubmitButtonBack(title: '更换了身份'));
              sp.setString('user_identity', identity);
            }
            avatarFrameImg = bean.data!.avatarFrameImg!;
            avatarFrameGifImg = bean.data!.avatarFrameGifImg!;
            level = bean.data!.level as int;
            if (identity == 'leader' && bean.data!.unauditNum != 0) {
              isShenHe = true;
            } else {
              isShenHe = false;
            }
            kefuUid = bean.data!.kefuUid.toString();
            kefuAvatar = bean.data!.kefuAvatar!;
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
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 点击公会判断是否进行了实名制
  // Future<void> isShiMing(BuildContext context) async {
  //   return showDialog(
  //       context: context,
  //       builder: (context) {
  //         return CustomDialog(
  //           title: '',
  //           callback: (res) {
  //             if(sp.getString('shimingzhi').toString() == '2' || sp.getString('shimingzhi').toString() == '3'){
  //               Navigator.pushNamed(context, 'ShimingzhiPage');
  //             }else if(sp.getString('shimingzhi').toString() == '1'){
  //               MyToastUtils.showToastBottom('已认证');
  //             }else if(sp.getString('shimingzhi').toString() == '0'){
  //               MyToastUtils.showToastBottom('审核中，请耐心等待');
  //             }
  //           },
  //           content: '尚未实名制，请前往实名制页面上传信息后在使用！',
  //         );
  //       });
  // }

  /// 客服
  Future<void> doPostKefu() async {
    try {
      kefuBean bean = await DataUtils.postKefu();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            sp.setString('my_online', bean.data!.online!);
            sp.setString('my_qq', bean.data!.online!);
            sp.setString('my_telegram', bean.data!.online!);
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
