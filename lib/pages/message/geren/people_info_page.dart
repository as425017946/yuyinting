import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:get/get.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:yuyinting/config/online_config.dart';
import 'package:yuyinting/pages/message/geren/ziliao_page.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../bean/CommonIntBean.dart';
import '../../../bean/Common_bean.dart';
import '../../../bean/joinRoomBean.dart';
import '../../../bean/userInfoBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/getx_tools.dart';
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
  final String otherId;
  final String title;

  const PeopleInfoPage({Key? key, required this.otherId, required this.title})
      : super(key: key);

  @override
  State<PeopleInfoPage> createState() => _PeopleInfoPageState();
}

class _PeopleInfoPageState extends State<PeopleInfoPage> {
  // ignore: non_constant_identifier_names
  int _currentIndex = 0, is_pretty = 0, all_gift_type = 0, live = 0;
  late final PageController _controller; //
  // 0-未知 1-男 2-女
  int sex = 0;
  int nobleID = 0; // 贵族
  String headImg = '',
      headImgID = '',
      nickName = '',
      userNumber = '',
      // ignore: non_constant_identifier_names
      voice_card = '',
      // ignore: non_constant_identifier_names
      voice_cardID = '',
      description = '',
      city = '',
      // ignore: non_constant_identifier_names
      photo_id = '',
      constellation = '',
      birthday = '',
      avatarFrameImg = '',
      avatarFrameGifImg = '';
  String isFollow = '', roomID = ''; //关注状态, 房间id

  List<String> imageList = [];

  // ignore: non_constant_identifier_names
  List<String> list_p = [];

  // ignore: non_constant_identifier_names
  List<String> list_pID = [];

