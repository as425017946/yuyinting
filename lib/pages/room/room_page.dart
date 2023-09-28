import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
  List<bool> upOrDown = [];
  List<bool> isMy = [];
  bool isOK = false;
  // 老板位
  bool isBoss = true;
  // 房间动效、房间声音、房间密码
  bool roomDX = true, roomSY = true, mima = false;
  bool isJinyiin = false;
  //是否被禁言了
  int isForbation =0;
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
  int isHomeShow = 1,isRoomBoss = 1;
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
    for(int i=0;i<9;i++){
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
      }else if (event.title == '动效') {
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
      }
    });

    doPostRoomInfo();

    listenRoomback = eventBus.on<RoomBack>().listen((event) {
      switch(event.title){
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
            for(int i=0;i<9;i++){
              upOrDown[i] = false;
            }
            for(int i=0;i<9;i++){
              isMy[i] = false;
            }
            upOrDown[int.parse(event.index!)] = true;
          });
          break;
        case '上麦':
          doPostSetmai(event.index!,'up');
          setState(() {
            for(int i=0;i<9;i++){
              upOrDown[i] = false;
            }
          });
          break;
        case '下麦':
          doPostSetmai(event.index!,'down');
          setState(() {
            for(int i=0;i<9;i++){
              isMy[i] = false;
            }
            for(int i=0;i<9;i++){
              upOrDown[i] = false;
            }
          });
          break;
        case '闭麦':

          break;
        case '自己':
          setState(() {
            for(int i=0;i<9;i++){
              isMy[i] = false;
            }
            for(int i=0;i<9;i++){
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
    // 这里后续要改，要传一个用户的id，目前没有，先写一个0
    return RoomItems.itemMessages(context, i, '0', widget.roomId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isOK ? GestureDetector(
        onTap: ((){
          setState(() {
            for(int i=0;i<9;i++){
              upOrDown[i] = false;
            }
            for(int i=0;i<9;i++){
              isMy[i] = false;
            }
          });
        }),
        child: Container(
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
                  RoomItems.notices(context, m0,notice, listM, widget.roomId),
                  /// 麦序位
                  RoomItems.maixu(context, m1, m2, m3, m4, m5, m6, m7, m8, isBoss, listM, widget.roomId),
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
                  RoomItems.footBtn(context, isJinyiin, isForbation, widget.roomId,isHomeShow,isRoomBoss,mima),
                ],
              ),
              /// 上麦下麦
              RoomItems.noPeople(upOrDown,0),
              RoomItems.noPeople(upOrDown,1),
              RoomItems.noPeople(upOrDown,2),
              RoomItems.noPeople(upOrDown,3),
              RoomItems.noPeople(upOrDown,4),
              RoomItems.noPeople(upOrDown,5),
              RoomItems.noPeople(upOrDown,6),
              RoomItems.noPeople(upOrDown,7),
              RoomItems.noPeople(upOrDown,8),
              /// 点击自己使用
              RoomItems.isMe(0,listM,isMy[0]),
              RoomItems.isMe(1,listM,isMy[1]),
              RoomItems.isMe(2,listM,isMy[2]),
              RoomItems.isMe(3,listM,isMy[3]),
              RoomItems.isMe(4,listM,isMy[4]),
              RoomItems.isMe(5,listM,isMy[5]),
              RoomItems.isMe(6,listM,isMy[6]),
              RoomItems.isMe(7,listM,isMy[7]),
              RoomItems.isMe(8,listM,isMy[8]),
            ],
          ),
        ),
      ) : Container(
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
            sp.setString('roomNumber', bean.data!.roomInfo!.roomNumber.toString());
            sp.setString('roomImage', bean.data!.roomInfo!.coverImgUrl!);
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

  /// 上麦，下麦
  Future<void> doPostSetmai(String serial_number,String action) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomId,
      'serial_number': int.parse(serial_number)+1,
      'uid': sp.getString('user_id').toString(),
      'action': action
    };
    try {
      CommonBean bean = await DataUtils.postSetmai(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          doPostRoomInfo2(serial_number,action);
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
  Future<void> doPostRoomInfo2(String index,String action) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomId,
    };
    try {
      roomInfoBean bean = await DataUtils.postRoomInfo(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            listM[int.parse(index)] = bean.data!.roomInfo!.mikeList![int.parse(index)];
            switch(index){
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
}
