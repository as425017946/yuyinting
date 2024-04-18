import 'dart:async';
import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screen/screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/pages/message/message_page.dart';
import 'package:yuyinting/pages/trends/trends_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';
import '../../bean/Common_bean.dart';
import '../../bean/charmAllBean.dart';
import '../../bean/hengFuBean.dart';
import '../../bean/isFirstOrderBean.dart';
import '../../bean/joinRoomBean.dart';
import '../../bean/qiehuanBean.dart';
import '../../bean/svgaAllBean.dart';
import '../../bean/xtListBean.dart';
import '../../colors/my_colors.dart';
import '../../db/DatabaseHelper.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/SlideAnimationController.dart';
import '../../utils/loading.dart';
import '../../utils/log_util.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/widget_utils.dart';
import '../gongping/gp_hi_page.dart';
import '../home/home_items.dart';
import '../home/home_page.dart';
// import '../mine/mine_page.dart';
import '../mine/mine/xc_mine_page.dart';
import '../room/room_page.dart';
import '../room/room_ts_mima_page.dart';
import 'package:http/http.dart' as http;

class Tab_Navigator extends StatefulWidget {
  const Tab_Navigator({Key? key}) : super(key: key);

  @override
  State<Tab_Navigator> createState() => _Tab_NavigatorState();
}

