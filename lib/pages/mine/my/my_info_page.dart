import 'dart:io';

import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:yuyinting/bean/myHomeBean.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/style_utils.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../../widget/Marquee.dart';
import '../../../widget/SwiperPage.dart';
import 'edit_my_info_page.dart';
import 'my_dongtai_page.dart';
import 'my_ziliao_page.dart';
import 'package:get/get.dart';

/// 个人主页
class MyInfoPage extends StatefulWidget {
  const MyInfoPage({Key? key}) : super(key: key);

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
  var width0 = 0.0.obs;
  var width1 = 0.0.obs;
  int _currentIndex = 0, gender = 0, is_pretty = 0, all_gift_type = 0;
  late final PageController _controller;
  String userNumber = '',
      voice_card = '',
      description = '',
      city = '',
      constellation = '',
      avatarFrameImg = '',
      avatarFrameGifImg = '';
  final TextEditingController _souSuoName = TextEditingController();
  List<String> imageList = [];
  // 设备是安卓还是ios
  String isDevices = 'android';
  @override
  void initState() {
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
    _currentIndex = 0;
    _controller = PageController(
      initialPage: 0,
    );
    // _initialize();
    doPostMyIfon();
  }

  final FlutterSoundPlayer _mPlayer = FlutterSoundPlayer();
  bool playRecord = false; //音频文件播放状态
  //播放录音
  void play() {
    LogE('录音地址**$voice_card');
    _mPlayer
        .startPlayer(
            fromURI: voice_card,
            whenFinished: () {
              setState(() {
                playRecord = false;
              });
            })
        .then((value) {
      setState(() {
        playRecord = true;
      });
    });
  }

//停止播放录音
  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      setState(() {
        playRecord = false;
      });
    });
  }

  void _initialize() async {
    await _mPlayer!.closePlayer();
    await _mPlayer!.openPlayer();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_mPlayer.isPlaying) {
      _mPlayer.stopPlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            //设置Container修饰
            image: DecorationImage(
              //背景图片修饰
              image: AssetImage("assets/images/people_bg.jpg"),
              fit: BoxFit.fill, //覆盖
            ),
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              _bg(),
              _content(),
              _head(),
              _nav(),
            ],
          ),
        ));
  }

  Widget _nav() {
    ///头部信息
    return Container(
      height: ScreenUtil().setHeight(60),
      width: double.infinity,
      margin: EdgeInsets.only(top: isDevices == 'ios' ? 80.h : 60.h),
      alignment: Alignment.bottomLeft,
      child: Row(
        children: [
          Container(
            width: ScreenUtil().setWidth(100),
            padding: const EdgeInsets.only(left: 15),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              color: Colors.white,
              onPressed: (() {
                stopPlayer();
                Navigator.of(context).pop();
              }),
            ),
          ),
          const Expanded(child: Text('')),
          GestureDetector(
            onTap: (() {
              if (MyUtils.checkClick()) {
                stopPlayer();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EditMyInfoPage(),
                  ),
                ).then((value) {
                  doPostMyIfon();
                });
              }
            }),
            child: Container(
              width: 100.h,
              height: 33.h,
              color: Colors.transparent,
              child: WidgetUtils.showImages('assets/images/mine_edit.png',
                  ScreenUtil().setHeight(33), ScreenUtil().setHeight(33)),
            ),
          ),
          WidgetUtils.commonSizedBox(0, 10),
        ],
      ),
    );
  }

  Widget _bg() {
    return WidgetUtils.CircleImageNet(
      Get.width,
      Get.width,
      0,
      sp.getString('user_headimg').toString(),
    );
  }

  Widget _head() {
    final top = Get.width*0.7;
    return Container(
      margin: EdgeInsets.only(left: 20.w, right: 20.w, top: top - 80.w),
      height: 270.w,
      alignment: Alignment.topLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: (() {
              if (MyUtils.checkClick()) {
                Navigator.of(context).push(PageRouteBuilder(
                    opaque: false,
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return SwiperPage(imgList: imageList);
                    }));
              }
            }),
            child: SizedBox(
              width: 160.w,
              height: 160.w,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 120.w,
                    height: 120.w,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(60.w),
                    ),
                  ),
                  WidgetUtils.CircleHeadImage(110.w, 110.w, sp.getString('user_headimg').toString()),
                  // 头像框静态图
                  (avatarFrameGifImg.isEmpty && avatarFrameImg.isNotEmpty)
                      ? WidgetUtils.CircleHeadImage(150.w, 150.w, avatarFrameImg)
                      : const Text(''),
                  // 头像框动态图
                  avatarFrameGifImg.isNotEmpty
                      ? SizedBox(
                          height: 150.w,
                          width: 150.w,
                          child: SVGASimpleImage(
                            resUrl: avatarFrameGifImg,
                          ),
                        )
                      : const Text(''),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Text(
                  sp.getString('nickname').toString(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 42.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 20.w),
                GestureDetector(
                  onTap: (() {
                    Clipboard.setData(ClipboardData(
                      text: userNumber,
                    ));
                    MyToastUtils.showToastBottom('已成功复制到剪切板');
                  }),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      WidgetUtils.onlyText(
                          'ID: $userNumber',
                          StyleUtils.getCommonTextStyle(
                              color: Colors.black,
                              fontSize: 24.sp,),),
                      WidgetUtils.commonSizedBox(0, 10.w),
                      WidgetUtils.showImages(
                        'assets/images/people_fuzhi.png',
                        40.w,
                        40.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                gender != 0
                    ? Container(
                        height: 30.w,
                        width: 50.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: gender == 1 ? MyColors.dtBlue : MyColors.dtPink,
                          borderRadius: BorderRadius.all(Radius.circular(15.w)),
                        ),
                        child: WidgetUtils.showImages(
                          gender == 1 ? 'assets/images/nan.png' : 'assets/images/nv.png',
                          22.w,
                          22.w,
                        ),
                      )
                    : const Text(''),
                WidgetUtils.commonSizedBox(0, 10.w),
                // 只有不是新贵或者新锐的时候展示萌新
                (isNew == 1 && isNewNoble == 0)
                    ? WidgetUtils.showImages('assets/images/dj/room_role_common.png', 30.w, 50.w)
                    : const Text(''),
                (isNew == 1 && isNewNoble == 0)
                    ? WidgetUtils.commonSizedBox(0, 10.w)
                    : const Text(''),
                // 展示新贵或者新锐图标
                isNewNoble == 1
                    ? WidgetUtils.showImages(
                        'assets/images/dj/room_rui.png', 30.w, 50.w)
                    : isNewNoble == 2
                        ? WidgetUtils.showImages(
                            'assets/images/dj/room_gui.png', 30.w, 50.w)
                        : isNewNoble == 3
                            ? WidgetUtils.showImages(
                                'assets/images/dj/room_gui.png', 30.w, 50.w)
                            : const Text(''),
                isNewNoble != 0
                    ? WidgetUtils.commonSizedBox(0, 10.w)
                    : const Text(''),
                isPretty == 1
                    ? WidgetUtils.showImages(
                        'assets/images/dj/lianghao.png', 30.w, 30.w)
                    : const Text(''),
                isPretty == 1
                    ? WidgetUtils.commonSizedBox(0, 10.w)
                    : WidgetUtils.commonSizedBox(0, 0),
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
                                          : (level >= 21 && level <= 25)
                                              ? 'assets/images/dj/dj_c_21-25.png'
                                              : (level >= 26 && level <= 30)
                                                  ? 'assets/images/dj/dj_c_26-30.png'
                                                  : (level >= 31 && level <= 35)
                                                      ? 'assets/images/dj/dj_c_31-35.png'
                                                      : (level >= 36 &&
                                                              level <= 40)
                                                          ? 'assets/images/dj/dj_c_36-40.png'
                                                          : (level >= 41 &&
                                                                  level <= 45)
                                                              ? 'assets/images/dj/dj_c_41-45.png'
                                                              : 'assets/images/dj/dj_c_46-50.png',
                              30.w,
                              85.w,
                            ),
                          Positioned(
                              left: 30.w,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Text(
                                    'LV.${level.toString()}',
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'ARIAL',
                                        foreground: Paint()
                                          ..style = PaintingStyle.stroke
                                          ..strokeWidth = 2
                                          ..color = (level >= 1 && level <= 10)
                                              ? MyColors.djOneM
                                              : (level >= 11 && level <= 15)
                                                  ? MyColors.djTwoM
                                                  : (level >= 16 && level <= 20)
                                                      ? MyColors.djThreeM
                                                      : (level >= 21 &&
                                                              level <= 25)
                                                          ? MyColors.djFourM
                                                          : (level >= 26 &&
                                                                  level <= 30)
                                                              ? MyColors.djFiveM
                                                              : (level >= 31 &&
                                                                      level <=
                                                                          35)
                                                                  ? MyColors
                                                                      .djSixM
                                                                  : (level >= 36 &&
                                                                          level <=
                                                                              40)
                                                                      ? MyColors
                                                                          .djSevenM
                                                                      : (level >= 41 &&
                                                                              level <=
                                                                                  45)
                                                                          ? MyColors
                                                                              .djEightM
                                                                          : MyColors
                                                                              .djNineM),
                                  ),
                                  Text(
                                    'LV.${level.toString()}',
                                    style: TextStyle(
                                        color: MyColors.djOne,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'ARIAL'),
                                  ),
                                ],
                              ))
                        ],
                      )
                    : const Text(''),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _content() {
    var top = Get.width * 0.7;
    return Column(
      children: [
        /// 音频
        Container(
          height: top,
          alignment: Alignment.bottomRight,
          padding: EdgeInsets.all(20.w),
          child: voice_card.isNotEmpty
              ? Row(
                  children: [
                    GestureDetector(
                      onTap: (() {
                        if (MyUtils.checkClick() && playRecord == false) {
                          play();
                        }
                      }),
                      child: Container(
                          height: ScreenUtil().setHeight(45),
                          width: ScreenUtil().setWidth(220),
                          margin: const EdgeInsets.only(left: 20),
                          alignment: Alignment.center,
                          //边框设置
                          decoration: const BoxDecoration(
                            //背景
                            color: MyColors.peopleYellow,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                          ),
                          child: Row(
                            children: [
                              const Expanded(
                                  child: SVGASimpleImage(
                                assetsName: 'assets/svga/audio_xindiaotu.svga',
                              )),
                              WidgetUtils.commonSizedBox(0, 10.h),
                              WidgetUtils.showImages(
                                  'assets/images/people_bofang.png',
                                  ScreenUtil().setHeight(35),
                                  ScreenUtil().setWidth(35)),
                              WidgetUtils.commonSizedBox(0, 10.h),
                            ],
                          )
                          // playRecord == false
                          //     ? Row(
                          //         children: [
                          //           const Expanded(
                          //               child: SVGASimpleImage(
                          //             assetsName:
                          //                 'assets/svga/audio_xindiaotu.svga',
                          //           )),
                          //           WidgetUtils.commonSizedBox(0, 10.h),
                          //           WidgetUtils.showImages(
                          //               'assets/images/people_bofang.png',
                          //               ScreenUtil().setHeight(35),
                          //               ScreenUtil().setWidth(35)),
                          //           WidgetUtils.commonSizedBox(0, 10.h),
                          //         ],
                          //       )
                          //     : const Expanded(
                          //         child: SVGASimpleImage(
                          //         assetsName: 'assets/svga/audio_bolang.svga',
                          //       )),
                          ),
                    ),
                    const Expanded(child: Text('')),
                  ],
                )
              : const Text(''),
        ),
        Expanded(
          child: Container(
            height: double.infinity,
            padding: EdgeInsets.only(left: 20, right: 20, top: 180.w),
            //边框设置
            decoration: const BoxDecoration(
              //背景
              color: Colors.white,
              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                        alignment: Alignment.bottomLeft,
                        height: ScreenUtil().setHeight(80),
                        child: Row(
                          children: [
                            AfterLayout(
                              callback: (RenderAfterLayout ral) {
                                width0.value = ral.size.width; // 子组件在屏幕中坐标
                              },
                              child: GestureDetector(
                                onTap: (() {
                                  setState(() {
                                    _currentIndex = 0;
                                    _controller.animateToPage(0,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  });
                                }),
                                child: Text(
                                  '资料',
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: _currentIndex == 0
                                          ? Colors.black
                                          : MyColors.g6,
                                      fontSize: ScreenUtil().setSp(36),
                                      fontWeight: _currentIndex == 0
                                          ? FontWeight.w600
                                          : FontWeight.normal),
                                ),
                              ),
                            ),
                            WidgetUtils.commonSizedBox(0, 20),
                            AfterLayout(
                              callback: (RenderAfterLayout ral) {
                                width1.value = ral.size.width; // 子组件在屏幕中坐标
                              },
                              child: GestureDetector(
                                onTap: (() {
                                  setState(() {
                                    _currentIndex = 1;
                                    _controller.animateToPage(1,
                                        duration:
                                            const Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  });
                                }),
                                child: Text(
                                  '动态',
                                  style: TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: _currentIndex == 1
                                          ? Colors.black
                                          : MyColors.g6,
                                      fontSize: ScreenUtil().setSp(36),
                                      fontWeight: _currentIndex == 1
                                          ? FontWeight.w600
                                          : FontWeight.normal),
                                ),
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
                Row(
                  children: [
                    Obx(() {
                      return _currentIndex == 0
                          ? SizedBox(
                              width: width0.value, //ScreenUtil().setHeight(55),
                              height: ScreenUtil().setHeight(10),
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  Container(
                                    width: ScreenUtil().setHeight(20),
                                    height: ScreenUtil().setHeight(4),
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: MyColors.homeTopBG,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                  ),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            )
                          : WidgetUtils.commonSizedBox(
                              ScreenUtil().setHeight(10),
                              width0.value //ScreenUtil().setHeight(55)
                              );
                    }),
                    WidgetUtils.commonSizedBox(0, 20),
                    Obx(() {
                      return _currentIndex == 1
                          ? SizedBox(
                              width: width1.value, //ScreenUtil().setHeight(68),
                              height: ScreenUtil().setHeight(10),
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  Container(
                                    width: ScreenUtil().setHeight(20),
                                    height: ScreenUtil().setHeight(4),
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: MyColors.homeTopBG,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                  ),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            )
                          : WidgetUtils.commonSizedBox(
                              ScreenUtil().setHeight(10),
                              width1.value //ScreenUtil().setHeight(68)
                              );
                    }),
                  ],
                ),
                isOK
                    ? Expanded(
                        child: PageView(
                          reverse: false,
                          controller: _controller,
                          onPageChanged: (index) {
                            setState(() {
                              // 更新当前的索引值
                              _currentIndex = index;
                            });
                          },
                          children: [
                            MyZiliaoPage(
                              userInfo: userInfo,
                              giftList: giftList,
                            ),
                            const MyDongtaiPage(),
                          ],
                        ),
                      )
                    : const Text('')
              ],
            ),
          ),
        )
      ],
    );
  }

  /// 个人主页
  int level = 0;
  late MyUserInfo userInfo;
  late GiftList giftList;
  bool isOK = false;
  int isNew = 0; // 是否萌新
  int isPretty = 0; // 是否靓号
  int isNewNoble = 0; // 是否新贵

  Future<void> doPostMyIfon() async {
    LogE('token ${sp.getString('user_id')}');
    LogE('token ${sp.getString('user_token')}');
    Loading.show(MyConfig.successTitle);
    Map<String, dynamic> params = <String, dynamic>{
      'uid': sp.getString('user_id')
    };
    try {
      myHomeBean bean = await DataUtils.postMyHome(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            imageList.clear();
            isOK = true;
            sp.setString("user_headimg", bean.data!.userInfo!.avatarUrl!);
            sp.setString("nickname", bean.data!.userInfo!.nickname!);
            gender = bean.data!.userInfo!.gender as int;
            userNumber = bean.data!.userInfo!.number.toString();
            voice_card = bean.data!.userInfo!.voiceCardUrl!;
            is_pretty = bean.data!.userInfo!.isPretty as int;
            level = bean.data!.userInfo!.level as int;
            userInfo = bean.data!.userInfo!;
            giftList = bean.data!.giftList!;
            isNew = bean.data!.userInfo!.isNew as int;
            isPretty = bean.data!.userInfo!.isPretty as int;
            isNewNoble = bean.data!.userInfo!.newNoble as int;
            imageList.add(bean.data!.userInfo!.avatarUrl!);
            avatarFrameImg = bean.data!.userInfo!.avatarFrameImg!;
            avatarFrameGifImg = bean.data!.userInfo!.avatarFrameGifImg!;
          });
          // 发送通知
          eventBus.fire(myInfoBack(userInfo: userInfo, giftList: giftList));
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
      LogE('错误信息 ${e.toString()}');
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
