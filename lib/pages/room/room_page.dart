import 'dart:async';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yuyinting/config/my_config.dart';
import 'package:yuyinting/pages/room/room_bq_page.dart';
import 'package:yuyinting/pages/room/room_send_info_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import 'package:yuyinting/widget/SVGASimpleImage2.dart';
import '../../bean/Common_bean.dart';
import '../../bean/roomInfoBean.dart';
import '../../colors/my_colors.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/SlideAnimationController.dart';
import '../../utils/log_util.dart';
import '../../utils/style_utils.dart';
import '../../widget/SVGASimpleImage.dart';
import '../../widget/SVGASimpleImage3.dart';
import '../home/home_items.dart';
import 'room_items.dart';

/// 厅内
class RoomPage extends StatefulWidget {
  String roomId;

  RoomPage({Key? key, required this.roomId}) : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  // 点击的类型
  int leixing = 0;
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
  var listen,
      listenRoomback,
      listenCheckBG,
      listenZDY,
      listJoin,
      listenShowLiWu,
      listenSend,
      listenSendImg;

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

  // list里面的type 0 代表系统公告 1 房间内的公告 2谁进入了房间 3厅内用户正常聊天
  List<Map> list = [];
  // 这个只存用户聊天信息
  List<Map> list2 = [];

  // 发言倒计时
  Timer? _timer;
  int _timeCount = 5;

  // 发送爆灯使用 wherePeople在哪个麦序上，0不在麦上  _timer2和_timeCount2是爆灯的倒计时
  int wherePeople = 0;
  Timer? _timer2;
  int _timeCount2 = 10;

