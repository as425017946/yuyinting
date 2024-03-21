import 'dart:io';

import 'package:flukit/flukit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:yuyinting/pages/message/care_home_page.dart';
import 'package:yuyinting/pages/mine/setting/setting_page.dart';
import 'package:yuyinting/pages/mine/tequan/tequan_page.dart';
import 'package:yuyinting/pages/mine/zhuangban/zhuangban_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';
import '../../bean/Common_bean.dart';
import '../../bean/kefuBean.dart';
import '../../bean/myInfoBean.dart';
import '../../colors/my_colors.dart';
import '../../config/config_screen_util.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/loading.dart';
import '../../utils/my_utils.dart';
import '../../utils/widget_utils.dart';
import '../../widget/Marquee.dart';
import 'gonghui/gonghui_home_page.dart';
import 'gonghui/my_gonghui_page.dart';
import 'huizhang/my_huizhang_page.dart';
import 'mine_smz_page.dart';
import 'my/my_info_page.dart';
import 'my/yqyl_page.dart';
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
  // 勿扰模式
  bool _switchValue = false;
  bool isWROk = false;
  // 是否有入住审核信息
  bool isShenHe = false;
  var listenSH;
  bool isGet = false;
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
                builder: (context) =>
                    GonghuiHomePage(kefuUid: kefuUid, kefuAvatar: kefuAvatar),
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
      } else if (event.title == '会长后台') {
        if (mounted) {
          Future.delayed(const Duration(seconds: 0), () {
            Navigator.of(context).push(PageRouteBuilder(
                opaque: false,
                pageBuilder: (context, animation, secondaryAnimation) {
                  return MyHuiZhangPage(
                    type: identity,
                  );
                }));
          }).then((value) {
            // doPostMyIfon();
          });
        }
      } else if (event.title == '邀请有礼') {
        if (mounted) {
          if (MyUtils.checkClick()) {
            MyUtils.goTransparentPage(
                context,
                YQYLPage(
                  kefuUid: kefuUid,
                  kefUavatar: kefuAvatar,
                ));
          }
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
    // doPostKefu();
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
        child: SingleChildScrollView(
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
                    WidgetUtils.showImages(
                        'assets/images/mine_icon_setting.png',
                        ScreenUtil().setHeight(40),
                        ScreenUtil().setHeight(40)),
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
                    child: SizedBox(
                      height: 140.h,
                      width: 140.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          WidgetUtils.CircleHeadImage(
                              ScreenUtil().setHeight(90),
                              ScreenUtil().setHeight(90),
                              sp.getString('user_headimg').toString()),
                          // 头像框静态图
                          (avatarFrameGifImg.isEmpty &&
                                  avatarFrameImg.isNotEmpty)
                              ? WidgetUtils.CircleHeadImage(
                                  ScreenUtil().setHeight(140),
                                  ScreenUtil().setHeight(140),
                                  avatarFrameImg)
                              : const Text(''),
                          // 头像框动态图
                          avatarFrameGifImg.isNotEmpty
                              ? SizedBox(
                                  height: 140.h,
                                  width: 140.h,
                                  child: SVGASimpleImage(
                                    resUrl: avatarFrameGifImg,
                                  ),
                                )
                              : const Text(''),
                        ],
                      ),
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
                                      'assets/images/dj/room_rui.png',
                                      30.h,
                                      50.h)
                                  : isNewNoble == 2
                                      ? WidgetUtils.showImages(
                                          'assets/images/dj/room_gui.png',
                                          30.h,
                                          50.h)
                                      : isNewNoble == 3
                                          ? WidgetUtils.showImages(
                                              'assets/images/dj/room_gui.png',
                                              30.h,
                                              50.h)
                                          : const Text(''),
                              isNewNoble != 0
                                  ? WidgetUtils.commonSizedBox(0, 5)
                                  : const Text(''),
                              isPretty == 1
                                  ? WidgetUtils.showImages(
                                      'assets/images/dj/lianghao.png',
                                      30.h,
                                      30.h)
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
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20.0)),
                              ),
                              child: WidgetUtils.showImages(
                                  sp.getInt('user_gender') == 1
                                      ? 'assets/images/nan.png'
                                      : 'assets/images/nv.png',
                                  ScreenUtil().setWidth(24), // 12,
                                  ScreenUtil().setWidth(24)), // 12,
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
                                                                      level <=
                                                                          35)
                                                                  ? 'assets/images/dj/dj_c_31-35.png'
                                                                  : (level >= 36 &&
                                                                          level <=
                                                                              40)
                                                                      ? 'assets/images/dj/dj_c_36-40.png'
                                                                      : (level >= 41 &&
                                                                              level <= 45)
                                                                          ? 'assets/images/dj/dj_c_41-45.png'
                                                                          : 'assets/images/dj/dj_c_46-50.png',
                                          ScreenUtil().setHeight(30),
                                          ScreenUtil().setHeight(85)),
                                      Positioned(
                                          left: 35.h, //45.w,
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
                                                                      level <=
                                                                          20)
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
                                                                          : (level >= 31 && level <= 35)
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
              _nobleCard(),
              WidgetUtils.commonSizedBox(18, 0),

              /// 展示信息
              // TODO:- 放开大客户系统
              /*
              _pageShow1(),
              WidgetUtils.commonSizedBox(18, 0),
              */
              _pageShow2(),
              /*WidgetUtils.containerNo(
                  pad: 20,
                  // height: 770.h,
                  width: double.infinity,
                  color: Colors.white,
                  ra: 20,
                  w: Column(
                    children: [
                      /// 钱包 礼物记录
                      _collection(),
                      WidgetUtils.commonSizedBox(20, 0),
                      WidgetUtils.whiteKuang(
                          'assets/images/mine_zhuangban.png', '我的装扮', false),
                      (identity != 'president' && isGet)
                          ? WidgetUtils.whiteKuang(
                              'assets/images/mine_gonghui.png',
                              '公会中心',
                              isShenHe)
                          : WidgetUtils.commonSizedBox(0, 0),
                      (identity == 'president' && isGet)
                          ? WidgetUtils.whiteKuang(
                              'assets/images/mine_huizhang.png',
                              '会长后台',
                              isShenHe)
                          : WidgetUtils.commonSizedBox(0, 0),
                      (isAgent != 1 && isGet)
                          ? WidgetUtils.whiteKuang(
                              'assets/images/mine_yaoqing.jpg', '邀请有礼', false)
                          : WidgetUtils.commonSizedBox(0, 0),
                      isAgent == 1
                          ? WidgetUtils.whiteKuang(
                              'assets/images/mine_quan.png', '全民代理', false)
                          : WidgetUtils.commonSizedBox(0, 0),
                      WidgetUtils.whiteKuang(
                          'assets/images/mine_daili.png', '等级成就', false),
                      WidgetUtils.whiteKuang(
                          'assets/images/mine_kefu.png', '联系客服', false),
                      Container(
                        width: double.infinity,
                        height: ScreenUtil().setHeight(90),
                        color: Colors.white,
                        child: Row(
                          children: [
                            Image(
                              image: const AssetImage(
                                  'assets/images/mine_wurao.jpg'),
                              width: ConfigScreenUtil.autoHeight40,
                              height: ConfigScreenUtil.autoHeight40,
                            ),
                            SizedBox(
                              width: ConfigScreenUtil.autoHeight10,
                            ),
                            WidgetUtils.onlyText(
                                '勿扰模式',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.black,
                                    fontSize: ScreenUtil().setSp(29))),
                            const Expanded(child: Text('')),
                            isWROk
                                ? Transform.translate(
                                    offset: Offset(15.h, 0),
                                    child: Transform.scale(
                                      scale: 0.8,
                                      child: CupertinoSwitch(
                                        value: _switchValue,
                                        onChanged: (value) {
                                          setState(() {
                                            _switchValue = value;
                                            if (value == false) {
                                              doPostSetDisturb('0');
                                            } else {
                                              doPostSetDisturb('1');
                                            }
                                          });
                                        },
                                        activeColor: MyColors.homeTopBG,
                                      ),
                                    ),
                                  )
                                : const Text(''),
                          ],
                        ),
                      ),
                    ],
                  ))*/
            ],
          ),
        ) /* add child content here */,
      ),
    );
  }

  /// 升级贵族
  Widget _nobleCard() {
    final height = ScreenUtil().setWidth(117).obs;
    Widget img = AfterLayout(
      callback: (RenderAfterLayout ral) {
        height.value = ral.size.height / 1.3;
      },
      child: const Image(
        image: AssetImage('assets/images/mine_gz_bg.png'),
        width: double.infinity,
        fit: BoxFit.fitWidth,
      ),
    );
    Widget num = Row(
      children: [
        const Expanded(child: Text('')),

        /// 关注
        GestureDetector(
          onTap: (() {
            if (MyUtils.checkClick()) {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
              Navigator.push(context, MaterialPageRoute(builder: (context) {
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
    );
    return Obx(() => SizedBox(
          width: double.infinity,
          height: ScreenUtil().setWidth(120) + height.value,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              img,
              GestureDetector(
                onTap: (() {
                  if (MyUtils.checkClick()) {
                    MyUtils.goTransparentPageCom(context, const TequanPage());
                  }
                }),
                child: Container(
                  width: double.infinity,
                  height: height.value,
                  padding: EdgeInsets.only(right: 20.w),
                  color: Colors.transparent,
                  alignment: Alignment.centerRight,
                  child: guizuType == 1
                      ? WidgetUtils.myContainer(
                          ScreenUtil().setWidth(45 * 1.3),
                          ScreenUtil().setWidth(100 * 1.3),
                          Colors.transparent,
                          MyColors.mineOrange,
                          '已开通',
                          ScreenUtil().setSp(21),
                          MyColors.mineOrange)
                      : SizedBox(
                          width: ScreenUtil().setWidth(116 * 1.3),
                          height: ScreenUtil().setWidth(45 * 1.3),
                          child: const SVGASimpleImage(
                            assetsName: 'assets/svga/guizu_kt.svga',
                          )),
                ),
              ),
              Container(
                  height: ScreenUtil().setWidth(120),
                  margin: EdgeInsets.only(top: height.value),
                  decoration: BoxDecoration(
                    //背景
                    color: Colors.white,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius: BorderRadius.all(Radius.circular(30.w)),
                  ),
                  child: num)
            ],
          ),
        ));
  }

  Widget _pageShow1() {
    return WidgetUtils.containerNo(
      pad: 20,
      width: double.infinity,
      color: Colors.white,
      ra: 20,
      w: _collection(),
    );
  }

  /// 钱包 礼物记录
  Widget _collection() {
    final Widget wallet = GestureDetector(
      onTap: (() {
        if (MyUtils.checkClick()) {
          Navigator.pushNamed(context, 'WalletPage');
        }
      }),
      child: _collectionItem(
        '我的钱包',
        '充值、兑换',
        MyColors.mineYellow,
        const Image(
          image: AssetImage('assets/images/mine_qianbao.png'),
          fit: BoxFit.contain,
        ),
      ),
    );
    final Widget liwu = GestureDetector(
      onTap: (() {
        if (MyUtils.checkClick()) {
          Navigator.pushNamed(context, 'LiwuPage');
        }
      }),
      child: _collectionItem(
        '礼物记录',
        '收送礼物明细',
        MyColors.minePink,
        const Image(
          image: AssetImage('assets/images/mine_liwu.png'),
          fit: BoxFit.contain,
        ),
      ),
    );
    return Row(
      children: [
        Expanded(child: wallet),
        SizedBox(width: 20.w),
        Expanded(child: liwu),
      ],
    );
  }

  Widget _pageShow2() {
    return WidgetUtils.containerNo(
        pad: 20,
        // height: 770.h,
        width: double.infinity,
        color: Colors.white,
        ra: 20,
        w: Column(
          children: [
            /// 经典等级 VIP等级
            // TODO:- 放开大客户系统
            _collection(),
            /*_collection2(),*/
            WidgetUtils.commonSizedBox(20, 0),
            WidgetUtils.whiteKuang(
                'assets/images/mine_zhuangban.png', '我的装扮', false),
            (identity != 'president' && isGet)
                ? WidgetUtils.whiteKuang(
                    'assets/images/mine_gonghui.png', '公会中心', isShenHe)
                : WidgetUtils.commonSizedBox(0, 0),
            (identity == 'president' && isGet)
                ? WidgetUtils.whiteKuang(
                    'assets/images/mine_huizhang.png', '会长后台', isShenHe)
                : WidgetUtils.commonSizedBox(0, 0),
            (isAgent != 1 && isGet)
                ? WidgetUtils.whiteKuang(
                    'assets/images/mine_yaoqing.jpg', '邀请有礼', false)
                : WidgetUtils.commonSizedBox(0, 0),
            isAgent == 1
                ? WidgetUtils.whiteKuang(
                    'assets/images/mine_quan.png', '全民代理', false)
                : WidgetUtils.commonSizedBox(0, 0),
            WidgetUtils.whiteKuang(
                'assets/images/mine_daili.png', '等级成就', false),
            WidgetUtils.whiteKuang(
                'assets/images/mine_kefu.png', '联系客服', false),
            Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(90),
              color: Colors.white,
              child: Row(
                children: [
                  Image(
                    image: const AssetImage('assets/images/mine_wurao.jpg'),
                    width: ConfigScreenUtil.autoHeight40,
                    height: ConfigScreenUtil.autoHeight40,
                  ),
                  SizedBox(
                    width: ConfigScreenUtil.autoHeight10,
                  ),
                  WidgetUtils.onlyText(
                      '勿扰模式',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(29))),
                  const Expanded(child: Text('')),
                  isWROk
                      ? Transform.translate(
                          offset: Offset(15.h, 0),
                          child: Transform.scale(
                            scale: 0.8,
                            child: CupertinoSwitch(
                              value: _switchValue,
                              onChanged: (value) {
                                setState(() {
                                  _switchValue = value;
                                  if (value == false) {
                                    doPostSetDisturb('0');
                                  } else {
                                    doPostSetDisturb('1');
                                  }
                                });
                              },
                              activeColor: MyColors.homeTopBG,
                            ),
                          ),
                        )
                      : const Text(''),
                ],
              ),
            ),
          ],
        ));
  }

  /// 经典等级 VIP等级
  Widget _collection2() {
    final Widget normal = GestureDetector(
      onTap: (() {
        if (MyUtils.checkClick()) {
          // Navigator.pushNamed(context, 'WalletPage');
        }
      }),
      child: _collectionItem(
        '经典等级',
        '成长等级',
        MyColors.mineGreen,
        _normalLevelIcon(),
      ),
    );
    final Widget vip = GestureDetector(
      onTap: (() {
        if (MyUtils.checkClick()) {
          Navigator.pushNamed(context, 'BigClientPage');
        }
      }),
      child: _collectionItem(
        'VIP 等级',
        'VIP 专属',
        MyColors.minePurple,
        const Text(''),
      ),
    );
    return Row(
      children: [
        Expanded(child: normal),
        SizedBox(width: 20.w),
        Expanded(child: vip),
      ],
    );
  }

  Widget _collectionItem(
      String title, String content, Color color, Widget child) {
    return FittedBox(
      fit: BoxFit.fitWidth,
      child: Container(
        width: 306,
        height: 133,
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: StyleUtils.getCommonTextStyle(
                        color: Colors.black,
                        fontSize: 33,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      content,
                      style: StyleUtils.getCommonTextStyle(
                        color: MyColors.mineGrey,
                        fontSize: 25,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 67,
                height: 69,
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _normalLevelIcon() {
    var children = <Widget>[
      Image(
          image: AssetImage(_normalDjIcon(level)),
          width: 67,
          height: 67,
          fit: BoxFit.contain,
          gaplessPlayback: true),
    ];
    if (level > 0) {
      children.add(Positioned(
          right: 0,
          bottom: -3,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Text(
                level.toString(),
                style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Impact',
                    foreground: Paint()
                      ..style = PaintingStyle.stroke
                      ..strokeWidth = 1
                      ..color = _normalDjColor(level)),
              ),
              Text(
                level.toString(),
                style: const TextStyle(
                    color: MyColors.djOne,
                    fontSize: 24,
                    fontWeight: FontWeight.normal,
                    fontFamily: 'Impact'),
              ),
            ],
          )));
    }
    return Stack(
      alignment: Alignment.centerLeft,
      children: children,
    );
  }

  String _normalDjIcon(int level) {
    if (level <= 10) {
      return 'assets/images/dj/dj_1-10.png';
    } else if (level <= 15) {
      return 'assets/images/dj/dj_11-15.png';
    } else if (level <= 20) {
      return 'assets/images/dj/dj_16-20.png';
    } else if (level <= 25) {
      return 'assets/images/dj/dj_21-25.png';
    } else if (level <= 30) {
      return 'assets/images/dj/dj_26-30.png';
    } else if (level <= 35) {
      return 'assets/images/dj/dj_31-35.png';
    } else if (level <= 40) {
      return 'assets/images/dj/dj_36-40.png';
    } else if (level <= 45) {
      return 'assets/images/dj/dj_41-45.png';
    } else {
      return 'assets/images/dj/dj_46-50.png';
    }
  }

  Color _normalDjColor(int level) {
    if (level <= 10) {
      return MyColors.djOneM;
    } else if (level <= 15) {
      return MyColors.djTwoM;
    } else if (level <= 20) {
      return MyColors.djThreeM;
    } else if (level <= 25) {
      return MyColors.djFourM;
    } else if (level <= 30) {
      return MyColors.djFiveM;
    } else if (level <= 35) {
      return MyColors.djSixM;
    } else if (level <= 40) {
      return MyColors.djSevenM;
    } else if (level <= 45) {
      return MyColors.djEightM;
    } else {
      return MyColors.djNineM;
    }
  }

/*
  Widget _collection1() {
    return Row(
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
                                fontSize: ScreenUtil().setSp(32),
                                fontWeight: FontWeight.w600)),
                        WidgetUtils.onlyText(
                            '充值、兑换',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.mineGrey,
                                fontSize: ScreenUtil().setSp(22))),
                        const Expanded(child: Text('')),
                      ],
                    ),
                  ),
                  WidgetUtils.showImages('assets/images/mine_qianbao.png',
                      ScreenUtil().setHeight(67), ScreenUtil().setHeight(67)),
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
                                  fontSize: ScreenUtil().setSp(32),
                                  fontWeight: FontWeight.w600)),
                          WidgetUtils.onlyText(
                              '收送礼物明细',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.mineGrey,
                                  fontSize: ScreenUtil().setSp(22))),
                          const Expanded(child: Text('')),
                        ],
                      ),
                    ),
                    WidgetUtils.showImages('assets/images/mine_liwu.png',
                        ScreenUtil().setHeight(67), ScreenUtil().setHeight(67)),
                    WidgetUtils.commonSizedBox(0, 10),
                  ],
                )),
          ),
        ),
      ],
    );
  }
*/
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
    try {
      MyInfoBean bean = await DataUtils.postMyIfon();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            isGet = true;
            // LogE('我的身份 == ${(identity != 'president' && isGet)}');
            sp.setString('shimingzhi', bean.data!.auditStatus.toString());
            sp.setString("user_headimg", bean.data!.avatar!);
            sp.setInt("user_gender", bean.data!.gender!);
            sp.setString("nickname", bean.data!.nickname!);
            sp.setString('user_id', bean.data!.uid.toString());
            sp.setString('user_phone', bean.data!.phone!);
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
            if (bean.data!.isDisturb == 0) {
              _switchValue = false;
            } else {
              _switchValue = true;
            }
            isWROk = true;
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 勿扰模式
  Future<void> doPostSetDisturb(String isDisturb) async {
    Map<String, dynamic> params = <String, dynamic>{
      'is_disturb': isDisturb,
    };
    try {
      CommonBean bean = await DataUtils.postSetDisturb(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (isDisturb == "0") {
              MyToastUtils.showToastBottom('勿扰模式已关闭');
            } else {
              MyToastUtils.showToastBottom('勿扰模式已开启，您现在只可收到互关用户消息');
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
