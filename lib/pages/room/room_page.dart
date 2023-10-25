import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:permission_handler/permission_handler.dart';
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
import '../../widget/SVGASimpleImage.dart';
import 'room_items.dart';

/// 厅内
class RoomPage extends StatefulWidget {
  String roomId;

  RoomPage({Key? key, required this.roomId}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage> with SingleTickerProviderStateMixin{
  bool m0 = false,
      m1 = false,
      m2 = false,
      m3 = false,
      m4 = false,
      m5 = false,
      m6 = false,
      m7 = false,
      m8 = false;
  List<bool> upOrDown = [];
  List<bool> isMy = [];
  //页面是否加载完成
  bool isOK = false;

  // 老板位
  bool isBoss = true;

  // 房间动效、房间声音、房间密码
  bool roomDX = true, roomSY = true, mima = false;
  bool isJinyiin = false;

  //是否被禁言了
  int isForbation = 0;
  String BgType = '';
  var listen, listenRoomback, listenCheckBG, listenZDY, listJoin, listenShowLiWu;
  // 是否展示礼物动效
  bool isLWShow = false;
  /// 声网使用
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool isShow = false;
  late final Gradient gradient;
  FocusNode? _focusNode;

  // 房间名称、背景图、动态背景图热度、公告、关注状态、当前身份、贵族id、房间id
  String roomName = '',
      bgImage = '',
      bgSVGA = '',
      hot_degree = '',
      notice = '',
      follow_status = '',
      role = '',
      noble_id = '',
      roomNumber = '',
      roomHeadImg = '';
  List<MikeList> listM = [];
  int isHomeShow = 1, isRoomBoss = 1;

  ///大厅使用
  List<Map> imgList = [
    {"url": "assets/svga/gp/l_maliao.svga"},
    {"url": "assets/svga/gp/l_sc.svga"},
  ];
  List<Map> imgList2 = [
    {"url": "assets/svga/gp/l_zp.svga"},
    {"url": "assets/svga/gp/l_mf.svga"},
  ];

  List<Map> list = [];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //添加系统公告
    setState(() {
      Map<String, String> map = {};
      map['info'] = '官方倡导绿色聊天，对聊天内容24小时在线巡查，严禁未成年人充值消费，严禁宣传与政治、色情、敏感话题等相关内容，任何传播违法/违规/低俗/暴力等不良信息的行为会导致封禁账号。';
      map['type'] = '0';
      list.add(map);
    });
    doPostRoomInfo();
    //是否上麦下麦和点击的是否自己
    for (int i = 0; i < 9; i++) {
      upOrDown.add(false);
      isMy.add(false);
    }
    // //初始化声网的音频插件
    // initAgora();
    // //初始化声卡采集
    // if(Platform.isWindows || Platform.isMacOS){
    //   starSK();
    // }
    listen = eventBus.on<SubmitButtonBack>().listen((event) {
      if (event.title == '清除公屏') {
      } else if (event.title == '清除魅力') {
      } else if (event.title == '老板位0') {
        setState(() {
          isBoss = false;
        });
      } else if (event.title == '老板位1') {
        setState(() {
          isBoss = true;
        });
      } else if (event.title == '动效') {
        setState(() {
          roomDX = !roomDX;
        });
      } else if (event.title == '房间声音') {
        setState(() {
          roomSY = !roomSY;
        });
      } else if (event.title == '退出房间') {
        Navigator.pop(context);
      } else if (event.title == '收起房间') {
        Navigator.pop(context);
      } else if (event.title == '设置密码成功') {
        setState(() {
          mima = true;
        });
      } else if (event.title == '取消密码') {
        setState(() {
          mima = false;
        });
      } else if (event.title == '修改房间名称') {
        setState(() {
          roomName = sp.getString('roomName').toString();
        });
      }
    });

    listenRoomback = eventBus.on<RoomBack>().listen((event) {
      switch (event.title) {
        case '关闭声音':
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
        case '空位置':
          setState(() {
            for (int i = 0; i < 9; i++) {
              upOrDown[i] = false;
            }
            for (int i = 0; i < 9; i++) {
              isMy[i] = false;
            }
            upOrDown[int.parse(event.index!)] = true;
          });
          break;
        case '上麦':
          doPostSetmai(event.index!, 'up');
          setState(() {
            for (int i = 0; i < 9; i++) {
              upOrDown[i] = false;
            }
          });
          break;
        case '锁麦':
          doPostSetLock(event.index!, 'yes');
          break;
        case '解锁':
          doPostSetLock(event.index!, 'no');
          break;
        case '下麦':
          doPostSetmai(event.index!, 'down');
          setState(() {
            for (int i = 0; i < 9; i++) {
              isMy[i] = false;
            }
            for (int i = 0; i < 9; i++) {
              upOrDown[i] = false;
            }
          });
          break;
        case '闭麦':
          setState(() {
            listM[int.parse(event.index!)].isClose = 1;
          });
          break;
        case '开麦':
          setState(() {
            listM[int.parse(event.index!)].isClose = 0;
          });
          break;
        case '闭麦1':
          setState(() {
            listM[int.parse(event.index!)].isClose = 1;
          });
          doPostSetClose(event.index!, 'no');
          break;
        case '开麦1':
          setState(() {
            listM[int.parse(event.index!)].isClose = 0;
          });
          doPostSetClose(event.index!, 'yes');
          break;
        case '自己':
          setState(() {
            for (int i = 0; i < 9; i++) {
              isMy[i] = false;
            }
            for (int i = 0; i < 9; i++) {
              upOrDown[i] = false;
            }
            isMy[int.parse(event.index!)] = true;
          });
          break;
        case '修改了公告':
          setState(() {
            notice = event.index!;
          });
          break;
      }
    });

    listenCheckBG = eventBus.on<CheckBGBack>().listen((event) {
      setState(() {
        if (event.bgType == '1') {
          BgType = '1';
          bgImage = event.bgImagUrl;
        } else {
          BgType = '2';
          bgSVGA = event.bgImagUrl;
        }
      });
    });

    listenZDY = eventBus.on<ZDYBack>().listen((event) {
      if (event.map!['room_id'].toString() == widget.roomId) {
        switch (event.type) {
          case 'up_mic': //上麦
            setState(() {
              for (int i = 0; i < 9; i++) {
                upOrDown[i] = false;
              }
            });
            doPostRoomInfo2((int.parse(event.map!['serial_number'].toString())-1).toString());
            break;
          case 'down_mic': //下麦
            setState(() {
              for (int i = 0; i < 9; i++) {
                isMy[i] = false;
              }
              for (int i = 0; i < 9; i++) {
                upOrDown[i] = false;
              }
            });
            doPostRoomInfo2((int.parse(event.map!['serial_number'].toString())-1).toString());
            break;
          case 'lock_mic': //锁麦
            setState(() {
              listM[int.parse(event.map!['serial_number'].toString())-1].isLock = 1;
            });
            break;
          case 'unlock_mic': //未锁麦
            setState(() {
              listM[int.parse(event.map!['serial_number'].toString())-1].isLock = 0;
            });
            break;
          case 'set_boss': //设置老板位
            setState(() {
              isRoomBoss = 1;
              isBoss = true;
            });
            break;
          case 'cancel_boss': //取消老板位
            setState(() {
              isRoomBoss = 0;
              isBoss = false;
            });
            break;
          case 'close_mic': //闭麦
            setState(() {
              listM[int.parse(event.map!['serial_number'].toString())-1].isClose = 1;
            });
            break;
          case 'un_close_mic': //开麦
            setState(() {
              listM[int.parse(event.map!['serial_number'].toString())-1].isClose = 0;
            });
            break;
        }
      }
    });

    listJoin = eventBus.on<JoinRoomYBack>().listen((event) {
      LogE('接收到了信息');
      if(event.map!['room_id'].toString() == widget.roomId){
        Map<dynamic, dynamic> mapg = {};
        mapg['info'] = event.map!['notice'];
        mapg['type'] = '1';
        list.add(mapg);

        Map<dynamic, dynamic> map = {};
        map['info'] = event.map!['nickname'];
        map['type'] = '2';
        //身份
        map['identity'] = event.map!['identity'];
        //等级
        map['lv'] = event.map!['lv'];
        // 贵族
        map['noble_id'] = event.map!['noble_id'];
        // 萌新
        map['is_new'] = event.map!['is_new'];
        // 是否靓号
        map['is_pretty'] = event.map!['is_pretty'];
        // 新贵
        map['new_noble'] = event.map!['new_noble'];
        list.add(map);
        setState(() {
        });
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    listen.cancel();
    listenRoomback.cancel();
    listenCheckBG.cancel();
    listJoin.cancel();
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
        onLeaveChannel: (RtcConnection connection, RtcStats stats) {
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
    _engine.setAudioProfile(
        profile: AudioProfileType.audioProfileMusicHighQuality,
        scenario: AudioScenarioType.audioScenarioGameStreaming);
    // 开启降噪
    _engine.setAINSMode(
        enabled: true, mode: AudioAinsMode.ainsModeUltralowlatency);
  }

  /// 开启声卡
  Future<void> starSK() async {
    _engine.enableLoopbackRecording(enabled: true);
  }

  /// 展示消息地方
  Widget itemMessages(BuildContext context, int i) {
    // 这里后续要改，要传一个用户的id，目前没有，先写一个0
    return RoomItems.itemMessages(context, i, '0', widget.roomId, list, listM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
      body: isOK
          ? GestureDetector(
              onTap: (() {
                setState(() {
                  for (int i = 0; i < 9; i++) {
                    upOrDown[i] = false;
                  }
                  for (int i = 0; i < 9; i++) {
                    isMy[i] = false;
                  }
                });
              }),
              child: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.white,
                child: Stack(
                  children: [
                    BgType == '1'
                        ? SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: Image(
                              image: NetworkImage(bgImage),
                              fit: BoxFit.fill,
                            ),
                          )
                        : SizedBox(
                            height: double.infinity,
                            width: double.infinity,
                            child: SVGASimpleImage(
                              resUrl: bgSVGA,
                            ),
                          ),
                    Column(
                      children: [
                        WidgetUtils.commonSizedBox(35, 0),
                        // 头部
                        RoomItems.roomTop(
                            context,
                            roomHeadImg,
                            roomName,
                            roomNumber,
                            follow_status,
                            hot_degree,
                            widget.roomId),
                        WidgetUtils.commonSizedBox(10, 0),

                        /// 公告 和 厅主
                        RoomItems.notices(
                            context, m0, notice, listM, widget.roomId),

                        /// 麦序位
                        RoomItems.maixu(context, m1, m2, m3, m4, m5, m6, m7, m8,
                            isBoss, listM, widget.roomId),
                        Expanded(
                          child: Transform.translate(
                            offset: Offset(0, -80.h),
                            child: Stack(
                              children: [
                                /// 消息列表
                                ListView.builder(
                                  padding: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(20), left: 20.h, right: 160.h),
                                  itemBuilder: itemMessages,
                                  itemCount: list.length,
                                ),
                                RoomItems.lunbotu1(context, imgList),
                                RoomItems.lunbotu2(context, imgList2),
                              ],
                            ),
                          ),
                        ),

                        /// 底部按钮信息
                        RoomItems.footBtn(context, isJinyiin, isForbation,
                            widget.roomId, isHomeShow, isRoomBoss, mima, listM),
                      ],
                    ),

                    /// 上麦下麦
                    RoomItems.noPeople(upOrDown, 0, listM),
                    RoomItems.noPeople(upOrDown, 1, listM),
                    RoomItems.noPeople(upOrDown, 2, listM),
                    RoomItems.noPeople(upOrDown, 3, listM),
                    RoomItems.noPeople(upOrDown, 4, listM),
                    RoomItems.noPeople(upOrDown, 5, listM),
                    RoomItems.noPeople(upOrDown, 6, listM),
                    RoomItems.noPeople(upOrDown, 7, listM),
                    RoomItems.noPeople(upOrDown, 8, listM),

                    /// 点击自己使用
                    RoomItems.isMe(0, listM, isMy[0]),
                    RoomItems.isMe(1, listM, isMy[1]),
                    RoomItems.isMe(2, listM, isMy[2]),
                    RoomItems.isMe(3, listM, isMy[3]),
                    RoomItems.isMe(4, listM, isMy[4]),
                    RoomItems.isMe(5, listM, isMy[5]),
                    RoomItems.isMe(6, listM, isMy[6]),
                    RoomItems.isMe(7, listM, isMy[7]),
                    RoomItems.isMe(8, listM, isMy[8]),
                  ],
                ),
              ),
            )
          : Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black87,
            ),
    );
  }

  /// 房间信息
  Future<void> doPostRoomInfo() async {
    LogE('token== ${sp.getString('user_token')}');
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomId,
    };
    try {
      roomInfoBean bean = await DataUtils.postRoomInfo(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            isOK = true;
            sp.setString('roomID', widget.roomId);
            sp.setString('roomName', bean.data!.roomInfo!.roomName!);
            sp.setString(
                'roomNumber', bean.data!.roomInfo!.roomNumber.toString());
            sp.setString('roomImage', bean.data!.roomInfo!.coverImgUrl!);
            sp.setString('roomNotice', bean.data!.roomInfo!.notice!);
            sp.setString('roomPass', bean.data!.roomInfo!.secondPwd!);
            BgType = bean.data!.roomInfo!.bgType.toString();
            bgSVGA = bean.data!.roomInfo!.bgUrl!;
            roomName = bean.data!.roomInfo!.roomName!;
            bgImage = bean.data!.roomInfo!.bgUrl!;
            notice = bean.data!.roomInfo!.notice!;
            hot_degree = bean.data!.roomInfo!.hotDegree.toString();
            follow_status = bean.data!.roomInfo!.followStatus!;
            role = bean.data!.userInfo!.role!;
            sp.setString('role', bean.data!.userInfo!.role!);
            noble_id = bean.data!.userInfo!.nobleId!;
            roomNumber = bean.data!.roomInfo!.roomNumber.toString();
            roomHeadImg = bean.data!.roomInfo!.coverImgUrl!;
            isBoss =
                bean.data!.roomInfo!.mikeList![7].isBoss == 0 ? false : true;
            m1 = bean.data!.roomInfo!.mikeList![0].uid == 0 ? false : true;
            m2 = bean.data!.roomInfo!.mikeList![1].uid == 0 ? false : true;
            m3 = bean.data!.roomInfo!.mikeList![2].uid == 0 ? false : true;
            m4 = bean.data!.roomInfo!.mikeList![3].uid == 0 ? false : true;
            m5 = bean.data!.roomInfo!.mikeList![4].uid == 0 ? false : true;
            m6 = bean.data!.roomInfo!.mikeList![5].uid == 0 ? false : true;
            m7 = bean.data!.roomInfo!.mikeList![6].uid == 0 ? false : true;
            m8 = bean.data!.roomInfo!.mikeList![7].uid == 0 ? false : true;
            m0 = bean.data!.roomInfo!.mikeList![8].uid == 0 ? false : true;
            isForbation = bean.data!.roomInfo!.isForbation as int;
            listM = bean.data!.roomInfo!.mikeList!;
            isHomeShow = bean.data!.roomInfo!.isShow as int;
            isRoomBoss = bean.data!.roomInfo!.mikeList![7].isBoss as int;
            mima = bean.data!.roomInfo!.secondPwd!.isNotEmpty ? true : false;
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
  Future<void> doPostFollow(
      String type, String follow_id, String status) async {
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

  /// 上麦，下麦
  Future<void> doPostSetmai(String serial_number, String action) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomId,
      'serial_number': int.parse(serial_number) + 1,
      'uid': sp.getString('user_id').toString(),
      'action': action
    };
    try {
      CommonBean bean = await DataUtils.postSetmai(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          doPostRoomInfo2(serial_number);
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

  ///上麦下麦刷新使用
  Future<void> doPostRoomInfo2(String index) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomId,
    };
    try {
      roomInfoBean bean = await DataUtils.postRoomInfo(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            listM[int.parse(index)] =
                bean.data!.roomInfo!.mikeList![int.parse(index)];
            switch (index) {
              case '0':
                m1 = bean.data!.roomInfo!.mikeList![0].uid == 0 ? false : true;
                break;
              case '1':
                m2 = bean.data!.roomInfo!.mikeList![1].uid == 0 ? false : true;
                break;
              case '2':
                m3 = bean.data!.roomInfo!.mikeList![2].uid == 0 ? false : true;
                break;
              case '3':
                m4 = bean.data!.roomInfo!.mikeList![3].uid == 0 ? false : true;
                break;
              case '4':
                m5 = bean.data!.roomInfo!.mikeList![4].uid == 0 ? false : true;
                break;
              case '5':
                m6 = bean.data!.roomInfo!.mikeList![5].uid == 0 ? false : true;
                break;
              case '6':
                LogE('*****上下麦位置****$index');
                LogE('*****上下麦位置****${bean.data!.roomInfo!.mikeList![6].uid == 0}');
                m7 = bean.data!.roomInfo!.mikeList![6].uid == 0 ? false : true;
                break;
              case '7':
                m8 = bean.data!.roomInfo!.mikeList![7].uid == 0 ? false : true;
                break;
              case '8':
                m0 = bean.data!.roomInfo!.mikeList![8].uid == 0 ? false : true;
                break;
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
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }

  /// 设置房间信息
  Future<void> doPostEditRoom() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomId,
      'second_pwd': '',
    };
    try {
      CommonBean bean = await DataUtils.postEditRoom(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            MyToastUtils.showToastBottom('房间密码已关闭');
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

  /// 锁麦
  Future<void> doPostSetLock(String serial_number, String status) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomId,
      'serial_number': int.parse(serial_number) + 1,
      'status': status
    };
    try {
      CommonBean bean = await DataUtils.postSetLock(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            for (int i = 0; i < 9; i++) {
              upOrDown[i] = false;
            }
            for (int i = 0; i < 9; i++) {
              isMy[i] = false;
            }
          });
          if (status == 'yes') {
            MyToastUtils.showToastBottom('麦位已上锁');
            listM[int.parse(serial_number)].isLock = 1;
          } else {
            MyToastUtils.showToastBottom('麦位已解锁');
            listM[int.parse(serial_number)].isLock = 0;
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
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }

  /// 闭麦/开麦
  Future<void> doPostSetClose(String serial_number, String status) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomId,
      'serial_number': int.parse(serial_number) + 1,
      'uid': sp.getString('user_id').toString(),
      'status': status
    };
    try {
      CommonBean bean = await DataUtils.postSetClose(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          if (status == 'no') {
            MyToastUtils.showToastBottom('已闭麦');
          } else {
            MyToastUtils.showToastBottom('已开麦');
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
      MyToastUtils.showToastBottom("数据请求超时，请检查网络状况!");
    }
  }

  /// 欢迎语
  Future<void> doPostRoomWelcomeMsg() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomId,
    };
    try {
      CommonBean bean = await DataUtils.postRoomWelcomeMsg(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:

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