  // ignore: non_constant_identifier_names
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
    _initialize();
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
  //停止播放录音
  void stopPlayer() {
    _mPlayer.stopPlayer().then((value) {
      setState(() {
        playRecord = false;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (_mPlayer.isPlaying) {
      _mPlayer.stopPlayer();
    }
  }

  void _initialize() async {
    await _mPlayer.closePlayer();
    await _mPlayer.openPlayer();
  }

  bool isShow = false;
  int isBlack = 0;

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
                  pinned: true,
                  //设置为true时，当SliverAppBar内容滑出屏幕时，将始终渲染一个固定在顶部的收起状态
                  expandedHeight: imgHeight * 0.6,
                  collapsedHeight: 56,
                  backgroundColor: Colors.white,
                  flexibleSpace: FlexibleSpaceBar(
                    // title: const Text("测试信息"),
                    centerTitle: true,
                    background: WidgetUtils.showImagesNet(
                        headImg.isEmpty ? '' : headImg,
                        imgHeight,
                        double.infinity),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    return Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            //渐变位置
                            begin: Alignment.topCenter, //右上
                            end: Alignment.bottomCenter, //左下
                            stops: [0.0, 1.0], //[渐变起始点, 渐变结束点]
                            //渐变颜色[始点颜色, 结束颜色]
                            colors: [MyColors.newY5, Colors.white]),
                      ),
                      height: Get.height - getxWindowPadding.top - 60 + 300.w,
                      child: _content(),
                    );
                  }, childCount: 1),
                ),
              ],
            ),
            Positioned(
              right: 40.w,
              top: 78.h,
              child: GestureDetector(
                onTap: (() {
                  setState(() {
                    isShow = true;
                  });
                }),
                child: Container(
                  width: ScreenUtil().setWidth(120),
                  height: 60.w,
                  color: Colors.transparent,
                  alignment: Alignment.centerRight,
                  child: WidgetUtils.showImages(
                    'assets/images/chat_dian.png',
                    30.w,
                    60.w,
                  ),
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
                                  top: ScreenUtil().setHeight(120), right: 15),
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
                        child: WidgetUtils.showImagesFill(
                            isFollow == '0'
                                ? 'assets/images/zy_guanzhu1.png'
                                : 'assets/images/zy_guanzhu2.png',
                            75.h,
                            300.w)),
                    const Expanded(child: Text('')),
                    GestureDetector(
                        onTap: (() {
                          if (MyUtils.checkClick()) {
                            // 先判断能否发私聊
                            doPostCanSendUser();
                          }
                        }),
                        child: WidgetUtils.showImagesFill(
                            'assets/images/zy_chat.png', 75.h, 300.w)),
                    const Expanded(child: Text('')),
                  ],
                ),
              ),
            ),
          ],
        ));
  }

  Widget _head() {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        height: 290.w,
        color: Colors.transparent,
        alignment: Alignment.topLeft,
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                                avatar: headImg,
                                avatarFrameGifImg: avatarFrameGifImg,
                                avatarFrameImg: avatarFrameImg,
                              ),
                            ],
                          ),
                        ),

                        /// 音频
                        if (voice_card.isNotEmpty)
                          Padding(
                            padding: EdgeInsets.only(left: 40.w),
                            child: GestureDetector(
                              onTap: (() {
                                if (MyUtils.checkClick()) {
                                  if (playRecord) {
                                    stopPlayer();
                                  } else {
                                    play();
                                  }
                                }
                              }),
                              child: VoiceCardBtn(isPlay: playRecord, top: 0),
                            ),
                          ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Row(
                      children: [
                        nobleID != 0
                            ? ShaderMask(
                                shaderCallback: (Rect bounds) {
                                  return const LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFF6ffffd),
                                      Color(0xFFf8fec4)
                                    ],
                                  ).createShader(Offset.zero & bounds.size);
                                },
                                blendMode: BlendMode.srcATop,
                                child: Text(
                                  nickName,
                                  style: TextStyle(
                                      fontSize: ScreenUtil().setSp(42),
                                      color: const Color(0xffffffff),
                                      fontWeight: FontWeight.w700),
                                ),
                              )
                            : Text(
                                nickName,
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
                    color: Colors.transparent,
                    child: Row(
                      children: [
                        if (sex != 0)
                          Container(
                            height: 40.w,
                            width: 80.w,
                            margin: EdgeInsets.only(right: 10.w),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color:
                                  sex == 1 ? MyColors.dtBlue : MyColors.dtPink,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.w)),
                            ),
                            child: WidgetUtils.showImages(
                              sex == 1
                                  ? 'assets/images/nan.png'
                                  : 'assets/images/nv.png',
                              25.w,
                              25.w,
                            ),
                          ),
                        // 只有不是新贵或者新锐的时候展示萌新
                        if (isNew == 1 && isNewNoble == 0) ...[
                          WidgetUtils.showImagesFill(
                            'assets/images/dj/room_role_common.png',
                            45.w,
                            85.w,
                          ),
                          WidgetUtils.commonSizedBox(0, 10.w),
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
                                        'assets/images/dj/room_qc.png',
                                        35.w,
                                        85.w)
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
                            : const Text(''),
                        // 用户等级
                        if (level > 0) ...[
                          CharmLevelFlag(
                              level: level, width: 75.w, height: 30.w),
                          WidgetUtils.commonSizedBox(0, 10.w),
                        ],
                        // 财富等级
                        if (grLevel > 0)
                          WealthLevelFlag(
                              level: grLevel, width: 75.w, height: 30.w),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 30.w, right: 20.w, left: 10.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 40.w,
                    child:
                        (live == 1 && widget.title != '小主页') ? _follow() : null,
                  ),
                  nobleID > 0
                      ? SizedBox(
                          height: 220.w,
                          width: 150.w,
                          child: SVGASimpleImage(
                            assetsName: nobleID == 1
                                ? 'assets/svga/gz/gz_xuanxian.svga'
                                : nobleID == 2
                                    ? 'assets/svga/gz/gz_shangxianxian.svga'
                                    : nobleID == 3
                                        ? 'assets/svga/gz/gz_jinxian.svga'
                                        : nobleID == 4
                                            ? 'assets/svga/gz/gz_xiandi.svga'
                                            : nobleID == 5
                                                ? 'assets/svga/gz/gz_zhushen.svga'
                                                : nobleID == 6
                                                    ? 'assets/svga/gz/gz_tianshen.svga'
                                                    : nobleID == 7
                                                        ? 'assets/svga/gz/gz_shenwang.svga'
                                                        : nobleID == 8
                                                            ? 'assets/svga/gz/gz_shenhuang.svga'
                                                            : nobleID == 9
                                                                ? 'assets/svga/gz/gz_tianzun.svga'
                                                                : 'assets/svga/gz/gz_chuanshuo.svga',
                          ),
                        )
                      : WidgetUtils.commonSizedBox(220.w, 150.w),
                ],
              ),
            ),
          ],
        ));
  }

  /// 房间
  Widget _follow() {
    return GestureDetector(
      onTap: (() {
        if (sp.getString('roomID').toString() == roomID) {
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
        height: 40.w,
        width: 160.w,
        padding: EdgeInsets.only(left: 5.w),
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          //设置Container修饰
          image: DecorationImage(
            //背景图片修饰
            image: AssetImage('assets/images/people_info_room.png'),
            fit: BoxFit.contain, //覆盖
          ),
        ),
        child: Row(
          children: [
            WidgetUtils.CircleHeadImage(30.w, 30.w, headImg),
            WidgetUtils.commonSizedBox(0, 10.w),
            WidgetUtils.showImages('assets/images/zhibo2.webp', 22.w, 22.w),
            WidgetUtils.commonSizedBox(0, 5.w),
            WidgetUtils.onlyText(
              '跟TA进房',
              StyleUtils.getCommonTextStyle(
                color: Colors.white,
                fontSize: 18.sp,
              ),
            ),
          ],
        ),
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
            padding: const EdgeInsets.symmetric(horizontal: 20),
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
    );
  }

  /// 查看用户
  int level = 0;
  int grLevel = 0;
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
            grLevel = bean.data!.grLevel as int;
            isNew = bean.data!.isNew as int;
            isPretty = bean.data!.isPretty as int;
            isNewNoble = bean.data!.newNoble as int;
            avatarFrameImg = bean.data!.avatarFrameImg!;
            avatarFrameGifImg = bean.data!.avatarFrameGifImg!;
            nobleID = bean.data!.nobleID as int;
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
      CommonIntBean bean = await DataUtils.postCanSendUser(params);
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
    if (roomID == null || roomID.toString().isEmpty) {
      return;
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
          sp.setString('roomID', '');
          setState(() {
            sp.setBool('joinRoom', false);
          });
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      sp.setString('roomID', '');
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
      'password': password,
      'anchor_uid': widget.otherId
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
