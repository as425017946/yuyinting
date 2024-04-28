import 'dart:io';
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
import '../../../utils/getx_tools.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/widget_utils.dart';
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
  // ignore: non_constant_identifier_names
  int _currentIndex = 0, gender = 0, is_pretty = 0, all_gift_type = 0;
  late final PageController _controller;
  String userNumber = '',
      // ignore: non_constant_identifier_names
      voice_card = '',
      description = '',
      city = '',
      constellation = '',
      avatarFrameImg = '',
      avatarFrameGifImg = '';
  // final TextEditingController _souSuoName = TextEditingController();
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
    _initialize();
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
    _mPlayer.stopPlayer().then((value) {
      setState(() {
        playRecord = false;
      });
    });
  }

  void _initialize() async {
    await _mPlayer.closePlayer();
    await _mPlayer.openPlayer();
  }

  @override
  void dispose() {
    super.dispose();
    if (_mPlayer.isPlaying) {
      _mPlayer.stopPlayer();
    }
  }

  @override
  Widget build(BuildContext context) {
    final imgHeight = Get.width;
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverAppBar(
                  pinned: true, //设置为true时，当SliverAppBar内容滑出屏幕时，将始终渲染一个固定在顶部的收起状态
                  expandedHeight: imgHeight * 0.6,
                  collapsedHeight: 56,
                  backgroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    // title: const Text("测试信息"),
                    centerTitle: true,
                    background: WidgetUtils.showImagesNet(sp.getString('user_headimg').toString(), imgHeight, double.infinity),
                  ),
                  actions: [
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
                        width: 99.h,
                        // height: 33.h,
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(right: 20.w),
                        padding: EdgeInsets.symmetric(horizontal: 33.h),
                        color: Colors.transparent,
                        child: WidgetUtils.showImages(
                            'assets/images/mine_edit_black.png',
                            ScreenUtil().setHeight(33),
                            ScreenUtil().setHeight(33)),
                      ),
                    ),
                  ],
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          //渐变位置
                            begin: Alignment.topCenter, //右上
                            end: Alignment.bottomCenter, //左下
                            stops: [
                              0.0,
                              1.0
                            ], //[渐变起始点, 渐变结束点]
                            //渐变颜色[始点颜色, 结束颜色]
                            colors: [
                              MyColors.newY5,
                              Colors.white
                            ]),
                      ),
                      height: Get.height - Get.statusBarHeight - 30 + 300.w,//1415.h,
                      child: _content(),
                    );
                  }, childCount: 1),
                ),
              ],
            ),
          ],
        ));
  }

  Widget _head() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      height: 280.w,
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
            child: Row(
              children: [
                SizedBox(
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
                      UserFrameHead(
                        size: 110.w,
                        avatar: sp.getString('user_headimg').toString(),
                        avatarFrameGifImg: avatarFrameGifImg,
                        avatarFrameImg: avatarFrameImg,
                      ),
                    ],
                  ),
                ),
                /// 音频
                voice_card.isNotEmpty
                    ? GestureDetector(
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
                              assetsName:
                              'assets/svga/audio_xindiaotu.svga',
                            )),
                        WidgetUtils.commonSizedBox(0, 10.h),
                        WidgetUtils.showImages(
                            'assets/images/people_bofang.png',
                            ScreenUtil().setHeight(35),
                            ScreenUtil().setWidth(35)),
                        WidgetUtils.commonSizedBox(0, 10.h),
                      ],
                    ),
                  ),
                )
                    : const Text(''),
              ],
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
                          fontSize: 24.sp,
                        ),
                      ),
                      WidgetUtils.commonSizedBox(0, 10.w),
                      WidgetUtils.showImages(
                        'assets/images/mine_fuzhi.png',
                        25.w,
                        25.w,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 60.w,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                if (gender != 0)
                Container(
                  height: 40.w,
                  width: 80.w,
                  margin: EdgeInsets.only(right: 10.w),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: gender == 1 ? MyColors.dtBlue : MyColors.dtPink,
                    borderRadius: BorderRadius.all(Radius.circular(25.w)),
                  ),
                  child: WidgetUtils.showImages(
                      gender == 1
                          ? 'assets/images/nan.png'
                          : 'assets/images/nv.png',
                      25.w,
                      25.w),
                ),
                // 只有不是新贵或者新锐的时候展示萌新
                if (isNew == 1 && isNewNoble == 0) ...[
                  WidgetUtils.showImagesFill(
                      'assets/images/dj/room_role_common.png', 45.w, 85.w),
                  WidgetUtils.commonSizedBox(0, 10.w)
                ],
                // 展示新贵或者新锐图标
                isNewNoble == 1
                    ? WidgetUtils.showImages(
                    'assets/images/dj/room_rui.png', 35.w, 85.w)
                    : isNewNoble == 2
                    ? WidgetUtils.showImages(
                    'assets/images/dj/room_gui.png', 35.w, 85.w)
                    : isNewNoble == 3
                    ? WidgetUtils.showImages(
                    'assets/images/dj/room_qc.png', 35.w, 85.w)
                    : const Text(''),
                isNewNoble != 0
                    ? WidgetUtils.commonSizedBox(0, 10.w)
                    : const Text(''),
                isPretty == 1
                    ? WidgetUtils.showImages(
                    'assets/images/dj/lianghao.png', 40.w, 40.w)
                    : const Text(''),
                isPretty == 1
                    ? WidgetUtils.commonSizedBox(0, 10.w)
                    : const Text(''),
                // 用户等级
                if (level > 0) ...[
                  CharmLevelFlag(level: level, width: 75.w, height: 30.w),
                  WidgetUtils.commonSizedBox(0, 10.w),
                ],
                // 财富等级
                if (grLevel > 0)
                  WealthLevelFlag(level: grLevel, width: 75.w, height: 30.w),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _content() {
    return Column(
      children: [
        _head(),
        Expanded(
          child: Container(
            height: double.infinity,
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                        alignment: Alignment.bottomLeft,
                        height: 80.w,
                        child: Row(
                          children: [
                            GestureDetector(
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
                            WidgetUtils.commonSizedBox(0, 20),
                            GestureDetector(
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
                          ],
                        )),
                  ],
                ),
                Row(
                  children: [
                    _currentIndex == 0
                        ? SizedBox(
                      width: ScreenUtil().setHeight(55),
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
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          const Expanded(child: Text('')),
                        ],
                      ),
                    )
                        : WidgetUtils.commonSizedBox(ScreenUtil().setHeight(10),
                        ScreenUtil().setHeight(55)),
                    WidgetUtils.commonSizedBox(0, 20),
                    _currentIndex == 1
                        ? SizedBox(
                      width: ScreenUtil().setHeight(68),
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
                              borderRadius:
                              BorderRadius.all(Radius.circular(10.0)),
                            ),
                          ),
                          const Expanded(child: Text('')),
                        ],
                      ),
                    )
                        : WidgetUtils.commonSizedBox(ScreenUtil().setHeight(10),
                        ScreenUtil().setHeight(68)),
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
  int grLevel = 0;
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
            sp.setString("user_sp.getString('user_headimg').toString()", bean.data!.userInfo!.avatarUrl!);
            sp.setString("nickname", bean.data!.userInfo!.nickname!);
            gender = bean.data!.userInfo!.gender as int;
            userNumber = bean.data!.userInfo!.number.toString();
            voice_card = bean.data!.userInfo!.voiceCardUrl!;
            is_pretty = bean.data!.userInfo!.isPretty as int;
            level = bean.data!.userInfo!.level as int;
            grLevel = bean.data!.userInfo!.grLevel as int;
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
