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
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../../widget/Marquee.dart';
import '../../../widget/SwiperPage.dart';
import 'edit_my_info_page.dart';
import 'my_dongtai_page.dart';
import 'my_ziliao_page.dart';

/// 个人主页
class MyInfoPage extends StatefulWidget {
  const MyInfoPage({Key? key}) : super(key: key);

  @override
  State<MyInfoPage> createState() => _MyInfoPageState();
}

class _MyInfoPageState extends State<MyInfoPage> {
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
    }else if (Platform.isIOS){
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
    if(_mPlayer.isPlaying) {
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
          child: Column(
            children: [
              WidgetUtils.commonSizedBox(isDevices == 'ios' ? 80.h : 60.h, 0),
              ///头部信息
              Container(
                height: ScreenUtil().setHeight(60),
                width: double.infinity,
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
                        child: WidgetUtils.showImages(
                            'assets/images/mine_edit.png',
                            ScreenUtil().setHeight(33),
                            ScreenUtil().setHeight(33)),
                      ),
                    ),
                    WidgetUtils.commonSizedBox(0, 10),
                  ],
                ),
              ),
              WidgetUtils.commonSizedBox(10, 0),
              Container(
                margin: const EdgeInsets.only(left: 20, right: 0),
                height: ScreenUtil().setHeight(150),
                width: double.infinity,
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: ((){
                        if(MyUtils.checkClick()){
                          Navigator.of(context).push(PageRouteBuilder(
                              opaque: false,
                              pageBuilder: (context, animation, secondaryAnimation) {
                                return SwiperPage(imgList: imageList);
                              }));
                        }
                      }),
                      child: WidgetUtils.CircleHeadImage(
                          ScreenUtil().setHeight(150),
                          ScreenUtil().setHeight(150),
                          sp.getString('user_headimg').toString()),
                    ),
                    WidgetUtils.commonSizedBox(0, 10),

                    ///昵称等信息
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Expanded(child: Text('')),
                          sp.getString('nickname').toString().length > 10
                              ? Marquee(
                                  speed: 20,
                                  child: Text(
                                    "${sp.getString('nickname')}    ${sp.getString('nickname')}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: ScreenUtil().setSp(35),
                                        fontWeight: FontWeight.w600),
                                  ),
                                )
                              : WidgetUtils.onlyText(
                                  sp.getString('nickname').toString(),
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: 35.sp,
                                      fontWeight: FontWeight.w600)),
                          WidgetUtils.commonSizedBox(5, 0),
                          Row(
                            children: [
                              gender != 0 ? Container(
                                height: ScreenUtil().setHeight(25),
                                width: ScreenUtil().setWidth(50),
                                alignment: Alignment.center,
                                //边框设置
                                decoration: BoxDecoration(
                                  //背景
                                  color: gender == 1
                                      ? MyColors.dtBlue
                                      : MyColors.dtPink,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(20.0)),
                                ),
                                child: WidgetUtils.showImages(
                                    gender == 1
                                        ? 'assets/images/nan.png'
                                        : 'assets/images/nv.png',
                                    12,
                                    12),
                              ) : const Text(''),
                              WidgetUtils.commonSizedBox(0, 10.h),
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
                                  :  isNewNoble == 3 ? WidgetUtils.showImages(
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
                              isPretty == 1 ? WidgetUtils.commonSizedBox(0, 10.h) : WidgetUtils.commonSizedBox(0, 0),
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
                            ],
                          ),
                          WidgetUtils.commonSizedBox(5, 0),
                          GestureDetector(
                            onTap: (() {
                              Clipboard.setData(ClipboardData(
                                text: userNumber,
                              ));
                              MyToastUtils.showToastBottom('已成功复制到剪切板');
                            }),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: ScreenUtil().setHeight(180),
                                minHeight: ScreenUtil().setHeight(38),
                              ),
                              padding: const EdgeInsets.only(left: 8, right: 8),
                              alignment: Alignment.center,
                              //边框设置
                              decoration: const BoxDecoration(
                                //背景
                                color: MyColors.peopleBlue,
                                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  WidgetUtils.onlyText(
                                      'ID:$userNumber',
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize: ScreenUtil().setSp(26))),
                                  WidgetUtils.commonSizedBox(0, 5),
                                  WidgetUtils.showImages(
                                      'assets/images/people_fuzhi.png',
                                      ScreenUtil().setHeight(22),
                                      ScreenUtil().setWidth(22)),
                                ],
                              ),
                            ),
                          ),
                          const Expanded(child: Text('')),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              WidgetUtils.commonSizedBox(10, 0),

              /// 音频
              voice_card.isNotEmpty
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
              WidgetUtils.commonSizedBox(15, 0),
              Expanded(
                child: Container(
                  height: double.infinity,
                  padding: const EdgeInsets.only(left: 20, right: 20),
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
                                  GestureDetector(
                                    onTap: (() {
                                      setState(() {
                                        _currentIndex = 0;
                                        _controller.animateToPage(0,
                                            duration: const Duration(
                                                milliseconds: 500),
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
                                            duration: const Duration(
                                                milliseconds: 500),
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
                                  ScreenUtil().setHeight(68)),
                        ],
                      ),
                      isOK ? Expanded(
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
                            MyZiliaoPage(userInfo: userInfo, giftList: giftList,),
                            const MyDongtaiPage(),
                          ],
                        ),
                      ) : const Text('')
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
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
