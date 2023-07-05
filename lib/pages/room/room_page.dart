import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/config/my_config.dart';
import 'package:yuyinting/pages/room/room_back_page.dart';
import 'package:yuyinting/pages/room/room_gongneng.dart';
import 'package:yuyinting/pages/room/room_liwu_page.dart';
import 'package:yuyinting/pages/room/room_manager_page.dart';
import 'package:yuyinting/pages/room/room_messages_page.dart';
import 'package:yuyinting/pages/room/room_people_info_page.dart';
import 'package:yuyinting/pages/room/room_redu_page.dart';
import 'package:yuyinting/pages/room/room_ts_gonggao_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../utils/log_util.dart';
import '../../utils/style_utils.dart';

/// 厅内
class RoomPage extends StatefulWidget {
  int type;

  RoomPage({Key? key, required this.type}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  bool m0 = true,
      m1 = true,
      m2 = true,
      m3 = false,
      m4 = false,
      m5 = false,
      m6 = false,
      m7 = false,
      m8 = false;
  bool isBoss = true;
  bool isJinyiin = false;
  var listen;
  /// 声网使用
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // //初始化声网的音频插件
    // initAgora();
    // //初始化声卡采集
    // if(Platform.isWindows || Platform.isMacOS){
    //   starSK();
    // }
    listen = eventBus.on<SubmitButtonBack>().listen((event) {
      if (event.title == '清除公屏') {
      } else if (event.title == '清除魅力') {
      } else if (event.title == '老板位') {
        setState(() {
          isBoss = !isBoss;
        });
      } else if (event.title == '动效') {
      } else if (event.title == '房间声音') {

      } else if (event.title == '退出房间') {
        Navigator.pop(context);
      } else if (event.title == '收起房间') {
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
    _engine.disableAudio();
  }

  // 初始化应用
  Future<void> initAgora() async {
    // 获取权限
    await [Permission.microphone].request();

    // 创建 RtcEngine
    _engine = await createAgoraRtcEngine();


    // 初始化 RtcEngine，设置频道场景为直播场景
    await _engine.initialize(const RtcEngineContext(
      appId: MyConfig.appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          LogE("用户加入频道： ${connection.localUid} joined");
          LogE("用户加入频道： ${connection.channelId} 频道id");
          // 本地用户加入
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          LogE("remote user $remoteUid joined");
          // 远程用户加入
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          LogE("remote user $remoteUid left channel");
          // 用户离开房间
          setState(() {
            _remoteUid = null;
          });
        },
        onLeaveChannel: (RtcConnection connection, RtcStats stats){
          //离开频道回调。

        },
      ),
    );
    _engine.enableAudio();
    // 加入频道，设置用户角色为主播
    await _engine.joinChannel(
      token: MyConfig.token,
      channelId: MyConfig.channel,
      options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster),
      uid: 0,
    );
    _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
    _engine.enableLocalAudio(true);
    // 设置音质
    _engine.setAudioProfile(profile: AudioProfileType.audioProfileMusicHighQuality, scenario: AudioScenarioType.audioScenarioGameStreaming);
    // 开启降噪
    _engine.setAINSMode(enabled: true, mode: AudioAinsMode.ainsModeUltralowlatency);
  }

  /// 开启声卡
  Future<void> starSK() async {
    _engine.enableLoopbackRecording(enabled: true);
  }



  Widget _itemTuiJian(BuildContext context, int i) {
    return GestureDetector(
      onTap: (() {
        Future.delayed(const Duration(seconds: 0), () {
          Navigator.of(context).push(PageRouteBuilder(
              opaque: false,
              pageBuilder: (context, animation, secondaryAnimation) {
                return const RoomPeopleInfoPage();
              }));
        });
      }),
      child: Column(
        children: [
          Row(
            children: [
              WidgetUtils.commonSizedBox(0, 20),
              WidgetUtils.onlyText(
                  '昵称',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.roomMaiWZ, fontSize: ScreenUtil().setSp(24)))
            ],
          ),
          WidgetUtils.commonSizedBox(5, 0),
          Stack(
            children: [
              Opacity(
                opacity: 0.3,
                child: Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      padding: const EdgeInsets.only(
                          left: 15, right: 15, top: 10, bottom: 10),
                      //边框设置
                      decoration: const BoxDecoration(
                        //背景
                        color: MyColors.roomMaiLiao,
                        //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(7),
                            topRight: Radius.circular(24),
                            bottomLeft: Radius.circular(24),
                            bottomRight: Radius.circular(24)),
                      ),
                      child: Row(
                        children: [
                          WidgetUtils.onlyText(
                              '信息',
                              StyleUtils.getCommonTextStyle(
                                  color: Colors.transparent,
                                  fontSize: ScreenUtil().setSp(21))),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 10, bottom: 10),
                    //边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: Colors.transparent,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(7),
                          topRight: Radius.circular(24),
                          bottomLeft: Radius.circular(24),
                          bottomRight: Radius.circular(24)),
                    ),
                    child: Row(
                      children: [
                        WidgetUtils.onlyText(
                            '信息',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(21))),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
          WidgetUtils.commonSizedBox(10, 0),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          //设置Container修饰
          image: DecorationImage(
            //背景图片修饰
            image: AssetImage("assets/images/room_bg.webp"),
            fit: BoxFit.fill, //覆盖
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                WidgetUtils.commonSizedBox(35, 0),
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20),
                    GestureDetector(
                      onTap: (() {
                        Future.delayed(const Duration(seconds: 0), () {
                          Navigator.push(
                            context,
                            PageRouteBuilder(//自定义路由
                              opaque: false,
                              pageBuilder: (context, a, _) => RoomManagerPage(type: 1),//需要跳转的页面
                              transitionsBuilder: (context, a, _, child) {
                                const begin =
                                Offset(0, 1); //Offset是一个2D小部件，他将记录坐标轴的x,y前者为宽，后者为高 如果将begin =Offset(1,0)改为(0,1),效果则会变成从下到上
                                const end = Offset.zero; //得到Offset.zero坐标值
                                const curve = Curves.ease; //这是一个曲线动画
                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve)); //使用补间动画转换为动画
                                return SlideTransition(
                                  //转场动画//目前我认为只能用于跳转效果
                                  position: a.drive(tween), //这里将获得一个新的动画
                                  child: child,
                                );
                              },
                            ),
                          );
                        });
                      }),
                      child: WidgetUtils.CircleHeadImage(
                          ScreenUtil().setHeight(55),
                          ScreenUtil().setHeight(55),
                          'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                    ),
                    WidgetUtils.commonSizedBox(0, 5),
                    Column(
                      children: [
                        SizedBox(
                          width: ScreenUtil().setHeight(120),
                          child: WidgetUtils.onlyText(
                              '房间名称',
                              StyleUtils.getCommonTextStyle(
                                  color: Colors.white,
                                  fontSize: ScreenUtil().setSp(21),
                                  fontWeight: FontWeight.bold)),
                        ),
                        WidgetUtils.commonSizedBox(5, 0),
                        SizedBox(
                          width: ScreenUtil().setHeight(120),
                          child: WidgetUtils.onlyText(
                              'ID 298113',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomID,
                                  fontSize: ScreenUtil().setSp(18))),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: ScreenUtil().setHeight(60),
                      height: ScreenUtil().setHeight(32),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          WidgetUtils.showImagesFill(
                              'assets/images/room_shoucang.png',
                              double.infinity,
                              double.infinity),
                          Container(
                            width: ScreenUtil().setHeight(60),
                            height: ScreenUtil().setHeight(32),
                            alignment: Alignment.center,
                            child: Text(
                              '收藏',
                              style: StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomID,
                                  fontSize: ScreenUtil().setSp(20)),
                            ),
                          )
                        ],
                      ),
                    ),
                    const Expanded(child: Text('')),

                    /// 热度
                    Stack(
                      children: [
                        Opacity(
                            opacity: 0.3,
                            child: Container(
                              width: ScreenUtil().setHeight(70),
                              height: ScreenUtil().setHeight(30),
                              //边框设置
                              decoration: const BoxDecoration(
                                //背景
                                color: MyColors.roomMaiLiao,
                                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                              ),
                            )),
                        GestureDetector(
                          onTap: (() {
                            LogE('热度点击');
                            Future.delayed(const Duration(seconds: 0), () {
                              Navigator.push(
                                context,
                                PageRouteBuilder(//自定义路由
                                  opaque: false,
                                  pageBuilder: (context, a, _) => const RoomReDuPage(),//需要跳转的页面
                                  transitionsBuilder: (context, a, _, child) {
                                    const begin =
                                    Offset(0, 1); //Offset是一个2D小部件，他将记录坐标轴的x,y前者为宽，后者为高
                                    const end = Offset.zero; //得到Offset.zero坐标值
                                    const curve = Curves.ease; //这是一个曲线动画
                                    var tween = Tween(begin: begin, end: end)
                                        .chain(CurveTween(curve: curve)); //使用补间动画转换为动画
                                    return SlideTransition(
                                      //转场动画//目前我认为只能用于跳转效果
                                      position: a.drive(tween), //这里将获得一个新的动画
                                      child: child,
                                    );
                                  },
                                ),
                              );
                            });
                          }),
                          child: SizedBox(
                            width: ScreenUtil().setHeight(70),
                            height: ScreenUtil().setHeight(30),
                            child: Row(
                              children: [
                                const Expanded(child: Text('')),
                                WidgetUtils.showImagesFill(
                                    'assets/images/room_hot.png',
                                    ScreenUtil().setHeight(18),
                                    ScreenUtil().setHeight(15)),
                                WidgetUtils.commonSizedBox(0, 2),
                                WidgetUtils.onlyTextCenter(
                                    '1800',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomID,
                                        fontSize: ScreenUtil().setSp(18))),
                                const Expanded(child: Text('')),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),


                    /// 退出的点
                    GestureDetector(
                      onTap: (() {
                        Future.delayed(const Duration(seconds: 0), () {
                          Navigator.of(context).push(PageRouteBuilder(
                              opaque: false,
                              pageBuilder:
                                  (context, animation, secondaryAnimation) {
                                return const RoomBackPage();
                              }));
                        });
                      }),
                      child: SizedBox(
                          height: ScreenUtil().setHeight(32),
                          width: ScreenUtil().setHeight(79),
                          child: WidgetUtils.showImages(
                              'assets/images/room_dian.png',
                              ScreenUtil().setHeight(32),
                              ScreenUtil().setHeight(7))
                      ),
                    ),
                  ],
                ),
                WidgetUtils.commonSizedBox(10, 0),
                /// 公告 和 厅主
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20),
                    Expanded(
                        child: Row(
                          children: [
                            SizedBox(
                              height: ScreenUtil().setHeight(240),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: (() {
                                      Future.delayed(const Duration(seconds: 0), () {
                                        Navigator.of(context).push(PageRouteBuilder(
                                            opaque: false,
                                            pageBuilder:
                                                (context, animation, secondaryAnimation) {
                                              return const RoomTSGongGaoPage();
                                            }));
                                      });
                                    }),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Opacity(
                                          opacity: 0.3,
                                          child: Container(
                                            width: ScreenUtil().setHeight(80),
                                            height: ScreenUtil().setHeight(30),
                                            //边框设置
                                            decoration: const BoxDecoration(
                                              //背景
                                              color: MyColors.roomMaiLiao,
                                              //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30.0)),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: ScreenUtil().setHeight(80),
                                          height: ScreenUtil().setHeight(30),
                                          child: Row(
                                            children: [
                                              const Expanded(child: Text('')),
                                              WidgetUtils.showImagesFill(
                                                  'assets/images/room_gonggao.png',
                                                  ScreenUtil().setHeight(30),
                                                  ScreenUtil().setHeight(30)),
                                              WidgetUtils.onlyTextCenter(
                                                  '公告',
                                                  StyleUtils.getCommonTextStyle(
                                                      color: MyColors.roomID,
                                                      fontSize:
                                                      ScreenUtil().setSp(21))),
                                              const Expanded(child: Text('')),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            ),
                            const Expanded(child: Text('')),
                          ],
                        )),

                    /// 厅主
                    Transform.translate(
                      offset: const Offset(0, -30),
                      child: SizedBox(
                        width: ScreenUtil().setHeight(180),
                        height: ScreenUtil().setHeight(240),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            m0 == true ? const SVGASimpleImage(
                                assetsName: 'assets/svga/wave_normal.svga') : WidgetUtils.showImages(
                                'assets/images/room_mai.png',
                                ScreenUtil().setHeight(110),
                                ScreenUtil().setHeight(110)),
                            m0 == true ? WidgetUtils.CircleHeadImage(
                                ScreenUtil().setHeight(110),
                                ScreenUtil().setHeight(110),
                                'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500') : const Text(''),
                            Column(
                              children: [
                                const Expanded(child: Text('')),
                                m0 == false
                                    ? WidgetUtils.onlyTextCenter(
                                    '主持麦',
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomMaiWZ,
                                        fontSize: ScreenUtil().setSp(21)))
                                    :Row(
                                  children: [
                                    const Expanded(child: Text('')),
                                    WidgetUtils.showImages(
                                        'assets/images/room_tingzhu.png',
                                        ScreenUtil().setHeight(27),
                                        ScreenUtil().setHeight(25)),
                                    WidgetUtils.commonSizedBox(0, 5),
                                    WidgetUtils.onlyText(
                                        '名称',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(21))),
                                    const Expanded(child: Text('')),
                                  ],
                                ),
                                m0 == true ? Row(
                                  children: [
                                    const Expanded(child: Text('')),
                                    WidgetUtils.showImages(
                                        'assets/images/room_xin.png',
                                        ScreenUtil().setHeight(17),
                                        ScreenUtil().setHeight(15)),
                                    WidgetUtils.commonSizedBox(0, 5),
                                    WidgetUtils.onlyText(
                                        '100',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(21))),
                                    const Expanded(child: Text('')),
                                  ],
                                ) : const Text('')
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    const Expanded(child: Text('')),
                  ],
                ),
                Transform.translate(
                  offset: const Offset(0, -40),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          WidgetUtils.commonSizedBox(0, 10),
                          GestureDetector(
                            onTap: ((){
                                setState(() {
                                  MyToastUtils.showToastBottom('已上麦');
                                  _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
                                  _engine.enableLocalAudio(true);
                                });
                            }),
                            child: SizedBox(
                              width: ScreenUtil().setHeight(140),
                              height: ScreenUtil().setHeight(190),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  m1 == true
                                      ? const SVGASimpleImage(
                                      assetsName: 'assets/svga/wave_normal.svga')
                                      : const Text(''),
                                  m1 == true
                                      ? WidgetUtils.CircleHeadImage(
                                      ScreenUtil().setHeight(80),
                                      ScreenUtil().setHeight(80),
                                      'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500')
                                      : WidgetUtils.showImages(
                                      'assets/images/room_mai.png',
                                      ScreenUtil().setHeight(80),
                                      ScreenUtil().setHeight(80)),
                                  Column(
                                    children: [
                                      const Expanded(child: Text('')),
                                      m1 == false
                                          ? WidgetUtils.onlyTextCenter(
                                          '1号麦',
                                          StyleUtils.getCommonTextStyle(
                                              color: MyColors.roomMaiWZ,
                                              fontSize: ScreenUtil().setSp(19)))
                                          : WidgetUtils.commonSizedBox(0, 0),
                                      m1 == false
                                          ? WidgetUtils.commonSizedBox(15, 0) : WidgetUtils.commonSizedBox(0, 0),
                                      m1 == false
                                          ? WidgetUtils.commonSizedBox(10, 0)
                                          : WidgetUtils.commonSizedBox(0, 0),
                                      m1 == true
                                          ? Row(
                                        children: [
                                          const Expanded(child: Text('')),
                                          WidgetUtils.showImages(
                                              'assets/images/room_fangguan.png',
                                              ScreenUtil().setHeight(27),
                                              ScreenUtil().setHeight(25)),
                                          WidgetUtils.commonSizedBox(0, 5),
                                          WidgetUtils.onlyText(
                                              '名称',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                  ScreenUtil().setSp(21))),
                                          const Expanded(child: Text('')),
                                        ],
                                      )
                                          : WidgetUtils.commonSizedBox(0, 0),
                                      m1 == true
                                          ? Row(
                                        children: [
                                          const Expanded(child: Text('')),
                                          WidgetUtils.showImages(
                                              'assets/images/room_xin.png',
                                              ScreenUtil().setHeight(17),
                                              ScreenUtil().setHeight(15)),
                                          WidgetUtils.commonSizedBox(0, 5),
                                          WidgetUtils.onlyText(
                                              '100',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.white,
                                                  fontSize:
                                                  ScreenUtil().setSp(21))),
                                          const Expanded(child: Text('')),
                                        ],
                                      )
                                          : WidgetUtils.commonSizedBox(0, 0),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const Expanded(child: Text('')),
                          SizedBox(
                            width: ScreenUtil().setHeight(140),
                            height: ScreenUtil().setHeight(190),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                m2 == true
                                    ? const SVGASimpleImage(
                                    assetsName: 'assets/svga/wave_normal.svga')
                                    : const Text(''),
                                m2 == true
                                    ? WidgetUtils.CircleHeadImage(
                                    ScreenUtil().setHeight(80),
                                    ScreenUtil().setHeight(80),
                                    'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500')
                                    : WidgetUtils.showImages(
                                    'assets/images/room_mai.png',
                                    ScreenUtil().setHeight(80),
                                    ScreenUtil().setHeight(80)),
                                Column(
                                  children: [
                                    const Expanded(child: Text('')),
                                    m2 == false
                                        ? WidgetUtils.onlyTextCenter(
                                        '2号麦',
                                        StyleUtils.getCommonTextStyle(
                                            color: MyColors.roomMaiWZ,
                                            fontSize: ScreenUtil().setSp(19)))
                                        : WidgetUtils.commonSizedBox(0, 0),
                                    m2 == false
                                        ? WidgetUtils.commonSizedBox(15, 0) : WidgetUtils.commonSizedBox(0, 0),
                                    m2 == false
                                        ? WidgetUtils.commonSizedBox(10, 0)
                                        : WidgetUtils.commonSizedBox(0, 0),
                                    m2 == true
                                        ? Row(
                                      children: [
                                        const Expanded(child: Text('')),
                                        WidgetUtils.showImages(
                                            'assets/images/room_fangguan.png',
                                            ScreenUtil().setHeight(27),
                                            ScreenUtil().setHeight(25)),
                                        WidgetUtils.commonSizedBox(0, 5),
                                        WidgetUtils.onlyText(
                                            '名称',
                                            StyleUtils.getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                ScreenUtil().setSp(21))),
                                        const Expanded(child: Text('')),
                                      ],
                                    )
                                        : WidgetUtils.commonSizedBox(0, 0),
                                    m2 == true
                                        ? Row(
                                      children: [
                                        const Expanded(child: Text('')),
                                        WidgetUtils.showImages(
                                            'assets/images/room_xin.png',
                                            ScreenUtil().setHeight(17),
                                            ScreenUtil().setHeight(15)),
                                        WidgetUtils.commonSizedBox(0, 5),
                                        WidgetUtils.onlyText(
                                            '100',
                                            StyleUtils.getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                ScreenUtil().setSp(21))),
                                        const Expanded(child: Text('')),
                                      ],
                                    )
                                        : WidgetUtils.commonSizedBox(0, 0),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const Expanded(child: Text('')),
                          SizedBox(
                            width: ScreenUtil().setHeight(140),
                            height: ScreenUtil().setHeight(190),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                m3 == true
                                    ? const SVGASimpleImage(
                                    assetsName: 'assets/svga/wave_normal.svga')
                                    : const Text(''),
                                m3 == true
                                    ? WidgetUtils.CircleHeadImage(
                                    ScreenUtil().setHeight(80),
                                    ScreenUtil().setHeight(80),
                                    'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500')
                                    : WidgetUtils.showImages(
                                    'assets/images/room_mai.png',
                                    ScreenUtil().setHeight(80),
                                    ScreenUtil().setHeight(80)),
                                Column(
                                  children: [
                                    const Expanded(child: Text('')),
                                    m3 == false
                                        ? WidgetUtils.onlyTextCenter(
                                        '3号麦',
                                        StyleUtils.getCommonTextStyle(
                                            color: MyColors.roomMaiWZ,
                                            fontSize: ScreenUtil().setSp(19)))
                                        : WidgetUtils.commonSizedBox(0, 0),
                                    m3 == false
                                        ? WidgetUtils.commonSizedBox(15, 0) : WidgetUtils.commonSizedBox(0, 0),
                                    m3 == false
                                        ? WidgetUtils.commonSizedBox(10, 0)
                                        : WidgetUtils.commonSizedBox(0, 0),
                                    m3 == true
                                        ? Row(
                                      children: [
                                        const Expanded(child: Text('')),
                                        WidgetUtils.showImages(
                                            'assets/images/room_fangguan.png',
                                            ScreenUtil().setHeight(27),
                                            ScreenUtil().setHeight(25)),
                                        WidgetUtils.commonSizedBox(0, 5),
                                        WidgetUtils.onlyText(
                                            '名称',
                                            StyleUtils.getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                ScreenUtil().setSp(21))),
                                        const Expanded(child: Text('')),
                                      ],
                                    )
                                        : WidgetUtils.commonSizedBox(0, 0),
                                    m3 == true
                                        ? Row(
                                      children: [
                                        const Expanded(child: Text('')),
                                        WidgetUtils.showImages(
                                            'assets/images/room_xin.png',
                                            ScreenUtil().setHeight(17),
                                            ScreenUtil().setHeight(15)),
                                        WidgetUtils.commonSizedBox(0, 5),
                                        WidgetUtils.onlyText(
                                            '100',
                                            StyleUtils.getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                ScreenUtil().setSp(21))),
                                        const Expanded(child: Text('')),
                                      ],
                                    )
                                        : WidgetUtils.commonSizedBox(0, 0),
                                  ],
                                )
                              ],
                            ),
                          ),
                          const Expanded(child: Text('')),
                          SizedBox(
                            width: ScreenUtil().setHeight(140),
                            height: ScreenUtil().setHeight(190),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                m4 == true
                                    ? const SVGASimpleImage(
                                    assetsName: 'assets/svga/wave_normal.svga')
                                    : const Text(''),
                                m4 == true
                                    ? WidgetUtils.CircleHeadImage(
                                    ScreenUtil().setHeight(80),
                                    ScreenUtil().setHeight(80),
                                    'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500')
                                    : WidgetUtils.showImages(
                                    'assets/images/room_mai.png',
                                    ScreenUtil().setHeight(80),
                                    ScreenUtil().setHeight(80)),
                                Column(
                                  children: [
                                    const Expanded(child: Text('')),
                                    m4 == false
                                        ? WidgetUtils.onlyTextCenter(
                                        '4号麦',
                                        StyleUtils.getCommonTextStyle(
                                            color: MyColors.roomMaiWZ,
                                            fontSize: ScreenUtil().setSp(19)))
                                        : WidgetUtils.commonSizedBox(0, 0),
                                    m4 == false
                                        ? WidgetUtils.commonSizedBox(15, 0) : WidgetUtils.commonSizedBox(0, 0),
                                    m4 == false
                                        ? WidgetUtils.commonSizedBox(10, 0)
                                        : WidgetUtils.commonSizedBox(0, 0),
                                    m4 == true
                                        ? Row(
                                      children: [
                                        const Expanded(child: Text('')),
                                        WidgetUtils.showImages(
                                            'assets/images/room_fangguan.png',
                                            ScreenUtil().setHeight(27),
                                            ScreenUtil().setHeight(25)),
                                        WidgetUtils.commonSizedBox(0, 5),
                                        WidgetUtils.onlyText(
                                            '名称',
                                            StyleUtils.getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                ScreenUtil().setSp(21))),
                                        const Expanded(child: Text('')),
                                      ],
                                    )
                                        : WidgetUtils.commonSizedBox(0, 0),
                                    m4 == true
                                        ? Row(
                                      children: [
                                        const Expanded(child: Text('')),
                                        WidgetUtils.showImages(
                                            'assets/images/room_xin.png',
                                            ScreenUtil().setHeight(17),
                                            ScreenUtil().setHeight(15)),
                                        WidgetUtils.commonSizedBox(0, 5),
                                        WidgetUtils.onlyText(
                                            '100',
                                            StyleUtils.getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize:
                                                ScreenUtil().setSp(21))),
                                        const Expanded(child: Text('')),
                                      ],
                                    )
                                        : WidgetUtils.commonSizedBox(0, 0),
                                  ],
                                )
                              ],
                            ),
                          ),
                          WidgetUtils.commonSizedBox(0, 10),
                        ],
                      ),

                      /// 第二排麦序
                      Transform.translate(
                        offset: const Offset(0, -20),
                        child: Row(
                          children: [
                            WidgetUtils.commonSizedBox(0, 10),
                            SizedBox(
                              width: ScreenUtil().setHeight(140),
                              height: ScreenUtil().setHeight(190),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  m5 == true
                                      ? const SVGASimpleImage(
                                      assetsName:
                                      'assets/svga/wave_normal.svga')
                                      : const Text(''),
                                  m5 == true
                                      ? WidgetUtils.CircleHeadImage(
                                      ScreenUtil().setHeight(80),
                                      ScreenUtil().setHeight(80),
                                      'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500')
                                      : WidgetUtils.showImages(
                                      'assets/images/room_mai.png',
                                      ScreenUtil().setHeight(80),
                                      ScreenUtil().setHeight(80)),
                                  Column(
                                    children: [
                                      const Expanded(child: Text('')),
                                      m5 == false
                                          ? WidgetUtils.onlyTextCenter(
                                          '5号麦',
                                          StyleUtils.getCommonTextStyle(
                                              color: MyColors.roomMaiWZ,
                                              fontSize: ScreenUtil().setSp(19)))
                                          : WidgetUtils.commonSizedBox(0, 0),
                                      m5 == false
                                          ? WidgetUtils.commonSizedBox(10, 0)
                                          : WidgetUtils.commonSizedBox(0, 0),
                                      m5 == true
                                          ? Row(
                                        children: [
                                          const Expanded(child: Text('')),
                                          WidgetUtils.showImages(
                                              'assets/images/room_fangguan.png',
                                              ScreenUtil().setHeight(27),
                                              ScreenUtil().setHeight(25)),
                                          WidgetUtils.commonSizedBox(0, 5),
                                          WidgetUtils.onlyText(
                                              '名称',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.white,
                                                  fontSize: ScreenUtil()
                                                      .setSp(21))),
                                          const Expanded(child: Text('')),
                                        ],
                                      )
                                          : WidgetUtils.commonSizedBox(0, 0),
                                      m5 == true
                                          ? Row(
                                        children: [
                                          const Expanded(child: Text('')),
                                          WidgetUtils.showImages(
                                              'assets/images/room_xin.png',
                                              ScreenUtil().setHeight(17),
                                              ScreenUtil().setHeight(15)),
                                          WidgetUtils.commonSizedBox(0, 5),
                                          WidgetUtils.onlyText(
                                              '80',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.white,
                                                  fontSize: ScreenUtil()
                                                      .setSp(21))),
                                          const Expanded(child: Text('')),
                                        ],
                                      )
                                          : WidgetUtils.commonSizedBox(0, 0),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Expanded(child: Text('')),
                            SizedBox(
                              width: ScreenUtil().setHeight(140),
                              height: ScreenUtil().setHeight(190),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  m6 == true
                                      ? const SVGASimpleImage(
                                      assetsName:
                                      'assets/svga/wave_normal.svga')
                                      : const Text(''),
                                  m6 == true
                                      ? WidgetUtils.CircleHeadImage(
                                      ScreenUtil().setHeight(80),
                                      ScreenUtil().setHeight(80),
                                      'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500')
                                      : WidgetUtils.showImages(
                                      'assets/images/room_mai.png',
                                      ScreenUtil().setHeight(80),
                                      ScreenUtil().setHeight(80)),
                                  Column(
                                    children: [
                                      const Expanded(child: Text('')),
                                      m6 == false
                                          ? WidgetUtils.onlyTextCenter(
                                          '6号麦',
                                          StyleUtils.getCommonTextStyle(
                                              color: MyColors.roomMaiWZ,
                                              fontSize: ScreenUtil().setSp(19)))
                                          : WidgetUtils.commonSizedBox(0, 0),
                                      m6 == false
                                          ? WidgetUtils.commonSizedBox(10, 0)
                                          : WidgetUtils.commonSizedBox(0, 0),
                                      m6 == true
                                          ? Row(
                                        children: [
                                          const Expanded(child: Text('')),
                                          WidgetUtils.showImages(
                                              'assets/images/room_fangguan.png',
                                              ScreenUtil().setHeight(27),
                                              ScreenUtil().setHeight(25)),
                                          WidgetUtils.commonSizedBox(0, 5),
                                          WidgetUtils.onlyText(
                                              '名称',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.white,
                                                  fontSize: ScreenUtil()
                                                      .setSp(21))),
                                          const Expanded(child: Text('')),
                                        ],
                                      )
                                          : WidgetUtils.commonSizedBox(0, 0),
                                      m6 == true
                                          ? Row(
                                        children: [
                                          const Expanded(child: Text('')),
                                          WidgetUtils.showImages(
                                              'assets/images/room_xin.png',
                                              ScreenUtil().setHeight(17),
                                              ScreenUtil().setHeight(15)),
                                          WidgetUtils.commonSizedBox(0, 5),
                                          WidgetUtils.onlyText(
                                              '80',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.white,
                                                  fontSize: ScreenUtil()
                                                      .setSp(21))),
                                          const Expanded(child: Text('')),
                                        ],
                                      )
                                          : WidgetUtils.commonSizedBox(0, 0),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Expanded(child: Text('')),
                            SizedBox(
                              width: ScreenUtil().setHeight(140),
                              height: ScreenUtil().setHeight(190),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  m7 == true
                                      ? const SVGASimpleImage(
                                      assetsName:
                                      'assets/svga/wave_normal.svga')
                                      : const Text(''),
                                  m7 == true
                                      ? WidgetUtils.CircleHeadImage(
                                      ScreenUtil().setHeight(80),
                                      ScreenUtil().setHeight(80),
                                      'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500')
                                      : WidgetUtils.showImages(
                                      'assets/images/room_mai.png',
                                      ScreenUtil().setHeight(80),
                                      ScreenUtil().setHeight(80)),
                                  Column(
                                    children: [
                                      const Expanded(child: Text('')),
                                      m7 == false
                                          ? WidgetUtils.onlyTextCenter(
                                          '7号麦',
                                          StyleUtils.getCommonTextStyle(
                                              color: MyColors.roomMaiWZ,
                                              fontSize: ScreenUtil().setSp(19)))
                                          : WidgetUtils.commonSizedBox(0, 0),
                                      m7 == false
                                          ? WidgetUtils.commonSizedBox(10, 0)
                                          : WidgetUtils.commonSizedBox(10, 0),
                                      m7 == true
                                          ? Row(
                                        children: [
                                          const Expanded(child: Text('')),
                                          WidgetUtils.showImages(
                                              'assets/images/room_fangguan.png',
                                              ScreenUtil().setHeight(27),
                                              ScreenUtil().setHeight(25)),
                                          WidgetUtils.commonSizedBox(0, 5),
                                          WidgetUtils.onlyText(
                                              '名称',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.white,
                                                  fontSize: ScreenUtil()
                                                      .setSp(21))),
                                          const Expanded(child: Text('')),
                                        ],
                                      )
                                          : WidgetUtils.commonSizedBox(0, 0),
                                      m7 == true
                                          ? Row(
                                        children: [
                                          const Expanded(child: Text('')),
                                          WidgetUtils.showImages(
                                              'assets/images/room_xin.png',
                                              ScreenUtil().setHeight(17),
                                              ScreenUtil().setHeight(15)),
                                          WidgetUtils.commonSizedBox(0, 5),
                                          WidgetUtils.onlyText(
                                              '80',
                                              StyleUtils.getCommonTextStyle(
                                                  color: Colors.white,
                                                  fontSize: ScreenUtil()
                                                      .setSp(21))),
                                          const Expanded(child: Text('')),
                                        ],
                                      )
                                          : WidgetUtils.commonSizedBox(0, 0),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            const Expanded(child: Text('')),
                            isBoss == true
                                ? SizedBox(
                              width: ScreenUtil().setHeight(140),
                              height: ScreenUtil().setHeight(190),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  m8 == true
                                      ? const SVGASimpleImage(
                                      assetsName:
                                      'assets/svga/wave_normal.svga')
                                      : const Text(''),
                                  m8 == true
                                      ? WidgetUtils.CircleHeadImage(
                                      ScreenUtil().setHeight(80),
                                      ScreenUtil().setHeight(80),
                                      'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500')
                                      : SizedBox(
                                    height: ScreenUtil().setHeight(80),
                                    width: ScreenUtil().setHeight(80),
                                    child: const SVGASimpleImage(
                                        assetsName:
                                        'assets/svga/laobanwei.svga'),
                                  ),
                                  Column(
                                    children: [
                                      const Expanded(child: Text('')),
                                      m8 == false
                                          ? WidgetUtils.onlyTextCenter(
                                          '老板位',
                                          StyleUtils.getCommonTextStyle(
                                              color: MyColors.roomMaiWZ,
                                              fontSize:
                                              ScreenUtil().setSp(19)))
                                          : WidgetUtils.commonSizedBox(0, 0),
                                      m8 == false
                                          ? WidgetUtils.commonSizedBox(10, 0)
                                          : WidgetUtils.commonSizedBox(0, 0),
                                      m8 == true
                                          ? Row(
                                        children: [
                                          const Expanded(
                                              child: Text('')),
                                          WidgetUtils.showImages(
                                              'assets/images/room_fangguan.png',
                                              ScreenUtil()
                                                  .setHeight(27),
                                              ScreenUtil()
                                                  .setHeight(25)),
                                          WidgetUtils.commonSizedBox(
                                              0, 5),
                                          WidgetUtils.onlyText(
                                              '名称',
                                              StyleUtils
                                                  .getCommonTextStyle(
                                                  color:
                                                  Colors.white,
                                                  fontSize:
                                                  ScreenUtil()
                                                      .setSp(
                                                      21))),
                                          const Expanded(
                                              child: Text('')),
                                        ],
                                      )
                                          : WidgetUtils.commonSizedBox(0, 0),
                                      m8 == true
                                          ? Row(
                                        children: [
                                          const Expanded(
                                              child: Text('')),
                                          WidgetUtils.showImages(
                                              'assets/images/room_xin.png',
                                              ScreenUtil()
                                                  .setHeight(17),
                                              ScreenUtil()
                                                  .setHeight(15)),
                                          WidgetUtils.commonSizedBox(
                                              0, 5),
                                          WidgetUtils.onlyText(
                                              '80',
                                              StyleUtils
                                                  .getCommonTextStyle(
                                                  color:
                                                  Colors.white,
                                                  fontSize:
                                                  ScreenUtil()
                                                      .setSp(
                                                      21))),
                                          const Expanded(
                                              child: Text('')),
                                        ],
                                      )
                                          : WidgetUtils.commonSizedBox(0, 0),
                                    ],
                                  )
                                ],
                              ),
                            )
                                : SizedBox(
                              width: ScreenUtil().setHeight(140),
                              height: ScreenUtil().setHeight(190),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  m8 == true
                                      ? const SVGASimpleImage(
                                      assetsName:
                                      'assets/svga/wave_normal.svga')
                                      : const Text(''),
                                  m8 == true
                                      ? WidgetUtils.CircleHeadImage(
                                      ScreenUtil().setHeight(80),
                                      ScreenUtil().setHeight(80),
                                      'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500')
                                      : WidgetUtils.showImages(
                                      'assets/images/room_mai.png',
                                      ScreenUtil().setHeight(80),
                                      ScreenUtil().setHeight(80)),
                                  Column(
                                    children: [
                                      const Expanded(child: Text('')),
                                      m8 == false
                                          ? WidgetUtils.onlyTextCenter(
                                          '8号麦',
                                          StyleUtils.getCommonTextStyle(
                                              color: MyColors.roomMaiWZ,
                                              fontSize:
                                              ScreenUtil().setSp(19)))
                                          : WidgetUtils.commonSizedBox(0, 0),
                                      m8 == false
                                          ? WidgetUtils.commonSizedBox(10, 0)
                                          : WidgetUtils.commonSizedBox(10, 0),
                                      m8 == true
                                          ? Row(
                                        children: [
                                          const Expanded(
                                              child: Text('')),
                                          WidgetUtils.showImages(
                                              'assets/images/room_fangguan.png',
                                              ScreenUtil()
                                                  .setHeight(27),
                                              ScreenUtil()
                                                  .setHeight(25)),
                                          WidgetUtils.commonSizedBox(
                                              0, 5),
                                          WidgetUtils.onlyText(
                                              '名称',
                                              StyleUtils
                                                  .getCommonTextStyle(
                                                  color:
                                                  Colors.white,
                                                  fontSize:
                                                  ScreenUtil()
                                                      .setSp(
                                                      21))),
                                          const Expanded(
                                              child: Text('')),
                                        ],
                                      )
                                          : WidgetUtils.commonSizedBox(0, 0),
                                      m8 == true
                                          ? Row(
                                        children: [
                                          const Expanded(
                                              child: Text('')),
                                          WidgetUtils.showImages(
                                              'assets/images/room_xin.png',
                                              ScreenUtil()
                                                  .setHeight(17),
                                              ScreenUtil()
                                                  .setHeight(15)),
                                          WidgetUtils.commonSizedBox(
                                              0, 5),
                                          WidgetUtils.onlyText(
                                              '100',
                                              StyleUtils
                                                  .getCommonTextStyle(
                                                  color:
                                                  Colors.white,
                                                  fontSize:
                                                  ScreenUtil()
                                                      .setSp(
                                                      21))),
                                          const Expanded(
                                              child: Text('')),
                                        ],
                                      )
                                          : WidgetUtils.commonSizedBox(0, 0),
                                    ],
                                  )
                                ],
                              ),
                            ),
                            WidgetUtils.commonSizedBox(0, 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      /// 消息列表
                      ListView.builder(
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                        itemBuilder: _itemTuiJian,
                        itemCount: 15,
                      ),
                      Positioned(
                        top: 10,
                        right: 15,
                        child: WidgetUtils.showImages(
                            'assets/images/room_hudong.png',
                            ScreenUtil().setHeight(100),
                            ScreenUtil().setHeight(150)),
                      ),
                      // Positioned(
                      //   bottom: 10,
                      //   right: 15,
                      //   child: WidgetUtils.showImages(
                      //       'assets/images/room_hudong.png',
                      //       ScreenUtil().setHeight(63),
                      //       ScreenUtil().setHeight(112)),
                      // )
                    ],
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(90),
                  child: Row(
                    children: [
                      WidgetUtils.commonSizedBox(0, 20),
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Opacity(
                            opacity: 0.3,
                            child: Row(
                              children: [
                                Container(
                                  height: ScreenUtil().setHeight(50),
                                  width: ScreenUtil().setHeight(120),
                                  //边框设置
                                  decoration: const BoxDecoration(
                                    //背景
                                    color: MyColors.roomMaiLiao,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(30.0)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          WidgetUtils.onlyTextCenter(
                              '聊聊...',
                              StyleUtils.getCommonTextStyle(
                                  color: MyColors.roomMaiLiao3,
                                  fontSize: ScreenUtil().setSp(25))),
                        ],
                      ),
                      const Expanded(child: Text('')),
                      Stack(
                        children: [
                          SizedBox(
                            height: ScreenUtil().setHeight(60),
                            width: ScreenUtil().setHeight(60),
                            child: const SVGASimpleImage(
                                assetsName: 'assets/svga/room_liwu.svga'),
                          ),
                          GestureDetector(
                            onTap: ((){
                              Future.delayed(const Duration(seconds: 0), () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(//自定义路由
                                    opaque: false,
                                    pageBuilder: (context, a, _) => const RoomLiWuPage(),//需要跳转的页面
                                    transitionsBuilder: (context, a, _, child) {
                                      const begin =
                                      Offset(0, 1); //Offset是一个2D小部件，他将记录坐标轴的x,y前者为宽，后者为高
                                      const end = Offset.zero; //得到Offset.zero坐标值
                                      const curve = Curves.ease; //这是一个曲线动画
                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve)); //使用补间动画转换为动画
                                      return SlideTransition(
                                        //转场动画//目前我认为只能用于跳转效果
                                        position: a.drive(tween), //这里将获得一个新的动画
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              });
                            }),
                            child:Container(
                                height: ScreenUtil().setHeight(60),
                                width: ScreenUtil().setHeight(60),
                                color: Colors.transparent
                            ),
                          )
                        ],
                      ),
                      WidgetUtils.commonSizedBox(0, 5),
                      Stack(
                        children: [
                          SizedBox(
                            height: ScreenUtil().setHeight(50),
                            width: ScreenUtil().setHeight(50),
                            child: const SVGASimpleImage(
                                assetsName: 'assets/svga/room_huodong.svga'),
                          ),
                          GestureDetector(
                            onTap: ((){
                              Future.delayed(const Duration(seconds: 0), () {
                                Navigator.push(
                                  context,
                                  PageRouteBuilder(//自定义路由
                                    opaque: false,
                                    pageBuilder: (context, a, _) => const RoomLiWuPage(),//需要跳转的页面
                                    transitionsBuilder: (context, a, _, child) {
                                      const begin =
                                      Offset(0, 1); //Offset是一个2D小部件，他将记录坐标轴的x,y前者为宽，后者为高
                                      const end = Offset.zero; //得到Offset.zero坐标值
                                      const curve = Curves.ease; //这是一个曲线动画
                                      var tween = Tween(begin: begin, end: end)
                                          .chain(CurveTween(curve: curve)); //使用补间动画转换为动画
                                      return SlideTransition(
                                        //转场动画//目前我认为只能用于跳转效果
                                        position: a.drive(tween), //这里将获得一个新的动画
                                        child: child,
                                      );
                                    },
                                  ),
                                );
                              });
                            }),
                            child:Container(
                                height: ScreenUtil().setHeight(50),
                                width: ScreenUtil().setHeight(50),
                                color: Colors.transparent
                            ),
                          )
                        ],
                      ),
                      WidgetUtils.commonSizedBox(0, 10),
                      GestureDetector(
                        onTap: (() {
                          Future.delayed(const Duration(seconds: 0), () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(//自定义路由
                                opaque: false,
                                pageBuilder: (context, a, _) => const RoomMessagesPage(),//需要跳转的页面
                                transitionsBuilder: (context, a, _, child) {
                                  const begin =
                                  Offset(0, 1); //Offset是一个2D小部件，他将记录坐标轴的x,y前者为宽，后者为高
                                  const end = Offset.zero; //得到Offset.zero坐标值
                                  const curve = Curves.ease; //这是一个曲线动画
                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve)); //使用补间动画转换为动画
                                  return SlideTransition(
                                    //转场动画//目前我认为只能用于跳转效果
                                    position: a.drive(tween), //这里将获得一个新的动画
                                    child: child,
                                  );
                                },
                              ),
                            );
                          });
                        }),
                        child: WidgetUtils.showImages(
                            'assets/images/room_message.png',
                            ScreenUtil().setHeight(50),
                            ScreenUtil().setHeight(50)),
                      ),
                      WidgetUtils.commonSizedBox(0, 10),
                      GestureDetector(
                        onTap: (() {
                          Future.delayed(const Duration(seconds: 0), () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(//自定义路由
                                opaque: false,
                                pageBuilder: (context, a, _) => RoomGongNeng(type: 1),//需要跳转的页面
                                transitionsBuilder: (context, a, _, child) {
                                  const begin =
                                  Offset(0, 1); //Offset是一个2D小部件，他将记录坐标轴的x,y前者为宽，后者为高
                                  const end = Offset.zero; //得到Offset.zero坐标值
                                  const curve = Curves.ease; //这是一个曲线动画
                                  var tween = Tween(begin: begin, end: end)
                                      .chain(CurveTween(curve: curve)); //使用补间动画转换为动画
                                  return SlideTransition(
                                    //转场动画//目前我认为只能用于跳转效果
                                    position: a.drive(tween), //这里将获得一个新的动画
                                    child: child,
                                  );
                                },
                              ),
                            );
                          });
                        }),
                        child: WidgetUtils.showImages(
                            'assets/images/room_gongneng.png',
                            ScreenUtil().setHeight(50),
                            ScreenUtil().setHeight(50)),
                      ),
                      WidgetUtils.commonSizedBox(0, 10),
                      GestureDetector(
                        onTap: (() {
                          setState(() {
                            isJinyiin = !isJinyiin;
                          });
                        }),
                        child: WidgetUtils.showImages(
                            isJinyiin ? 'assets/images/room_yin_off.png' : 'assets/images/room_yin_on.png',
                            ScreenUtil().setHeight(50),
                            ScreenUtil().setHeight(50)),
                      ),
                      // WidgetUtils.commonSizedBox(0, 10),
                      // Stack(
                      //   alignment: Alignment.center,
                      //   children: [
                      //     Opacity(
                      //       opacity: 0.6,
                      //       child: Row(
                      //         children: [
                      //           Container(
                      //             height: ScreenUtil().setHeight(60),
                      //             width: ScreenUtil().setHeight(80),
                      //             //边框设置
                      //             decoration: const BoxDecoration(
                      //               //背景
                      //               color: MyColors.roomMaiLiao2,
                      //               //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      //               borderRadius:
                      //                   BorderRadius.all(Radius.circular(30.0)),
                      //             ),
                      //           )
                      //         ],
                      //       ),
                      //     ),
                      //     WidgetUtils.onlyTextCenter(
                      //         '上麦',
                      //         StyleUtils.getCommonTextStyle(
                      //             color: MyColors.roomShangMaiWZ,
                      //             fontSize: ScreenUtil().setSp(21))),
                      //   ],
                      // ),
                      WidgetUtils.commonSizedBox(0, 10),
                    ],
                  ),
                ),


              ],
            ),
            /// 禁言使用
            m0
                ? Positioned(
              right: ScreenUtil().setHeight(5),
              top: ScreenUtil().setHeight(120),
              child: Opacity(
                opacity: 0.55,
                child: Container(
                  height: ScreenUtil().setHeight(104),
                  width: ScreenUtil().setHeight(117),
                  //边框设置
                  decoration: const BoxDecoration(
                    //背景
                    color: MyColors.roomTCBlack,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius:
                    BorderRadius.all(Radius.circular(12.0)),
                  ),
                ),
              ),
            )
                : const Text(''),
            m0
                ? Positioned(
              right: ScreenUtil().setHeight(5),
              top: ScreenUtil().setHeight(120),
              child: Container(
                height: ScreenUtil().setHeight(104),
                width: ScreenUtil().setHeight(117),
                color: Colors.transparent,
                child: Column(
                  children: [
                    Expanded(
                        child: WidgetUtils.onlyTextCenter(
                            '上麦',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.roomTCWZ1,
                                fontSize: ScreenUtil().setSp(21)))),
                    Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(1),
                      margin: EdgeInsets.only(
                          left: ScreenUtil().setHeight(10),
                          right: ScreenUtil().setHeight(10)),
                      color: MyColors.roomTCWZ1,
                    ),
                    Expanded(
                        child: WidgetUtils.onlyTextCenter(
                            '锁麦',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.roomTCWZ1,
                                fontSize: ScreenUtil().setSp(21)))),
                  ],
                ),
              ),
            )
                : const Text(''),
          ],
        ),
      ),


      // body: Container(
      //   height: double.infinity,
      //   child: SVGASimpleImage(
      //     assetsName: 'assets/svga/twin_card_bg1.svga',
      //   ),
      // ),
    );
  }
}