class _Tab_NavigatorState extends State<Tab_Navigator>
    with TickerProviderStateMixin {
  // final _defaultColor = MyColors.btn_d;
  // final _activetColor = MyColors.btn_a;
  int _currentIndex = 0;

  //定义个变量，检测两次点击返回键的时间，如果在1秒内点击两次就退出
  DateTime? lastPopTime = null;

  late final PageController _controller;

  // 是否开始拖拽
  bool isDragNow = false;

  // 是否将要删除
  bool isRemove = false;

  // 是否有进入房间返回出来
  bool isJoinRoom = false;

  // 收起房间是否点击了回去
  bool isFirstJoinRoom = false;

  /// 会重复播放的控制器
  late AnimationController _repeatController;

  /// 线性动画
  late Animation<double> _animation;

  /// 公屏使用
  SlideAnimationController? slideAnimationController;
  String path = ''; // 图片地址
  String name = ''; // 要展示公屏的名称
  bool isShowHF = false; // 是否显示横幅
  String msg = ''; // 拼接显示数据
  List<hengFuBean> listMP = []; // 存放每个进来的公屏，按顺序播放
  late hengFuBean myhf; //出现第一个横幅使用
  ///爆出大礼物使用
  bool isBig = false;
  int bigType = 0; //大礼物默认是爆出 0爆出1送出

  var listen,
      listenZdy,
      listenRoomBack,
      listenMessage,
      listenZDY,
      listenShouQi,
      listenJoinHF;
  bool isSDKInit = false;

  // 是否开始预下载
  bool isDown = false;

  // 设备是安卓还是ios
  String isDevices = 'android';

  @override
  void initState() {
    if (Platform.isAndroid) {
      setState(() {
        isDevices = 'android';
      });
    } else if (Platform.isIOS) {
      setState(() {
        isDevices = 'ios';
      });
    }
    // 清空存储信息
    deleteChatInfo();
    doPostSystemMsgList();
    MyUtils.initSDK();
    MyUtils.addChatListener();
    //先退出然后在登录
    MyUtils.signOutLogin();
    // //保持屏幕常亮
    // saveLiang();
    doPostIsFirstOrder();
    super.initState();
    initE();
    _currentIndex = 0;
    _controller = PageController(
      initialPage: 0,
    );

    /// 动画持续时间是 3秒，此处的this指 TickerProviderStateMixin
    _repeatController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat(); // 设置动画重复播放

    // 创建一个从0到360弧度的补间动画 v * 2 * π
    _animation = Tween<double>(begin: 0, end: 1).animate(_repeatController);

    // 中大奖使用，目前接口没有接，所以先注释
    // setState(() {
    //   isBig = true;
    // });
    listen = eventBus.on<ResidentBack>().listen((event) {
      setState(() {
        isBig = false;
      });
    });
    // 接受自定义消息
    listenZdy = eventBus.on<JoinRoomYBack>().listen((event) {
      LogE('聊天室消息  ${sp.getString('sqRoomID').toString() == event.map!['room_id'].toString()}');
      if (event.map!['type'] == 'send_all_user' || event.map!['type'] == 'blind_box_all') {
        LogE('前面有没有横幅  ${listMP.length}');
        if (listMP.isEmpty) {
          hengFuBean hf = hengFuBean.fromJson(event.map!);
          myhf = hf;
          //显示横幅、map赋值
          setState(() {
            isShowHF = true;
            listMP.add(hf);
          });
          // 判断数据显示使用
          showInfo(hf);
          // 看看集合里面有几个，10s一执行
          hpTimer();
        } else {
          hengFuBean hf = hengFuBean.fromJson(event.map!);
          myhf = hf;
          setState(() {
            listMP.add(hf);
          });
        }
      } else if (event.map!['type'] == 'chatroom_msg' && sp.getString('sqRoomID').toString() == event.map!['room_id'].toString()) {
        saveChatInfo(
            event.map!, '4', event.map!['nickname'], event.map!['content']);
      } else if (event.map!['type'] == 'welcome_msg' && sp.getString('sqRoomID').toString() == event.map!['room_id'].toString()) {
        saveChatInfo(event.map!, '3', event.map!['send_nickname'],
            '${event.map!['nickname']},${event.map!['content']}');
      } else if (event.map!['type'] == 'send_gift' && sp.getString('sqRoomID').toString() == event.map!['room_id'].toString()) {
        //厅内发送的送礼物消息
        charmAllBean cb = charmAllBean.fromJson(event.map);
        saveChatInfo(event.map!, '5', event.map!['nickname'],
            '${event.map!['from_nickname']};向;${event.map!['to_nickname']};送出${cb.giftInfo![0].giftName!}(${cb.giftInfo![0].giftPrice.toString()}); x${cb.giftInfo![0].giftNumber.toString()}');
      } else if (event.map!['type'] == 'one_click_gift' && sp.getString('sqRoomID').toString() == event.map!['room_id'].toString()) {
        charmAllBean cb = charmAllBean.fromJson(event.map);
        String infos = ''; // 这个是拼接用户送的礼物信息使用
        for (int i = 0; i < cb.giftInfo!.length; i++) {
          if (infos.isEmpty) {
            setState(() {
              infos =
                  '${cb.giftInfo![i].giftName!}(${cb.giftInfo![i].giftPrice.toString()}) x${cb.giftInfo![i].giftNumber}';
            });
          } else {
            setState(() {
              infos =
                  '$infos,${cb.giftInfo![i].giftName!}(${cb.giftInfo![i].giftPrice.toString()}) x${cb.giftInfo![i].giftNumber}';
            });
          }
        }
        saveChatInfo(event.map!, '6', event.map!['from_nickname'],
            '${event.map!['from_nickname']};向;${event.map!['to_nickname']};送出;$infos');
      } else if (event.map!['type'] == 'send_screen_all' && sp.getString('sqRoomID').toString() == event.map!['room_id'].toString()) {
        charmAllBean cb = charmAllBean.fromJson(event.map);
        String info = '';
        for (int i = 0; i < cb.giftInfo!.length; i++) {
          if (info.isEmpty) {
            info =
                '${cb.giftInfo![i].giftName!}(${cb.giftInfo![i].giftPrice!}) x${cb.giftInfo![i].giftNumber!}';
          } else {
            info =
                '$info ${cb.giftInfo![i].giftName!}(${cb.giftInfo![i].giftPrice!}) x${cb.giftInfo![i].giftNumber!}';
          }
        }
        saveChatInfo(event.map!, '9', cb.fromNickname!,
            '${cb.fromNickname};向;${cb.toNickname};赠送了;$info');
      } else if (event.map!['type'] == 'clean_charm' && sp.getString('sqRoomID').toString() == event.map!['room_id'].toString()) {
        // 防止用户被顶号时没有清空表
        deleteChatInfo();
      } else if(event.map!['type'] == 'clean_public_screen' && sp.getString('sqRoomID').toString() == event.map!['room_id'].toString()){
        //清除了公屏
        deleteChatInfo();
      }
    });
    // 收起房间使用
    listenRoomBack = eventBus.on<SubmitButtonBack>().listen((event) {
      LogE('账号 == ${event.title}');
      if (event.title == '收起房间') {
        sp.setBool('sqRoom', true);
        setState(() {
          isJoinRoom = true;
          isFirstJoinRoom = false;
        });
      } else if (event.title == '加入其他房间') {
        sp.setBool('sqRoom', false);
        // 判断加入过其他房间，并且现在是收起的状态
        if (isJoinRoom) {
          setState(() {
            isFirstJoinRoom = false;
            isJoinRoom = false;
            //取消订阅所有远端用户的音频流。
            _engine!.muteAllRemoteAudioStreams(true);
            // 取消发布本地音频流
            _engine!.muteLocalAudioStream(true);
            _engine!.disableAudio();
            _dispose();
            // 调用离开房间接口
            // doPostLeave(sp.getString('roomIDJoinOther').toString());
          });
        }
      } else if (event.title == '账号已在其他设备登录') {
        if (isJoinRoom) {
          setState(() {
            isFirstJoinRoom = false;
            isJoinRoom = false;
            //取消订阅所有远端用户的音频流。
            _engine!.muteAllRemoteAudioStreams(true);
            // 取消发布本地音频流
            _engine!.muteLocalAudioStream(true);
            _engine!.disableAudio();
            _dispose();
            MyUtils.jumpLogin(context);
          });
        }
      } else if (event.title == '成功切换账号') {
        deleteChatInfo();
        if (isJoinRoom) {
          setState(() {
            isFirstJoinRoom = false;
            isJoinRoom = false;
            //取消订阅所有远端用户的音频流。
            _engine!.muteAllRemoteAudioStreams(true);
            // 取消发布本地音频流
            _engine!.muteLocalAudioStream(true);
            _engine!.disableAudio();
            _dispose();
          });
        }
      } else if (event.title == '资源开始下载') {
        if (isDown == false) {
          doPostSvgaGiftList();
          doPostSvgaDressList();
        }
      } else if (event.title == '去掉旋转') {
        // 防止用户被顶号时没有清空表
        setState(() {
          sp.setBool('sqRoom', false);
          isJoinRoom = false;
        });
      } else if (event.title == '添加新账号') {
        // 防止用户被顶号时没有清空表
        deleteChatInfo();
        if (isJoinRoom) {
          setState(() {
            isFirstJoinRoom = false;
            isJoinRoom = false;
            //取消订阅所有远端用户的音频流。
            _engine!.muteAllRemoteAudioStreams(true);
            // 取消发布本地音频流
            _engine!.muteLocalAudioStream(true);
            _engine!.disableAudio();
            _dispose();
            // 调用离开房间接口
            // doPostLeave(sp.getString('roomID').toString());
          });
        }
      } else if (event.title == '账号退出登录') {
        // 防止用户被顶号时没有清空表
        deleteChatInfo();
        if (isJoinRoom) {
          setState(() {
            isFirstJoinRoom = false;
            isJoinRoom = false;
            //取消订阅所有远端用户的音频流。
            _engine!.muteAllRemoteAudioStreams(true);
            // 取消发布本地音频流
            _engine!.muteLocalAudioStream(true);
            _engine!.disableAudio();
            _dispose();
          });
        }
      } else if (event.title == 'im重连') {
        doPostCheckToken();
      } else if (event.title == 'im断开链接') {
        // if(isJoinRoom){
        //   setState(() {
        //     //取消订阅所有远端用户的音频流。
        //     _engine.muteAllRemoteAudioStreams(true);
        //     // 取消发布本地音频流
        //     _engine.muteLocalAudioStream(true);
        //   });
        // }
      }
    });

    listenMessage = eventBus.on<SendMessageBack>().listen((event) {
      doPostSystemMsgList();
    });
    // 接收自定义消息
    listenZDY = eventBus.on<ZDYBack>().listen((event) {
      //别人给我发送的打招呼
      if (event.type == 'say_hi') {
        setState(() {
          isRed = true;
        });
        MyUtils.goTransparentPageRoom(
            context,
            GPHiPage(
              uid: event.map!['uid'].toString(),
              nickName: event.map!['nickname'].toString(),
              avatar: event.map!['avatar'].toString(),
              gender: event.map!['gender'].toString(),
            ));
      } else if (event.type == 'room_black') {
        //设置黑名单
        // if (event.map!['uid'].toString() == sp.getString('user_id').toString()) {
        //   if(isJoinRoom){
        //     MyToastUtils.showToastBottom('你已被房间设置为黑名单用户！');
        //     setState(() {
        //       isJoinRoom = false;
        //       // 取消发布本地音频流
        //       _engine.muteLocalAudioStream(true);
        //       _engine.disableAudio();
        //     });
        //     _dispose();
        //   }
        // }
      } else if (event.type == 'down_mic') {
        if (isJoinRoom) {
          //判断被被下麦的人是不是自己
          if (event.map!['uid'].toString() ==
                  sp.getString('user_id').toString() &&
              event.map!['from_uid'].toString() !=
                  sp.getString('user_id').toString() && event.map!['from_uid'].toString().isNotEmpty) {
            MyToastUtils.showToastBottom('你已被管理下掉了麦序！');
            // 取消发布本地音频流
            _engine!.muteLocalAudioStream(true);
            _engine!.disableAudio();
            _dispose();
          }
        }
      } else if (event.type == 'login_kick') {
        // 这个状态是后台直接封禁了账号，然后直接踢掉app
        if (isJoinRoom) {
          MyUtils.signOut();
          setState(() {
            isJoinRoom = false;
          });
          // 取消发布本地音频流
          _engine!.muteLocalAudioStream(true);
          // 调用离开房间接口
          // doPostLeave(sp.getString('roomID').toString());
          _engine!.disableAudio();
          _dispose();
          sp.setString('user_token', '');
          sp.setString("user_account", '');
          sp.setString("user_id", '');
          sp.setString("em_pwd", '');
          sp.setString("em_token", '');
          sp.setString("user_password", '');
          sp.setString('user_phone', '');
          sp.setString('nickname', '');
          sp.setString("user_headimg", '');
          sp.setString("user_headimg_id", '');
          // 保存身份
          sp.setString("user_identity", '');
          // 直接杀死app
          SystemNavigator.pop();
        } else {
          sp.setString('user_token', '');
          sp.setString("user_account", '');
          sp.setString("user_id", '');
          sp.setString("em_pwd", '');
          sp.setString("em_token", '');
          sp.setString("user_password", '');
          sp.setString('user_phone', '');
          sp.setString('nickname', '');
          sp.setString("user_headimg", '');
          sp.setString("user_headimg_id", '');
          // 保存身份
          sp.setString("user_identity", '');
          // 直接杀死app
          SystemNavigator.pop();
        }
      } else if (event.type == 'user_room_black') {
        if (isJoinRoom) {
          if (event.map!['uid'].toString() ==
                  sp.getString('user_id').toString() &&
              sp.getString('roomID').toString() ==
                  event.map!['room_id'].toString()) {
            MyToastUtils.showToastBottom('你已被房间设置为黑名单用户！');
            // 取消发布本地音频流
            _engine!.muteLocalAudioStream(true);
            // 调用离开房间接口
            // doPostLeave(sp.getString('roomID').toString());
            _engine!.disableAudio();
            _dispose();
          }
        }
      }
    });

    //收起房间后加入了其他房间
    listenShouQi = eventBus.on<shouqiRoomBack>().listen((event) {
      if (event.title == '收起房间') {
        _engine = event.engine;
      }
    });

    listenJoinHF = eventBus.on<hfJoinBack>().listen((event) {
      if (event.title == '厅外点击横幅') {
        LogE('厅外点击横幅== ${event.roomID}');
        // 如果房间id不是0（0是大厅），没有收起房间，直接进入房间
        if (event.roomID != '0' && isJoinRoom == false) {
          doPostBeforeJoin2(event.roomID);
        } else if (event.roomID != '0' && isJoinRoom == true) {
          // 如果房间id不是0（0是大厅），收起了房间
          if (sp.getString('roomID') == event.roomID) {
            // 点击的横幅是自己在的房间
            doPostBeforeJoin(event.roomID);
          } else {
            // 点击的横幅不是自己在的房间
            doPostBeforeJoin2(event.roomID);
          }
        }
      }
    });
  }

  saveLiang() async {
    // 获取屏幕亮度:
    double brightness = await Screen.brightness;
    // 设置亮度:
    Screen.setBrightness(0.5);
    // 检测屏幕是否常亮:
    bool isKeptOn = await Screen.isKeptOn;
    // 防止进入睡眠模式:
    Screen.keepOn(true);
  }

  RtcEngine? _engine;

  //初始化
  void initE() async {
    // 创建 RtcEngine
    _engine = await createAgoraRtcEngine();
  }

  Future<void> _dispose() async {
    if(_engine != null) {
      await _engine!.leaveChannel(); // 离开频道
      await _engine!.release(); // 释放资源
    }
  }

  Timer? _timer;

  // 18秒后请求一遍
  void hpTimer() {
    _timer = Timer.periodic(const Duration(seconds: 18), (timer) {
      if (listMP.isNotEmpty) {
        setState(() {
          listMP.removeAt(0);
          LogE('移除信息 ${listMP.length}');
        });
        if (listMP.isEmpty) {
          setState(() {
            isBig = false;
            isShowHF = false;
          });
          _timer!.cancel();
        } else {
          setState(() {
            isShowHF = true;
          });
          // 判断数据显示使用
          showInfo(listMP[0]);
        }
      }
    });
  }

  // 接受到数据进行判断使用
  void showInfo(hengFuBean hf) {
    LogE('===名称===  ${hf.title}');
    switch (hf.title) {
      case '贵族':
        if (hf.nobleId! > 1 && hf.nobleId! < 5) {
          // 低贵族
          setState(() {
            name = '低贵族';
            path = 'assets/svga/gp/gp_guizu_d.svga';
          });
        } else if (hf.nobleId! > 4 && hf.nobleId! < 8) {
          // 高贵族
          setState(() {
            name = '高贵族';
            path = 'assets/svga/gp/gp_guizu_g.svga';
          });
        }
        break;
      case '抽奖超级转盘':
        if (hf.giftInfo![0].giftName == '瑞麟') {
          setState(() {
            name = '388800转盘礼物';
            isBig = true;
            isShowHF = false;
            bigType = 0;
          });
        } else {
          setState(() {
            name = '抽奖超级转盘';
            path = 'assets/svga/gp/gp_zp2.svga';
          });
        }
        break;
      case '抽奖心动转盘':
        setState(() {
          name = '抽奖心动转盘';
          path = 'assets/svga/gp/gp_zp1.svga';
        });
        break;
      case '超级转盘':
        setState(() {
          name = '超级转盘';
          path = 'assets/svga/gp/gp_zp2.svga';
        });
        break;
      case '心动转盘':
        setState(() {
          name = '心动转盘';
          path = 'assets/svga/gp/gp_zp1.svga';
        });
        break;
      case '马里奥':
        setState(() {
          name = '马里奥';
          path = 'assets/svga/gp/gp_maliao.svga';
        });
        break;
      case '白灵':
        setState(() {
          name = '白灵';
          path = 'assets/svga/gp/gp_gui.svga';
        });
        break;
      case '抽奖水星魔方':
        setState(() {
          name = '抽奖蓝魔方';
          path = 'assets/svga/gp/gp_lan.svga';
        });
        break;
      case '抽奖金星魔方':
        setState(() {
          name = '抽奖金魔方';
          path = 'assets/svga/gp/gp_jin.svga';
        });
        break;
      case '蓝魔方':
        setState(() {
          name = '蓝魔方';
          path = 'assets/svga/gp/gp_lan.svga';
        });
        break;
      case '金魔方':
        setState(() {
          name = '金魔方';
          path = 'assets/svga/gp/gp_jin.svga';
        });
        break;
      case '1q直刷':
        setState(() {
          name = '1q直刷';
          path = 'assets/svga/gp/gp_1q.svga';
        });
        break;
      case '1w直刷':
        setState(() {
          name = '1w直刷';
          path = 'assets/svga/gp/gp_1w.svga';
        });
        break;
      case '388800转盘礼物':
        setState(() {
          name = '388800转盘礼物';
          isBig = true;
          isShowHF = false;
          bigType = 0;
        });
        break;
      case '送出388800转盘礼物':
        setState(() {
          name = '送出388800转盘礼物';
          isBig = true;
          isShowHF = false;
          bigType = 1;
        });
        break;
      case '5000_9990背包礼物':
        setState(() {
          name = '5000_9990背包礼物';
          path = 'assets/svga/gp/bb_500_999.svga';
        });
        break;
      case '10000_49990背包礼物':
        setState(() {
          name = '10000_49990背包礼物';
          path = 'assets/svga/gp/bb_1000_4999.svga';
        });
        break;
      case '50000_99990背包礼物':
        setState(() {
          name = '50000_99990背包礼物';
          path = 'assets/svga/gp/bb_5000_9999.svga';
        });
        break;
      case '100000_380000背包礼物':
        setState(() {
          name = '100000_380000背包礼物';
          path = 'assets/svga/gp/bb_10000_38000.svga';
        });
        break;
      case '388800背包礼物':
        setState(() {
          name = '388800背包礼物';
          isBig = true;
          isShowHF = false;
          bigType = 1;
        });
        break;
      case '盲盒礼物横幅':
        setState(() {
          name = '盲盒礼物横幅';
          path = 'assets/svga/gp/gp_mh.svga';
        });
        break;
    }
    // 在页面中使用自定义时间和图片地址
    slideAnimationController = SlideAnimationController(
      vsync: this,
      duration: const Duration(seconds: 16), // 自定义时间
    );
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      slideAnimationController!.playAnimation();
    });
  }

  @override
  void dispose() {
    _repeatController.dispose();
    if(slideAnimationController != null){
      slideAnimationController!.dispose();
    }
    listen.cancel();
    listenZdy.cancel();
    listenRoomBack.cancel();
    listenZDY.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (lastPopTime == null ||
            DateTime.now().difference(lastPopTime!) > Duration(seconds: 1)) {
          lastPopTime = DateTime.now();

          MyToastUtils.showToastBottom("再按一次退出");
          return Future.value(false);
        } else {
          lastPopTime = DateTime.now();
          if (isJoinRoom) {
            // 取消发布本地音频流
            _engine!.muteLocalAudioStream(true);
            // 调用离开房间接口
            doPostLeave(sp.getString('roomID').toString());
            _engine!.disableAudio();
            _dispose();
          }
          // 退出app
          return Future.value(true);
        }
      },
      child: Stack(
        children: [
          Scaffold(
            body: PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(), //禁止左右滑动
              onPageChanged: (index) {
                setState(() {
                  // 更新当前的索引值
                  _currentIndex = index;
                  // 如果点击的是消息，清空红点
                  if (index == 2) {
                    eventBus.fire(BiLiBack(index: 2, number: '消息'));
                    setState(() {
                      isRed = false;
                    });
                  }
                });
              },
              children: const [
                HomePage(),
                TrendsPage(),
                MessagePage(),
                MinePage()
              ],
            ),
            bottomNavigationBar: BottomNavigationBar(
                selectedFontSize: 12,
                unselectedFontSize: 12,
                selectedItemColor: MyColors.newHomeBlack2,
                unselectedItemColor: MyColors.newHomeBlack2,
                currentIndex: _currentIndex,
                onTap: (index) {
                  _controller.jumpToPage(index);
                  setState(() {
                    _currentIndex = index;
                  });
                  if (index == 0) {
                    eventBus.fire(SubmitButtonBack(title: '回到首页'));
                  }
                },
                type: BottomNavigationBarType.fixed,
                items: [
                  _bottomNavigationBarItem(
                      '首页', 'assets/images/ic_bottom_menu1.png', 0),
                  _bottomNavigationBarItem(
                      '动态', 'assets/images/ic_bottom_menu2.png', 1),
                  _bottomNavigationBarItem(
                      '消息', 'assets/images/ic_bottom_menu3.png', 2),
                  _bottomNavigationBarItem(
                      '我的', 'assets/images/ic_bottom_menu3.png', 3),
                ]),
          ),

          isRed
              ? Positioned(
                  bottom: (isDevices == 'ios' ? 105 : 65) * 1.3 / 2,
                  right: 295.w,
                  child: Container(
                    width: 15 * 1.3 / 2,
                    height: 15 * 1.3 / 2,
                    //边框设置
                    decoration: const BoxDecoration(
                      //背景
                      color: Colors.red,
                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    alignment: Alignment.center,
                  ))
              : const Text(''),

          /// 公屏推送使用
          isShowHF
              ? HomeItems.itemAnimation(
                  path,
                  slideAnimationController!.controller,
                  slideAnimationController!.animation,
                  name,
                  listMP[0],
                  '厅外点击横幅',
                  sp.getString('roomID').toString())
              : const Text(''),

          /// 爆出5w2的礼物推送使用
          isBig
              ? HomeItems.itemBig(listMP[0], bigType, '厅外点击横幅',
                  sp.getString('roomID').toString())
              : const Text(''),

          /// 房间图标转动
          isJoinRoom
              ? Positioned(
                  bottom: 160,
                  right: 20,
                  child: GestureDetector(
                    onTap: (() {
                      if (isFirstJoinRoom == false) {
                        setState(() {
                          isFirstJoinRoom = true;
                        });
                        doPostBeforeJoin(sp.getString('roomID'));
                      }
                    }),
                    child: RotationTransition(
                      turns: _animation,
                      child: Draggable(
                          data: '1',
                          //当拖动对象开始被拖动时调用
                          onDragStarted: () {
                            setState(() {
                              isDragNow = true;
                            });
                          },
                          //当拖动对象被放下时调用
                          onDragEnd: (va) {
                            setState(() {
                              isDragNow = false;
                            });
                          },
                          //当draggable 被放置并被【DragTarget】 接受时调用
                          onDragCompleted: () {},
                          //当draggable 被放置但未被【DragTarget】 接受时调用
                          onDraggableCanceled: (velocity, offset) {},

                          //拖动显示
                          feedback: Container(
                            clipBehavior: Clip.antiAlias,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3)),
                            child: WidgetUtils.CircleHeadImage(
                                ScreenUtil().setHeight(90),
                                ScreenUtil().setHeight(90),
                                sp.getString('roomImage').toString()),
                          ),
                          //拖动占位
                          childWhenDragging: Opacity(
                            opacity: 0,
                            child: WidgetUtils.CircleHeadImage(
                                ScreenUtil().setHeight(90),
                                ScreenUtil().setHeight(90),
                                sp.getString('roomImage').toString()),
                          ),
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Container(
                                  height: 95.h,
                                  width: 95.h,
                                  decoration: BoxDecoration(
                                    //背景
                                    color: Colors.white,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(55.h)),
                                  )),
                              WidgetUtils.CircleHeadImage(
                                  ScreenUtil().setHeight(90),
                                  ScreenUtil().setHeight(90),
                                  sp.getString('roomImage').toString()),
                              SizedBox(
                                height: 40.h,
                                width: 40.h,
                                child: const SVGASimpleImage(
                                  assetsName:
                                      'assets/svga/chorus_svga_room_voice_bar.svga',
                                ),
                              )
                            ],
                          )),
                    ),
                  ),
                )
              : const Text(''),
          Column(
            children: [
              const Expanded(child: Text('')),
              isDragNow
                  ? DragTarget(
                      // 调用以构建此小部件的内容
                      builder: (BuildContext context,
                          List<String?> candidateData,
                          List<dynamic> rejectedData) {
                        return Container(
                          width: double.infinity,
                          height: ScreenUtil().setHeight(80),
                          decoration: BoxDecoration(
                            //背景
                            color: isRemove ? Colors.red[500] : Colors.red[200],
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(15.0),
                                topRight: Radius.circular(15.0)),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete,
                                size: 20,
                                color: isRemove ? Colors.white : Colors.white70,
                              ),
                              WidgetUtils.commonSizedBox(0, 5),
                              WidgetUtils.onlyTextCenter(
                                  isRemove ? '松手即可退出房间' : '拖到这里退出房间',
                                  StyleUtils.getCommonTextStyle(
                                      color: isRemove
                                          ? Colors.white
                                          : Colors.white70,
                                      fontSize: ScreenUtil().setSp(21)))
                            ],
                          ),
                        );
                      },
                      // 调用以确定此小部件是否有兴趣接受给定的被拖动到这个拖动目标上的数据片段
                      onWillAccept: (data) {
                        setState(() {
                          isRemove = true;
                        });
                        return true;
                      },
                      // 当一条可接受的数据被拖放到这个拖动目标上时调用
                      onAccept: (data) {
                        setState(() {
                          _dispose();
                          // 调用离开房间接口
                          doPostLeave(sp.getString('roomID').toString());
                          sp.setString('roomID', '');
                          isRemove = false;
                          isJoinRoom = false;
                        });
                      },
                      // 当一条可接受的数据被拖放离开这个拖动目标上时调用
                      onLeave: (data) {
                        setState(() {
                          isRemove = false;
                          isJoinRoom = true;
                        });
                      },
                    )
                  : const Text('')
            ],
          )
        ],
      ),
    );
  }

  /// 自定义底部信息
  _bottomNavigationBarItem(String title, String imgUrl, int i) {
    return BottomNavigationBarItem(
      label: title,
      icon: Image.asset(
        i == 0
            ? "assets/images/ic_bottom_menu1.png"
            : i == 1
                ? "assets/images/ic_bottom_menu2.png"
                : i == 2
                    ? "assets/images/ic_bottom_menu3.png"
                    : "assets/images/ic_bottom_menu4.png",
        fit: BoxFit.fill,
        width: 25,
        height: 25,
      ),
      activeIcon: Image.asset(
        i == 0
            ? "assets/images/ic_bottom_menu11.png"
            : i == 1
                ? "assets/images/ic_bottom_menu22.png"
                : i == 2
                    ? "assets/images/ic_bottom_menu33.png"
                    : "assets/images/ic_bottom_menu44.png",
        width: 25,
        height: 25,
      ),
    );
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
          setState(() {
            isJoinRoom = false;
          });
          // ignore: use_build_context_synchronously
          MyUtils.goTransparentRFPage(
              context,
              RoomPage(
                roomId: roomID,
                beforeId: '',
                roomToken: bean.data!.rtc!,
              ));
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
            isFirstJoinRoom = false;
          });
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      setState(() {
        isFirstJoinRoom = false;
      });
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 加入房间前
  Future<void> doPostBeforeJoin2(roomID) async {
    LogE('厅外点击横幅==1 $roomID');
    //判断房间id是否为空的
    if (sp.getString('roomID') != null ||
        sp.getString('roomID').toString().isNotEmpty) {
      // 不是空的，并且不是之前进入的房间
      if (sp.getString('roomID').toString() != roomID) {
        sp.setString('roomIDJoinOther', roomID);
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
          doPostRoomJoin2(roomID, '', bean.data!.rtc!);
          break;
        case MyHttpConfig.errorRoomCode: //需要密码
          MyToastUtils.showToastBottom('此房间已被密码锁定');
          // // ignore: use_build_context_synchronously
          //   MyUtils.goTransparentPageCom(
          //       context,
          //       RoomTSMiMaPage(
          //           roomID: roomID, roomToken: bean.data!.rtc!, anchorUid: ''));
          break;
        case MyHttpConfig.errorloginCode:
          //取消订阅所有远端用户的音频流。
          _engine!.muteAllRemoteAudioStreams(true);
          // 取消发布本地音频流
          _engine!.muteLocalAudioStream(true);
          _engine!.disableAudio();
          _dispose();
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
  Future<void> doPostRoomJoin2(roomID, password, roomToken) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
      'password': password
    };
    try {
      Loading.show();
      CommonBean bean = await DataUtils.postRoomJoin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          // 如果收起了房间，先把音频停掉
          if (isJoinRoom) {
            setState(() {
              isFirstJoinRoom = false;
              isJoinRoom = false;
              //取消订阅所有远端用户的音频流。
              _engine!.muteAllRemoteAudioStreams(true);
              // 取消发布本地音频流
              _engine!.muteLocalAudioStream(true);
              _engine!.disableAudio();
              _dispose();
            });
          }
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
          //取消订阅所有远端用户的音频流。
          _engine!.muteAllRemoteAudioStreams(true);
          // 取消发布本地音频流
          _engine!.muteLocalAudioStream(true);
          _engine!.disableAudio();
          _dispose();
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

  /// 获取系统消息
  List<Map<String, dynamic>> listMessage = [];
  bool isRed = false;

  Future<void> doPostSystemMsgList() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    try {
      Map<String, dynamic> params = <String, dynamic>{
        'is_all': '',
      };
      xtListBean bean = await DataUtils.postSystemMsgList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          if (bean.data!.list!.isNotEmpty) {
            setState(() {
              isRed = true;
            });
            for (int i = 0; i < bean.data!.list!.length; i++) {
              Map<String, dynamic> params = <String, dynamic>{
                'messageID': bean.data!.list![i].id as int,
                'type': bean.data!.list![i].type,
                'title': bean.data!.list![i].title,
                'text': bean.data!.list![i].text,
                'img': bean.data!.list![i].img,
                'url': bean.data!.list![i].url,
                'add_time': bean.data!.list![i].addTime,
                'data_status': 0,
                'img_url': bean.data!.list![i].imgUrl,
              };
              // 插入数据
              await databaseHelper.insertData('messageXTTable', params);
            }
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
      List<Map<String, dynamic>> allData =
          await databaseHelper.getAllData('messageSLTable');
      // 执行查询操作
      List<Map<String, dynamic>> result = await db.query(
        'messageSLTable',
        columns: ['MAX(id) AS id'],
        groupBy: 'combineID',
      );
      // 查询出来后在查询单条信息具体信息
      List<int> listId = [];
      String ids = '';
      for (int i = 0; i < result.length; i++) {
        listId.add(result[i]['id']);
        if (ids.isNotEmpty) {
          ids = '$ids,${result[i]['id'].toString()}';
        } else {
          ids = result[i]['id'].toString();
        }
      }
      // 生成占位符字符串，例如: ?,?,?,?
      String placeholders =
          List.generate(listId.length, (index) => '?').join(',');
      // 构建查询语句和参数
      String query =
          'SELECT * FROM messageSLTable WHERE id IN ($placeholders) and uid = ${sp.getString('user_id')} order by add_time desc';
      List<dynamic> args = listId;
      // 执行查询
      List<Map<String, dynamic>> result2 = await db.rawQuery(query, args);
      String myIds = '';
      setState(() {
        listMessage = result2;
        for (int i = 0; i < listMessage.length; i++) {
          if (myIds.isNotEmpty) {
            myIds = '$myIds,${listMessage[i]['otherUid'].toString()}';
          } else {
            myIds = listMessage[i]['otherUid'].toString();
          }
        }
      });
      for (int i = 0; i < listMessage.length; i++) {
        String query =
            "SELECT * FROM messageSLTable WHERE  combineID = '${listMessage[i]['combineID']}' and readStatus = 0";
        List<Map<String, dynamic>> result3 = await db.rawQuery(query);
        if (result3.isNotEmpty && _currentIndex != 2) {
          setState(() {
            isRed = true;
          });
          break;
        } else {
          setState(() {
            isRed = false;
          });
        }
      }
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 离开房间下麦
  Future<void> doPostLeave(String roomID) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
    };
    try {
      CommonBean bean = await DataUtils.postLeave(params);
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
    } catch (e) {}
  }

  double jindu = 0, jinduNum = 0;
  String jinduBaifeinbi = '';

  /// 下载礼物
  Future<void> doPostSvgaGiftList() async {
    setState(() {
      isDown = true;
    });
    Map<String, dynamic> params = <String, dynamic>{
      'resource_id': sp.getString('isFirstDown').toString() == 'null'
          ? '0'
          : sp.getString('isFirstDown').toString(),
    };
    try {
      svgaAllBean bean = await DataUtils.postSvgaGiftList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          // 存一下总数量
          setState(() {
            sp.setInt('isFirstDownNum', bean.data!.total as int);
            LogE('需要下载数量 ${bean.data!.imgList!.length}');
            jinduBaifeinbi = (1 / bean.data!.total!).toStringAsFixed(2);
            LogE('百分比 $jinduBaifeinbi');
            if (isDevices == 'android') {
              downloadAllImages(bean);
            }
          });
          break;
        case MyHttpConfig.errorloginCode:
          setState(() {
            isDown = false;
          });
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          setState(() {
            isDown = false;
          });
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      setState(() {
        isDown = false;
      });
      Loading.dismiss();
    }
  }

  /// 装扮预下载下载
  Future<void> doPostSvgaDressList() async {
    setState(() {
      isDown = true;
    });
    Map<String, dynamic> params = <String, dynamic>{
      'resource_id': sp.getString('isFirstDownZB').toString() == 'null'
          ? '0'
          : sp.getString('isFirstDownZB').toString(),
    };
    try {
      svgaAllBean bean = await DataUtils.postSvgaDressList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          // 存一下总数量
          setState(() {
            if (isDevices == 'android') {
              downloadAllImages2(bean);
            }
          });
          break;
        case MyHttpConfig.errorloginCode:
          setState(() {
            isDown = false;
          });
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          setState(() {
            isDown = false;
          });
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      setState(() {
        isDown = false;
      });
      Loading.dismiss();
    }
  }

  //调用 downloadAllImages 方法来开始下载所有图片
  void downloadAllImages(svgaAllBean bean) async {
    for (int i = 0; i < bean.data!.imgList!.length; i++) {
      bool result = await saveSVGAImgTemp(bean.data!.imgList![i].path!);
      if (result) {
        // 下载成功后的操作
        print('图片 $i 下载成功');
        if (i == bean.data!.imgList!.length - 1) {
          setState(() {
            sp.setString('isFirstDown', bean.data!.nextResourceId.toString());
          });
          print('下载完成修改值 ${sp.getString('isFirstDown').toString()}');
        }
        setState(() {
          jindu = double.parse(jinduBaifeinbi) * (i + 1);
          jinduNum = (jindu * 100).truncateToDouble();
          eventBus.fire(DownLoadingBack(jindu: jindu, jinduNum: jinduNum));
        });
      } else {
        // 下载失败后的操作
        print('图片 $i 下载失败');
      }
    }
  }

  //调用 downloadAllImages 方法来开始下载所有图片
  void downloadAllImages2(svgaAllBean bean) async {
    for (int i = 0; i < bean.data!.imgList!.length; i++) {
      bool result = await saveSVGAImgTemp(bean.data!.imgList![i].path!);
      if (result) {
        // 下载成功后的操作
        print('装扮图片 $i 下载成功');
        if (i == bean.data!.imgList!.length - 1) {
          setState(() {
            sp.setString('isFirstDownZB',bean.data!.nextResourceId.toString());
          });
          print('装扮下载完成修改值 ${sp.getString('isFirstDownZB').toString()}');
        }
      } else {
        // 下载失败后的操作
        print('装扮图片 $i 下载失败');
      }
    }
  }

  // 保存网络SVGA图片到缓存目录
  Future<bool> saveSVGAImgTemp(String imgUrl) async {
    var response = await http.get(Uri.parse(imgUrl));
    List<String> listName = imgUrl.split('/');
    // 生成新的文件名
    String fileName = listName[listName.length - 1];

    // 获取保存路径
    Directory? directory = await getExternalStorageDirectory();
    String savePath = "${directory!.path}/$fileName";
    // 保存图片
    File file = File(savePath);
    await file.writeAsBytes(response.bodyBytes);
    if (await file.exists()) {
      // MyToastUtils.showToastBottom("下载成功");
      LogE('下载成功 路径 $savePath');
      return true;
    } else {
      MyToastUtils.showToastBottom("下载失败");
      return false;
    }
  }

  /// 切换用户
  Future<void> doPostCheckToken() async {
    try {
      Map<String, dynamic> params = <String, dynamic>{
        'token': sp.getString('user_token').toString(),
      };
      qiehuanBean commonBean = await DataUtils.postCheckToken(params);
      switch (commonBean.code) {
        case MyHttpConfig.successCode:
          break;
        case MyHttpConfig.errorloginCode:
          eventBus.fire(RoomBack(title: '顶号', index: ''));
          // 取消发布本地音频流
          _engine!.muteLocalAudioStream(true);
          // 调用离开房间接口
          doPostLeave(sp.getString('roomID').toString());
          _engine!.disableAudio();
          _dispose();
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          // MyToastUtils.showToastBottom(commonBean.msg!);
          break;
      }
    } catch (e) {}
  }

  /// 首充
  Future<void> doPostIsFirstOrder() async {
    try {
      isFirstOrderBean bean = await DataUtils.postIsFirstOrder();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (bean.data!.twelve == 1 &&
                bean.data!.oneHundred == 1 &&
                bean.data!.twoSixSix == 1) {
              sp.setString('scIsOk', '1');
            } else {
              sp.setString('scIsOk', '0');
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
    } catch (e) {}
  }

  /// 保存本房间消息
  Future<void> saveChatInfo(Map<dynamic, dynamic> map, String type,
      String chatInfos, String contenInfo) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    Map<String, dynamic> params = <String, dynamic>{
      'roomID': sp.get('sqRoomID').toString(),
      'info': chatInfos,
      'uid': map!['from_uid'],
      'type': type,
      'content': contenInfo,
      'image': map!['image'],
      'identity': map!['identity'],
      'lv': type == '3' ? map!['send_level'] : map!['lv'],
      'noble_id': map!['noble_id'],
      'is_new': map!['is_new'],
      'is_pretty': map!['is_pretty'],
      'new_noble': map!['new_noble'],
      'isWelcome': '1',
      'isOk': 'true',
      'newLv': '',
      'by1': '',
      'by2': '',
      'by3': '',
    };
    // 插入数据
    await databaseHelper.insertData('roomInfoTable', params);
  }

  /// 删除本房间消息本房间消息
  Future<void> deleteChatInfo() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    //删除
    db.delete('roomInfoTable');
    //删除
    db.delete('roomGiftTable');
    // 防止用户被顶号时没有清空表
    if (sp.getString('sqRoomID').toString().isNotEmpty) {
      sp.setString('sqRoomID', '');
    }
  }
}
