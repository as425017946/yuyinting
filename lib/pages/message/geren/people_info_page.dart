import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:yuyinting/pages/message/geren/ziliao_page.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../bean/Common_bean.dart';
import '../../../bean/joinRoomBean.dart';
import '../../../bean/userInfoBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/loading.dart';
import '../../../utils/log_util.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../../widget/SwiperPage.dart';
import '../../room/room_page.dart';
import '../../room/room_ts_mima_page.dart';
import '../chat_page.dart';
import 'dongtai_page.dart';

/// 他人主页
class PeopleInfoPage extends StatefulWidget {
  String otherId;
  String title;
  PeopleInfoPage({Key? key, required this.otherId, required this.title})
      : super(key: key);

  @override
  State<PeopleInfoPage> createState() => _PeopleInfoPageState();
}

class _PeopleInfoPageState extends State<PeopleInfoPage> {
  int _currentIndex = 0, is_pretty = 0, all_gift_type = 0, live = 0;
  late final PageController _controller; //
  // 0-未知 1-男 2-女
  int sex = 0;
  String headImg = '',
      headImgID = '',
      nickName = '',
      userNumber = '',
      voice_card = '',
      voice_cardID = '',
      description = '',
      city = '',
      photo_id = '',
      constellation = '',
      birthday = '',
      avatarFrameImg = '',
      avatarFrameGifImg = '';
  String isFollow = '', roomID = ''; //关注状态, 房间id

  List<String> imageList = [];

  List<String> list_p = [];
  List<String> list_pID = [];
  List<String> list_label = [];

  @override
  void initState() {
    super.initState();
    setState(() {
      sp.setBool('joinRoom', false);
    });
    _currentIndex = 0;
    _controller = PageController(
      initialPage: 0,
    );
    // _initialize();
    doPostUserInfo();
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

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    if (_mPlayer.isPlaying) {
      _mPlayer.stopPlayer();
    }
  }

  void _initialize() async {
    await _mPlayer!.closePlayer();
    await _mPlayer!.openPlayer();
  }