  void _startTimer() {
    _timer = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => {
              setState(() {
                if (_timeCount <= 0) {
                  _timer!.cancel();
                  _timeCount = 5;
                } else {
                  _timeCount -= 1;
                }
              })
            });
  }

  void _startTimer2() {
    _timer2 = Timer.periodic(
        const Duration(seconds: 1),
        (Timer timer) => {
              setState(() {
                if (_timeCount2 <= 0) {
                  _timer2!.cancel();
                  _timeCount2 = 10;
                  setState(() {
                    wherePeople = 0;
                  });
                } else {
                  _timeCount2 -= 1;
                }
              })
            });
  }

  // 送礼选中了那个用户
  var listenPeople;
  List<bool> listPeople = [];
  /// 公屏使用
  late SlideAnimationController slideAnimationController;
  String path = ''; // 图片地址
  String name = '蓝魔方'; // 要展示公屏的名称


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //添加系统公告
    setState(() {
      Map<String, String> map = {};
      map['info'] =
          '官方倡导绿色聊天，对聊天内容24小时在线巡查，严禁未成年人充值消费，严禁宣传与政治、色情、敏感话题等相关内容，任何传播违法/违规/低俗/暴力等不良信息的行为会导致封禁账号。';
      map['type'] = '0';
      list.add(map);
    });
    doPostRoomInfo();
    //是否上麦下麦和点击的是否自己
    for (int i = 0; i < 9; i++) {
      upOrDown.add(false);
      isMy.add(false);
      listPeople.add(false);
    }
    // //初始化声网的音频插件
    // initAgora();
    // //初始化声卡采集
    // if(Platform.isWindows || Platform.isMacOS){
    //   starSK();
    // }
    // 厅内设置监听
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
      } else if (event.title == '表情') {
        // 判断是不是贵族，除了0都是贵族身份
        if (noble_id == '0') {
          if (_timeCount == 5) {
            if (isForbation == 0) {
              MyUtils.goTransparentPage(context, const RoomBQPage());
            } else {
              MyToastUtils.showToastBottom('你已被房间禁言！');
            }
          } else {
            MyToastUtils.showToastBottom('太频繁啦，请歇一歇~');
          }
        } else {
          if (isForbation == 0) {
            MyUtils.goTransparentPage(context, const RoomBQPage());
          } else {
            MyToastUtils.showToastBottom('你已被房间禁言！');
          }
        }
      } else if (event.title == '聊天') {
        // 判断是不是贵族，除了0都是贵族身份
        if (noble_id == '0') {
          if (_timeCount == 5) {
            if (isForbation == 0) {
              MyUtils.goTransparentPage(
                  context,
                  RoomSendInfoPage(
                    info: '',
                  ));
            } else {
              MyToastUtils.showToastBottom('你已被房间禁言！');
            }
          } else {
            MyToastUtils.showToastBottom('太频繁啦，请歇一歇~');
          }
        } else {
          if (isForbation == 0) {
            MyUtils.goTransparentPage(
                context,
                RoomSendInfoPage(
                  info: '',
                ));
          } else {
            MyToastUtils.showToastBottom('你已被房间禁言！');
          }
        }
      } else if (event.title == '爆灯') {
        for (int i = 0; i < listM.length; i++) {
          if (sp.getString('user_id').toString() == listM[i].uid.toString()) {
            setState(() {
              wherePeople = i + 1;
            });
          }
        }
        // 如果在麦上，就开启爆灯模式
        if (wherePeople != 0) {
          _startTimer2();
        } else {
          MyToastUtils.showToastBottom('上麦后才可以使用哦~');
        }
      }
    });
    // 厅内操作监听
    listenRoomback = eventBus.on<RoomBack>().listen((event) {
      switch (event.title) {
        case '关闭声音':
          setState(() {
            isJinyiin = !isJinyiin;
          });
          break;
        case '收藏':
          doPostFollow('2', widget.roomId, '1');
          break;
        case '取消收藏':
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
        case '欢迎':
          // 用户id
          String uid = event.index!.split(',')[0];
          // 点击的list里面的第几个
          String index = event.index!.split(',')[1];
          setState(() {
            list[int.parse(index)]['isWelcome'] = '1';
          });
          doPostRoomWelcomeMsg(uid);
          break;
        case '已播放完成':
          setState(() {
            list[int.parse(event.index!)]['isOK'] = 'true';
          });
          break;
      }
    });
    // 更换背景图监听
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
    // 上麦下麦等操作im监听
    listenZDY = eventBus.on<ZDYBack>().listen((event) {
      if (event.map!['room_id'].toString() == widget.roomId) {
        switch (event.type) {
          case 'up_mic': //上麦
            setState(() {
              for (int i = 0; i < 9; i++) {
                upOrDown[i] = false;
              }
            });
            doPostRoomInfo2(
                (int.parse(event.map!['serial_number'].toString()) - 1)
                    .toString());
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
            doPostRoomInfo2(
                (int.parse(event.map!['serial_number'].toString()) - 1)
                    .toString());
            break;
          case 'lock_mic': //锁麦
            setState(() {
              listM[int.parse(event.map!['serial_number'].toString()) - 1]
                  .isLock = 1;
            });
            break;
          case 'unlock_mic': //未锁麦
            setState(() {
              listM[int.parse(event.map!['serial_number'].toString()) - 1]
                  .isLock = 0;
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
              listM[int.parse(event.map!['serial_number'].toString()) - 1]
                  .isClose = 1;
            });
            break;
          case 'un_close_mic': //开麦
            setState(() {
              listM[int.parse(event.map!['serial_number'].toString()) - 1]
                  .isClose = 0;
            });
            break;
        }
      }
    });
    // 加入房间监听
    listJoin = eventBus.on<JoinRoomYBack>().listen((event) {
      LogE('接收到了信息${event.map!['type']}');
      if (event.map!['room_id'].toString() == widget.roomId) {
        // 判断是不是点击了欢迎某某人
        if (event.map!['type'] == 'welcome_msg') {
          Map<dynamic, dynamic> map = {};
          map['info'] = event.map!['send_nickname'];
          map['uid'] = event.map!['uid'];
          map['type'] = '3';
          // 欢迎语信息
          map['content'] =
              '${event.map!['send_nickname']},${event.map!['content']}';
          // 身份
          map['identity'] = event.map!['identity'];
          // 等级
          map['lv'] = event.map!['send_level'];
          // 贵族
          map['noble_id'] = event.map!['noble_id'];
          // 萌新
          map['is_new'] = event.map!['is_new'];
          // 是否靓号
          map['is_pretty'] = event.map!['is_pretty'];
          // 新贵
          map['new_noble'] = event.map!['new_noble'];
          // 是否点击了欢迎 0未欢迎 1已欢迎
          map['isWelcome'] = '0';

          setState(() {
            list.add(map);
          });
        } else if (event.map!['type'] == 'chatroom_msg') {
          //厅内发送的文字消息
          Map<dynamic, dynamic> map = {};
          map['info'] = event.map!['nickname'];
          map['uid'] = event.map!['uid'];
          map['type'] = '4';
          // 发送的信息
          map['content'] = event.map!['content'];
          // 发送的图片
          map['image'] = event.map!['image'];
          // 身份
          map['identity'] = event.map!['identity'];
          // 等级
          map['lv'] = event.map!['lv'];
          // 贵族
          map['noble_id'] = event.map!['noble_id'];
          // 萌新
          map['is_new'] = event.map!['is_new'];
          // 是否靓号
          map['is_pretty'] = event.map!['is_pretty'];
          // 新贵
          map['new_noble'] = event.map!['new_noble'];
          // 是否点击了欢迎 0未欢迎 1已欢迎
          map['isWelcome'] = '0';
          // svga动画是否播放完成
          map['isOk'] = 'false';

          setState(() {
            list.add(map);
            list2.add(map);
          });
        } else {
          bool isHave = false;
          for (int i = 0; i < list.length; i++) {
            if (list[i]['type'] == '1') {
              setState(() {
                isHave = true;
              });
            }
          }
          if (!isHave) {
            Map<dynamic, dynamic> mapg = {};
            mapg['info'] = event.map!['notice'];
            mapg['type'] = '1';
            setState(() {
              list.add(mapg);
            });
          }

          Map<dynamic, dynamic> map = {};
          map['info'] = event.map!['nickname'];
          map['type'] = '2';
          map['uid'] = event.map!['uid'];
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
          // 是否点击了欢迎 0未欢迎 1已欢迎
          map['isWelcome'] = '0';
          setState(() {
            list.add(map);
          });
        }

        WidgetsBinding.instance!.addPostFrameCallback((_) {
          scrollToLastItem(); // 在widget构建完成后滚动到底部
        });
      }
    });
    // 发消息监听
    listenSend = eventBus.on<SendRoomInfoBack>().listen((event) {
      _startTimer();
      doPostRoomMessageSend(event.info, 0);
    });
    // 发图片监听
    listenSendImg = eventBus.on<SendRoomImgBack>().listen((event) {
      _startTimer();
      doPostRoomMessageSend(event.info, 1);
    });
    // 送礼选中了那个用户监听
    listenPeople = eventBus.on<ChoosePeopleBack>().listen((event) {
      setState(() {
        for (int i = 0; i < 9; i++) {
          listPeople[i] = event.listPeople[i];
        }
      });
    });

    switch (name) {
      case '超级转盘':
        setState(() {
          path = 'assets/svga/gp/gp_zp2.svga';
        });
        break;
      case '心动转盘':
        setState(() {
          path = 'assets/svga/gp/gp_zp1.svga';
        });
        break;
      case '马里奥':
        setState(() {
          path = 'assets/svga/gp/gp_maliao.svga';
        });
        break;
      case '白鬼':
        setState(() {
          path = 'assets/svga/gp/gp_gui.svga';
        });
        break;
      case '低贵族':
        setState(() {
          path = 'assets/svga/gp/gp_guizu_d.svga';
        });
        break;
      case '高贵族':
        setState(() {
          path = 'assets/svga/gp/gp_guizu_g.svga';
        });
        break;
      case '蓝魔方':
        setState(() {
          path = 'assets/svga/gp/gp_lan.svga';
        });
        break;
      case '金魔方':
        setState(() {
          path = 'assets/svga/gp/gp_jin.svga';
        });
        break;
      case '1q直刷':
        setState(() {
          path = 'assets/svga/gp/gp_1q.svga';
        });
        break;
      case '1w直刷':
        setState(() {
          path = 'assets/svga/gp/gp_1w.svga';
        });
        break;
    }
    // 在页面中使用自定义时间和图片地址
    slideAnimationController = SlideAnimationController(
      vsync: this,
      duration: const Duration(seconds: 30), // 自定义时间
    );
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      slideAnimationController.playAnimation();
    });
  }

  final ScrollController _scrollController = ScrollController();
  final ScrollController _scrollController2 = ScrollController();

  // 在数据变化后将滚动位置设置为最后一个item的位置
  void scrollToLastItem() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );

    _scrollController.addListener(() {
      // 在这里处理滚动事件
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels == 0) {
          // ListView已经滚动到顶部
          print('ListView已经滚动到顶部');
          for (int i = 0; i < list.length; i++) {
            list[i]['isOk'] = 'true';
          }
          // 执行你的操作
        } else {
          // ListView已经滚动到底部
          print('ListView已经滚动到底部');
          // 执行你的操作
          for (int i = 0; i < list.length; i++) {
            list[i]['isOk'] = 'true';
          }
        }
      }
    });

    _scrollController2.animateTo(
      _scrollController2.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );

    _scrollController2.addListener(() {
      // 在这里处理滚动事件
      if (_scrollController2.position.atEdge) {
        if (_scrollController2.position.pixels == 0) {
          // ListView已经滚动到顶部
          print('ListView已经滚动到顶部');
          for (int i = 0; i < list2.length; i++) {
            list2[i]['isOk'] = 'true';
          }
          // 执行你的操作
        } else {
          // ListView已经滚动到底部
          print('ListView已经滚动到底部');
          // 执行你的操作
          for (int i = 0; i < list2.length; i++) {
            list2[i]['isOk'] = 'true';
          }
        }
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
    listenZDY.cancel();
    listJoin.cancel();
    listenSend.cancel();
    listenSendImg.cancel();
    _engine.disableAudio();
    _scrollController.dispose();
    listenPeople.cancel();
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
  /// 纯用户聊天使用展示消息地方
  Widget itemMessages2(BuildContext context, int i) {
    // 这里后续要改，要传一个用户的id，目前没有，先写一个0
    return RoomItems.itemMessages(context, i, '0', widget.roomId, list2, listM);
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
                            child: WidgetUtils.showImagesNet(bgImage, double.infinity, double.infinity),
                          )
                        : BgType == '2'
                            ? SizedBox(
                                height: double.infinity,
                                width: double.infinity,
                                child: SVGASimpleImage(
                                  resUrl: bgSVGA,
                                ),
                              )
                            : const Text(''),
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
                        RoomItems.notices(context, m0, notice, listM,
                            widget.roomId, wherePeople, listPeople),

                        /// 麦序位
                        RoomItems.maixu(
                            context,
                            m1,
                            m2,
                            m3,
                            m4,
                            m5,
                            m6,
                            m7,
                            m8,
                            isBoss,
                            listM,
                            widget.roomId,
                            wherePeople,
                            listPeople),
                        Expanded(
                          child: Transform.translate(
                            offset: Offset(0, -80.h),
                            child: Stack(
                              children: [
                                RoomItems.lunbotu1(context, imgList),
                                RoomItems.lunbotu2(context, imgList2, widget.roomId),
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

                    /// 聊天除使用
                    Positioned(
                      bottom: 60.h,
                      child:
                          /// 消息列表最外层
                          SizedBox(
                            height: 590.h,
                            width: 465.h,
                            child: Column(
                              children: [
                                //分类使用
                                SizedBox(
                                  height: 50.h,
                                  child: Row(
                                    children: [
                                      WidgetUtils.commonSizedBox(0, 20),
                                      GestureDetector(
                                        onTap: (() {
                                          setState(() {
                                            leixing = 0;
                                          });
                                        }),
                                        child: WidgetUtils.showImages(leixing == 0 ? 'assets/images/room_gp1.png' : 'assets/images/room_gp2.png', 25.h, 60.h),
                                      ),
                                      WidgetUtils.commonSizedBox(0, 10),
                                      Container(
                                        height: ScreenUtil().setHeight(10),
                                        width: ScreenUtil().setWidth(1),
                                        color: MyColors.roomTCWZ3,
                                      ),
                                      WidgetUtils.commonSizedBox(0, 10),
                                      GestureDetector(
                                        onTap: (() {
                                          setState(() {
                                            leixing = 1;
                                          });
                                        }),
                                        child: WidgetUtils.showImages(leixing == 1 ? 'assets/images/room_lt1.png' : 'assets/images/room_lt2.png', 25.h, 60.h),
                                      ),
                                      WidgetUtils.commonSizedBox(0, 10),
                                    ],
                                  ),
                                ),
                                Expanded(child: leixing == 0 ? ListView.builder(
                                  padding: EdgeInsets.only(
                                      left: 20.h,),
                                  itemBuilder: itemMessages,
                                  controller: _scrollController,
                                  itemCount: list.length,
                                ) : ListView.builder(
                                  padding: EdgeInsets.only(
                                    top: ScreenUtil().setHeight(10),
                                    left: 20.h,),
                                  itemBuilder: itemMessages2,
                                  controller: _scrollController,
                                  itemCount: list2.length,
                                ))
                              ],
                            ),
                          ),
                    ),

                    /// 公屏推送使用
                    HomeItems.itemAnimation(
                        path,
                        slideAnimationController.controller,
                        slideAnimationController.animation,
                        '恭喜某某用户单抽喜中价值500元的小柴一个',
                        name),
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
    LogE('userToken ${sp.getString('user_token')}');
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
            LogE('====身份$role');
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
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
                LogE(
                    '*****上下麦位置****${bean.data!.roomInfo!.mikeList![6].uid == 0}');
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 欢迎语
  Future<void> doPostRoomWelcomeMsg(String sendId) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomId,
      'uid': sendId,
      'send_id': sp.getString('user_id').toString(),
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 厅内发消息
  Future<void> doPostRoomMessageSend(String content, int type) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomId,
      'uid': sp.getString('user_id').toString(),
      'content': type == 0 ? content : '',
      'image': type == 1 ? content : '',
    };
    try {
      CommonBean bean = await DataUtils.postRoomMessageSend(params);
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
