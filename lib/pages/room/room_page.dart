import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/config/my_config.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import '../../bean/Common_bean.dart';
import '../../bean/roomInfoBean.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/log_util.dart';
import '../../utils/style_utils.dart';
import 'room_items.dart';

/// 厅内
class RoomPage extends StatefulWidget {
  String roomId;
  RoomPage({Key? key, required this.roomId}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> {
  bool m0 = false,
      m1 = false,
      m2 = false,
      m3 = false,
      m4 = false,
      m5 = false,
      m6 = false,
      m7 = false,
      m8 = false;
  bool isOK = false;
  // 老板位
  bool isBoss = true;
  bool isJinyiin = false;
  String BgType = '';
  var listen, listenRoomback;
  /// 声网使用
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool isShow = false;
  late final Gradient gradient;
  FocusNode? _focusNode;
  // 房间名称、背景图、动态背景图热度、公告、关注状态、当前身份、贵族id、房间id
  String roomName = '', bgImage = '', bgSVGA = '', hot_degree = '', notice = '', follow_status = '', role = '', noble_id = '', roomNumber = '',roomHeadImg = '';
  List<MikeList> listM = [];
  ///大厅使用
  List<Map> imgList = [
    {"url": "assets/svga/gp/l_maliao.svga"},
    {"url": "assets/svga/gp/l_sc.svga"},
  ];
  List<Map> imgList2 = [
    {"url": "assets/svga/gp/l_zp.svga"},
    {"url": "assets/svga/gp/l_mf.svga"},
  ];


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

    doPostRoomInfo(widget.roomId);

    listenRoomback = eventBus.on<RoomBack>().listen((event) {
      switch(event.title){
        case '闭麦':
          setState(() {
            isJinyiin = !isJinyiin;
          });
          break;
        case '收藏':
          LogE('****===');
          doPostFollow('2', widget.roomId, '1');
          break;
        case '取消收藏':
          LogE('****===++++++');
          doPostFollow('2', widget.roomId, '0');
          break;
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

  Widget itemMessages(BuildContext context, int i) {
    return RoomItems.itemMessages(context, i);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isOK ? Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          //设置Container修饰
          image: DecorationImage(
            //背景图片修饰
            image: BgType.isEmpty ?  const AssetImage('assets/images/room_bg.png') :
            (BgType == '1'
                ? NetworkImage(bgImage)
                : SvgPicture.asset(bgSVGA) as ImageProvider),
            fit: BoxFit.fill, //覆盖
          ),
        ),
        child: Stack(
          children: [
            Column(
              children: [
                WidgetUtils.commonSizedBox(35, 0),
                // 头部
                RoomItems.roomTop(context, roomHeadImg, roomName, roomNumber, follow_status, hot_degree, widget.roomId),
                WidgetUtils.commonSizedBox(10, 0),
                /// 公告 和 厅主
                RoomItems.notices(context, m0,notice, listM),
                /// 麦序位
                RoomItems.maixu(m1, m2, m3, m4, m5, m6, m7, m8, isBoss, listM),
                Expanded(
                  child: Stack(
                    children: [
                      /// 消息列表
                      ListView.builder(
                        padding: EdgeInsets.only(top: ScreenUtil().setHeight(20)),
                        itemBuilder: itemMessages,
                        itemCount: 15,
                      ),
                      RoomItems.lunbotu1(context, imgList),
                      RoomItems.lunbotu2(context, imgList2),
                    ],
                  ),
                ),
                /// 底部按钮信息
                RoomItems.footBtn(context, isJinyiin),
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
      ) : Container(
        height: double.infinity,
        width: double.infinity,
        color: Colors.black87,
      ),

    );
  }


  /// 加入房间前
  Future<void> doPostRoomInfo(roomID) async {
    LogE('token== ${sp.getString('user_token')}');
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
    };
    try {
      roomInfoBean bean = await DataUtils.postRoomInfo(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            isOK = true;
            BgType = bean.data!.roomInfo!.bgType.toString();
            roomName = bean.data!.roomInfo!.roomName!;
            bgImage = bean.data!.roomInfo!.bg!;
            notice = bean.data!.roomInfo!.notice!;
            hot_degree = bean.data!.roomInfo!.hotDegree.toString();
            follow_status = bean.data!.roomInfo!.followStatus!;
            role = bean.data!.userInfo!.role!;
            noble_id = bean.data!.userInfo!.nobleId!;
            roomNumber = bean.data!.roomInfo!.roomNumber.toString();
            roomHeadImg = bean.data!.roomInfo!.coverImg!;
            isBoss = bean.data!.roomInfo!.mikeList![7].isBoss == 0 ? false : true;
            m1 = bean.data!.roomInfo!.mikeList![0].uid == 0 ? false : true;
            m2 = bean.data!.roomInfo!.mikeList![1].uid == 0 ? false : true;
            m3 = bean.data!.roomInfo!.mikeList![2].uid == 0 ? false : true;
            m4 = bean.data!.roomInfo!.mikeList![3].uid == 0 ? false : true;
            m5 = bean.data!.roomInfo!.mikeList![4].uid == 0 ? false : true;
            m6 = bean.data!.roomInfo!.mikeList![5].uid == 0 ? false : true;
            m7 = bean.data!.roomInfo!.mikeList![6].uid == 0 ? false : true;
            m8 = bean.data!.roomInfo!.mikeList![7].uid == 0 ? false : true;
            m0 = bean.data!.roomInfo!.mikeList![8].uid == 0 ? false : true;

            listM = bean.data!.roomInfo!.mikeList!;
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
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }


  /// 关注用户或房间
  Future<void> doPostFollow(String type, String follow_id, String status) async {
    Map<String, dynamic> params = <String, dynamic>{
      'type': type,
      'status': status,
      'follow_id': follow_id,
    };
    try {
      CommonBean bean = await DataUtils.postFollow(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            follow_status = status;
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
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }

}