  bool isShow = false;
  int isBlack = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Container(
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
                  WidgetUtils.commonSizedBox(35, 0),

                  ///头部信息
                  Container(
                    height: ScreenUtil().setHeight(60),
                    width: double.infinity,
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (() {
                            Navigator.pop(context);
                          }),
                          child: Container(
                            width: 100.h,
                            color: Colors.transparent,
                            alignment: Alignment.center,
                            child: WidgetUtils.showImages(
                                'assets/images/back_other_white.png',
                                40.h,
                                40.h),
                          ),
                        ),
                        const Expanded(child: Text('')),
                      ],
                    ),
                  ),
                  WidgetUtils.commonSizedBox(10, 0),
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 0),
                    height: ScreenUtil().setHeight(170),
                    width: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: (() {
                            if (MyUtils.checkClick()) {
                              Navigator.of(context).push(PageRouteBuilder(
                                  opaque: false,
                                  pageBuilder:
                                      (context, animation, secondaryAnimation) {
                                    return SwiperPage(imgList: imageList);
                                  }));
                            }
                          }),
                          child: SizedBox(
                            width: 150.h,
                            height: 150.h,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                WidgetUtils.CircleHeadImage(
                                    ScreenUtil().setHeight(110),
                                    ScreenUtil().setHeight(110),
                                    headImg),
                                // 头像框静态图
                                (avatarFrameGifImg.isEmpty &&
                                        avatarFrameImg.isNotEmpty)
                                    ? WidgetUtils.CircleHeadImage(
                                        ScreenUtil().setHeight(150),
                                        ScreenUtil().setHeight(150),
                                        avatarFrameImg)
                                    : const Text(''),
                                // 头像框动态图
                                avatarFrameGifImg.isNotEmpty
                                    ? SizedBox(
                                        height: 150.h,
                                        width: 150.h,
                                        child: SVGASimpleImage(
                                          resUrl: avatarFrameGifImg,
                                        ),
                                      )
                                    : const Text(''),
                              ],
                            ),
                          ),
                        ),
                        WidgetUtils.commonSizedBox(0, 10),

                        ///昵称等信息
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Expanded(child: Text('')),
                              WidgetUtils.onlyText(
                                  nickName,
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.white,
                                      fontSize: ScreenUtil().setSp(38),
                                      fontWeight: FontWeight.w600)),
                              WidgetUtils.commonSizedBox(5, 0),
                              Row(
                                children: [
                                  sex != 0
                                      ? Container(
                                          height: ScreenUtil().setHeight(25),
                                          width: ScreenUtil().setWidth(50),
                                          alignment: Alignment.center,
                                          //边框设置
                                          decoration: BoxDecoration(
                                            //背景
                                            color: sex == 1
                                                ? MyColors.dtBlue
                                                : MyColors.dtPink,
                                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(
                                                    ScreenUtil().setHeight(25) /
                                                        2)),
                                          ),
                                          child: WidgetUtils.showImages(
                                              sex == 1
                                                  ? 'assets/images/nan.png'
                                                  : 'assets/images/nv.png',
                                              (12 * 2).w,
                                              (12 * 2).w),
                                        )
                                      : const Text(''),
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
                                  isPretty == 1
                                      ? WidgetUtils.commonSizedBox(0, 10.h)
                                      : WidgetUtils.commonSizedBox(0, 0),
                                  // 用户等级
                                  level != 0
                                      ? Stack(
                                          alignment: Alignment.centerLeft,
                                          children: [
                                            WidgetUtils.showImagesFill(
                                                (level >= 1 && level <= 10)
                                                    ? 'assets/images/dj/dj_c_1-10.png'
                                                    : (level >= 11 &&
                                                            level <= 15)
                                                        ? 'assets/images/dj/dj_c_11-15.png'
                                                        : (level >= 16 &&
                                                                level <= 20)
                                                            ? 'assets/images/dj/dj_c_16-20.png'
                                                            : (level >= 21 &&
                                                                    level <= 25)
                                                                ? 'assets/images/dj/dj_c_21-25.png'
                                                                : (level >= 26 &&
                                                                        level <=
                                                                            30)
                                                                    ? 'assets/images/dj/dj_c_26-30.png'
                                                                    : (level >= 31 &&
                                                                            level <=
                                                                                35)
                                                                        ? 'assets/images/dj/dj_c_31-35.png'
                                                                        : (level >= 36 &&
                                                                                level <= 40)
                                                                            ? 'assets/images/dj/dj_c_36-40.png'
                                                                            : (level >= 41 && level <= 45)
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
                                                          fontSize: ScreenUtil()
                                                              .setSp(18),
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontFamily: 'ARIAL',
                                                          foreground: Paint()
                                                            ..style =
                                                                PaintingStyle
                                                                    .stroke
                                                            ..strokeWidth = 2
                                                            ..color = (level >=
                                                                        1 &&
                                                                    level <= 10)
                                                                ? MyColors
                                                                    .djOneM
                                                                : (level >= 11 &&
                                                                        level <=
                                                                            15)
                                                                    ? MyColors
                                                                        .djTwoM
                                                                    : (level >= 16 &&
                                                                            level <=
                                                                                20)
                                                                        ? MyColors
                                                                            .djThreeM
                                                                        : (level >= 21 &&
                                                                                level <= 25)
                                                                            ? MyColors.djFourM
                                                                            : (level >= 26 && level <= 30)
                                                                                ? MyColors.djFiveM
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
                                                          fontSize: ScreenUtil()
                                                              .setSp(18),
                                                          fontWeight:
                                                              FontWeight.w600,
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
                                    maxWidth: ScreenUtil().setHeight(170),
                                    minHeight: ScreenUtil().setHeight(38),
                                  ),
                                  padding:
                                      const EdgeInsets.only(left: 8, right: 8),
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
                                              fontSize:
                                                  ScreenUtil().setSp(26))),
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
                        (live == 1 && widget.title != '小主页')
                            ? GestureDetector(
                                onTap: (() {
                                  if (sp.getString('roomID').toString() ==
                                      roomID) {
                                    if (MyUtils.checkClick()) {
                                      MyToastUtils.showToastBottom('您已在本房间');
                                    }
                                    return;
                                  } else {
                                    if (sp.getBool('joinRoom') == false) {
                                      setState(() {
                                        sp.setBool('joinRoom', true);
                                      });
                                      doPostBeforeJoin(roomID);
                                    }
                                  }
                                }),
                                child: Container(
                                  height: ScreenUtil().setHeight(40),
                                  width: ScreenUtil().setWidth(130),
                                  padding: const EdgeInsets.only(left: 8),
                                  alignment: Alignment.center,
                                  //边框设置
                                  decoration: const BoxDecoration(
                                    //背景
                                    color: Colors.white,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20.0),
                                      bottomLeft: Radius.circular(20.0),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      WidgetUtils.showImages(
                                          'assets/images/zhibozhong2.webp',
                                          ScreenUtil().setHeight(22),
                                          ScreenUtil().setWidth(22)),
                                      WidgetUtils.commonSizedBox(0, 5),
                                      WidgetUtils.onlyText(
                                          '踩房间',
                                          StyleUtils.getCommonTextStyle(
                                              color: MyColors.careBlue,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 21.sp)),
                                    ],
                                  ),
                                ),
                              )
                            : const Text(''),
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
                                if (MyUtils.checkClick() &&
                                    playRecord == false) {
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
                                // child: playRecord == false
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
                                //         assetsName:
                                //             'assets/svga/audio_bolang.svga',
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
                                      ZiliaoPage(otherId: widget.otherId),
                                      DongtaiPage(otherId: widget.otherId),
                                    ],
                                  ),
                                )
                              : const Text('')
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: ScreenUtil().setHeight(120),
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.center,
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
                      Color.fromRGBO(255, 255, 255, 0),
                      Color.fromRGBO(255, 255, 255, 1)
                    ])),
                child: Row(
                  children: [
                    // WidgetUtils.PeopleButton('assets/images/people_hongbao.png', '发红包', MyColors.peopleRed),
                    const Expanded(child: Text('')),
                    GestureDetector(
                        onTap: (() {
                          doPostFollow();
                        }),
                        child: WidgetUtils.PeopleButton(
                            'assets/images/people_jia.png',
                            isFollow == '0' ? '加关注' : '取消关注',
                            MyColors.peopleYellow)),
                    const Expanded(child: Text('')),
                    GestureDetector(
                      onTap: (() {
                        if (MyUtils.checkClick()) {
                          // 先判断能否发私聊
                          doPostCanSendUser();
                        }
                      }),
                      child: WidgetUtils.PeopleButton(
                          'assets/images/people_sixin.png',
                          '私信',
                          MyColors.peopleBlue2),
                    ),
                    const Expanded(child: Text('')),
                  ],
                ),
              ),
            ),
            Positioned(
              right: 10.h,
              top: 50.h,
              child: GestureDetector(
                onTap: (() {
                  setState(() {
                    isShow = true;
                  });
                }),
                child: Container(
                  width: ScreenUtil().setWidth(120),
                  height: 60.h,
                  color: Colors.transparent,
                  alignment: Alignment.centerRight,
                  child: WidgetUtils.showImages(
                      'assets/images/chat_dian_white.png',
                      ScreenUtil().setHeight(50),
                      ScreenUtil().setHeight(80)),
                ),
              ),
            ),
            // 头部黑名单
            isShow
                ? GestureDetector(
                    onTap: (() {
                      setState(() {
                        isShow = false;
                      });
                    }),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      alignment: Alignment.topRight,
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                isShow = false;
                              });
                              doPostUpdateBlack();
                            }),
                            child: Container(
                              height: ScreenUtil().setHeight(80),
                              width: ScreenUtil().setHeight(220),
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(100), right: 15),
                              //边框设置
                              decoration: const BoxDecoration(
                                //背景
                                color: Colors.white,
                                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  WidgetUtils.showImages(
                                      'assets/images/chat_black_p.png',
                                      ScreenUtil().setHeight(42),
                                      ScreenUtil().setHeight(38)),
                                  WidgetUtils.commonSizedBox(
                                      0, ScreenUtil().setHeight(10)),
                                  WidgetUtils.onlyText(
                                      isBlack == 0 ? '加入黑名单' : '移除黑名单',
                                      StyleUtils.loginHintTextStyle),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : const Text(''),
          ],
        ));
  }

  /// 查看用户
  int level = 0;
  bool isOK = false;
  int isNew = 0; // 是否萌新
  int isPretty = 0; // 是否靓号
  int isNewNoble = 0; // 是否新贵
  Future<void> doPostUserInfo() async {
    LogE('用户token ${sp.getString('user_token')}');
    Loading.show(MyConfig.successTitle);
    Map<String, dynamic> params = <String, dynamic>{'uid': widget.otherId};
    try {
      userInfoBean bean = await DataUtils.postUserInfo(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          list_p.clear();
          imageList.clear();
          setState(() {
            isOK = true;
            sp.setString("label_id", bean.data!.labelId!);
            headImg = bean.data!.avatarUrl!;
            imageList.add(headImg);
            headImgID = bean.data!.avatar.toString();
            sex = bean.data!.gender as int;
            nickName = bean.data!.nickname!;
            userNumber = bean.data!.number.toString();
            voice_card = bean.data!.voiceCardUrl!;
            voice_cardID = bean.data!.voiceCard.toString();
            birthday = bean.data!.birthday!;
            description = bean.data!.description!;
            city = bean.data!.city!;
            live = bean.data!.live as int;
            isFollow = bean.data!.isFollow!;
            roomID = bean.data!.roomID.toString();
            level = bean.data!.level as int;
            isNew = bean.data!.isNew as int;
            isPretty = bean.data!.isPretty as int;
            isNewNoble = bean.data!.newNoble as int;
            avatarFrameImg = bean.data!.avatarFrameImg!;
            avatarFrameGifImg = bean.data!.avatarFrameGifImg!;
            if (bean.data!.label!.isNotEmpty) {
              list_label = bean.data!.label!.split(',');
            }
            if (bean.data!.photoId!.isNotEmpty) {
              list_pID = bean.data!.photoId!.split(',');
              if (bean.data!.photoUrl!.length > 4) {
                list_p.add(bean.data!.photoUrl![0]);
                list_p.add(bean.data!.photoUrl![1]);
                list_p.add(bean.data!.photoUrl![2]);
                list_p.add(bean.data!.photoUrl![3]);
              } else {
                list_p = bean.data!.photoUrl!;
              }
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
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      LogE('错误  ${e.toString()}');
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 能否发私聊
  Future<void> doPostCanSendUser() async {
    Map<String, dynamic> params = <String, dynamic>{'uid': widget.otherId};
    try {
      CommonBean bean = await DataUtils.postCanSendUser(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          //可以发私聊跳转
          // ignore: use_build_context_synchronously
          MyUtils.goTransparentRFPage(
              context,
              ChatPage(
                  nickName: nickName,
                  otherUid: widget.otherId,
                  otherImg: headImg));
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

  /// 取消关注
  Future<void> doPostFollow() async {
    //是否关注 1关注 0取关
    String type = '';
    if (isFollow == '1') {
      type = '0';
    } else {
      type = '1';
    }
    Map<String, dynamic> params = <String, dynamic>{
      'type': '1',
      'status': type,
      'follow_id': widget.otherId,
    };
    try {
      CommonBean bean = await DataUtils.postFollow(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (isFollow == '1') {
              isFollow = '0';
            } else {
              isFollow = '1';
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

  /// 加入房间前
  Future<void> doPostBeforeJoin(roomID) async {
    //判断房间id是否为空的
    if (sp.getString('roomID') == null || sp.getString('').toString().isEmpty) {
    } else {
      // 不是空的，并且不是之前进入的房间
      if (sp.getString('roomID').toString() != roomID) {
        sp.setString('roomID', roomID);
        eventBus.fire(SubmitButtonBack(title: '加入其他房间'));
      }
    }
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
    };
    try {
      Loading.show();
      joinRoomBean bean = await DataUtils.postBeforeJoin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          doPostRoomJoin(roomID, '', bean.data!.rtc!);
          break;
        case MyHttpConfig.errorRoomCode: //需要密码
          // ignore: use_build_context_synchronously
          MyUtils.goTransparentPageCom(
              context,
              RoomTSMiMaPage(
                  roomID: roomID, roomToken: bean.data!.rtc!, anchorUid: ''));
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          setState(() {
            sp.setBool('joinRoom', false);
          });
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      setState(() {
        sp.setBool('joinRoom', false);
      });
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 加入房间
  Future<void> doPostRoomJoin(roomID, password, roomToken) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
      'password': password
    };
    try {
      Loading.show();
      CommonBean bean = await DataUtils.postRoomJoin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          // ignore: use_build_context_synchronously
          MyUtils.goTransparentRFPage(
              context,
              RoomPage(
                roomId: roomID,
                beforeId: '',
                roomToken: roomToken,
              ));
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          setState(() {
            sp.setBool('joinRoom', false);
          });
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      setState(() {
        sp.setBool('joinRoom', false);
      });
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 加入/取消黑名单
  Future<void> doPostUpdateBlack() async {
    //0解除 1拉黑
    Map<String, dynamic> params = <String, dynamic>{
      'type': isBlack == 0 ? '1' : '0',
      'black_uid': widget.otherId,
    };
    try {
      CommonBean bean = await DataUtils.postUpdateBlack(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          if (isBlack == 0) {
            setState(() {
              isBlack = 1;
            });
          } else {
            setState(() {
              isBlack = 0;
            });
          }
          if (isBlack == 0) {
            MyToastUtils.showToastBottom("移除黑名单！");
          } else {
            MyToastUtils.showToastBottom("成功加入黑名单！");
          }
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
