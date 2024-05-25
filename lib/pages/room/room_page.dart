import 'dart:async';
import 'dart:io';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:screen/screen.dart';
import 'package:sqflite/sqflite.dart';
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:yuyinting/config/my_config.dart';
import 'package:yuyinting/pages/room/room_bq_page.dart';
import 'package:yuyinting/pages/room/room_new_gift_page.dart';
import 'package:yuyinting/pages/room/room_send_info_page.dart';
import 'package:yuyinting/pages/room/room_show_liwu_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/svga_tools.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import '../../bean/CommonIntBean.dart';
import '../../bean/CommonMyIntBean.dart';
import '../../bean/Common_bean.dart';
import '../../bean/charmAllBean.dart';
import '../../bean/charmMHBean.dart';
import '../../bean/hengFuBean.dart';
import '../../bean/joinRoomBean.dart';
import '../../bean/maiXuBean.dart';
import '../../bean/roomInfoBean.dart';
import '../../bean/roomTJBean.dart';
import '../../bean/userMaiInfoBean.dart';
import '../../bean/zjgpBean.dart';
import '../../colors/my_colors.dart';
import '../../db/DatabaseHelper.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/SVGASimpleImage3.dart';
import '../../utils/SlideAnimationController.dart';
import '../../utils/loading.dart';
import '../../utils/log_util.dart';
import '../../utils/style_utils.dart';
import '../../widget/mic_queren_page.dart';
import '../game/car_page.dart';
import '../home/home_items.dart';
import 'room_items.dart';

RtcEngine? _engine;

/// 厅内
class RoomPage extends StatefulWidget {
  String roomId;
  String beforeId;
  String roomToken;

  RoomPage(
      {Key? key,
      required this.roomId,
      required this.beforeId,
      required this.roomToken})
      : super(key: key);

  @override
  State<RoomPage> createState() => _RoomPageState();
}

class _RoomPageState extends State<RoomPage>
    with
        TickerProviderStateMixin,
        WidgetsBindingObserver {

  // 用户头像
  String avatar = '';

  // 是否第一次进入
  int isFirst = 0;

  /// 存进入的座驾信息
  List<Map> listUrlZJ = [];

  /// 存进入pk动画信息
  List<String> listUrlPK = [];

  /// 存进入pk动画信息
  List<String> listUrlJL = [];

  //蓝色方魅力值, 红色方魅力值
  String blueScore = '0', redScore = '0';

  // 房间pk时间
  int pkTime = 0;

  // pk文字
  String pkTitle = 'PK时间：';

  // 是否开启了房间pk 0已结束或未开启 1进行中 2惩罚中
  int isPK = -1;

  // 刚开始pk
  bool isPKStar = false;

  // 哪方胜利了
  String whoWin = '';

  // 存是否展示座驾
  bool isZJShow = false;

  // 存是否展示新的进场特效
  bool isJRShow = false;

  String jianLiWu = '';

  String giftName = '', nickName = '', otherNickName = '';

  /// 播放svga动画使用
  late SVGAAnimationController animationControllerBG;
  late SVGAAnimationController animationControllerSL;
  late SVGAAnimationController animationControllerZJ;
  late SVGAAnimationController animationControllerPK;
  late SVGAAnimationController animationControllerJL;
  late SVGAAnimationController animationControllerJR;

  Future _loadSVGA(isUrl, svgaUrl) {
    LogE('动画类型 $isUrl === $svgaUrl');
    Future Function(String) decoder;
    if (isUrl) {
      decoder = SVGAParser.shared.decodeFromURL;
    } else {
      decoder = SVGAParser.shared.decodeFromAssets;
    }
    return decoder(svgaUrl);
  }

  /// 厅内送礼物使用
  int shuliang = 0;

  void showStar(Map m) async {
    // 动画正在进行中不做处理
    if (animationControllerSL.isAnimating) {
      LogE('进行中====');
    } else {
      //本地图
      if (m['svgaBool'] == false) {
        File file = File(m['svgaUrl']);
        if (await file.exists()) {
          animationControllerSL?.videoItem =
              await SVGAParser.shared.decodeFromBuffer(file.readAsBytesSync());
          animationControllerSL
              ?.forward() // Try to use .forward() .reverse()
              .whenComplete(() => animationControllerSL?.videoItem = null);
          // 监听动画
          animationControllerSL?.addListener(_animListener);
        } else {
          LogE('礼物不存在');
          setState(() {
            listUrl.removeAt(0);
          });
          //礼物地址没有，直接返回，不进行后续操作
          return;
        }
      } else {
        //网络图
        final videoItem = await _loadSVGA(m['svgaBool'], m['svgaUrl']);
        if (videoItem != null) {
          videoItem.autorelease = false;
          animationControllerSL?.videoItem = videoItem;
          animationControllerSL
              ?.forward() // Try to use .forward() .reverse()
              .whenComplete(() => animationControllerSL?.videoItem = null);
          // 监听动画
          animationControllerSL?.addListener(_animListener);
        } else {
          setState(() {
            listUrl.removeAt(0);
          });
          //礼物地址没有，直接返回，不进行后续操作
          return;
        }
      }
    }
  }

  //网络动画
  void _animListener() {
    //TODO
    if (animationControllerSL.isCompleted) {
      LogE('动画结束 ${DateTime.now()}');
      setState(() {
        // 动画播放到最后一帧时停止播放
        animationControllerSL?.stop();
        animationControllerSL.removeListener(_animListener);
        if (listUrl.isNotEmpty) {
          listUrl.removeAt(0);
          if (listUrl.isEmpty) {
            // 全部动画结束的处理逻辑
            // ...
            setState(() {
              isShowSVGA = false;
            });
          } else {
            Future.delayed(const Duration(milliseconds: 1), () {
              showStar(listUrl[0]); // 递归调用showStar方法播放下一个动画
            });
          }
        }
      });
    }
  }

  // 展示座驾
  void showStarZJ(Map m) async {
    // 动画正在进行中不做处理
    if (animationControllerZJ.isAnimating) {
      LogE('进行中====');
    } else {
      //本地图
      if (m['svgaBool'] == false) {
        File file = File(m['svgaUrl']);
        if (await file.exists()) {
          animationControllerZJ?.videoItem =
              await SVGAParser.shared.decodeFromBuffer(file.readAsBytesSync());
          animationControllerZJ
              ?.forward() // Try to use .forward() .reverse()
              .whenComplete(() => animationControllerZJ?.videoItem = null);
          // 监听动画
          animationControllerZJ?.addListener(_animListenerZJ);
        } else {
          LogE('礼物不存在');
          setState(() {
            listUrlZJ.removeAt(0);
          });
          //礼物地址没有，直接返回，不进行后续操作
          return;
        }
      } else {
        //网络图
        final videoItem = await _loadSVGA(true, m['svgaUrl']);
        if (videoItem != null) {
          videoItem.autorelease = false;
          animationControllerZJ?.videoItem = videoItem;
          animationControllerZJ
              ?.forward() // Try to use .forward() .reverse()
              .whenComplete(() => animationControllerZJ?.videoItem = null);
          // 监听动画
          animationControllerZJ?.addListener(_animListenerZJ);
        } else {
          setState(() {
            listUrlZJ.removeAt(0);
          });
          //礼物地址没有，直接返回，不进行后续操作
          return;
        }
      }
    }
  }

  //网络动画
  void _animListenerZJ() {
    //TODO
    if (animationControllerZJ.isCompleted) {
      LogE('动画结束 ${DateTime.now()}');
      setState(() {
        // 动画播放到最后一帧时停止播放
        animationControllerZJ?.stop();
        animationControllerZJ.removeListener(_animListenerZJ);
        if (listUrlZJ.isNotEmpty) {
          listUrlZJ.removeAt(0);
          if (listUrlZJ.isEmpty) {
            setState(() {
              isZJShow = false;
            });
            // 全部动画结束的处理逻辑
            // ...
          } else {
            Future.delayed(const Duration(milliseconds: 1), () {
              showStarZJ(listUrlZJ[0]); // 递归调用showStar方法播放下一个动画
            });
          }
        }
      });
    }
  }

  /// 展示pk动画
  void showStarPK(String path) async {
    // 动画正在进行中不做处理
    if (animationControllerPK.isAnimating) {
      LogE('进行中====');
    } else {
      //本地图
      final videoItem = await _loadSVGA(false, path);
      animationControllerPK?.videoItem = videoItem;
      animationControllerPK
          ?.forward() // Try to use .forward() .reverse()
          .whenComplete(() => animationControllerPK?.videoItem = null);
      // 监听动画
      animationControllerPK?.addListener(_animListenerPK);
    }
  }

  //网络动画
  void _animListenerPK() {
    //TODO
    if (animationControllerPK.isCompleted) {
      LogE('动画结束 ${DateTime.now()}');
      setState(() {
        // 动画播放到最后一帧时停止播放
        animationControllerPK?.stop();
        animationControllerPK.removeListener(_animListenerPK);
        if (listUrlPK.isNotEmpty) {
          listUrlPK.removeAt(0);
          if (listUrlPK.isEmpty) {
            // 全部动画结束的处理逻辑
            // ...
            isPKStar = false;
          } else {
            Future.delayed(const Duration(milliseconds: 1), () {
              showStarPK(listUrlPK[0]); // 递归调用showStar方法播放下一个动画
            });
          }
        }
      });
    }
  }

  /// 展示减礼物的动画
  void showStarJL(String path) async {
    // 动画正在进行中不做处理
    if (animationControllerJL.isAnimating) {
      LogE('进行中====');
    } else {
      // 网络图
      final videoItem = await _loadSVGA(true, path);
      animationControllerJL?.videoItem = videoItem;
      animationControllerJL
          ?.forward() // Try to use .forward() .reverse()
          .whenComplete(() => animationControllerJL?.videoItem = null);
      // 监听动画
      animationControllerJL?.addListener(_animListenerJL);
    }
  }

  //网络动画
  void _animListenerJL() {
    //TODO
    if (animationControllerJL.isCompleted) {
      LogE('动画结束 ${DateTime.now()}');
      setState(() {
        // 动画播放到最后一帧时停止播放
        animationControllerJL?.stop();
        animationControllerJL.removeListener(_animListenerJL);
        if (listUrlJL.isNotEmpty) {
          listUrlJL.removeAt(0);
          if (listUrlJL.isEmpty) {
            // 全部动画结束的处理逻辑
            // ...
          } else {
            Future.delayed(const Duration(milliseconds: 1), () {
              showStarJL(listUrlJL[0]); // 递归调用showStar方法播放下一个动画
            });
          }
        }
      });
    }
  }

  // 展示用户进入房间展示svga
  void showStarJoinRoom(Map m) async {
    // 动画正在进行中不做处理
    if (animationControllerJR.isAnimating) {
      LogE('进行中====');
    } else {
      //本地图
      final bool svgaBool = m['svgaBool'];
      LogE('进厅横幅== $svgaBool');
      final MovieEntity videoItem = await _loadSVGA(svgaBool, m['svgaUrl']);
      if (svgaBool) {
        await videoItem.hfItem(
            m['avatar'], m['nickNanme'], m['svgaName'], m['gender']);
      }
      animationControllerJR?.videoItem = videoItem;
      animationControllerJR
          ?.forward() // Try to use .forward() .reverse()
          .whenComplete(() => animationControllerJR?.videoItem = null);
      // 监听动画
      animationControllerJR?.addListener(_animListenerJoinRoom);
    }
  }

  //展示用户进入房间监听
  void _animListenerJoinRoom() {
    //TODO
    if (animationControllerJR.isCompleted) {
      LogE('动画结束 ${DateTime.now()}');
      setState(() {
        // 动画播放到最后一帧时停止播放
        animationControllerJR?.stop();
        animationControllerJR.removeListener(_animListenerJoinRoom);
        if (listJoinRoom.isNotEmpty) {
          listJoinRoom.removeAt(0);
          if (listJoinRoom.isEmpty) {
            setState(() {
              isJRShow = false;
            });
            // 全部动画结束的处理逻辑
            // ...
          } else {
            Future.delayed(const Duration(milliseconds: 1), () {
              showStarJoinRoom(listJoinRoom[0]); // 递归调用showStar方法播放下一个动画
            });
          }
        }
      });
    }
  }

  /// 背景图为svga的时候使用
  void showStar2(String bgSVGAa) async {
    try {
      final videoItem = await _loadSVGA(true, bgSVGAa);
      videoItem.autorelease = false;
      animationControllerBG?.videoItem = videoItem;
      animationControllerBG
          ?.repeat() // Try to use .forward() .reverse()
          .whenComplete(() => animationControllerBG?.videoItem = null);
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
      LogE('加载背景图错误提示 ${e.toString()}');
    }
  }

  void _startTimerPK() {
    Future.delayed(const Duration(seconds: 1), () {
      LogE('pk时间 == $pkTime');
      if (pkTime == 0) {
        LogE('pk名称 == $pkTitle');
        if (pkTitle == '惩罚时间') {
          setState(() {
            blueScore = '0';
            redScore = '0';
            whoWin = '';
            isPK = 0;
            isPKStar = false;
          });
        }
      } else {
        setState(() {
          pkTime--;
        });
      }
      if(pkTime >= 0){
        _startTimerPK();
      }
    });
  }

  void _cancelTimerAll() {
    listenSend.cancel();
    listenSendImg.cancel();
  }

  // 点击的类型
  int leixing = 1;
  bool m0 = false,
      m1 = false,
      m2 = false,
      m3 = false,
      m4 = false,
      m5 = false,
      m6 = false,
      m7 = false,
      m8 = false;

  //9个麦序是否正在开麦
  bool audio1 = false,
      audio2 = false,
      audio3 = false,
      audio4 = false,
      audio5 = false,
      audio6 = false,
      audio7 = false,
      audio8 = false,
      audio9 = false;
  List<bool> upOrDown = [];
  List<bool> isMy = [];

  //页面是否加载完成
  bool isOK = false;

  // 老板位
  bool isBoss = true;

  // 房间动效、房间声音、房间密码、首页展示
  bool roomDX = true, roomSY = true, mima = false, roomZS = true;
  bool isJinyiin = true;

  //是否被禁言了  0否 1是
  int isForbation = 0;
  String BgType = '';
  var listen,
      listenRoomback,
      listenCheckBG,
      listenZDY,
      listJoin,
      listenShowLiWu,
      listenSend,
      listenSendImg,
      listenBig,
      listenSGJ;

  // 是否展示礼物动效
  bool isLWShow = false;

  /// 声网使用
  int? _remoteUid;
  bool _localUserJoined = false;

  // RtcEngine? _engine;
  bool isShow = false;
  late final Gradient gradient;
  FocusNode? _focusNode;

  // 判断自己是不是在麦上使用/ 本人是否开麦状态
  bool isMeUp = false, isMeStatus = false;

  // 在几号麦上
  String mxIndex = '';

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

  //离线模式
  int roomLixian = 0;

  // 是否抱麦
  bool isBaoMic = false;

  // list里面的type 0 代表系统公告 1 房间内的公告 2谁进入了房间 3厅内用户正常聊天
  List<Map> list = [];

  // 这个只存公屏中奖信息
  List<Map> list2 = [];

  // 发言倒计时
  int _timeCount = 3;

  // 发送爆灯使用 wherePeople在哪个麦序上，0不在麦上  _timer2和_timeCount2是爆灯的倒计时
  List<String> wherePeopleList = ["0", "0", "0", "0", "0", "0", "0", "0", "0"];

  void _startTimer() {
    setState(() {
      _timeCount = 1;
    });
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _timeCount = 3;
      });
    });
  }

  void _startTimer2(String maixu) {
    switch (maixu) {
      case "1":
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            wherePeopleList[0] = "0";
          });
        });
        break;
      case "2":
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            wherePeopleList[1] = "0";
          });
        });
        break;
      case "3":
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            wherePeopleList[2] = "0";
          });
        });
        break;
      case "4":
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            wherePeopleList[3] = "0";
          });
        });
        break;
      case "5":
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            wherePeopleList[4] = "0";
          });
        });
        break;
      case "6":
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            wherePeopleList[5] = "0";
          });
        });
        break;
      case "7":
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            wherePeopleList[6] = "0";
          });
        });
        break;
      case "8":
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            wherePeopleList[7] = "0";
          });
        });
        break;
      case "9":
        Future.delayed(const Duration(seconds: 3), () {
          setState(() {
            wherePeopleList[8] = "0";
          });
        });
        break;
    }
  }

  // 送礼选中了那个用户
  var listenPeople;
  List<bool> listPeople = [];

  /// 公屏使用
  SlideAnimationController? slideAnimationController;
  String path = ''; // 图片地址
  String name = ''; // 要展示公屏的名称
  bool isShowHF = false; // 是否显示横幅
  String msg = ''; // 拼接显示数据
  Map<String, String>? map; //存放接收自定义的数据使用
  List<hengFuBean> listMP = []; // 存放每个进来的公屏，按顺序播放
  List<charmAllBean> listCM = []; // 存放每个进来的png图片，按顺序播放
  List<List<bool>> listCMb = []; // 存放每个进来的png图片，送给了谁，按顺序播放
  late hengFuBean myhf; //出现第一个横幅使用
  ///爆出大礼物使用
  bool isBig = false;
  int bigType = 0; //大礼物默认是爆出 0爆出1送出

  // 送礼物显示SVGA
  bool isShowSVGA = true;

  // 是否贵族进场
  bool isGuZu = false;
  String tequanzhuangban = '';

  // 赠送礼物使用
  List<Map> listUrl = [];
  var listenSVGA, listenGZOK, listenMessage, listenJoinHF;


  // 是否返回了
  bool isBack = false;

  // 新增默认进场播放
  List<Map> listJoinRoom = [];

  Widget roomHouse(BuildContext context, int i) {
    return Column(children: [
      GestureDetector(
        onTap: (() {
          // eventBus.fire(SubmitButtonBack(title: '退出房间,${widget.roomID}'));
          // 点击的是不是当前房间，如果是关闭弹窗，不是跳转房间
          if (MyUtils.checkClick() && sp.getBool('joinRoom') == false) {
            setState(() {
              sp.setBool('joinRoom', true);
            });
            if (sp.getString('roomID').toString() == listPH[i].id.toString()) {
              setState(() {
                sp.setBool('joinRoom', false);
                isBack = false;
              });
            } else {
              //取消订阅所有远端用户的音频流。
              // _engine!.muteAllRemoteAudioStreams(true);
              // // 取消发布本地音频流
              // _engine!.muteLocalAudioStream(true);
              // _engine!.disableAudio();
              // _dispose();
              // 清空存储信息
              deleteChatInfo();
              deleteGifInfo();
              doPostBeforeJoin(listPH[i].id.toString());
            }
          }
        }),
        child: Container(
          margin: const EdgeInsets.only(left: 10, right: 10),
          child: Stack(
            children: [
              WidgetUtils.CircleImageNet(200.h, 200.h, 20, listPH[i].coverImg!),
              Positioned(
                  bottom: 10.h,
                  left: 10.h,
                  child: SizedBox(
                    width: 190.h,
                    child: Text(
                      listPH[i].roomName!,
                      style: StyleUtils.getCommonTextStyle(
                          color: Colors.white, fontSize: 30.sp),
                    ),
                  ))
            ],
          ),
        ),
      ),
      WidgetUtils.commonSizedBox(20.h, 0),
    ]);
  }

  // 上麦更新麦序记录第一次时间，用于判断切换麦序2s可切换一次，2s内不能随意切换
  int maiTime = 0;

  // 设备是安卓还是ios
  String isDevices = 'android';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      isFirst++;
    });
    //2.页面初始化的时候，添加一个状态的监听者
    WidgetsBinding.instance?.addObserver(this);
    if (Platform.isAndroid) {
      setState(() {
        isDevices = 'android';
      });
    } else if (Platform.isIOS) {
      setState(() {
        isDevices = 'ios';
      });
    }
    // 查询本地存储信息
    searchChatInfo();
    searchHaveGiftInfo();
    // 在页面中使用自定义时间和图片地址
    slideAnimationController = SlideAnimationController(
      vsync: this,
      duration: const Duration(seconds: 15), // 自定义时间
    );
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      slideAnimationController!.playAnimation();
    });
    //页面渲染完成
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      // 进入房间后清空代理房间id
      sp.setString('daili_roomid', '');
      sp.setString('isShouQi', '0');
      LogE('用户id ${sp.getString('user_id').toString()}');
      LogE('用户token ${sp.getString('user_token').toString()}');
      //初始化声网的音频插件
      initAgora();
      //初始化声卡采集
      if (Platform.isWindows || Platform.isMacOS) {
        starSK();
      }
      setState(() {
        sp.setBool('joinRoom', false);
      });
      animationControllerSL = SVGAAnimationController(vsync: this);
      animationControllerZJ = SVGAAnimationController(vsync: this);
      animationControllerBG = SVGAAnimationController(vsync: this);
      animationControllerPK = SVGAAnimationController(vsync: this);
      animationControllerJL = SVGAAnimationController(vsync: this);
      animationControllerJR = SVGAAnimationController(vsync: this);
      //保存进入房间的id
      sp.setString('roomID', widget.roomId);
      //保持屏幕常亮
      saveLiang();
      //把外面首页旋转的图去掉
      eventBus.fire(SubmitButtonBack(title: '去掉旋转'));
      //添加系统公告
      setState(() {
        Map<String, String> map = {};
        map['info'] =
            '官方倡导绿色聊天，对聊天内容24小时在线巡查，严禁未成年人充值消费，严禁宣传与政治、色情、敏感话题等相关内容，任何传播违法/违规/低俗/暴力等不良信息的行为会导致封禁账号。';
        map['type'] = '0';
        list.add(map);
      });
      doPostRoomInfo();
      doPostSystemMsgList();
      //是否上麦下麦和点击的是否自己
      for (int i = 0; i < 9; i++) {
        upOrDown.add(false);
        isMy.add(false);
      }
      for (int i = 0; i < 10; i++) {
        listPeople.add(false);
      }
      // 厅内设置监听
      listen = eventBus.on<SubmitButtonBack>().listen((event) {
        if (event.title == '清除公屏') {
          // setState(() {
          //   list.clear();
          //   list2.clear();
          // });
        } else if (event.title == '清除魅力') {
          // setState(() {
          //   for(int i = 0; i < listM.length; i++){
          //     listM[i].charm = 0;
          //   }
          // });
        } else if (event.title == '清除魅力') {
        } else if (event.title == '账号已在其他设备登录') {
          LogE('账号已在其他设备登录');
          //取消订阅所有远端用户的音频流。
          _engine!.muteAllRemoteAudioStreams(true);
          // 取消发布本地音频流
          _engine!.muteLocalAudioStream(true);
          _engine!.disableAudio();
          _dispose();
          // 清空存储信息
          deleteChatInfo();
          deleteGifInfo();
          // MyUtils.jumpLogin(context);
        } else if (event.title == '老板位1') {
          setState(() {
            isBoss = true;
          });
        } else if (event.title == '动效已开启') {
          setState(() {
            roomDX = true;
          });
        } else if (event.title == '动效已关闭') {
          setState(() {
            roomDX = false;
          });
        } else if (event.title == '首页展示已开启') {
          setState(() {
            isHomeShow = 1;
          });
        } else if (event.title == '首页展示已关闭') {
          setState(() {
            isHomeShow = 0;
          });
        } else if (event.title == '房间声音已开启') {
          LogE('房间声音已开启');
          setState(() {
            sp.setString('roomAudio', '1');
            roomSY = true;
            //默认订阅所有远端用户的音频流。
            _engine!.muteAllRemoteAudioStreams(false);
          });
        } else if (event.title == '房间声音已关闭') {
          LogE('房间声音已关闭');
          setState(() {
            sp.setString('roomAudio', '0');
            roomSY = false;
            //取消订阅所有远端用户的音频流。
            _engine!.muteAllRemoteAudioStreams(true);
          });
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
            if (isForbation == 0) {
              MyUtils.goTransparentPage(context, const RoomBQPage());
            } else {
              MyToastUtils.showToastBottom('你已被房间禁言！');
            }
            // if (_timeCount == 3) {
            //   if (isForbation == 0) {
            //     MyUtils.goTransparentPage(context, const RoomBQPage());
            //   } else {
            //     MyToastUtils.showToastBottom('你已被房间禁言！');
            //   }
            // } else {
            //   MyToastUtils.showToastBottom('太频繁啦，请歇一歇~');
            // }
          } else {
            if (isForbation == 0) {
              MyUtils.goTransparentPage(context, const RoomBQPage());
            } else {
              MyToastUtils.showToastBottom('你已被房间禁言！');
            }
          }
        } else if (event.title == '聊天') {
          // 判断是不是贵族，除了0都是贵族身份
          // LogE('我的身份 1==$noble_id');
          // LogE('我的身份 2==$_timeCount');
          // LogE('我的身份 3==$isForbation');
          if (noble_id == '0') {
            // if (_timeCount == 3) {
            if (isForbation == 0) {
              MyUtils.goTransparentPage(
                  context,
                  RoomSendInfoPage(
                    info: '',
                  ));
            } else {
              MyToastUtils.showToastBottom('你已被房间禁言！');
            }
            // } else {
            //   MyToastUtils.showToastBottom('太频繁啦，请歇一歇~');
            // }
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
          String wherePeople = '';
          for (int i = 0; i < listM.length; i++) {
            if (sp.getString('user_id').toString() == listM[i].uid.toString()) {
              wherePeople = (i + 1).toString();
              wherePeopleList[i] = (i + 1).toString();
            }
          }
          // 如果在麦上，就开启爆灯模式
          if (isMeUp) {
            _startTimer2(wherePeople);
            doPostBurstLight(wherePeople);
          } else {
            MyToastUtils.showToastBottom('上麦后才可以使用哦~');
          }
        } else if (event.title == '清空红点') {
          LogE('清空');
          setState(() {
            isRed = false;
          });
        } else if (event.title == '成功切换账号') {
          setState(() {
            //取消订阅所有远端用户的音频流。
            _engine!.muteAllRemoteAudioStreams(true);
            // 取消发布本地音频流
            _engine!.muteLocalAudioStream(true);
            _engine!.disableAudio();
          });
          _dispose();
          // 清空存储信息
          deleteChatInfo();
          deleteGifInfo();
        } else if (event.title == 'im重连') {
          // try {
          //   if (sp.getString('roomID').toString() == widget.roomId.toString()) {
          //     EMClient.getInstance.chatRoomManager
          //         .joinChatRoom(widget.roomId.toString());
          //   }
          // } catch (e) {
          //   LogE(e.toString());
          // }
          if (sp.getString('roomID').toString() == widget.roomId.toString()) {
            final chatRoomId = sp.getString('chatRoomId').toString();
            if (chatRoomId.isNotEmpty) {
              EMClient.getInstance.chatRoomManager
                  .joinChatRoom(chatRoomId);
            }
          }
          setState(() {
            if(sp.getString('roomAudio').toString() == '0'){
              roomSY = false;
              //取消订阅所有远端用户的音频流。
              _engine!.muteAllRemoteAudioStreams(true);
            }else{
              roomSY = true;
              //开启订阅所有远端用户的音频流。
              _engine!.muteAllRemoteAudioStreams(false);
            }
            if (isJinyiin == false) {
              // 启用音频模块
              _engine!.enableAudio();
              // 发声音发音频流
              _engine!.enableLocalAudio(true);
              //设置成主播
              _engine!
                  .setClientRole(role: ClientRoleType.clientRoleBroadcaster);
              // 发布本地音频流
              _engine!.muteLocalAudioStream(false);
            }
          });
        } else if (event.title == 'im断开链接') {
          // setState(() {
          //   //取消订阅所有远端用户的音频流。
          //   _engine!.muteAllRemoteAudioStreams(true);
          //   // 取消发布本地音频流
          //   _engine!.muteLocalAudioStream(true);
          // });
        } else if (event.title == '离线模式') {
          LogE('离线模式 == $roomLixian');
          if (roomLixian == 0) {
            setState(() {
              roomLixian = 1;
            });
          } else {
            setState(() {
              roomLixian = 0;
            });
          }
        }
      });
      // 厅内操作监听
      listenRoomback = eventBus.on<RoomBack>().listen((event) {
        LogE('状态 ${event.title}');
        switch (event.title) {
          case '关闭声音':
            setState(() {
              isJinyiin = !isJinyiin;
              // 自己上麦了
              if (isMeUp) {
                //点击了静音
                if (isJinyiin == false) {
                  // 开启发布本地音频流
                  _engine!.muteLocalAudioStream(false);
                  listM[int.parse(event.index!)].isClose = 0;
                  for (int i = 0; i < 9; i++) {
                    upOrDown[i] = false;
                    isMy[i] = false;
                  }
                  doPostSetClose(event.index!, 'yes');
                } else {
                  // 取消发布本地音频流
                  _engine!.muteLocalAudioStream(true);
                  listM[int.parse(event.index!)].isClose = 1;
                  for (int i = 0; i < 9; i++) {
                    upOrDown[i] = false;
                    isMy[i] = false;
                  }
                  doPostSetClose(event.index!, 'no');
                }
              }
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
                isMy[i] = false;
              }
              upOrDown[int.parse(event.index!)] = true;
            });
            break;
          case '上麦':
            //判断上麦或者换麦的时间间隔是否大于了2s
            if (DateTime.now().millisecondsSinceEpoch - maiTime > 2000) {
              //设置成主播
              _engine!
                  .setClientRole(role: ClientRoleType.clientRoleBroadcaster);
              doPostSetmai(
                  event.index!, 'up', sp.getString('user_id').toString(), '0');
              setState(() {
                maiTime = DateTime.now().millisecondsSinceEpoch;
                for (int i = 0; i < 9; i++) {
                  upOrDown[i] = false;
                }
              });
            } else {
              MyToastUtils.showToastBottom('亲，跳麦需间隔2S以上哦~');
            }
            break;
          case '锁麦':
            doPostSetLock(event.index!, 'yes');
            break;
          case '解锁':
            doPostSetLock(event.index!, 'no');
            break;
          case '下麦':
            if (DateTime.now().millisecondsSinceEpoch - maiTime > 2000) {
              setState(() {
                maiTime = DateTime.now().millisecondsSinceEpoch;
              });
              if (event.index!.contains(';')) {
                doPostSetmai(event.index!.split(';')[0], 'down',
                    event.index!.split(';')[1], '0');
              } else {
                if (roomLixian == 1) {
                  setState(() {
                    roomLixian = 0;
                  });
                }
                doPostSetmai(event.index!, 'down',
                    sp.getString('user_id').toString(), '0');
                setState(() {
                  for (int i = 0; i < 9; i++) {
                    isMy[i] = false;
                  }
                  for (int i = 0; i < 9; i++) {
                    upOrDown[i] = false;
                  }
                });
              }
            } else {
              MyToastUtils.showToastBottom('下麦太快了哦~');
            }
            break;
          case 'leave_room':
            // 调用离开房间接口
            doPostLeave();
            //离开频道并释放资源
            _dispose();
            // 清空存储信息
            deleteChatInfo();
            deleteGifInfo();
            Navigator.pop(context);
            break;
          case '顶号':
            // 调用离开房间接口
            doPostLeave();
            // 清空存储信息
            deleteChatInfo();
            deleteGifInfo();
            //离开频道并释放资源
            _dispose();
            break;
          case '闭麦':
            setState(() {
              // 取消发布本地音频流
              _engine!.muteLocalAudioStream(true);
              // 适用只听声音，不发声音流
              _engine!.enableLocalAudio(false);
              listM[int.parse(event.index!)].isClose = 1;
              for (int i = 0; i < 9; i++) {
                upOrDown[i] = false;
                isMy[i] = false;
              }
            });
            break;
          case '开麦':
            setState(() {
              // 启用音频模块
              _engine!.enableAudio();
              // 发声音发音频流
              _engine!.enableLocalAudio(true);
              // 开启发布本地音频流
              _engine!.muteLocalAudioStream(false);
              listM[int.parse(event.index!)].isClose = 0;
              for (int i = 0; i < 9; i++) {
                upOrDown[i] = false;
                isMy[i] = false;
              }
            });
            break;
          case '闭麦1':
            setState(() {
              // 取消发布本地音频流
              _engine!.muteLocalAudioStream(true);
              // 适用只听声音，不发声音流
              _engine!.enableLocalAudio(false);
              listM[int.parse(event.index!)].isClose = 1;
              for (int i = 0; i < 9; i++) {
                upOrDown[i] = false;
                isMy[i] = false;
              }
            });
            doPostSetClose(event.index!, 'no');
            break;
          case '开麦1':
            setState(() {
              // 启用音频模块
              _engine!.enableAudio();
              // 发声音发音频流
              _engine!.enableLocalAudio(true);
              // 开启发布本地音频流
              _engine!.muteLocalAudioStream(false);
              listM[int.parse(event.index!)].isClose = 0;
              for (int i = 0; i < 9; i++) {
                upOrDown[i] = false;
                isMy[i] = false;
              }
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
          case '厅头修改':
            setState(() {
              roomHeadImg = event.index!;
            });
            break;
          case '点击房间关闭':
            setState(() {
              isBack = true;
            });
            break;
          case '抱麦':
            doPostSetmai('', 'up', event.index!, '1');
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
            if (event.bgImagUrl.contains('gif') ||
                event.bgImagUrl.contains('GIF')) {
              BgType = '1';
              bgImage = event.bgImagUrl;
            } else {
              BgType = '2';
              bgSVGA = event.bgImagUrl;
              if (bgSVGA!.isNotEmpty) {
                showStar2(bgSVGA);
              }
            }
          }
        });
      });
      // 上麦下麦等操作im监听
      listenZDY = eventBus.on<ZDYBack>().listen((event) {
        if (event.map!['room_id'].toString() == widget.roomId) {
          LogE('自定义消息 *** ${event.type}');
          switch (event.type) {
            case 'un_close_mic': //开麦
              doUpdateInfo(event.map, '开麦');
              // 上下麦操作不是本地才刷新
              if (event.map!['uid'].toString() != sp.getString('user_id')) {
              } else {
                isMeUp = true;
                mxIndex = event.map!['serial_number'].toString();
                setState(() {
                  isJinyiin = false;
                });
                // 启用音频模块
                _engine!.enableAudio();
                // 发声音发音频流
                _engine!.enableLocalAudio(true);
                //设置成主播
                _engine!
                    .setClientRole(role: ClientRoleType.clientRoleBroadcaster);
                // 发布本地音频流
                _engine!.muteLocalAudioStream(false);
              }
              break;
            case 'close_mic': //闭麦
              // 上下麦操作不是本地才刷新
              doUpdateInfo(event.map, '闭麦');
              if (event.map!['uid'].toString() != sp.getString('user_id')) {
              } else {
                setState(() {
                  isJinyiin = true;
                });
                // 设置成观众
                _engine!.setClientRole(role: ClientRoleType.clientRoleAudience);
                // 取消发布本地音频流
                _engine!.muteLocalAudioStream(true);
                // 适用只听声音，不发声音流
                _engine!.enableLocalAudio(false);
              }
              break;
            case 'up_mic': //上麦
              setState(() {
                for (int i = 0; i < 9; i++) {
                  upOrDown[i] = false;
                }
              });
              // 上下麦操作不是本地才刷新
              if (event.map!['uid'].toString() != sp.getString('user_id')) {
                LogE('他人上麦');
                doUpdateInfo(event.map, '上麦');
              } else {
                isMeUp = true;
                mxIndex = event.map!['serial_number'].toString();
                LogE('开麦状态== ${event.map!['is_close'].toString() == '0'}');
                LogE('开麦状态== ${event.map!['is_close'].toString()}');
                if (event.map!['is_close'].toString() == '0') {
                  setState(() {
                    isJinyiin = false;
                  });
                  // 启用音频模块
                  _engine!.enableAudio();
                  // 发声音发音频流
                  _engine!.enableLocalAudio(true);
                  //设置成主播
                  _engine!.setClientRole(
                      role: ClientRoleType.clientRoleBroadcaster);
                  // 发布本地音频流
                  _engine!.muteLocalAudioStream(false);
                } else {
                  setState(() {
                    isJinyiin = true;
                  });
                  // 设置成观众
                  _engine!
                      .setClientRole(role: ClientRoleType.clientRoleAudience);
                  // 取消发布本地音频流
                  _engine!.muteLocalAudioStream(true);
                  // 适用只听声音，不发声音流
                  _engine!.enableLocalAudio(false);
                }
              }
              break;
            case 'down_mic': //下麦
              if (event.map!['uid'].toString() ==
                      sp.getString('user_id').toString() &&
                  event.map!['from_uid'].toString() !=
                      sp.getString('user_id').toString() &&
                  event.map!['from_uid'].toString().isNotEmpty) {
                MyToastUtils.showToastBottom('你已被管理下掉了麦序！');
              }
              setState(() {
                for (int i = 0; i < 9; i++) {
                  isMy[i] = false;
                }
                for (int i = 0; i < 9; i++) {
                  upOrDown[i] = false;
                }
                doUpdateInfo(event.map, '下麦');
              });
              if (mounted) {
                // 上下麦操作不是本地才刷新
                if (event.map!['uid'].toString() ==
                    sp.getString('user_id').toString()) {
                  if (roomLixian == 1) {
                    setState(() {
                      roomLixian = 0;
                    });
                  }
                  // 设置成观众
                  _engine!
                      .setClientRole(role: ClientRoleType.clientRoleAudience);
                  // 取消发布本地音频流
                  _engine!.muteLocalAudioStream(true);
                  // 适用只听声音，不发声音流
                  _engine!.enableLocalAudio(false);
                  setState(() {
                    isMeUp = false;
                  });
                }
              }
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
            case 'room_forbation': //禁言
              //判断被禁言的人是不是自己
              if (event.map!['uid'].toString() ==
                  sp.getString('user_id').toString()) {
                setState(() {
                  isForbation = 1;
                });
              }
              break;
            case 'cancel_room_forbation': //取消禁言
              //判断被取消禁言的人是不是自己
              if (event.map!['uid'].toString() ==
                  sp.getString('user_id').toString()) {
                setState(() {
                  isForbation = 0;
                });
              }
              break;
            case 'room_black': //设置黑名单
              //判断被拉黑的人是不是自己
              if (event.map!['uid'].toString() ==
                  sp.getString('user_id').toString()) {
                // MyToastUtils.showToastBottom('你已被房间设置为黑名单用户！');
                // setState(() {
                //   isMeUp = false;
                // });
                // // 取消发布本地音频流
                // _engine!.muteLocalAudioStream(true);
                // // 调用离开房间接口
                // doPostLeave();
                // _engine!.disableAudio();
                // _dispose();
                // Navigator.pop(context);
              } else {
                // 别人被拉黑了，刷新一下麦上的人员信息
                if (event.map!['old_serial_number'].toString() != '0') {
                  doUpdateOtherInfo(
                      event.map!['old_serial_number'].toString(), '拉黑');
                }
              }
              break;
            case 'user_room_black':
              // 这个是针对，用户被拉黑前，用户断网使用，保证他会被踢出去
              if (event.map!['uid'].toString() ==
                  sp.getString('user_id').toString()) {
                MyToastUtils.showToastBottom('你已被房间设置为黑名单用户！');
                setState(() {
                  isMeUp = false;
                });
                // 取消发布本地音频流
                _engine!.muteLocalAudioStream(true);
                // 适用只听声音，不发声音流
                _engine!.enableLocalAudio(false);
                // 调用离开房间接口
                doPostLeave();
                // 清空存储信息
                deleteChatInfo();
                deleteGifInfo();
                _engine!.disableAudio();
                _dispose();
                // Navigator.pop(context);
                Navigator.popUntil(context, ModalRoute.withName('回首页'));
              }
              break;
            case 'room_admin': //设置管理员
              //判断被设置管理员的人是不是自己
              if (event.map!['uid'].toString() ==
                  sp.getString('user_id').toString()) {
                MyToastUtils.showToastBottom('您已被提升为本房间的管理员身份！');
                role = 'adminer';
                sp.setString('role', 'adminer');
              }
              break;
            case 'cancel_room_admin': //取消管理员
              //判断被取消管理员的人是不是自己
              if (event.map!['uid'].toString() ==
                  sp.getString('user_id').toString()) {
                MyToastUtils.showToastBottom('您已被取消本房间的管理员身份！');
                role = 'adminer';
                sp.setString('role', 'adminer');
              }
              break;
            case 'room_pk_start':
              setState(() {
                blueScore = '0';
                redScore = '0';
                listUrlPK.add('assets/svga/pk/room_pk_star.svga');
                isPKStar = true;
                isPK = 1;
                whoWin = '';
                pkTime = int.parse(event.map!['seconds'].toString());
                pkTitle = 'PK时间';
              });
              showStarPK(listUrlPK[0]);
              //开启房间pk
              _startTimerPK();
              break;
            case 'room_pk_result':
              setState(() {
                if (event.map!['win'].toString() == 'red') {
                  pkTitle = '惩罚时间';
                  pkTime = 60;
                  whoWin = 'red';
                  listUrlPK.add('assets/svga/pk/room_pk_red_win.svga');
                  isPK = 2;
                } else if (event.map!['win'].toString() == 'blue') {
                  pkTitle = '惩罚时间';
                  pkTime = 60;
                  whoWin = 'blue';
                  listUrlPK.add('assets/svga/pk/room_pk_blue_win.svga');
                  isPK = 2;
                } else {
                  blueScore = '0';
                  redScore = '0';
                  pkTitle = 'PK时间';
                  pkTime = 0;
                  whoWin = 'draw';
                  listUrlPK.add('assets/svga/pk/room_pk_pingjun.svga');
                  isPK = 0;
                }
                isPKStar = true;
              });
              showStarPK(listUrlPK[0]);
              break;
            case 'room_pk_ahead_punish':
              //提前结束
              if (pkTitle == '惩罚时间') {
                setState(() {
                  blueScore = '0';
                  redScore = '0';
                  whoWin = '';
                  isPK = 0;
                  isPKStar = false;
                });
              }
              break;
          }
        } else {
          if (event.type == 'login_kick') {
            // 这个状态是后台直接封禁了账号，然后直接踢掉app
            MyUtils.signOut();
            // 取消发布本地音频流
            _engine!.muteLocalAudioStream(true);
            _engine!.disableAudio();
            _dispose();
            // 调用离开房间接口
            doPostLeave();
            // 清空存储信息
            deleteChatInfo();
            deleteGifInfo();
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
          } else if (event.type == 'up_noble' && int.parse(event.map!['noble_id'].toString()) > 1) {
            if (sp.getString('user_id').toString() ==
                event.map!['uid'].toString()) {
              sp.setString('nobleID', event.map!['noble_id'].toString());
            }
            if (listMP.isEmpty) {
              hengFuBean hf = hengFuBean();
              setState(() {
                hf.roomName = event.map!['room_name'];
                hf.title = '贵族';
                hf.fromNickname = event.map!['nickname'];
                hf.nobleId = int.parse(event.map!['noble_id'].toString());
              });
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
              hengFuBean hf = hengFuBean();
              setState(() {
                hf.roomName = event.map!['room_name'];
                hf.title = '贵族';
                hf.fromNickname = event.map!['nickname'];
                hf.nobleId = int.parse(event.map!['noble_id'].toString());
              });
              myhf = hf;
              setState(() {
                listMP.add(hf);
              });
            }
          }
        }
      });
      // 加入房间事件的监听
      listJoin = eventBus.on<JoinRoomYBack>().listen((event) {
        /// 用户长时间断网或者杀死app使用
        if (event.map!['type'] == 'user_leave_room') {
          // 清空存储信息
          deleteChatInfo();
          deleteGifInfo();
          //取消订阅所有远端用户的音频流。
          _engine!.muteAllRemoteAudioStreams(true);
          // 取消发布本地音频流
          _engine!.muteLocalAudioStream(true);
          _engine!.disableAudio();
          //离开频道并释放资源
          _dispose();
          Navigator.pop(context);
        } else if (event.map!['type'] == 'yq_up_mic' && sp.getString('mic_quren').toString() == '0') {
          if (mounted) {
            // 收到邀请通知
            if (event.map!['uid'].toString() ==
                sp.getString('user_id').toString()) {
                MyUtils.goTransparentPageCom(context, MicPage(title: '邀请上麦', roomID: widget.roomId, listM: listM,));
            }
          }
        }  else if (event.map!['type'] == 'yq_open_mic'  && sp.getString('mic_quren').toString() == '0') {
          if (mounted) {
            // 收到邀请通知
            if (event.map!['uid'].toString() ==
                sp.getString('user_id').toString()) {
              MyUtils.goTransparentPageCom(context, MicPage(title: '邀请开麦', roomID: widget.roomId, listM: listM,));
            }
          }
        } else if (event.map!['type'] == 'bao_mic') {
          // 通知用户被报上了麦序
          setState(() {
            for (int i = 0; i < 9; i++) {
              isMy[i] = false;
            }
            for (int i = 0; i < 9; i++) {
              upOrDown[i] = false;
            }
          });
          if (mounted) {
            // 上下麦操作不是本地才刷新
            if (event.map!['uid'].toString() ==
                sp.getString('user_id').toString()) {
              // MyToastUtils.showToastBottom(event.map!['text'].toString());
              doPostRoomMikeInfo();
            }
          }
        } else if (event.map!['type'] == 'user_down_mic') {
          //通知用户下麦
          setState(() {
            for (int i = 0; i < 9; i++) {
              isMy[i] = false;
            }
            for (int i = 0; i < 9; i++) {
              upOrDown[i] = false;
            }
            doUpdateOtherInfo(event.map!['serial_number'].toString(), '下麦');
          });
          if (mounted) {
            // 上下麦操作不是本地才刷新
            if (event.map!['uid'].toString() ==
                sp.getString('user_id').toString()) {
              // 设置成观众
              _engine!.setClientRole(role: ClientRoleType.clientRoleAudience);
              // 取消发布本地音频流
              _engine!.muteLocalAudioStream(true);
              setState(() {
                isMeUp = false;
              });
            }
          }
        } else if (event.map!['type'] == 'user_un_close_mic') {
          //通知用户开麦
          doUpdateOtherInfo(event.map!['serial_number'].toString(), '开麦');
          // 上下麦操作不是本地才刷新
          if (event.map!['uid'].toString() != sp.getString('user_id')) {
          } else {
            MyToastUtils.showToastBottom('您已被管理开麦~');
            setState(() {
              isJinyiin = false;
            });
            // 启用音频模块
            _engine!.enableAudio();
            // 发声音发音频流
            _engine!.enableLocalAudio(true);
            //设置成主播
            _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
            // 发布本地音频流
            _engine!.muteLocalAudioStream(false);
          }
        } else if (event.map!['type'] == 'user_close_mic') {
          //通知用户闭麦
          doUpdateOtherInfo(event.map!['serial_number'].toString(), '闭麦');
          if (event.map!['uid'].toString() != sp.getString('user_id')) {
          } else {
            MyToastUtils.showToastBottom('您已被管理闭麦~');
            setState(() {
              isJinyiin = true;
            });
            // 设置成观众
            _engine!.setClientRole(role: ClientRoleType.clientRoleAudience);
            // 取消发布本地音频流
            _engine!.muteLocalAudioStream(true);
          }
        } else if (event.map!['type'] == 'burstlight') {
          //通知用户开启了爆灯
          if (event.map!['uid'].toString() != sp.getString('user_id')) {
            setState(() {
              wherePeopleList[
                      int.parse(event.map!['serial_number'].toString()) - 1] =
                  event.map!['serial_number'].toString();
            });
            _startTimer2(event.map!['serial_number'].toString());
          }
        } else {
          /// 这里是用户的其他正常操作
          if (event.map!['room_id'].toString() == widget.roomId) {
            // 判断是不是点击了欢迎某某人
            if (event.map!['type'] == 'welcome_msg') {
              Map<dynamic, dynamic> map = {};
              map['info'] = event.map!['send_nickname'];
              map['uid'] = event.map!['from_uid'];
              map['type'] = '3';
              // 欢迎语信息
              map['content'] =
                  '${event.map!['nickname']},${event.map!['content']}';
              // 身份
              map['identity'] = event.map!['identity'];
              // 等级
              map['lv'] = event.map!['send_level'];
              // 财富等级
              map['newLv'] = event.map!['gr_lv'];
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
              map['bubble_img'] = event.map!['bubble_img'];
              LogE('欢迎某人== ${event.map!['bubble_img']}');
              setState(() {
                saveChatInfo(
                    event.map!,
                    '3',
                    event.map!['send_nickname'],
                    '${event.map!['nickname']},${event.map!['content']}',
                    event.map!['from_uid']);
                list.add(map);
              });
            } else if (event.map!['type'] == 'blind_box') {
              // 盲盒礼物
              //厅内发送的送礼物消息
              charmMHBean cb = charmMHBean.fromJson(event.map);
              for (int i = 0; i < listM.length; i++) {
                for (int a = 0; a < cb.charm!.length; a++) {
                  if (listM[i].uid.toString() == cb.charm![a].uid) {
                    setState(() {
                      listM[i].charm = int.parse(cb.charm![a].charm.toString());
                    });
                  }
                }
              }
              // 送出的盲盒
              for (int i = 0; i < cb.giftInfo!.length; i++) {
                Map<dynamic, dynamic> map = {};
                map['info'] = cb.giftInfo![i].nickName!;
                map['uid'] = event.map!['from_uid'];
                map['type'] = '6';
                String giftInfos = '';
                String mhType = '';
                if (cb.boxId == '1') {
                  mhType = '青铜礼盒(66)x${cb.number!}';
                } else if (cb.boxId == '2') {
                  mhType = '白银礼盒(300)x${cb.number!}';
                } else if (cb.boxId == '3') {
                  mhType = '黄金礼盒(660)x${cb.number!}';
                }
                for (int a = 0; a < cb.giftInfo![i].giftList!.length; a++) {
                  setState(() {
                    giftName = cb.giftInfo![i].giftList![a].giftName!;
                    nickName = cb.fromNickname!;
                    otherNickName = cb.giftInfo![i].nickName!;
                  });
                  // 保存信息
                  saveGiftInfo(
                    cb.fromAvatar!,
                    cb.fromUid!,
                    cb.fromNickname!,
                    cb.giftInfo![i].nickName!,
                    cb.toUids!,
                    cb.giftInfo![i].giftList![a].giftImgStatic!,
                    cb.giftInfo![i].giftList![a].giftNumber.toString(),
                    cb.giftInfo![i].giftList![a].giftName!,
                    cb.giftInfo![i].giftList![a].giftPrice.toString(),
                  );
                  if (giftInfos.isEmpty) {
                    giftInfos =
                        ' 爆出${cb.giftInfo![i].giftList![a].giftName!}(${cb.giftInfo![i].giftList![a].giftPrice.toString()}) x${cb.giftInfo![i].giftList![a].giftNumber.toString()}';
                  } else {
                    giftInfos =
                        '$giftInfos,爆出${cb.giftInfo![i].giftList![a].giftName!}(${cb.giftInfo![i].giftList![a].giftPrice.toString()}) x${cb.giftInfo![i].giftList![a].giftNumber.toString()}';
                  }
                  setState(() {
                    // 加入播放队列
                    if (isDevices == 'android') {
                      // 这个是为了让别人也能看见自己送出的礼物
                      if (listUrl.isEmpty) {
                        if (cb.giftInfo![i].giftList![a].giftName! == '黄金宫殿' ||
                            cb.giftInfo![i].giftList![a].giftName! == '糖果木马' ||
                            cb.giftInfo![i].giftList![a].giftName! == '机械时代' ||
                            cb.giftInfo![i].giftList![a].giftName! == '书中仙' ||
                            cb.giftInfo![i].giftList![a].giftName! == '星光宝盒') {
                          saveSVGAIMAGE(cb.giftInfo![i].giftList![a].giftImg!);
                        } else {
                          LogE(
                              '盲盒礼物== ${cb.giftInfo![i].giftList![a].giftImg!}');
                          Map<dynamic, dynamic> map = {};
                          map['svgaUrl'] =
                              cb.giftInfo![i].giftList![a].giftImg!;
                          map['svgaBool'] = true;
                          // 直接用网络图地址
                          listUrl.add(map);
                          isShowSVGA = true;
                          showStar(listUrl[0]);
                        }
                      } else {
                        LogE(
                            '盲盒礼物==** ${cb.giftInfo![i].giftList![a].giftImg!}');
                        if (cb.giftInfo![i].giftList![a].giftName! == '黄金宫殿' ||
                            cb.giftInfo![i].giftList![a].giftName! == '糖果木马' ||
                            cb.giftInfo![i].giftList![a].giftName! == '机械时代' ||
                            cb.giftInfo![i].giftList![a].giftName! == '书中仙' ||
                            cb.giftInfo![i].giftList![a].giftName! == '星光宝盒') {
                          saveSVGAIMAGE(cb.giftInfo![i].giftList![a].giftImg!);
                        } else {
                          // 直接用网络图地址
                          Map<dynamic, dynamic> map = {};
                          map['svgaUrl'] =
                              cb.giftInfo![i].giftList![a].giftImg!;
                          map['svgaBool'] = true;
                          // 直接用网络图地址
                          listUrl.add(map);
                        }
                      }
                    } else {
                      // ios
                      // 这个是为了让别人也能看见自己送出的礼物
                      if (listUrl.isEmpty) {
                        Map<dynamic, dynamic> map = {};
                        map['svgaUrl'] = cb.giftInfo![i].giftList![a].giftImg!;
                        map['svgaBool'] = true;
                        // 直接用网络图地址
                        listUrl.add(map);
                        isShowSVGA = true;
                        showStar(listUrl[0]);
                      } else {
                        // 直接用网络图地址
                        Map<dynamic, dynamic> map = {};
                        map['svgaUrl'] = cb.giftInfo![i].giftList![a].giftImg!;
                        map['svgaBool'] = true;
                        // 直接用网络图地址
                        listUrl.add(map);
                      }
                    }
                  });
                }
                // 发送的信息
                map['content'] =
                    '${event.map!['from_nickname']};向;${cb.giftInfo![i].nickName!};送出$mhType;$giftInfos';
                saveChatInfo(
                    event.map!,
                    '6',
                    event.map!['from_nickname'],
                    '${event.map!['from_nickname']};向;${cb.giftInfo![i].nickName!};送出$mhType;$giftInfos',
                    event.map!['from_uid']);
                setState(() {
                  list.add(map);
                });
              }
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                // scrollToLastItem2(); // 在widget构建完成后滚动到底部
                scrollToLastItem();
              });
            } else if (event.map!['type'] == 'clean_charm') {
              // 清除魅力值
              setState(() {
                for (int i = 0; i < listM.length; i++) {
                  listM[i].charm = 0;
                }
              });
            } else if (event.map!['type'] == 'clean_charm_single') {
              if (event.map['uid'].toString().contains(',')) {
                List<String> listId = event.map['uid'].toString().split(',');
                // 清除单个魅力或多个
                for (int i = 0; i < listM.length; i++) {
                  for (int a = 0; a < listId.length; a++) {
                    if (listId[a] == listM[i].uid.toString()) {
                      setState(() {
                        listM[i].charm = 0;
                      });
                      break;
                    }
                  }
                }
              } else {
                // 清除单个魅力或多个
                for (int i = 0; i < listM.length; i++) {
                  if (event.map['uid'].toString() == listM[i].uid.toString()) {
                    setState(() {
                      listM[i].charm = 0;
                    });
                    break;
                  }
                }
              }
            } else if (event.map!['type'] == 'clean_public_screen') {
              // 清除公屏
              deleteChatInfo();
              setState(() {
                list.clear();
                list2.clear();
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
              // 财富等级
              map['newLv'] = event.map!['gr_lv'];
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
              map['bubble_img'] = event.map!['bubble_img'];

              setState(() {
                saveChatInfo(event.map!, '4', event.map!['nickname'],
                    event.map!['content'], event.map!['uid']);
                list.add(map);
              });
            } else if (event.map!['type'] == 'send_gift') {
              blueScore = (int.parse(blueScore) +
                      int.parse(event.map!['blue_score'].toString()))
                  .toString();
              redScore = (int.parse(redScore) +
                      int.parse(event.map!['red_score'].toString()))
                  .toString();
              // 发png图会用到，其他的不使用
              List<bool> listPeoplepng = [];
              for (int i = 0; i < 10; i++) {
                listPeoplepng.add(false);
              }
              //厅内发送的送礼物消息
              charmAllBean cb = charmAllBean.fromJson(event.map);

              // 本地记录送礼
              if (cb.recordToNickname!.contains(',')) {
                List lName = cb.recordToNickname!.split(',');
                List lUid = cb.toUids!.split(',');
                for (int i = 0; i < lName.length; i++) {
                  // 保存信息
                  saveGiftInfo(
                    cb.fromAvatar!,
                    cb.fromUid!,
                    cb.fromNickname!,
                    lName[i],
                    lUid[i],
                    cb.giftInfo![0].giftImgStatic!,
                    cb.giftInfo![0].giftNumber.toString(),
                    cb.giftInfo![0].giftName!,
                    cb.giftInfo![0].giftPrice.toString(),
                  );
                }
                setState(() {
                  giftName = cb.giftInfo![0].giftName!;
                  nickName = cb.fromNickname!;
                  otherNickName = lName[lName.length - 1];
                });
              } else {
                setState(() {
                  giftName = cb.giftInfo![0].giftName!;
                  nickName = cb.fromNickname!;
                  otherNickName = cb.toNickname!;
                });
                // 保存信息
                saveGiftInfo(
                  cb.fromAvatar!,
                  cb.fromUid!,
                  cb.fromNickname!,
                  cb.toNickname!,
                  cb.toUids!,
                  cb.giftInfo![0].giftImgStatic!,
                  cb.giftInfo![0].giftNumber.toString(),
                  cb.giftInfo![0].giftName!,
                  cb.giftInfo![0].giftPrice.toString(),
                );
              }
              for (int i = 0; i < listM.length; i++) {
                for (int a = 0; a < cb.charm!.length; a++) {
                  if (listM[i].uid.toString() == cb.charm![a].uid) {
                    setState(() {
                      listPeoplepng[i] = true;
                      listM[i].charm = int.parse(cb.charm![a].charm.toString());
                    });
                  }
                }
              }
              if (listPeoplepng[0] == false &&
                  listPeoplepng[1] == false &&
                  listPeoplepng[2] == false &&
                  listPeoplepng[3] == false &&
                  listPeoplepng[4] == false &&
                  listPeoplepng[5] == false &&
                  listPeoplepng[6] == false &&
                  listPeoplepng[7] == false &&
                  listPeoplepng[8] == false) {
                listPeoplepng[9] = true;
              }
              Map<dynamic, dynamic> map = {};
              map['info'] = event.map!['nickname'];
              map['uid'] = event.map!['from_uid'];
              map['type'] = '5';
              // 发送的信息
              map['content'] =
                  '${event.map!['from_nickname']};向;${event.map!['to_nickname']};送出${cb.giftInfo![0].giftName!}(${cb.giftInfo![0].giftPrice.toString()}); x${cb.giftInfo![0].giftNumber.toString()}';

              saveChatInfo(
                  event.map!,
                  '5',
                  event.map!['nickname'],
                  '${event.map!['from_nickname']};向;${event.map!['to_nickname']};送出${cb.giftInfo![0].giftName!}(${cb.giftInfo![0].giftPrice.toString()}); x${cb.giftInfo![0].giftNumber.toString()}',
                  event.map!['from_uid']);
              if (cb.giftInfo![0].giftImg!.contains('png')) {
                setState(() {
                  list.add(map);
                  if (listCMb.isEmpty) {
                    listCM.add(cb);
                    listCMb.add(listPeoplepng);
                    MyUtils.goTransparentPageCom(
                        context,
                        RoomShowLiWuPage(
                            listPeople: listCMb[0],
                            url: listCM[0].giftInfo![0].giftImg!));
                    hpTimer2();
                  } else {
                    listCM.add(cb);
                    listCMb.add(listPeoplepng);
                    hpTimer2();
                  }
                });
              } else if (cb.giftInfo![0].giftImg!.contains('svga')) {
                setState(() {
                  list.add(map);
                  // 判断如果不是自己，则可以加入播放队列
                  if (event.map!['from_uid'].toString() !=
                      sp.getString('user_id').toString()) {
                    if (isDevices == 'android') {
                      // 这个是为了让别人也能看见自己送出的礼物
                      if (listUrl.isEmpty) {
                        if (cb.giftInfo![0].giftName! == '北欧天马' ||
                            cb.giftInfo![0].giftName! == '浮生若梦' ||
                            cb.giftInfo![0].giftName! == '圣光之子' ||
                            cb.giftInfo![0].giftName! == '环游世界' ||
                            cb.giftInfo![0].giftName! == '鲸遇心海' ||
                            cb.giftInfo![0].giftName! == '竞速时刻' ||
                            cb.giftInfo![0].giftName! == '君临天下' ||
                            cb.giftInfo![0].giftName! == '狂欢宇宙' ||
                            cb.giftInfo![0].giftName! == '梦游长安（幸运）' ||
                            cb.giftInfo![0].giftName! == '木马奇缘' ||
                            cb.giftInfo![0].giftName! == '奇幻游记' ||
                            cb.giftInfo![0].giftName! == '热气球' ||
                            cb.giftInfo![0].giftName! == '梦想岛' ||
                            cb.giftInfo![0].giftName! == '雪域飞虎' ||
                            cb.giftInfo![0].giftName! == '御龙英豪' ||
                            cb.giftInfo![0].giftName! == '秒见财神' ||
                            cb.giftInfo![0].giftName! == '情定埃菲尔' ||
                            cb.giftInfo![0].giftName! == '为爱启航' ||
                            cb.giftInfo![0].giftName! == '巅峰之证（幸运）' ||
                            cb.giftInfo![0].giftName! == '吞星之鲸' ||
                            cb.giftInfo![0].giftName! == '兮之城堡' ||
                            cb.giftInfo![0].giftName! == '星际战舰' ||
                            cb.giftInfo![0].giftName! == '阿洛斯' ||
                            cb.giftInfo![0].giftName! == '爱神丘比特' ||
                            cb.giftInfo![0].giftName! == '遨游客机' ||
                            cb.giftInfo![0].giftName! == '白龙' ||
                            cb.giftInfo![0].giftName! == '激流勇进' ||
                            cb.giftInfo![0].giftName! == '金蝉子（幸运）' ||
                            cb.giftInfo![0].giftName! == '空间跳跃' ||
                            cb.giftInfo![0].giftName! == '美杜莎' ||
                            cb.giftInfo![0].giftName! == '天鹅之女' ||
                            cb.giftInfo![0].giftName! == '夏天海棠' ||
                            cb.giftInfo![0].giftName! == '香槟酒' ||
                            cb.giftInfo![0].giftName! == '星云火箭' ||
                            cb.giftInfo![0].giftName! == '羽神' ||
                            cb.giftInfo![0].giftName! == '玉兔抱月' ||
                            cb.giftInfo![0].giftName! == '缘定' ||
                            cb.giftInfo![0].giftName! == '月吟环' ||
                            cb.giftInfo![0].giftName! == '至尊王座' ||
                            cb.giftInfo![0].giftName! == '女神龙骑' ||
                            cb.giftInfo![0].giftName! == '天空之境' ||
                            cb.giftInfo![0].giftName! == '战神' ||
                            cb.giftInfo![0].giftName! == '堕落天使' ||
                            cb.giftInfo![0].giftName! == '青丘狐仙' ||
                            cb.giftInfo![0].giftName! == '黑龙' ||
                            cb.giftInfo![0].giftName! == '神龙宝藏' ||
                            cb.giftInfo![0].giftName! == '女神铠甲' ||
                            cb.giftInfo![0].giftName! == '天鹅之女') {
                          saveSVGAIMAGE(cb.giftInfo![0].giftImg!);
                        } else {
                          Map<dynamic, dynamic> map = {};
                          map['svgaUrl'] = cb.giftInfo![0].giftImg!;
                          map['svgaBool'] = true;
                          // 直接用网络图地址
                          listUrl.add(map);
                          isShowSVGA = true;
                          showStar(listUrl[0]);
                        }
                      } else {
                        if (cb.giftInfo![0].giftName! == '北欧天马' ||
                            cb.giftInfo![0].giftName! == '浮生若梦' ||
                            cb.giftInfo![0].giftName! == '圣光之子' ||
                            cb.giftInfo![0].giftName! == '环游世界' ||
                            cb.giftInfo![0].giftName! == '鲸遇心海' ||
                            cb.giftInfo![0].giftName! == '竞速时刻' ||
                            cb.giftInfo![0].giftName! == '君临天下' ||
                            cb.giftInfo![0].giftName! == '狂欢宇宙' ||
                            cb.giftInfo![0].giftName! == '梦游长安（幸运）' ||
                            cb.giftInfo![0].giftName! == '木马奇缘' ||
                            cb.giftInfo![0].giftName! == '奇幻游记' ||
                            cb.giftInfo![0].giftName! == '热气球' ||
                            cb.giftInfo![0].giftName! == '梦想岛' ||
                            cb.giftInfo![0].giftName! == '雪域飞虎' ||
                            cb.giftInfo![0].giftName! == '御龙英豪' ||
                            cb.giftInfo![0].giftName! == '秒见财神' ||
                            cb.giftInfo![0].giftName! == '情定埃菲尔' ||
                            cb.giftInfo![0].giftName! == '为爱启航' ||
                            cb.giftInfo![0].giftName! == '巅峰之证（幸运）' ||
                            cb.giftInfo![0].giftName! == '吞星之鲸' ||
                            cb.giftInfo![0].giftName! == '兮之城堡' ||
                            cb.giftInfo![0].giftName! == '星际战舰' ||
                            cb.giftInfo![0].giftName! == '阿洛斯' ||
                            cb.giftInfo![0].giftName! == '爱神丘比特' ||
                            cb.giftInfo![0].giftName! == '遨游客机' ||
                            cb.giftInfo![0].giftName! == '白龙' ||
                            cb.giftInfo![0].giftName! == '激流勇进' ||
                            cb.giftInfo![0].giftName! == '金蝉子（幸运）' ||
                            cb.giftInfo![0].giftName! == '空间跳跃' ||
                            cb.giftInfo![0].giftName! == '美杜莎' ||
                            cb.giftInfo![0].giftName! == '天鹅之女' ||
                            cb.giftInfo![0].giftName! == '夏天海棠' ||
                            cb.giftInfo![0].giftName! == '香槟酒' ||
                            cb.giftInfo![0].giftName! == '星云火箭' ||
                            cb.giftInfo![0].giftName! == '羽神' ||
                            cb.giftInfo![0].giftName! == '玉兔抱月' ||
                            cb.giftInfo![0].giftName! == '缘定' ||
                            cb.giftInfo![0].giftName! == '月吟环' ||
                            cb.giftInfo![0].giftName! == '至尊王座' ||
                            cb.giftInfo![0].giftName! == '女神龙骑' ||
                            cb.giftInfo![0].giftName! == '天空之境' ||
                            cb.giftInfo![0].giftName! == '战神' ||
                            cb.giftInfo![0].giftName! == '堕落天使' ||
                            cb.giftInfo![0].giftName! == '青丘狐仙' ||
                            cb.giftInfo![0].giftName! == '黑龙' ||
                            cb.giftInfo![0].giftName! == '神龙宝藏' ||
                            cb.giftInfo![0].giftName! == '女神铠甲' ||
                            cb.giftInfo![0].giftName! == '天鹅之女') {
                          saveSVGAIMAGE(cb.giftInfo![0].giftImg!);
                        } else {
                          // 直接用网络图地址
                          Map<dynamic, dynamic> map = {};
                          map['svgaUrl'] = cb.giftInfo![0].giftImg!;
                          map['svgaBool'] = true;
                          // 直接用网络图地址
                          listUrl.add(map);
                        }
                      }
                    } else {
                      // ios
                      // 这个是为了让别人也能看见自己送出的礼物
                      if (listUrl.isEmpty) {
                        Map<dynamic, dynamic> map = {};
                        map['svgaUrl'] = cb.giftInfo![0].giftImg!;
                        map['svgaBool'] = true;
                        // 直接用网络图地址
                        listUrl.add(map);
                        isShowSVGA = true;
                        showStar(listUrl[0]);
                      } else {
                        // 直接用网络图地址
                        Map<dynamic, dynamic> map = {};
                        map['svgaUrl'] = cb.giftInfo![0].giftImg!;
                        map['svgaBool'] = true;
                        // 直接用网络图地址
                        listUrl.add(map);
                      }
                    }
                  }
                });
              }
            } else if (event.map!['type'] == 'send_reduce_gift') {
              //厅内发送的负数礼物送礼物消息
              charmAllBean cb = charmAllBean.fromJson(event.map);
              for (int i = 0; i < listM.length; i++) {
                for (int a = 0; a < cb.charm!.length; a++) {
                  if (listM[i].uid.toString() == cb.charm![a].uid) {
                    setState(() {
                      listM[i].charm = int.parse(cb.charm![a].charm.toString());
                    });
                  }
                }
              }
              // 本地记录送礼
              if (cb.recordToNickname!.contains(',')) {
                List lName = cb.recordToNickname!.split(',');
                List lUid = cb.toUids!.split(',');
                for (int i = 0; i < lName.length; i++) {
                  // 保存信息
                  saveGiftInfo(
                    cb.fromAvatar!,
                    cb.fromUid!,
                    cb.fromNickname!,
                    lName[i],
                    lUid[i],
                    cb.giftInfo![0].giftImgStatic!,
                    cb.giftInfo![0].giftNumber.toString(),
                    cb.giftInfo![0].giftName!,
                    cb.giftInfo![0].giftPrice.toString(),
                  );
                }
                setState(() {
                  giftName = cb.giftInfo![0].giftName!;
                  nickName = cb.fromNickname!;
                  otherNickName = lName[lName.length - 1];
                });
              } else {
                setState(() {
                  giftName = cb.giftInfo![0].giftName!;
                  nickName = cb.fromNickname!;
                  otherNickName = cb.toNickname!;
                });
                // 保存信息
                saveGiftInfo(
                  cb.fromAvatar!,
                  cb.fromUid!,
                  cb.fromNickname!,
                  cb.toNickname!,
                  cb.toUids!,
                  cb.giftInfo![0].giftImgStatic!,
                  cb.giftInfo![0].giftNumber.toString(),
                  cb.giftInfo![0].giftName!,
                  cb.giftInfo![0].giftPrice.toString(),
                );
              }
              Map<dynamic, dynamic> map = {};
              map['info'] = event.map!['nickname'];
              map['uid'] = event.map!['from_uid'];
              map['type'] = '5';
              // 发送的信息
              map['content'] =
                  '${event.map!['from_nickname']};向;${event.map!['to_nickname']};送出${cb.giftInfo![0].giftName!}(${cb.giftInfo![0].giftPrice.toString()}); x${cb.giftInfo![0].giftNumber.toString()}';

              saveChatInfo(
                  event.map!,
                  '5',
                  event.map!['nickname'],
                  '${event.map!['from_nickname']};向;${event.map!['to_nickname']};送出${cb.giftInfo![0].giftName!}(${cb.giftInfo![0].giftPrice.toString()}); x${cb.giftInfo![0].giftNumber.toString()}',
                  event.map!['from_uid']);

              /// 收到送的减礼物的im
              setState(() {
                list.add(map);
                blueScore = (int.parse(blueScore) +
                        int.parse(event.map!['blue_score'].toString()))
                    .toString();
                redScore = (int.parse(redScore) +
                        int.parse(event.map!['red_score'].toString()))
                    .toString();
                listUrlJL.add(event.map!['gift_info'][0]['gift_img']);
                jianLiWu = event.map!['serial_number_list'];
              });
              showStarJL(listUrlJL[0]);
            } else if (event.map!['type'] == 'one_click_gift') {
              //赠送全部背包礼物
              String infos = ''; // 这个是拼接用户送的礼物信息使用
              charmAllBean cb = charmAllBean.fromJson(event.map);
              setState(() {
                giftName = cb.giftInfo![0].giftName!;
                nickName = cb.fromNickname!;
                otherNickName = cb.toNickname!;
              });
              // //判断一键赠送给的谁加入本地数据库里面
              // saveImages(cb);
              for (int i = 0; i < listM.length; i++) {
                for (int a = 0; a < cb.charm!.length; a++) {
                  if (listM[i].uid.toString() == cb.charm![a].uid) {
                    setState(() {
                      listM[i].charm = int.parse(cb.charm![a].charm.toString());
                    });
                  }
                }
              }
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
                setState(() {
                  // 这个是为了让别人也能看见自己送出的礼物
                  if (listUrl.isEmpty) {
                    Map<dynamic, dynamic> map = {};
                    map['svgaUrl'] = cb.giftInfo![i].giftImg!;
                    map['svgaBool'] = true;
                    // 直接用网络图地址
                    listUrl.add(map);
                    isShowSVGA = true;
                    showStar(listUrl[0]);
                  } else {
                    Map<dynamic, dynamic> map = {};
                    map['svgaUrl'] = cb.giftInfo![i].giftImg!;
                    map['svgaBool'] = true;
                    // 直接用网络图地址
                    listUrl.add(map);
                  }
                });
                // 保存信息
                saveGiftInfo(
                  cb.fromAvatar!,
                  cb.fromUid!,
                  cb.fromNickname!,
                  cb.toNickname!,
                  cb.toUids!,
                  cb.giftInfo![i].giftImgStatic!,
                  cb.giftInfo![i].giftNumber.toString(),
                  cb.giftInfo![i].giftName!,
                  cb.giftInfo![i].giftPrice.toString(),
                );
              }
              //厅内发送的送礼物消息
              Map<dynamic, dynamic> map = {};
              map['info'] = event.map!['from_nickname'];
              map['uid'] = event.map!['from_uid'];
              map['type'] = '6';
              // 发送的信息
              map['content'] =
                  '${event.map!['from_nickname']};向;${event.map!['to_nickname']};送出;$infos';
              setState(() {
                saveChatInfo(
                    event.map!,
                    '6',
                    event.map!['from_nickname'],
                    '${event.map!['from_nickname']};向;${event.map!['to_nickname']};送出;$infos',
                    event.map!['from_uid']);
                list.add(map);
                // 这个是为了让别人也能看见自己送出的礼物
              });
            } else if (event.map!['type'] == 'collect_room') {
              // 收藏房间使用
              Map<dynamic, dynamic> map = {};
              map['type'] = '7';
              map['uid'] = event.map!['from_uid'];
              // 发送的信息
              map['content'] = event.map!['info'];
              setState(() {
                list.add(map);
              });
            } else if (event.map!['type'] == 'join_room') {
              LogE('***信息 == ${event.map!['follow_info']}');
              if (event.map!['is_stealth'] == 0) {
                // 跟随主播进入房间
                Map<dynamic, dynamic> map = {};
                map['type'] = '8';
                map['info'] = event.map!['nickname'];
                map['uid'] = event.map!['uid'];
                // 发送的信息
                map['content'] = event.map!['follow_info'];
                setState(() {
                  list.add(map);
                });
              }
            } else if (event.map!['type'] == 'play_win_gift') {
              // 厅内小礼物不在显示
            } else if (event.map!['type'] == 'send_screen_gift') {
              // 这个是本房间收到了在房间送出的3w8礼物
              zjgpBean cb = zjgpBean.fromJson(event.map!);
              String info = '';
              for (int i = 0; i < cb.giftInfo!.length; i++) {
                if (info.isEmpty) {
                  info =
                      '${cb.giftInfo![i].giftName!}(${cb.giftInfo![i].giftPrice.toString()}) x${cb.giftInfo![i].giftNumber!}';
                } else {
                  info =
                      '$info ${cb.giftInfo![i].giftName!}(${cb.giftInfo![i].giftPrice.toString()}) x${cb.giftInfo![i].giftNumber!}';
                }
              }
              //厅内发送的送礼物消息
              Map<dynamic, dynamic> map = {};
              map['info'] = event.map!['nickname'];
              map['uid'] = event.map!['uid'];
              map['type'] = '9';
              // 发送的信息
              map['content'] =
                  '${cb.nickName};在${event.map!['room_name']}向;${event.map!['to_nickname']};送出;$info';
              setState(() {
                list.add(map);
              });
            } else if (event.map!['type'] == 'send_screen') {
              // 这个是本房间收到了在本房间玩游戏中奖的信息（公屏信息）
              // 厅内抽奖使用
              zjgpBean cb = zjgpBean.fromJson(event.map!);
              String info = '';
              for (int i = 0; i < cb.giftInfo!.length; i++) {
                if (info.isEmpty) {
                  info =
                      '${cb.giftInfo![i].giftName!}(${cb.giftInfo![i].giftPrice.toString()}) x${cb.giftInfo![i].giftNumber!}';
                } else {
                  info =
                      '$info ${cb.giftInfo![i].giftName!}(${cb.giftInfo![i].giftPrice.toString()}) x${cb.giftInfo![i].giftNumber!}';
                }
              }
              if (cb.gameName! == '赛车游戏') {
                info = cb.amount!;
              }
              //厅内发送的送礼物消息
              Map<dynamic, dynamic> map = {};
              map['info'] = event.map!['nickname'];
              map['uid'] = event.map!['uid'];
              map['type'] = '9';
              // 发送的信息
              if (cb.gameName == '水星魔方') {
                map['content'] = '${cb.nickName};在;黄金幻宝;中赢得;$info';
              } else if (cb.gameName == '金星魔方') {
                map['content'] = '${cb.nickName};在;钻石幻宝;中赢得;$info';
              } else if (cb.gameName == '心动转盘') {
                map['content'] = '${cb.nickName};在;心动转盘;中赢得;$info';
              } else if (cb.gameName == '超级转盘') {
                map['content'] = '${cb.nickName};在;超级转盘;中赢得;$info';
              } else {
                map['content'] =
                    '${cb.nickName};在;${cb.gameName};中赢得;${cb.amount!}';
              }
              setState(() {
                list.add(map);
                // list2.add(map);
              });
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                // scrollToLastItem2(); // 在widget构建完成后滚动到底部
                scrollToLastItem();
              });
            } else if (event.map!['type'] == 'send_all_user' ||
                event.map!['type'] == 'blind_box_all') {
              // 是这个厅，并送了带横幅的礼物
              if (listMP.isEmpty) {
                // 厅内出现横幅使用
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
                // 厅内出现横幅使用
                hengFuBean hf = hengFuBean.fromJson(event.map!);
                myhf = hf;
                setState(() {
                  listMP.add(hf);
                });
              }
            } else if (event.map!['type'] == 'send_screen_all') {
              // 厅内送礼
              charmAllBean cb = charmAllBean.fromJson(event.map!);
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
              //厅内发送的送礼物消息
              Map<dynamic, dynamic> map = {};
              map['info'] = cb.fromNickname;
              map['uid'] = event.map!['from_uid'];
              map['type'] = '9';
              // 发送的信息
              map['content'] =
                  '${cb.fromNickname};向;${cb.toNickname};赠送了;$info';
              saveChatInfo(
                  event.map!,
                  '9',
                  cb.fromNickname!,
                  '${cb.fromNickname};向;${cb.toNickname};赠送了;$info',
                  event.map!['from_uid']);
              setState(() {
                list.add(map);
              });
            } else {
              // 正常进入房间使用
              LogE(
                  '正常进入房间===  ${event.map!['uid'].toString() != sp.getString('user_id').toString()}');
              if (event.map!['uid'].toString() !=
                      sp.getString('user_id').toString() &&
                  int.parse(event.map!['is_stealth'].toString()) == 0) {
                //展示新增svga
                Map<dynamic, dynamic> mapNew = {};
                final img = event.map!['enter_dress_gif_img'];
                if (img == null || img.isEmpty) {
                  mapNew['svgaUrl'] = 'assets/svga/room_moren.svga';
                  mapNew['svgaBool'] = false;
                } else {
                  mapNew['svgaUrl'] = img;
                  mapNew['svgaBool'] = true;
                  mapNew['svgaName'] = event.map['enter_dress_name'];
                }
                mapNew['nickNanme'] = event.map!['nickname'];
                mapNew['avatar'] = event.map!['avatar']; // 头像
                mapNew['gender'] = event.map!['gender']; // 性别
                // mapNew['enter_dress_gif_img'] = event.map!['enter_dress_gif_img']; // 进厅横幅动图
                // mapNew['enter_dress_name'] = event.map!['enter_dress_name']; // 进厅横幅名称
                if (listJoinRoom.isEmpty) {
                  listJoinRoom.add(mapNew);
                  showStarJoinRoom(listJoinRoom[0]);
                  isJRShow = true;
                } else {
                  listJoinRoom.add(mapNew);
                }

                setState(() {
                  avatar = event.map!['avatar']; // 头像
                });

                Map<dynamic, dynamic> map = {};
                map['info'] = event.map!['nickname'];
                map['type'] = '2';
                map['uid'] = event.map!['uid'];
                //身份
                map['identity'] = event.map!['identity'];
                //等级
                map['lv'] = event.map!['lv'];
                // 财富等级
                map['newLv'] = event.map!['gr_lv'];
                // 贵族
                map['noble_id'] = event.map!['noble_id'];
                // 萌新
                map['is_new'] = event.map!['is_new'];
                // 是否靓号
                map['is_pretty'] = event.map!['is_pretty'];
                // 新贵
                map['new_noble'] = event.map!['new_noble'];
                LogE('特权== ${event.map!['noble_id']}');
                // if(event.map!['noble_id'].toString() != '0'){
                //   setState(() {
                //     isGuZu = true;
                //   });
                // }
                // 是否点击了欢迎 0未欢迎 1已欢迎
                map['isWelcome'] = '0';
                // 座驾名称
                map['mount_name'] = event.map!['mount_name'];
                LogE('装扮名称 ==  ${event.map!['mount_name']}');

                /// 判断如果装扮了座驾，需要播放
                if (event.map!['mount'].toString().isNotEmpty) {
                  if (isDevices == 'android') {
                    // 这个是为了让别人也能看见自己送出的礼物
                    if (listUrl.isEmpty) {
                      if (event.map!['mount_name'].toString() == '白虎守护' ||
                          event.map!['mount_name'].toString() == '飞鹰' ||
                          event.map!['mount_name'].toString() == '飞鱼' ||
                          event.map!['mount_name'].toString() == '凤凰涅槃' ||
                          event.map!['mount_name'].toString() == '金龙降临' ||
                          event.map!['mount_name'].toString() == '鲸鱼' ||
                          event.map!['mount_name'].toString() == '旷世神龙' ||
                          event.map!['mount_name'].toString() == '兰博基尼' ||
                          event.map!['mount_name'].toString() == '青龙守护' ||
                          event.map!['mount_name'].toString() == '星空战机' ||
                          event.map!['mount_name'].toString() == '钢铁侠' ||
                          event.map!['mount_name'].toString() == '紫电跑车') {
                        saveSVGAIMAGEZJ(event.map!['mount'].toString());
                      } else {
                        setState(() {
                          Map<dynamic, dynamic> map = {};
                          map['svgaUrl'] = event.map!['mount'].toString();
                          map['svgaBool'] = true;
                          map['isZuoJi'] = '1';
                          listUrl.add(map);
                          isShowSVGA = true;
                        });
                        showStar(listUrl[0]);
                      }
                    } else {
                      if (event.map!['mount_name'].toString() == '白虎守护' ||
                          event.map!['mount_name'].toString() == '飞鹰' ||
                          event.map!['mount_name'].toString() == '飞鱼' ||
                          event.map!['mount_name'].toString() == '凤凰涅槃' ||
                          event.map!['mount_name'].toString() == '金龙降临' ||
                          event.map!['mount_name'].toString() == '鲸鱼' ||
                          event.map!['mount_name'].toString() == '旷世神龙' ||
                          event.map!['mount_name'].toString() == '兰博基尼' ||
                          event.map!['mount_name'].toString() == '青龙守护' ||
                          event.map!['mount_name'].toString() == '星空战机' ||
                          event.map!['mount_name'].toString() == '钢铁侠' ||
                          event.map!['mount_name'].toString() == '紫电跑车') {
                        saveSVGAIMAGEZJ(event.map!['mount'].toString());
                      } else {
                        setState(() {
                          Map<dynamic, dynamic> map = {};
                          map['svgaUrl'] = event.map!['mount'].toString();
                          map['svgaBool'] = true;
                          map['isZuoJi'] = '1';
                          listUrl.add(map);
                          isShowSVGA = true;
                        });
                        showStar(listUrl[0]);
                      }
                    }
                  } else {
                    // ios
                    if (listUrl.isEmpty) {
                      setState(() {
                        Map<dynamic, dynamic> map = {};
                        map['svgaUrl'] = event.map!['mount'].toString();
                        map['svgaBool'] = true;
                        map['isZuoJi'] = '1';
                        listUrl.add(map);
                        isShowSVGA = true;
                      });
                      showStar(listUrl[0]);
                    } else {
                      // 直接用网络图地址
                      setState(() {
                        Map<dynamic, dynamic> map = {};
                        map['svgaUrl'] = event.map!['mount'].toString();
                        map['svgaBool'] = true;
                        map['isZuoJi'] = '1';
                        listUrl.add(map);
                        isShowSVGA = true;
                      });
                    }
                  }
                }
                setState(() {
                  list.add(map);
                });
              }
            }

            WidgetsBinding.instance!.addPostFrameCallback((_) {
              scrollToLastItem(); // 在widget构建完成后滚动到底部
            });
          } else {
            LogE('其他房间发送im接收数据 ===  ${event.map!['type']}');
            if (event.map!['type'] == 'send_screen') {
              // 厅内抽奖使用
              zjgpBean cb = zjgpBean.fromJson(event.map!);
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
              //厅内发送的送礼物消息
              Map<dynamic, dynamic> map = {};
              map['info'] = event.map!['nickname'];
              map['uid'] = event.map!['uid'];
              map['type'] = '9';
              // 发送的信息
              if (cb.gameName == '水星魔方') {
                map['content'] = '${cb.nickName};在;黄金幻宝;中赢得;$info';
              } else if (cb.gameName == '金星魔方') {
                map['content'] = '${cb.nickName};在;钻石幻宝;中赢得;$info';
              } else if (cb.gameName == '心动转盘') {
                map['content'] = '${cb.nickName};在;心动转盘;中赢得;$info';
              } else if (cb.gameName == '超级转盘') {
                map['content'] = '${cb.nickName};在;超级转盘;中赢得;$info';
              } else {
                map['content'] =
                    '${cb.nickName};在;${cb.gameName};中赢得;${cb.amount!}';
              }
              setState(() {
                list.add(map);
                // list2.add(map);
              });

              WidgetsBinding.instance!.addPostFrameCallback((_) {
                // scrollToLastItem2(); // 在widget构建完成后滚动到底部
                scrollToLastItem();
              });
            } else if (event.map!['type'] == 'send_screen_all') {
              // 厅内送礼
              charmAllBean cb = charmAllBean.fromJson(event.map!);
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
              //厅内发送的送礼物消息
              Map<dynamic, dynamic> map = {};
              map['info'] = cb.fromNickname;
              map['uid'] = event.map!['from_uid'];
              map['type'] = '9';
              // 发送的信息
              map['content'] =
                  '${cb.fromNickname};向;${cb.toNickname};赠送了;$info';
              setState(() {
                list.add(map);
              });

              WidgetsBinding.instance!.addPostFrameCallback((_) {
                scrollToLastItem(); // 在widget构建完成后滚动到底部
              });
            } else if (event.map!['type'] == 'send_all_user' ||
                event.map!['type'] == 'blind_box_all') {
              if (listMP.isEmpty) {
                // 厅内出现横幅使用
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
                // 厅内出现横幅使用
                hengFuBean hf = hengFuBean.fromJson(event.map!);
                myhf = hf;
                setState(() {
                  listMP.add(hf);
                });
              }
            } else if (event.map!['type'] == 'send_screen_gift') {
              // 这个是其他房间收到了在其他房间送出的3w8礼物
              zjgpBean cb = zjgpBean.fromJson(event.map!);
              String info = '';
              for (int i = 0; i < cb.giftInfo!.length; i++) {
                if (info.isEmpty) {
                  info =
                      '${cb.giftInfo![i].giftName!}(${cb.giftInfo![i].giftPrice.toString()}) x${cb.giftInfo![i].giftNumber!}';
                } else {
                  info =
                      '$info ${cb.giftInfo![i].giftName!}(${cb.giftInfo![i].giftPrice.toString()}) x${cb.giftInfo![i].giftNumber!}';
                }
              }
              //厅内发送的送礼物消息
              Map<dynamic, dynamic> map = {};
              map['info'] = event.map!['nickname'];
              map['uid'] = event.map!['uid'];
              map['type'] = '9';
              // 发送的信息
              map['content'] =
                  '${cb.nickName};在${event.map!['room_name']}向;${event.map!['to_nickname']};送出;$info';
              setState(() {
                list.add(map);
              });
              WidgetsBinding.instance!.addPostFrameCallback((_) {
                scrollToLastItem(); // 在widget构建完成后滚动到底部
              });
            }
          }
        }
      });
      // 发消息监听
      listenSend = eventBus.on<SendRoomInfoBack>().listen((event) {
        if (mounted && _timeCount == 3) {
          _startTimer();
        }

        doPostRoomMessageSend(event.info, 0);
      });
      // 发图片监听
      listenSendImg = eventBus.on<SendRoomImgBack>().listen((event) {
        if (mounted && _timeCount == 3) {
          _startTimer();
        }
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

      listenBig = eventBus.on<ResidentBack>().listen((event) {
        setState(() {
          isBig = false;
        });
      });

      // 接受播放礼物
      listenSVGA = eventBus.on<SVGABack>().listen((event) {
        // 赠送了全部
        if (event.isAll) {
        } else {
          if (isDevices == 'android' && !event.isJian) {
            setState(() {
              if (listUrl.isEmpty) {
                if (event.url.contains('北欧天马') ||
                    event.url.contains('浮生若梦') ||
                    event.url.contains('圣光之子') ||
                    event.url.contains('环游世界') ||
                    event.url.contains('鲸遇心海') ||
                    event.url.contains('竞速时刻') ||
                    event.url.contains('君临天下') ||
                    event.url.contains('梦游长安（幸运）') ||
                    event.url.contains('木马奇缘') ||
                    event.url.contains('奇幻游记') ||
                    event.url.contains('热气球') ||
                    event.url.contains('梦想岛') ||
                    event.url.contains('雪域飞虎') ||
                    event.url.contains('御龙英豪') ||
                    event.url.contains('秒见财神') ||
                    event.url.contains('情定埃菲尔') ||
                    event.url.contains('为爱启航') ||
                    event.url.contains('巅峰之证（幸运）') ||
                    event.url.contains('吞星之鲸') ||
                    event.url.contains('兮之城堡') ||
                    event.url.contains('星际战舰') ||
                    event.url.contains('阿洛斯') ||
                    event.url.contains('爱神丘比特') ||
                    event.url.contains('遨游客机') ||
                    event.url.contains('白龙') ||
                    event.url.contains('激流勇进') ||
                    event.url.contains('金蝉子（幸运）') ||
                    event.url.contains('空间跳跃') ||
                    event.url.contains('美杜莎') ||
                    event.url.contains('天鹅之女') ||
                    event.url.contains('夏天海棠') ||
                    event.url.contains('香槟酒') ||
                    event.url.contains('星云火箭') ||
                    event.url.contains('羽神') ||
                    event.url.contains('玉兔抱月') ||
                    event.url.contains('缘定') ||
                    event.url.contains('月吟环') ||
                    event.url.contains('至尊王座') ||
                    event.url.contains('女神龙骑') ||
                    event.url.contains('天空之境') ||
                    event.url.contains('战神') ||
                    event.url.contains('堕落天使') ||
                    event.url.contains('青丘狐仙') ||
                    event.url.contains('黑龙') ||
                    event.url.contains('神龙宝藏') ||
                    event.url.contains('女神铠甲') ||
                    event.url.contains('天鹅之女')) {
                  saveSVGAIMAGE(event.url);
                } else {
                  // 直接用网络图地址
                  Map<dynamic, dynamic> map = {};
                  map['svgaUrl'] = event.url;
                  map['svgaBool'] = true;
                  // 直接用网络图地址
                  listUrl.add(map);
                  isShowSVGA = true;
                  showStar(listUrl[0]);
                }
              } else {
                if (event.url.contains('北欧天马') ||
                    event.url.contains('浮生若梦') ||
                    event.url.contains('圣光之子') ||
                    event.url.contains('环游世界') ||
                    event.url.contains('鲸遇心海') ||
                    event.url.contains('竞速时刻') ||
                    event.url.contains('君临天下') ||
                    event.url.contains('梦游长安（幸运）') ||
                    event.url.contains('木马奇缘') ||
                    event.url.contains('奇幻游记') ||
                    event.url.contains('热气球') ||
                    event.url.contains('梦想岛') ||
                    event.url.contains('雪域飞虎') ||
                    event.url.contains('御龙英豪') ||
                    event.url.contains('秒见财神') ||
                    event.url.contains('情定埃菲尔') ||
                    event.url.contains('为爱启航') ||
                    event.url.contains('巅峰之证（幸运）') ||
                    event.url.contains('吞星之鲸') ||
                    event.url.contains('兮之城堡') ||
                    event.url.contains('星际战舰') ||
                    event.url.contains('阿洛斯') ||
                    event.url.contains('爱神丘比特') ||
                    event.url.contains('遨游客机') ||
                    event.url.contains('白龙') ||
                    event.url.contains('激流勇进') ||
                    event.url.contains('金蝉子（幸运）') ||
                    event.url.contains('空间跳跃') ||
                    event.url.contains('美杜莎') ||
                    event.url.contains('天鹅之女') ||
                    event.url.contains('夏天海棠') ||
                    event.url.contains('香槟酒') ||
                    event.url.contains('星云火箭') ||
                    event.url.contains('羽神') ||
                    event.url.contains('玉兔抱月') ||
                    event.url.contains('缘定') ||
                    event.url.contains('月吟环') ||
                    event.url.contains('至尊王座') ||
                    event.url.contains('女神龙骑') ||
                    event.url.contains('天空之境') ||
                    event.url.contains('战神') ||
                    event.url.contains('堕落天使') ||
                    event.url.contains('青丘狐仙') ||
                    event.url.contains('黑龙') ||
                    event.url.contains('神龙宝藏') ||
                    event.url.contains('女神铠甲') ||
                    event.url.contains('天鹅之女')) {
                  saveSVGAIMAGE(event.url);
                } else {
                  // 直接用网络图地址
                  Map<dynamic, dynamic> map = {};
                  map['svgaUrl'] = event.url;
                  map['svgaBool'] = true;
                  // 直接用网络图地址
                  listUrl.add(map);
                }
              }
            });
          } else if (isDevices == 'ios' && !event.isJian) {
            if (listUrl.isEmpty) {
              // 直接用网络图地址
              Map<dynamic, dynamic> map = {};
              map['svgaUrl'] = event.url;
              map['svgaBool'] = true;
              // 直接用网络图地址
              listUrl.add(map);
              isShowSVGA = true;
              showStar(listUrl[0]);
            } else {
              // 直接用网络图地址
              Map<dynamic, dynamic> map = {};
              map['svgaUrl'] = event.url;
              map['svgaBool'] = true;
              // 直接用网络图地址
              listUrl.add(map);
            }
          }
        }
      });
      // 贵族特权进场动画播放完成
      listenGZOK = eventBus.on<RoomGZSVGABack>().listen((event) {
        if (event.isOK) {
          setState(() {
            isGuZu = false;
          });
        }
      });

      // 每隔1分钟请求一次房间热度信息
      doGetHot();

      // 水果机播放完成
      listenSGJ = eventBus.on<RoomSGJBack>().listen((event) {
        if (event.isOK) {
          setState(() {
            list[event.index!]['isOk'] = 'true';
          });
        }
      });

      listenMessage = eventBus.on<SendMessageBack>().listen((event) {
        doPostSystemMsgList();
      });

      // 侧滑推荐
      doPostShowRoomList();

      listenJoinHF = eventBus.on<hfJoinBack>().listen((event) {
        if (event.title == '厅内点击横幅') {
          // 如果房间id不是0（0是大厅），没有收起房间，直接进入房间
          if (event.roomID != '0' && sp.getString('roomID') != event.roomID) {
            doPostBeforeJoin(event.roomID);
          }
        }
      });
    });
  }

  Future<void> doGetHot() async{
    Future.delayed(const Duration(seconds: 60), (){
      doPostHotDegree();
      doGetHot();
    });
  }

// Connectivity 对象
  final Connectivity _connectivity = Connectivity();

  // 消息订阅
  StreamSubscription<ConnectivityResult>? _subscription;

  // 初始返回的网络状态
  ConnectivityResult? _connectivityStatus;

  // 初始化
  Future<void> _init() async {
    try {
      //状态订阅
      _subscription =
          _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    } on PlatformException catch (e) {
      LogE('/*- $e');
      LogE('/*- 连接网络出现了异常');
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectivityStatus = result;
    });
    if (_engine == null) {
      initAgora();
    }
    LogE('/*- ${_connectivityStatus?.toString()}');
    if (result == ConnectivityResult.mobile) {
      LogE('/*- 成功连接移动网络');
    } else if (result == ConnectivityResult.wifi) {
      LogE('/*- 成功连接WIFI');
    } else if (result == ConnectivityResult.ethernet) {
      LogE('/*- 成功连接到以太网');
    } else if (result == ConnectivityResult.vpn) {
      LogE('/*- 成功连接vpn网络');
    } else if (result == ConnectivityResult.none) {
      LogE('/*- 没有连接到任何网络');
    }
  }

  //上下麦刷新更新本地状态使用
  void doUpdateInfo(Map<String, String>? map, String status) {
    if (status == '下麦') {
      for (int i = 0; i < listM.length; i++) {
        setState(() {
          //换麦了
          if (map!['serial_number'].toString() ==
              listM[i].serialNumber.toString()) {
            LogE('刷新了***$i');
            listM[i].uid = 0;
            listM[i].isBoss = 0;
            listM[i].isLock = 0;
            listM[i].isClose = 1;
            listM[i].nickname = '';
            listM[i].avatar = '';
            listM[i].charm = 0;
            listM[i].identity = '';
            listM[i].waveImg = '';
            listM[i].waveGifImg = '';
            listM[i].avatarFrameImg = '';
            listM[i].avatarFrameGifImg = '';
            listM[i].isAudio = false;
            listM[i].nobleID = 0;
            if (listM[i].serialNumber == 1) {
              m1 = false;
            } else if (listM[i].serialNumber == 2) {
              m2 = false;
            } else if (listM[i].serialNumber == 3) {
              m3 = false;
            } else if (listM[i].serialNumber == 4) {
              m4 = false;
            } else if (listM[i].serialNumber == 5) {
              m5 = false;
            } else if (listM[i].serialNumber == 6) {
              m6 = false;
            } else if (listM[i].serialNumber == 7) {
              m7 = false;
            } else if (listM[i].serialNumber == 8) {
              m8 = false;
            } else if (listM[i].serialNumber == 9) {
              m0 = false;
            }
          }
        });
      }
    } else if (status == '上麦') {
      for (int i = 0; i < listM.length; i++) {
        // 原来没有麦序位置
        if (map!['old_serial_number'].toString() != '0') {
          setState(() {
            //换麦了
            if (map!['old_serial_number'].toString() ==
                listM[i].serialNumber.toString()) {
              LogE('刷新了***$i');
              listM[i].uid = 0;
              listM[i].isBoss = 0;
              listM[i].isLock = 0;
              listM[i].isClose = 1;
              listM[i].nickname = '';
              listM[i].avatar = '';
              listM[i].charm = 0;
              listM[i].identity = '';
              listM[i].waveImg = '';
              listM[i].waveGifImg = '';
              listM[i].avatarFrameImg = '';
              listM[i].avatarFrameGifImg = '';
              listM[i].isAudio = false;
              listM[i].nobleID = 0;
              if (listM[i].serialNumber == 1) {
                m1 = false;
              } else if (listM[i].serialNumber == 2) {
                m2 = false;
              } else if (listM[i].serialNumber == 3) {
                m3 = false;
              } else if (listM[i].serialNumber == 4) {
                m4 = false;
              } else if (listM[i].serialNumber == 5) {
                m5 = false;
              } else if (listM[i].serialNumber == 6) {
                m6 = false;
              } else if (listM[i].serialNumber == 7) {
                m7 = false;
              } else if (listM[i].serialNumber == 8) {
                m8 = false;
              } else if (listM[i].serialNumber == 9) {
                m0 = false;
              }
            }
          });
        }
        if (listM[i].serialNumber.toString() ==
            map!['serial_number'].toString()) {
          setState(() {
            listM[i].uid = int.parse(map!['uid'].toString());
            listM[i].roomId = int.parse(map!['room_id'].toString());
            listM[i].serialNumber = int.parse(map!['serial_number'].toString());
            listM[i].isBoss = int.parse(map!['is_boss'].toString());
            listM[i].isLock = int.parse(map!['is_lock'].toString());
            listM[i].isClose = int.parse(map!['is_close'].toString());
            listM[i].nickname = map!['nickname'].toString();
            listM[i].avatar = map!['avatar'].toString();
            listM[i].charm = int.parse(map!['charm'].toString());
            listM[i].avatarFrameImg = '';
            listM[i].avatarFrameGifImg = map!['avatar_gif_img'].toString();
            listM[i].waveGifImg = map!['wave_gif_img'].toString();
            listM[i].waveName = map!['wave_name'].toString();
            listM[i].nobleID = int.parse(map!['noble_id'].toString());
            if (listM[i].serialNumber == 1) {
              m1 = true;
            } else if (listM[i].serialNumber == 2) {
              m2 = true;
            } else if (listM[i].serialNumber == 3) {
              m3 = true;
            } else if (listM[i].serialNumber == 4) {
              m4 = true;
            } else if (listM[i].serialNumber == 5) {
              m5 = true;
            } else if (listM[i].serialNumber == 6) {
              m6 = true;
            } else if (listM[i].serialNumber == 7) {
              m7 = true;
            } else if (listM[i].serialNumber == 8) {
              m8 = true;
            } else if (listM[i].serialNumber == 9) {
              m0 = true;
            }
          });
        }
      }
    } else if (status == '开麦') {
      for (int i = 0; i < listM.length; i++) {
        setState(() {
          if (map!['serial_number'].toString() ==
              listM[i].serialNumber.toString()) {
            LogE('开麦=== $i');
            listM[i].isClose = 0;
          }
        });
      }
    } else if (status == '闭麦') {
      for (int i = 0; i < listM.length; i++) {
        setState(() {
          if (map!['serial_number'].toString() ==
              listM[i].serialNumber.toString()) {
            listM[i].isClose = 1;
          }
        });
      }
    }
  }

  //给别人开麦和下麦
  void doUpdateOtherInfo(String serialNumber, String status) {
    if (status == '下麦' || status == '拉黑') {
      for (int i = 0; i < listM.length; i++) {
        setState(() {
          //换麦了
          if (serialNumber == listM[i].serialNumber.toString()) {
            LogE('刷新了***$i');
            listM[i].uid = 0;
            listM[i].isBoss = 0;
            listM[i].isLock = 0;
            listM[i].isClose = 1;
            listM[i].nickname = '';
            listM[i].avatar = '';
            listM[i].charm = 0;
            listM[i].identity = '';
            listM[i].waveImg = '';
            listM[i].waveGifImg = '';
            listM[i].avatarFrameImg = '';
            listM[i].avatarFrameGifImg = '';
            listM[i].isAudio = false;
            if (listM[i].serialNumber == 1) {
              m1 = false;
            } else if (listM[i].serialNumber == 2) {
              m2 = false;
            } else if (listM[i].serialNumber == 3) {
              m3 = false;
            } else if (listM[i].serialNumber == 4) {
              m4 = false;
            } else if (listM[i].serialNumber == 5) {
              m5 = false;
            } else if (listM[i].serialNumber == 6) {
              m6 = false;
            } else if (listM[i].serialNumber == 7) {
              m7 = false;
            } else if (listM[i].serialNumber == 8) {
              m8 = false;
            } else if (listM[i].serialNumber == 9) {
              m0 = false;
            }
          }
        });
      }
    } else if (status == '开麦') {
      for (int i = 0; i < listM.length; i++) {
        setState(() {
          if (serialNumber == listM[i].serialNumber.toString()) {
            LogE('开麦=== $i');
            listM[i].isClose = 0;
          }
        });
      }
    } else if (status == '闭麦') {
      for (int i = 0; i < listM.length; i++) {
        setState(() {
          if (serialNumber == listM[i].serialNumber.toString()) {
            listM[i].isClose = 1;
          }
        });
      }
    }
  }

  //监听程序进入前后台的状态改变的方法
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    switch (state) {
      //进入应用时候不会触发该状态 应用程序处于可见状态，并且可以响应用户的输入事件。它相当于 Android 中Activity的onResume
      case AppLifecycleState.resumed:
        if(sp.getString('carShow').toString() == '1'){
          MyUtils.goTransparentPageCom(context, const Carpage());
        }
        print("应用进入前台======");
        setState(() {
          isFirst++;
          _engine!.enableAudio();
        });
        if (isFirst > 0) {
          doPostRoomUserMikeInfo();
        }
        break;
      //应用状态处于闲置状态，并且没有用户的输入事件，
      // 注意：这个状态切换到 前后台 会触发，所以流程应该是先冻结窗口，然后停止UI
      case AppLifecycleState.inactive:
        print("应用处于闲置状态，这种状态的应用应该假设他们可能在任何时候暂停 切换到后台会触发======");
        break;
      //当前页面即将退出
      case AppLifecycleState.detached:
        print("当前页面即将退出======");
        break;
      // 应用程序处于不可见状态
      case AppLifecycleState.paused:
        print("应用处于不可见状态 后台======");
        break;
    }
  }

  //拿到本地svga存储路径
  saveSVGAIMAGE(name) {
    LogE('礼物名称 $name');
    List<String> lujing = name.toString().split('/');
    // // 获取保存路径
    // Directory? directory = await getExternalStorageDirectory();
    // LogE('获取保存路径 $directory');
    String savePath =
        "/sdcard/Android/data/com.littledog.yyt/files/${lujing[lujing.length - 1]}";
    LogE('礼物地址 $savePath');
    if (listUrl.isEmpty) {
      setState(() {
        // 直接用本地图
        Map<dynamic, dynamic> map = {};
        map['svgaUrl'] = savePath;
        map['svgaBool'] = false;
        // 直接用网络图地址
        listUrl.add(map);
      });
      isShowSVGA = true;
      showStar(listUrl[0]);
    } else {
      setState(() {
        // 直接用本地图
        Map<dynamic, dynamic> map = {};
        map['svgaUrl'] = savePath;
        map['svgaBool'] = false;
        // 直接用网络图地址
        listUrl.add(map);
      });
    }
  }

  //拿到本地svga存储路径
  saveSVGAIMAGEZJ(name) async {
    LogE('礼物名称 $name');
    List<String> lujing = name.toString().split('/');
    // 获取保存路径
    Directory? directory = await getExternalStorageDirectory();
    LogE('获取保存路径 $directory');
    String savePath =
        "/sdcard/Android/data/com.littledog.yyt/files/${lujing[lujing.length - 1]}";
    LogE('礼物地址 $savePath');
    if (listUrl.isEmpty) {
      setState(() {
        Map<dynamic, dynamic> map = {};
        map['svgaUrl'] = savePath;
        map['svgaBool'] = false;
        map['isZuoJi'] = '1';
        // 直接用本地图
        listUrl.add(map);
      });
      isShowSVGA = true;
      showStar(listUrl[0]);
    } else {
      setState(() {
        Map<dynamic, dynamic> map = {};
        map['svgaUrl'] = savePath;
        map['svgaBool'] = false;
        map['isZuoJi'] = '1';
        // 直接用本地图
        listUrl.add(map);
      });
    }
  }

  //保持屏幕常亮
  saveLiang() async {
    // 获取屏幕亮度:
    double brightness = await Screen.brightness;
    // 设置亮度:
    // Screen.setBrightness(0.5);
    // 检测屏幕是否常亮:
    bool isKeptOn = await Screen.isKeptOn;
    // 防止进入睡眠模式:
    Screen.keepOn(true);
  }

  // 18秒后请求一遍
  void hpTimer() {
    Future.delayed(const Duration(seconds: 18), () {
      if (listMP.isNotEmpty) {
        setState(() {
          listMP.removeAt(0);
        });
        if (listMP.isEmpty) {
          setState(() {
            isBig = false;
            isShowHF = false;
          });
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

  // 18秒后请求一遍
  void hpTimer2() {
    Future.delayed(const Duration(seconds: 4), () {
      if (listCM.isNotEmpty) {
        setState(() {
          listCM.removeAt(0);
          listCMb.removeAt(0);
        });
        if (listCM.isNotEmpty) {
          MyUtils.goTransparentPageCom(
              context,
              RoomShowLiWuPage(
                  listPeople: listCMb[0],
                  url: listCM[0].giftInfo![0].giftImg!));
        }
      }
    });
  }

  // 接受到数据进行判断使用
  void showInfo(hengFuBean hf) {
    switch (hf.title) {
      case '贵族':
        if (hf.nobleId! > 1 && hf.nobleId! < 5) {
          // 低贵族
          setState(() {
            name = '低贵族';
            path = 'assets/svga/gp/gp_guizu_1.svga';
          });
        } else if (hf.nobleId! > 4 && hf.nobleId! < 8) {
          // 中贵族
          setState(() {
            name = '中贵族';
            path = 'assets/svga/gp/gp_guizu_2.svga';
          });
        } else if (hf.nobleId! > 7) {
          // 高贵族
          setState(() {
            name = '高贵族';
            path = 'assets/svga/gp/gp_guizu_3.svga';
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
      case '3000_6999背包礼物':
        setState(() {
          name = '3000_6999背包礼物';
          path = 'assets/svga/gp/bb_3000_6999.svga';
        });
        break;
      case '7000_19999背包礼物':
        setState(() {
          name = '7000_19999背包礼物';
          path = 'assets/svga/gp/bb_7000_19999.svga';
        });
        break;
      case '20000_99999背包礼物':
        setState(() {
          name = '20000_99999背包礼物';
          path = 'assets/svga/gp/bb_20000_99999.svga';
        });
        break;
      case '100000背包礼物':
        setState(() {
          name = '100000背包礼物';
          path = 'assets/svga/gp/bb_100000.svga';
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

  final ScrollController _scrollController = ScrollController();

  // final ScrollController _scrollController2 = ScrollController();

  // 在数据变化后将滚动位置设置为最后一个item的位置
  void scrollToLastItem() {
    LogE('加载完成//////');
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
  }

  // // 在数据变化后将滚动位置设置为最后一个item的位置
  // void scrollToLastItem2() {
  //   _scrollController2.animateTo(
  //     _scrollController2.position.maxScrollExtent,
  //     duration: const Duration(milliseconds: 100),
  //     curve: Curves.easeInOut,
  //   );
  // }

  @override
  void dispose() {
    //3. 页面销毁时，移出监听者
    WidgetsBinding.instance?.removeObserver(this);
    // 在页面销毁时，取消事件监听
    try {
      if (_engine != null) {
        _engine!.unregisterEventHandler(_eventHandler);
      }
    } catch (e) {
      LogE('声网 dispose: ${e.toString()}');
    }
    listen.cancel();
    listenRoomback.cancel();
    listenCheckBG.cancel();
    listenZDY.cancel();
    listJoin.cancel();
    listenSend.cancel();
    listenSendImg.cancel();
    _scrollController.dispose();
    if (slideAnimationController != null) {
      slideAnimationController!.dispose();
    }
    // _scrollController2.dispose();
    listenPeople.cancel();
    listenBig.cancel();
    listenSVGA.cancel();
    listenGZOK.cancel();
    listenMessage.cancel();
    _cancelTimerAll();
    listenSGJ.cancel();
    listenJoinHF.cancel();
    animationControllerBG.dispose();
    animationControllerSL.dispose();
    animationControllerZJ.dispose();
    animationControllerPK.dispose();
    animationControllerJL.dispose();
    animationControllerJR.dispose();
    if (_subscription != null) {
      _subscription!.cancel();
    }
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _dispose() async {
    LogE('====退出监听');
    try {
      if (_engine != null) {
        await _engine!.leaveChannel(); // 离开频道
        await _engine!.release(); // 释放资源
        _engine = null;
      }
    } catch (e) {
      LogE('初始化失败===============');
    }
  }

  // 离开频道
  Future<void> _levave() async {
    await _engine!.leaveChannel(); // 离开频道
  }

  late RtcEngineEventHandler _eventHandler;

  Future<void> _initEngine(RtcEngineContext context, {int time = 0}) async {
    if (_engine == null) {
      MyToastUtils.showToastBottom('启动失败, 请重新进入房间!');
      return;
    }
    try {
      await _engine!.initialize(context);
      return;
    } on AgoraRtcException catch (e) {
      LogE('声网初始化失败: ${e.message}');
      switch (e.code) {
        case -101:
        case -7:
        case -2: // -101：App ID无效。-7：SDK 未初始化。-2：参数无效。
          MyToastUtils.showToastBottom('启动失败, 请重新进入房间!');
          return;
        default: // -1：一般错误（未指定原因）。-22： 资源请求失败。 您的应用消耗系统资源过多或系统资源不足，导致SDK分配资源失败。
          break;
      }
    } catch (e) {
      LogE('声网初始化失败: ${e.toString()}');
    }
    if (time > 2000) {
      MyToastUtils.showToastBottom('启动失败, 请重新进入房间!');
      return;
    }
    await Future.delayed(Duration(milliseconds: time));
    await _initEngine(context, time: time + 250);
  }

  // 初始化应用
  Future<void> initAgora() async {
    await _dispose();

    // _dispose();
    // 获取权限
    await [Permission.microphone].request();

    // 创建 RtcEngine
    _engine = await createAgoraRtcEngine();

    // 初始化 RtcEngine，设置频道场景为直播场景
    // await _engine!.initialize(const RtcEngineContext(
    //   appId: MyConfig.appId,
    //   channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    // ));
    await _initEngine(const RtcEngineContext(
      appId: MyConfig.appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    // 启用音频模块
    _engine!.enableAudio();
    LogE('频道token ${widget.roomToken}');
    LogE('频道channelId ${widget.roomId}');
    // // 通过此方法设置为观众
    // _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    // 设置音质
    _engine!.setAudioProfile(
        profile: AudioProfileType.audioProfileMusicHighQuality,
        scenario: AudioScenarioType.audioScenarioGameStreaming);
    // // 开启降噪
    // _engine!.setAINSMode(
    //     enabled: true, mode: AudioAinsMode.ainsModeUltralowlatency);
    //默认订阅所有远端用户的音频流。
    _engine!.muteAllRemoteAudioStreams(false);
    var isHave = _engine!
        .enableAudioVolumeIndication(interval: 50, smooth: 3, reportVad: true);
    LogE('是否成功 ==  $isHave');
    LogE('本人上麦 ==  $isMeUp');
    if (isMeUp && isMeStatus) {
      // 发布本地音频流
      _engine!.muteLocalAudioStream(false);
      // 发声音流
      _engine!.enableLocalAudio(true);
    } else {
      // 取消发布本地音频流
      _engine!.muteLocalAudioStream(true);
      // 适用只听声音，不发声音流
      _engine!.enableLocalAudio(false);
    }
    _engine!.setParameters("{\"che.audio.max_mixed_participants\":9}");
    _engine!.enableAudioVolumeIndication(
        interval: 1000, smooth: 3, reportVad: true);
    _eventHandler = RtcEngineEventHandler(
      onAudioVolumeIndication: (RtcConnection connection,
          List<AudioVolumeInfo> speakers, int speakerNumber, int totalVolume) {
        // LogE("用户数量： ${speakers.length}");
        if (sp.getString('isShouQi').toString() == '0') {
          for (int i = 0; i < speakers.length; i++) {
            // LogE("用户音量： ${speakers[i].volume}");
            // LogE("用户id： ${speakers[i].uid}");
            /// 只采集声音大于75的用户
            if (speakers[i].volume! > 10) {
              //是本人
              if (speakers[i].uid == 0) {
                for (int a = 0; a < listM.length; a++) {
                  if (sp.getString('user_id').toString() ==
                      listM[a].uid.toString()) {
                    if (mounted) {
                      upAudioStatus(listM[a].serialNumber.toString(), true);
                    }
                  }
                }
              } else {
                //不是本人
                for (int a = 0; a < listM.length; a++) {
                  // 发音用户不是本人
                  if (speakers[i].uid == listM[a].uid) {
                    // 并且发声了
                    if (mounted) {
                      setState(() {
                        upAudioStatus(listM[a].serialNumber.toString(), true);
                      });
                    }
                  }
                }
              }
            } else {
              /// 声音小于75 不显示光波
              //是本人
              if (speakers[i].uid == 0) {
                for (int a = 0; a < listM.length; a++) {
                  if (sp.getString('user_id').toString() ==
                      listM[a].uid.toString()) {
                    if (mounted) {
                      setState(() {
                        upAudioStatus(listM[a].serialNumber.toString(), false);
                      });
                    }
                  }
                }
              } else {
                //不是本人
                for (int a = 0; a < listM.length; a++) {
                  // 发音用户不是本人
                  if (speakers[i].uid == listM[a].uid) {
                    // 并且发声了
                    if (mounted) {
                      setState(() {
                        upAudioStatus(listM[a].serialNumber.toString(), false);
                      });
                    }
                  }
                }
              }
            }
          }
        }
      },
      //本地音频统计数据。
      onLocalAudioStats: (RtcConnection connection, LocalAudioStats stats) {},
      //本地音频状态发生改变回调。
      onLocalAudioStateChanged: (RtcConnection connection,
          LocalAudioStreamState state, LocalAudioStreamError error) {},
      onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
        LogE("用户加入频道： ${connection.localUid} joined");
        LogE("用户加入频道： ${connection.channelId} 频道id");
        // 本地用户加入
        if (mounted) {
          setState(() {
            _localUserJoined = true;
          });
        }
      },
      onError: (ErrorCodeType err, String msg) {
        LogE("用户加入频道错误信息： $err ");
        LogE("用户加入频道错误信息：2 $msg ");
      },
      onConnectionStateChanged: (RtcConnection connection,
          ConnectionStateType state, ConnectionChangedReasonType reason) {
        LogE("用户已经加入频道： ${connection.channelId} 频道id");
        // LogE("用户已经加入频道： 状态 $state");
        LogE("用户已经加入频道： 状态 $reason");
        //如果加入频道失败等多项原因导致没声音，先移除频道，然后在重新走一遍加入频道流程
        if (reason == ConnectionChangedReasonType.connectionChangedJoinFailed ||
            reason ==
                ConnectionChangedReasonType.connectionChangedSameUidLogin ||
            reason ==
                ConnectionChangedReasonType
                    .connectionChangedClientIpAddressChangedByUser ||
            reason == ConnectionChangedReasonType.connectionChangedEchoTest ||
            reason == ConnectionChangedReasonType.connectionChangedLost ||
            reason ==
                ConnectionChangedReasonType
                    .connectionChangedSettingProxyServer) {
          _levave();
          initAgora();
        }
      },
      onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
        LogE("用户加入频道2 remote user $remoteUid joined");
        // 远程用户加入
        if (mounted) {
          setState(() {
            _remoteUid = remoteUid;
          });
        }
      },
      onUserOffline: (RtcConnection connection, int remoteUid,
          UserOfflineReasonType reason) {
        LogE("用户加入频道3 remote user $remoteUid left channel");
        // 用户离开房间
        if (mounted) {
          setState(() {
            _remoteUid = null;
          });
        }
      },
      onLeaveChannel: (RtcConnection connection, RtcStats stats) {
        //离开频道回调。
        LogE("用户离开 ${connection.channelId} remote user $stats left channel");
      },
    );
    LogE('声网状态 ${_eventHandler != null}');
    _engine!.registerEventHandler(_eventHandler);
    LogE('声网状态 ${_eventHandler != null}');
    // 加入频道，设置用户角色为主播
    await _engine!.joinChannel(
      token: widget.roomToken,
      channelId: widget.roomId,
      options: const ChannelMediaOptions(
          // 设置用户角色为主播
          // 如果要将用户角色设置为观众，则修改 clientRoleBroadcaster 为 clientRoleAudience
          clientRoleType: ClientRoleType.clientRoleBroadcaster),
      uid: int.parse(sp.getString('user_id').toString()),
    );
    _init();

    if(sp.getString('roomAudio').toString() == 'null' || sp.getString('roomAudio').toString().isEmpty){
      sp.setString('roomAudio', '1');
    }else{
      setState(() {
        if(sp.getString('roomAudio').toString() == '0'){
          roomSY = false;
          //取消订阅所有远端用户的音频流。
          _engine!.muteAllRemoteAudioStreams(true);
          MyToastUtils.showToastBottom('您已关闭房间声音');
        }else{
          roomSY = true;
          //开启订阅所有远端用户的音频流。
          _engine!.muteAllRemoteAudioStreams(false);
        }
      });
    }
  }

  ///更新9个麦序的开麦状态
  void upAudioStatus(String ss, bool status) {
    // LogE('更新麦序  == $ss////$status');
    switch (ss) {
      case "1":
        setState(() {
          audio1 = status;
        });
        break;
      case "2":
        setState(() {
          audio2 = status;
        });
        break;
      case "3":
        setState(() {
          audio3 = status;
        });
        break;
      case "4":
        setState(() {
          audio4 = status;
        });
        break;
      case "5":
        setState(() {
          audio5 = status;
        });
        break;
      case "6":
        setState(() {
          audio6 = status;
        });
        break;
      case "7":
        setState(() {
          audio7 = status;
        });
        break;
      case "8":
        setState(() {
          audio8 = status;
        });
        break;
      case "9":
        // LogE('更新麦序*******$status');
        setState(() {
          audio9 = status;
        });
        break;
    }
  }

  /// 开启声卡
  Future<void> starSK() async {
    _engine!.enableLoopbackRecording(enabled: true);
  }

  /// 展示消息地方
  Widget itemMessages(BuildContext context, int i) {
    // 这里后续要改，要传一个用户的id，目前没有，先写一个0
    return RoomItems.itemMessages(context, i, widget.roomId, list, listM);
  }

  /// 纯用户聊天使用展示消息地方
  Widget itemMessages2(BuildContext context, int i) {
    // 这里后续要改，要传一个用户的id，目前没有，先写一个0
    return RoomItems.itemMessages(context, i, widget.roomId, list2, listM);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
      body: WillPopScope(
        child: isOK
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
                  decoration: const BoxDecoration(
                    //设置Container修饰
                    image: DecorationImage(
                      //背景图片修饰
                      image:
                          AssetImage("assets/images/img_placeholder_room.png"),
                      fit: BoxFit.fill, //覆盖
                    ),
                  ),
                  child: Stack(
                    children: [
                      BgType == '1'
                          ? SizedBox(
                              height: double.infinity,
                              width: double.infinity,
                              child: WidgetUtils.showImagesNetRoom(
                                  bgImage, double.infinity, double.infinity),
                            )
                          : BgType == '2'
                              ? (bgSVGA.contains('gif') ||
                                      bgSVGA.contains('GIF'))
                                  ? SizedBox(
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: WidgetUtils.showImagesNetRoom(
                                          bgSVGA,
                                          double.infinity,
                                          double.infinity),
                                    )
                                  : Container(
                                      height: double.infinity,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        //设置Container修饰
                                        image: DecorationImage(
                                          //背景图片修饰
                                          image: AssetImage(
                                              "assets/images/img_placeholder_room.png"),
                                          fit: BoxFit.fill, //覆盖
                                        ),
                                      ),
                                      child: SVGAImage(
                                        animationControllerBG,
                                        fit: BoxFit.fill,
                                      ),
                                    )
                              : const Text(''),
                      Column(
                        children: [
                          WidgetUtils.commonSizedBox(
                              isDevices == 'ios' ? 80.h : 60.h, 0),
                          // 头部
                          RoomItems.roomTop(
                              context,
                              roomHeadImg,
                              roomName,
                              roomNumber,
                              follow_status,
                              hot_degree,
                              widget.roomId,
                              listM,
                              role),
                          WidgetUtils.commonSizedBox(10, 0),

                          /// 公告 和 厅主
                          RoomItems.notices(
                              context,
                              m0,
                              notice,
                              listM,
                              widget.roomId,
                              wherePeopleList[8],
                              listPeople,
                              audio9,
                              jianLiWu,
                              animationControllerJL),

                          /// 麦序
                          Stack(
                            children: [
                              (whoWin != 'draw' && isPK != 0)
                                  ? Transform.translate(
                                      offset: Offset(0, -50.h),
                                      child: Container(
                                        height: 340.h,
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          //设置Container修饰
                                          image: DecorationImage(
                                            //背景图片修饰
                                            image: AssetImage(
                                                "assets/images/room_pk_bg.png"),
                                            fit: BoxFit.fill, //覆盖
                                          ),
                                        ),
                                      ),
                                    )
                                  : const Text(''),
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
                                  wherePeopleList,
                                  listPeople,
                                  audio1,
                                  audio2,
                                  audio3,
                                  audio4,
                                  audio5,
                                  audio6,
                                  audio7,
                                  audio8,
                                  whoWin,
                                  jianLiWu,
                                  animationControllerJL),
                              // (isPK == 0)
                              //     ? Transform.translate(
                              //         offset: Offset(0, -50.h),
                              //         child: Container(
                              //           height: 450.h,
                              //           width: double.infinity,
                              //           decoration: const BoxDecoration(
                              //             //设置Container修饰
                              //             image: DecorationImage(
                              //               //背景图片修饰
                              //               image: AssetImage(
                              //                   "assets/images/pk_bg.png"),
                              //               fit: BoxFit.fill, //覆盖
                              //             ),
                              //           ),
                              //         ),
                              //       )
                              //     : const Text(''),

                              // /// 麦序位
                              // Transform.translate(
                              //   offset: Offset(0, 80.h),
                              //   child: RoomItems.maixuPK(
                              //       context,
                              //       m1,
                              //       m2,
                              //       m3,
                              //       m4,
                              //       m5,
                              //       m6,
                              //       m7,
                              //       m8,
                              //       isBoss,
                              //       listM,
                              //       widget.roomId,
                              //       wherePeopleList,
                              //       listPeople,
                              //       audio1,
                              //       audio2,
                              //       audio3,
                              //       audio4,
                              //       audio5,
                              //       audio6,
                              //       audio7,
                              //       audio8,
                              //       whoWin,
                              //       jianLiWu,
                              //       animationControllerJL),
                              // ),

                              // Positioned(
                              //   top: 50.w,
                              //     right: 0,
                              //     child: GestureDetector(
                              //       onTap: ((){
                              //
                              //       }),
                              //       child: Container(
                              //         height: 300.h,
                              //         width: 120.w,
                              //         color: Colors.transparent,
                              //         child: Stack(
                              //           children: [
                              //             WidgetUtils.showImagesFill(
                              //                 'assets/images/pk_sq.png', 300.h, 120.w),
                              //             Container(
                              //               height: 300.h,
                              //               padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                              //               child: ListView.builder(
                              //                 padding: const EdgeInsets.only(top: 0),
                              //                 itemBuilder: _itemOtherRoom,
                              //                 itemCount: 9,
                              //               ),
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     )),

                              // Positioned(
                              //     top: 50.w,
                              //     right: 0,
                              //     child: GestureDetector(
                              //       onTap: ((){
                              //
                              //       }),
                              //       child: Container(
                              //         height: 300.h,
                              //         width: 300.w,
                              //         color: Colors.transparent,
                              //         child: Stack(
                              //           children: [
                              //             WidgetUtils.showImagesFill(
                              //                 'assets/images/pk_zk.png', 300.h, 300.w),
                              //             Container(
                              //               height: 300.h,
                              //               width: 300.w,
                              //               padding: EdgeInsets.only(top: 10.h, bottom: 10.h),
                              //               child: Column(
                              //                 children: [
                              //                   WidgetUtils.commonSizedBox(20.w, 0),
                              //                   Container(
                              //                     height: 80.h,
                              //                     width: 50.h,
                              //                     color: Colors.transparent,
                              //                     child: Column(
                              //                       children: [
                              //                         WidgetUtils.showImages('assets/images/room_mai.png', 50.h, 50.h),
                              //                         WidgetUtils.onlyTextCenter(
                              //                             '主持麦',
                              //                             StyleUtils.getCommonTextStyle(
                              //                                 color: MyColors.roomMaiWZ,
                              //                                 fontSize: ScreenUtil().setSp(14)))
                              //                       ],
                              //                     ),
                              //                   ),
                              //                   zkPeople(0),
                              //                   zkPeople(4),
                              //                 ],
                              //               )
                              //             ),
                              //           ],
                              //         ),
                              //       ),
                              //     )),
                              //
                              // Positioned(left: 20.w, bottom: 90.w, child: WidgetUtils.showImagesFill(
                              //     'assets/images/pk_cf.png', 52.h, 110.w)),
                            ],
                          ),
                          //pk
                          (whoWin != 'draw' && isPK != 0)
                              ? Transform.translate(
                                  offset: Offset(0, -160.h),
                                  child: Container(
                                    height: 50.h,
                                    width: double.infinity,
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    child: Stack(
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: SizedBox(
                                                    height: 50.h,
                                                    child:
                                                        const SVGASimpleImage3(
                                                      assetsName:
                                                          'assets/svga/pk/room_pk_blue.svga',
                                                    ))),
                                            Expanded(
                                                child: SizedBox(
                                                    height: 50.h,
                                                    child:
                                                        const SVGASimpleImage3(
                                                      assetsName:
                                                          'assets/svga/pk/room_pk_red.svga',
                                                    ))),
                                          ],
                                        ),
                                        Container(
                                          width: double.infinity,
                                          height: 50.h,
                                          alignment: Alignment.center,
                                          child: Row(
                                            children: [
                                              const Spacer(),
                                              WidgetUtils.onlyText(
                                                  blueScore,
                                                  StyleUtils.getCommonTextStyle(
                                                      color: Colors.white,
                                                      fontSize: 22.sp)),
                                              WidgetUtils.showImages(
                                                  'assets/images/room_pk_qj.png',
                                                  30.h,
                                                  60.h),
                                              WidgetUtils.onlyText(
                                                  redScore,
                                                  StyleUtils.getCommonTextStyle(
                                                      color: Colors.white,
                                                      fontSize: 22.sp)),
                                              const Spacer(),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              : const Text(''),

                          _lunbotu(),

                          /// 底部按钮信息
                          RoomItems.footBtn(
                              context,
                              isJinyiin,
                              isForbation,
                              widget.roomId,
                              isHomeShow,
                              isRoomBoss,
                              mima,
                              listM,
                              roomDX,
                              roomSY,
                              isRed,
                              isMeUp,
                              mxIndex,
                              roomLixian),
                          isDevices == 'ios'
                              ? WidgetUtils.commonSizedBox(20.h, 0)
                              : WidgetUtils.commonSizedBox(0, 0)
                        ],
                      ),

                      //pk或惩罚时间
                      (whoWin != 'draw' && isPK != 0)
                          ? Positioned(
                              top: 290.h,
                              child: Container(
                                width: 300.w,
                                height: 40.h,
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    WidgetUtils.commonSizedBox(0, 20.w),
                                    Text(
                                      '$pkTitle: ${((pkTime ~/ 60) % 60).toString().padLeft(2, '0')}:${(pkTime % 60).toString().padLeft(2, '0')}',
                                      style: TextStyle(
                                          fontSize: ScreenUtil().setSp(26),
                                          color: Colors.white,
                                          fontFamily: 'YOUSHEBIAOTIHEI'),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            )
                          : const Text(''),

                      //提前结束pk
                      (whoWin != 'draw' &&
                              isPK != 0 &&
                              sp.getString('role').toString() != 'user' &&
                              sp.getString('role').toString() != 'streamer')
                          ? Positioned(
                              top: 270.h,
                              right: 10.w,
                              child: GestureDetector(
                                onTap: (() {
                                  if (MyUtils.checkClick()) {
                                    if (pkTitle == 'PK时间') {
                                      dopPostAheadOver();
                                    } else {
                                      doPostAheadPunish();
                                    }
                                  }
                                }),
                                child: Container(
                                  width: 160.w,
                                  height: 50.h,
                                  alignment: Alignment.centerRight,
                                  color: Colors.transparent,
                                  child: Stack(
                                    children: [
                                      WidgetUtils.showImages(
                                          'assets/images/trends_fabu_btn.png',
                                          50.h,
                                          160.w),
                                      WidgetUtils.onlyTextCenter(
                                        '提前结束',
                                        TextStyle(
                                            fontSize: ScreenUtil().setSp(28),
                                            color: Colors.white,
                                            fontFamily: 'YOUSHEBIAOTIHEI'),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : const Text(''),

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

                      /// 送礼展示
                      nickName.isNotEmpty
                          ? Positioned(
                              bottom: (whoWin != 'draw' && isPK != 0)
                                  ? 520.h
                                  : 610.h,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                color: Colors.transparent,
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    GestureDetector(
                                      onTap: (() {
                                        if (MyUtils.checkClick()) {
                                          MyUtils.goTransparentPage(
                                              context,
                                              RoomNewGiftPage(
                                                roomID: widget.roomId,
                                              ));
                                        }
                                      }),
                                      child: Container(
                                        padding: EdgeInsets.only(
                                            top: 0.h,
                                            bottom: 5.h,
                                            left: 10.h,
                                            right: 10.h),
                                        //边框设置
                                        decoration: const BoxDecoration(
                                          //背景
                                          color: Colors.white10,
                                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(15)),
                                        ),
                                        child: Row(
                                          children: [
                                            Text(nickName,
                                                style: TextStyle(
                                                  color: MyColors.djEightM,
                                                  fontSize: 24.sp,
                                                  height: 2,
                                                )),
                                            Text('打赏',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 24.sp,
                                                  height: 2,
                                                )),
                                            Text(otherNickName,
                                                style: TextStyle(
                                                  color: MyColors.djEightM,
                                                  fontSize: 24.sp,
                                                  height: 2,
                                                )),
                                            Text(giftName,
                                                style: TextStyle(
                                                  color: MyColors.peopleYellow,
                                                  fontSize: 24.sp,
                                                  height: 2,
                                                ))
                                          ],
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                              ))
                          : const Text(''),

                      /// 聊天除使用
                      Positioned(
                        bottom: isDevices == 'ios' ? 100.h : 80.h,
                        child:

                            /// 消息列表最外层
                            Container(
                          height: ((isDevices == 'ios' && isPK == 0)
                                  ? 520.h
                                  : (isDevices == 'ios' && isPK != 0)
                                      ? 400.h
                                      : (isDevices == 'android' && isPK == 0)
                                          ? 530.h
                                          : 440.h) -
                              10.h,
                          width: 420.h,
                          color: Colors.transparent,
                          child: Column(
                            children: [
                              //分类使用 先把公屏和房间注释
                              // SizedBox(
                              //   height: 50.h,
                              //   child: Row(
                              //     children: [
                              //       WidgetUtils.commonSizedBox(0, 20),
                              //       GestureDetector(
                              //         onTap: (() {
                              //           setState(() {
                              //             leixing = 0;
                              //           });
                              //         }),
                              //         child: WidgetUtils.showImages(
                              //             leixing == 0
                              //                 ? 'assets/images/room_gp1.png'
                              //                 : 'assets/images/room_gp2.png',
                              //             25.h,
                              //             60.h),
                              //       ),
                              //       WidgetUtils.commonSizedBox(0, 10),
                              //       Container(
                              //         height: ScreenUtil().setHeight(10),
                              //         width: ScreenUtil().setWidth(1),
                              //         color: MyColors.roomTCWZ3,
                              //       ),
                              //       WidgetUtils.commonSizedBox(0, 10),
                              //       GestureDetector(
                              //         onTap: (() {
                              //           setState(() {
                              //             leixing = 1;
                              //           });
                              //         }),
                              //         child: WidgetUtils.showImages(
                              //             leixing == 1
                              //                 ? 'assets/images/room_lt1.png'
                              //                 : 'assets/images/room_lt2.png',
                              //             25.h,
                              //             60.h),
                              //       ),
                              //       WidgetUtils.commonSizedBox(0, 10),
                              //     ],
                              //   ),
                              // ),
                              // Expanded(
                              //     child: leixing == 0
                              //         ? ListView.builder(
                              //             padding: EdgeInsets.only(
                              //               left: 20.h,
                              //             ),
                              //             itemBuilder: itemMessages2,
                              //             controller: _scrollController2,
                              //             itemCount: list2.length,
                              //           )
                              //         : ListView.builder(
                              //             padding: EdgeInsets.only(
                              //               top: ScreenUtil().setHeight(10),
                              //               left: 20.h,
                              //             ),
                              //             itemBuilder: itemMessages,
                              //             controller: _scrollController,
                              //             itemCount: list.length,
                              //           ))
                              Expanded(
                                child: FocusDetector(
                                  onFocusGained: () {
                                    scrollToEnd();
                                  },
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(
                                      top: ScreenUtil().setHeight(10),
                                      left: 20.h,
                                    ),
                                    itemBuilder: itemMessages,
                                    controller: _scrollController,
                                    itemCount: list.length,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      /// 公屏推送横幅使用
                      isShowHF
                          ? HomeItems.itemAnimation(
                              path,
                              slideAnimationController!.controller,
                              slideAnimationController!.animation,
                              name,
                              listMP[0],
                              '厅内点击横幅',
                              widget.roomId)
                          : const Text(''),

                      /// 爆出5w2的礼物横幅推送使用
                      isBig
                          ? HomeItems.itemBig(
                              listMP[0], bigType, '厅内点击横幅', widget.roomId)
                          : const Text(''),

                      /// 厅内送礼物显示动画使用
                      (isShowSVGA == true &&
                              roomDX == true &&
                              listUrl.isNotEmpty)
                          ? IgnorePointer(
                              ignoring: true,
                              child: SizedBox(
                                height: double.infinity,
                                width: double.infinity,
                                child: SVGAImage(
                                  animationControllerSL,
                                  fit: (listUrl[0]['isZuoJi']
                                              .toString()
                                              .isEmpty ||
                                          listUrl[0]['isZuoJi'].toString() ==
                                              'null')
                                      ? BoxFit.fitHeight
                                      : BoxFit.fitWidth,
                                ),
                              ),
                            )
                          : const Text(''),

                      /// New提示进入房间
                      (isJRShow == true)
                          ? IgnorePointer(
                              ignoring: true,
                              child: Center(
                                  child: Row(
                                children: [
                                  if (listJoinRoom[0]['svgaBool'])
                                    SizedBox(
                                      height: 50.h * 1.5,
                                      width: 400.w * 1.5,
                                      child: SVGAImage(
                                        animationControllerJR,
                                        fit: BoxFit.fitWidth,
                                      ),
                                    )
                                  else
                                    SizedBox(
                                      height: 55.h,
                                      width: 400.w,
                                      child: Stack(
                                        children: [
                                          SVGAImage(
                                            animationControllerJR,
                                            fit: BoxFit.fitWidth,
                                          ),
                                          Transform.translate(
                                            offset: Offset(0, 2.h),
                                            child: Row(
                                              // 头像// avatar 进厅横幅动图 enter_dress_gif_img 进厅横幅名称 enter_dress_name
                                              children: [
                                                WidgetUtils.commonSizedBox(
                                                    0, 15.w),
                                                WidgetUtils.CircleHeadImage(
                                                    45.h, 45.h, avatar),
                                                WidgetUtils.commonSizedBox(
                                                    0, 10.w),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    const Spacer(),
                                                    WidgetUtils.onlyText(
                                                        listJoinRoom[0]
                                                            ['nickNanme'],
                                                        StyleUtils
                                                            .getCommonTextStyle(
                                                                color: Colors
                                                                    .yellow,
                                                                fontSize:
                                                                    22.sp)),
                                                    WidgetUtils.onlyText(
                                                        '进入聊天室',
                                                        StyleUtils
                                                            .getCommonTextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize:
                                                                    22.sp)),
                                                    const Spacer(),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  const Spacer(),
                                ],
                              )),
                            )
                          : const Text(''),

                      /// 装扮座驾进入房间
                      (isZJShow == true)
                          ? IgnorePointer(
                              ignoring: true,
                              child: SizedBox(
                                height: double.infinity,
                                width: double.infinity,
                                child: SVGAImage(
                                  animationControllerZJ,
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                            )
                          : const Text(''),

                      /// pk 动画展示
                      (isPKStar == true)
                          ? IgnorePointer(
                              ignoring: true,
                              child: Center(
                                child: Container(
                                  width: double.infinity,
                                  height: 300.h,
                                  color: Colors.transparent,
                                  child: SVGAImage(
                                    animationControllerPK,
                                    fit: BoxFit.fitWidth,
                                  ),
                                ),
                              ),
                            )
                          : const Text(''),

                      // /// 贵族进场动画
                      // isGuZu
                      //     ? IgnorePointer(
                      //         ignoring: true,
                      //         child: SizedBox(
                      //           height: double.infinity,
                      //           width: double.infinity,
                      //           child: SVGASimpleImage6(
                      //             resUrl: tequanzhuangban,
                      //           ),
                      //         ),
                      //       )
                      //     : const Text(''),

                      /// 页面返回出现推荐房间
                      isBack ? _backView() : const Text('')
                    ],
                  ),
                ),
              )
            : Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(
                  //设置Container修饰
                  image: DecorationImage(
                    //背景图片修饰
                    image:
                    AssetImage("assets/images/room_join_bg.jpg"),
                    fit: BoxFit.fill, //覆盖
                  ),
                ),
              ),
        onWillPop: () async {
          //这里可以响应物理返回键
          // setState(() {
          //   isBack = true;
          // });
          if (isOK && MyUtils.checkClick()) {
            _cancelTimerAll();
            sp.setString('isShouQi', '1');
            sp.setString('sqRoomID', widget.roomId);
            if(roomSY == false){
              //取消订阅所有远端用户的音频流。
              _engine!.muteAllRemoteAudioStreams(true);
            }
            eventBus.fire(SubmitButtonBack(title: '收起房间'));
            // Navigator.pop(context);
            return true;
          } else {
            return false;
          }
        },
      ),
    );
  }

  Widget _backView() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: (() {
              if (sp.getBool('joinRoom') == false) {
                setState(() {
                  isBack = false;
                });
              }
            }),
            child: Container(
              color: Colors.transparent,
            ),
          ),
        ),
        Expanded(
            child: Container(
          height: double.infinity,
          color: Colors.black87,
          child: Column(
            children: [
              WidgetUtils.commonSizedBox(35, 0),
              Row(
                children: [
                  const Spacer(),
                  GestureDetector(
                    onTap: (() {
                      if (MyUtils.checkClick()) {
                        //取消订阅所有远端用户的音频流。
                        _engine!.muteAllRemoteAudioStreams(true);
                        // 取消发布本地音频流
                        _engine!.muteLocalAudioStream(true);
                        _engine!.disableAudio();
                        sp.setString('roomID', '');
                        // 调用离开房间接口
                        doPostLeave();
                        // 清空存储信息
                        deleteChatInfo();
                        deleteGifInfo();
                        sp.setString('isShouQi', '0');
                        //离开频道并释放资源
                        _dispose();
                        eventBus.fire(SubmitButtonBack(title: '退出房间'));
                        Navigator.pop(context);
                      }
                    }),
                    child: Column(
                      children: [
                        WidgetUtils.showImages(
                            'assets/images/room_exit.png',
                            ScreenUtil().setHeight(60),
                            ScreenUtil().setHeight(60)),
                        WidgetUtils.onlyTextCenter(
                            '退出房间',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.roomTCWZ3,
                                fontSize: ScreenUtil().setSp(24))),
                      ],
                    ),
                  ),
                  WidgetUtils.commonSizedBox(0, 50.w),
                  GestureDetector(
                    onTap: (() {
                      if (MyUtils.checkClick()) {
                        _cancelTimerAll();
                        sp.setString('isShouQi', '1');
                        sp.setString('sqRoomID', widget.roomId);
                        if(roomSY == false){
                          //取消订阅所有远端用户的音频流。
                          _engine!.muteAllRemoteAudioStreams(true);
                        }
                        eventBus.fire(SubmitButtonBack(title: '收起房间'));
                        Navigator.pop(context);
                      }
                    }),
                    child: Column(
                      children: [
                        WidgetUtils.showImages(
                            'assets/images/room_shouqi.png',
                            ScreenUtil().setHeight(60),
                            ScreenUtil().setHeight(60)),
                        WidgetUtils.onlyTextCenter(
                            '收起房间',
                            StyleUtils.getCommonTextStyle(
                                color: MyColors.roomTCWZ3,
                                fontSize: ScreenUtil().setSp(24))),
                      ],
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              WidgetUtils.commonSizedBox(40, 0),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
                  itemBuilder: roomHouse,
                  itemCount: listPH.length,
                ),
              )
            ],
          ),
        ))
      ],
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
            listM.clear();
            sp.setString('nobleID', bean.data!.userInfo!.nobleId!);
            LogE('贵族等级 == ${bean.data!.userInfo!.nobleId!}');
            sp.setString('roomName', bean.data!.roomInfo!.roomName!);
            sp.setString(
                'roomNumber', bean.data!.roomInfo!.roomNumber.toString());
            sp.setString('roomImage', bean.data!.roomInfo!.coverImgUrl!);
            sp.setString('roomNotice', bean.data!.roomInfo!.notice!);
            sp.setString('roomPass', bean.data!.roomInfo!.secondPwd!);
            sp.setInt("user_level", bean.data!.userInfo!.level as int);
            sp.setInt("user_grLevel", bean.data!.userInfo!.grLevel as int);
            BgType = bean.data!.roomInfo!.bgType.toString();
            bgSVGA = bean.data!.roomInfo!.bgUrl!;
            if (bgSVGA!.isNotEmpty) {
              showStar2(bgSVGA);
            }
            roomLixian = bean.data!.roomInfo!.lockMic as int;
            roomName = bean.data!.roomInfo!.roomName!;
            bgImage = bean.data!.roomInfo!.bgUrl!;
            notice = bean.data!.roomInfo!.notice!;
            hot_degree = bean.data!.roomInfo!.hotDegree.toString();
            follow_status = bean.data!.roomInfo!.followStatus!;
            role = bean.data!.userInfo!.role!;
            sp.setString('role', bean.data!.userInfo!.role!);
            sp.setString('user_identity', role);
            LogE('登录人的身份 ${bean.data!.userInfo!.role!}');
            LogE('登录人的财富等级 ${bean.data!.userInfo!.grLevel!}');
            // 等级变了
            if (bean.data!.userInfo!.level! >= 3) {
              eventBus.fire(SubmitButtonBack(title: '等级大于3级'));
            }
            // 等级变了
            if (bean.data!.userInfo!.grLevel! >= 3) {
              eventBus.fire(SubmitButtonBack(title: '财富等级大于3级'));
            }
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
            pkTime = bean.data!.roomInfo!.syTime as int;
            blueScore = bean.data!.roomInfo!.blueScore!;
            redScore = bean.data!.roomInfo!.redScore!;
            avatar = bean.data!.userInfo!.avatar!;
            if (pkTime > 0) {
              //开启房间pk
              _startTimerPK();
            }
            isPK = bean.data!.roomInfo!.pkStatus as int;
            if (isPK == 1) {
              isPKStar = true;
              pkTitle = 'PK时间';
            } else if (isPK == 2) {
              whoWin = bean.data!.roomInfo!.win!;
              LogE('结束=== ${bean.data!.roomInfo!.win! != 'draw'}');
              if (bean.data!.roomInfo!.win! != 'draw') {
                isPKStar = true;
                pkTitle = '惩罚时间';
              }
            } else if (isPK == 0) {
              isPKStar = false;
              pkTitle = 'PK时间';
            }
            LogE('===--- ${bean.data!.roomInfo!.mikeList![8].avatar}');
            // 判断麦上有没有自己
            for (int i = 0; i < bean.data!.roomInfo!.mikeList!.length; i++) {
              if (sp.getString('user_id').toString() ==
                  bean.data!.roomInfo!.mikeList![i].uid.toString()) {
                isMeUp = true;
                mxIndex =
                    bean.data!.roomInfo!.mikeList![i].serialNumber.toString();
                if (bean.data!.roomInfo!.mikeList![i].isClose == 0) {
                  isMeStatus = true;
                  isJinyiin = false;
                  // 启用音频模块
                  _engine!.enableAudio();
                  // 发声音发音频流
                  _engine!.enableLocalAudio(true);
                  //设置成主播
                  _engine!.setClientRole(
                      role: ClientRoleType.clientRoleBroadcaster);
                  // 发布本地音频流
                  _engine!.muteLocalAudioStream(false);
                }
                break;
              }
            }
            // 判断有没有贵族特权装扮
            if (bean.data!.userInfo!.carDressGifImg!.isNotEmpty &&
                bean.data!.userInfo!.isStealth == 0) {
              isGuZu = true;
              tequanzhuangban = bean.data!.userInfo!.carDressGifImg!;
            } else {
              isGuZu = false;
              tequanzhuangban = '';
            }

            if ((sp.getString('sqRoomID').toString() != widget.roomId ||
                    sp.getString('sqRoomID').toString().isEmpty) &&
                bean.data!.userInfo!.isStealth == 0) {
              sp.setString('sqRoomID', '');
              //展示新增svga
              Map<dynamic, dynamic> mapNew = {};
              final img = bean.data!.userInfo!.enter_dress_gif_img;
              if (img == null || img.isEmpty) {
                mapNew['svgaUrl'] = 'assets/svga/room_moren.svga';
                mapNew['svgaBool'] = false;
              } else {
                mapNew['svgaUrl'] = img;
                mapNew['svgaBool'] = true;
                mapNew['svgaName'] = bean.data!.userInfo!.enter_dress_name;
              }
              mapNew['nickNanme'] = bean.data!.userInfo!.nickname!;
              mapNew['avatar'] = bean.data!.userInfo!.avatar; // 头像
              mapNew['gender'] = bean.data!.userInfo!.gender;
              setState(() {
                avatar = bean.data!.userInfo!.avatar!; // 头像
              });
              // mapNew['enter_dress_gif_img'] = bean.data!.userInfo!.enter_dress_gif_img; // 进厅横幅动图
              // mapNew['enter_dress_name'] = bean.data!.userInfo!.enter_dress_name; // 进厅横幅名称
              if (listJoinRoom.isEmpty) {
                listJoinRoom.add(mapNew);
                showStarJoinRoom(listJoinRoom[0]);
                isJRShow = true;
              } else {
                listJoinRoom.add(mapNew);
              }

              //进入房间
              Map<dynamic, dynamic> mapg = {};
              mapg['info'] = notice;
              mapg['type'] = '1';
              list.add(mapg);
              // 存储本人进入房间，目的是为了自己能看见自己的坐骑
              Map<dynamic, dynamic> map = {};
              map['info'] = bean.data!.userInfo!.nickname!;
              map['type'] = '2';
              map['uid'] = sp.getString('user_id').toString();
              //身份
              map['identity'] = bean.data!.userInfo!.role!;
              //等级
              map['lv'] = bean.data!.userInfo!.level.toString();
              // 财富等级
              map['newLv'] = bean.data!.userInfo!.grLevel.toString();
              // 贵族
              map['noble_id'] = bean.data!.userInfo!.nobleId.toString();
              // 萌新
              map['is_new'] = bean.data!.userInfo!.isNew.toString();
              // 是否靓号
              map['is_pretty'] = bean.data!.userInfo!.isPretty.toString();
              // 新贵
              map['new_noble'] = bean.data!.userInfo!.newNoble.toString();
              // 是否点击了欢迎 0未欢迎 1已欢迎
              map['isWelcome'] = '0';
              // 座驾名称
              map['mount_name'] = bean.data!.userInfo!.carDressName!;

              LogE('房间信息== ${bean.data!.userInfo!.carDressGifImg!}');
              LogE('房间信息== ${bean.data!.userInfo!.carDressName!}');

              /// 判断如果装扮了座驾，需要播放
              if (bean.data!.userInfo!.carDressGifImg!.isNotEmpty) {
                if (isDevices == 'android') {
                  // 这个是为了让别人也能看见自己送出的礼物
                  if (listUrlZJ.isEmpty) {
                    if (bean.data!.userInfo!.carDressName! == '白虎守护' ||
                        bean.data!.userInfo!.carDressName! == '飞鹰' ||
                        bean.data!.userInfo!.carDressName! == '飞鱼' ||
                        bean.data!.userInfo!.carDressName! == '凤凰涅槃' ||
                        bean.data!.userInfo!.carDressName! == '金龙降临' ||
                        bean.data!.userInfo!.carDressName! == '鲸鱼' ||
                        bean.data!.userInfo!.carDressName! == '旷世神龙' ||
                        bean.data!.userInfo!.carDressName! == '兰博基尼' ||
                        bean.data!.userInfo!.carDressName! == '青龙守护' ||
                        bean.data!.userInfo!.carDressName! == '星空战机' ||
                        bean.data!.userInfo!.carDressName! == '钢铁侠' ||
                        bean.data!.userInfo!.carDressName! == '紫电跑车') {
                      saveSVGAIMAGEZJ(bean.data!.userInfo!.carDressGifImg!);
                    } else {
                      setState(() {
                        Map<dynamic, dynamic> map = {};
                        map['svgaUrl'] = bean.data!.userInfo!.carDressGifImg!;
                        map['svgaBool'] = true;
                        listUrlZJ.add(map);
                        isZJShow = true;
                      });
                      showStarZJ(listUrlZJ[0]);
                    }
                  } else {
                    if (bean.data!.userInfo!.carDressName! == '白虎守护' ||
                        bean.data!.userInfo!.carDressName! == '飞鹰' ||
                        bean.data!.userInfo!.carDressName! == '飞鱼' ||
                        bean.data!.userInfo!.carDressName! == '凤凰涅槃' ||
                        bean.data!.userInfo!.carDressName! == '金龙降临' ||
                        bean.data!.userInfo!.carDressName! == '鲸鱼' ||
                        bean.data!.userInfo!.carDressName! == '旷世神龙' ||
                        bean.data!.userInfo!.carDressName! == '兰博基尼' ||
                        bean.data!.userInfo!.carDressName! == '青龙守护' ||
                        bean.data!.userInfo!.carDressName! == '星空战机' ||
                        bean.data!.userInfo!.carDressName! == '钢铁侠' ||
                        bean.data!.userInfo!.carDressName! == '紫电跑车') {
                      saveSVGAIMAGEZJ(bean.data!.userInfo!.carDressGifImg!);
                    } else {
                      setState(() {
                        Map<dynamic, dynamic> map = {};
                        map['svgaUrl'] = bean.data!.userInfo!.carDressGifImg!;
                        map['svgaBool'] = true;
                        listUrlZJ.add(map);
                        isZJShow = true;
                      });
                      showStarZJ(listUrlZJ[0]);
                    }
                  }
                } else {
                  // ios
                  if (listUrlZJ.isEmpty) {
                    setState(() {
                      Map<dynamic, dynamic> map = {};
                      map['svgaUrl'] = bean.data!.userInfo!.carDressGifImg!;
                      map['svgaBool'] = true;
                      listUrlZJ.add(map);
                      isZJShow = true;
                    });
                    showStarZJ(listUrlZJ[0]);
                  } else {
                    // 直接用网络图地址
                    setState(() {
                      Map<dynamic, dynamic> map = {};
                      map['svgaUrl'] = bean.data!.userInfo!.carDressGifImg!;
                      map['svgaBool'] = true;
                      listUrlZJ.add(map);
                      isZJShow = true;
                    });
                  }
                }
              }
              list.add(map);
            }

            isOK = true;
          });
          break;
        case MyHttpConfig.errorloginCode:
          setState(() {
            isOK = true;
          });
          //取消订阅所有远端用户的音频流。
          _engine!.muteAllRemoteAudioStreams(true);
          // 取消发布本地音频流
          _engine!.muteLocalAudioStream(true);
          _engine!.disableAudio();
          // 清空存储信息
          deleteChatInfo();
          deleteGifInfo();
          _dispose();
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          setState(() {
            isOK = true;
          });
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      setState(() {
        isOK = true;
      });
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 房间热度，每隔2分钟请求一次
  Future<void> doPostHotDegree() async {
    Map<String, dynamic> params = <String, dynamic>{'room_id': widget.roomId};
    try {
      CommonMyIntBean bean = await DataUtils.postHotDegree(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            hot_degree = bean.data.toString();
          });
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
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
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
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 上麦，下麦
  Future<void> doPostSetmai(
      String serial_number, String action, String whoUid, String baoMic) async {
    //baoMic  0否 1是
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomId,
      'serial_number': serial_number.isEmpty ? 0 : int.parse(serial_number) + 1,
      'uid': whoUid,
      'action': action,
      'from_uid': sp.getString('user_id'),
      'is_bao_mic': baoMic
    };
    try {
      maiXuBean bean = await DataUtils.postSetmai(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (action == 'up') {
              // 启用音频模块
              _engine!.enableAudio();
              //设置成主播
              _engine!
                  .setClientRole(role: ClientRoleType.clientRoleBroadcaster);
              // 发布本地音频流
              _engine!.muteLocalAudioStream(true);
            } else {
              // 下麦的人是自己
              if (whoUid == sp.getString('user_id')) {
                setState(() {
                  isJinyiin = true;
                });
                // 设置成观众
                _engine!.setClientRole(role: ClientRoleType.clientRoleAudience);
                // 取消发布本地音频流
                _engine!.muteLocalAudioStream(true);
              }
            }
            // 判断麦上有没有自己
            for (int i = 0; i < bean.data!.length; i++) {
              listM[i].id = bean.data![i].id;
              listM[i].uid = bean.data![i].uid;
              listM[i].roomId = bean.data![i].roomId;
              listM[i].serialNumber = bean.data![i].serialNumber;
              listM[i].isBoss = bean.data![i].isBoss;
              listM[i].isLock = bean.data![i].isLock;
              listM[i].isClose = bean.data![i].isClose;
              listM[i].nickname = bean.data![i].nickname;
              listM[i].avatar = bean.data![i].avatar;
              listM[i].charm = bean.data![i].charm;
              listM[i].identity = bean.data![i].identity;
              listM[i].waveImg = bean.data![i].waveImg;
              listM[i].waveGifImg = bean.data![i].waveGifImg;
              listM[i].avatarFrameImg = bean.data![i].avatarFrameImg;
              listM[i].avatarFrameGifImg = bean.data![i].avatarFrameGifImg;
              listM[i].waveName = bean.data![i].waveName;
              listM[i].nobleID = bean.data![i].nobleID!;
              if (i == 0) {
                m1 = bean.data![0].uid == 0 ? false : true;
              } else if (i == 1) {
                m2 = bean.data![1].uid == 0 ? false : true;
              } else if (i == 2) {
                m3 = bean.data![2].uid == 0 ? false : true;
              } else if (i == 3) {
                m4 = bean.data![3].uid == 0 ? false : true;
              } else if (i == 4) {
                m5 = bean.data![4].uid == 0 ? false : true;
              } else if (i == 5) {
                m6 = bean.data![5].uid == 0 ? false : true;
              } else if (i == 6) {
                m7 = bean.data![6].uid == 0 ? false : true;
              } else if (i == 7) {
                m8 = bean.data![7].uid == 0 ? false : true;
              } else if (i == 8) {
                m0 = bean.data![8].uid == 0 ? false : true;
              }
              if (sp.getString('user_id').toString() ==
                  bean.data![i].uid.toString()) {
                if (bean.data![i].isClose == 0) {
                  // 启用音频模块
                  _engine!.enableAudio();
                  // 发声音发音频流
                  _engine!.enableLocalAudio(true);
                  //设置成主播
                  _engine!.setClientRole(
                      role: ClientRoleType.clientRoleBroadcaster);
                  // 发布本地音频流
                  _engine!.muteLocalAudioStream(false);
                }
                isMeUp = true;
                mxIndex = bean.data![i].serialNumber.toString();
              }
            }
          });
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
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  ///上麦下麦刷新使用
  Future<void> doPostRoomMikeInfo() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomId,
    };
    try {
      maiXuBean bean = await DataUtils.postRoomMikeInfo(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            // 判断麦上有没有自己
            for (int i = 0; i < bean.data!.length; i++) {
              listM[i].id = bean.data![i].id;
              listM[i].uid = bean.data![i].uid;
              listM[i].roomId = bean.data![i].roomId;
              listM[i].serialNumber = bean.data![i].serialNumber;
              listM[i].isBoss = bean.data![i].isBoss;
              listM[i].isLock = bean.data![i].isLock;
              listM[i].isClose = bean.data![i].isClose;
              listM[i].nickname = bean.data![i].nickname;
              listM[i].avatar = bean.data![i].avatar;
              listM[i].charm = bean.data![i].charm;
              listM[i].identity = bean.data![i].identity;
              listM[i].waveImg = bean.data![i].waveImg;
              listM[i].waveGifImg = bean.data![i].waveGifImg;
              listM[i].avatarFrameImg = bean.data![i].avatarFrameImg;
              listM[i].avatarFrameGifImg = bean.data![i].avatarFrameGifImg;
              if (i == 0) {
                m1 = bean.data![0].uid == 0 ? false : true;
              } else if (i == 1) {
                m2 = bean.data![1].uid == 0 ? false : true;
              } else if (i == 2) {
                m3 = bean.data![2].uid == 0 ? false : true;
              } else if (i == 3) {
                m4 = bean.data![3].uid == 0 ? false : true;
              } else if (i == 4) {
                m5 = bean.data![4].uid == 0 ? false : true;
              } else if (i == 5) {
                m6 = bean.data![5].uid == 0 ? false : true;
              } else if (i == 6) {
                m7 = bean.data![6].uid == 0 ? false : true;
              } else if (i == 7) {
                m8 = bean.data![7].uid == 0 ? false : true;
              } else if (i == 8) {
                m0 = bean.data![8].uid == 0 ? false : true;
              }
              if (sp.getString('user_id').toString() ==
                  bean.data![i].uid.toString()) {
                isMeUp = true;
                // 启用音频模块
                _engine!.enableAudio();
                //设置成主播
                _engine!
                    .setClientRole(role: ClientRoleType.clientRoleBroadcaster);
                // 取消发布本地音频流
                _engine!.muteLocalAudioStream(true);
              }
            }

            if (isMeUp == false) {
              // 设置成观众
              _engine!.setClientRole(role: ClientRoleType.clientRoleAudience);
              // 取消发布本地音频流
              _engine!.muteLocalAudioStream(true);
              // 静音
            }
          });
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
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
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
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
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
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 闭麦/开麦
  Future<void> doPostSetClose(String serial_number, String status) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomId,
      'serial_number': int.parse(serial_number) + 1,
      'uid': '0',
      'status': status
    };
    try {
      CommonBean bean = await DataUtils.postSetClose(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (status == 'no') {
              isJinyiin = true;
              MyToastUtils.showToastBottom('已闭麦');
              // 取消发布本地音频流
              _engine!.muteLocalAudioStream(true);
            } else {
              isJinyiin = false;
              MyToastUtils.showToastBottom('已开麦');
              // 启用音频模块
              _engine!.enableAudio();
              // 发声音发音频流
              _engine!.enableLocalAudio(true);
              //设置成主播
              _engine!
                  .setClientRole(role: ClientRoleType.clientRoleBroadcaster);
              // 发布本地音频流
              _engine!.muteLocalAudioStream(false);
            }
          });
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
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
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
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
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
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 离开房间
  Future<void> doPostLeave() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomId,
    };
    try {
      CommonBean bean = await DataUtils.postLeave(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
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
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 获取系统消息
  List<Map<String, dynamic>> listMessage = [];
  bool isRed = false;

  Future<void> doPostSystemMsgList() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;

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
        'SELECT * FROM messageSLTable WHERE id IN ($placeholders) and uid = ${sp.getString('user_id').toString()}  order by add_time desc';
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
      // 更新头像和昵称
      await db.update(
          'messageSLTable',
          {
            'headNetImg': sp.getString('user_headimg').toString(),
          },
          whereArgs: [listMessage[i]['uid']],
          where: 'uid = ?');
      String query =
          "SELECT * FROM messageSLTable WHERE  combineID = '${listMessage[i]['combineID']}' and readStatus = 0";
      List<Map<String, dynamic>> result3 = await db.rawQuery(query);
      if (result3.isNotEmpty) {
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
  }

  // 自己头像和他人头像
  String myHeadImg = '', otherHeadImg = '';

  saveImages(charmAllBean cb) async {
    // 一键赠送人是自己
    if (cb.fromUid.toString() == sp.getString('user_id').toString()) {
      //保存头像
      MyUtils.saveImgTemp(sp.getString('user_headimg').toString(),
          sp.getString('user_id').toString());
      MyUtils.saveImgTemp(cb.avatar!, cb.toUids!);
      // 保存路径
      Directory? directory = await getTemporaryDirectory();
      //保存自己头像
      if (sp.getString('user_headimg').toString().contains('.gif') ||
          sp.getString('user_headimg').toString().contains('.GIF')) {
        myHeadImg = '${directory!.path}/${sp.getString('user_id')}.gif';
      } else if (sp.getString('user_headimg').toString().contains('.jpg') ||
          sp.getString('user_headimg').toString().contains('.GPG')) {
        myHeadImg = '${directory!.path}/${sp.getString('user_id')}.jpg';
      } else if (sp.getString('user_headimg').toString().contains('.jpeg') ||
          sp.getString('user_headimg').toString().contains('.GPEG')) {
        myHeadImg = '${directory!.path}/${sp.getString('user_id')}.jpeg';
      } else {
        myHeadImg = '${directory!.path}/${sp.getString('user_id')}.png';
      }
      // 保存他人头像
      if (cb.avatar!.contains('.gif') || cb.avatar!.contains('.GIF')) {
        otherHeadImg = '${directory!.path}/${cb.toUids!}.gif';
      } else if (cb.avatar!.contains('.jpg') || cb.avatar!.contains('.GPG')) {
        otherHeadImg = '${directory!.path}/${cb.toUids!}.jpg';
      } else if (cb.avatar!.contains('.jpeg') || cb.avatar!.contains('.GPEG')) {
        otherHeadImg = '${directory!.path}/${cb.toUids!}.jpeg';
      } else {
        otherHeadImg = '${directory!.path}/${cb.toUids!}.png';
      }
      String infos = '';
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
      String zzMoney = (double.parse(cb.amount!) * 0.8).toStringAsFixed(2);
      String content =
          '我向你赠送了全部背包礼物：\n$infos\n总额为：${cb.amount!}*0.8=${zzMoney}金豆';
      //请求发消息的接口
      doPostSendUserMsg(content, cb);
    }
  }

  // 一键赠送背包礼物发送消息
  Future<void> doPostSendUserMsg(String content, charmAllBean cb) async {
    LogE('发送时间===${cb.toUids!}');
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    Map<String, dynamic> params = <String, dynamic>{
      'uid': cb.toUids!,
      'type': '1',
      'content': content
    };
    try {
      // CommonBean bean = await DataUtils.postSendUserMsg(params);
      CommonIntBean bean = await DataUtils.postCanSendUser(params);
      String combineID = '';
      if (int.parse(sp.getString('user_id').toString()) >
          int.parse(cb.toUids!)) {
        combineID = '${cb.toUids!}-${sp.getString('user_id').toString()}';
      } else {
        combineID = '${sp.getString('user_id').toString()}-${cb.toUids!}';
      }
      switch (bean.code) {
        case MyHttpConfig.successCode:
          final textMsg = EMMessage.createTxtSendMessage(
            targetId: cb.toUids!,
            content: content,
          );
          textMsg.attributes = {
            'nickname': sp.getString('nickname'),
            'avatar': sp.getString('user_headimg'),
            'weight': 50,
          };
          EMClient.getInstance.chatManager.sendMessage(textMsg);

          LogE('发送时间===${DateTime.now()}');
          Map<String, dynamic> params = <String, dynamic>{
            'uid': sp.getString('user_id').toString(),
            'otherUid': cb.toUids!,
            'whoUid': sp.getString('user_id').toString(),
            'combineID': combineID,
            'nickName': cb.toNickname,
            'content': content,
            'headNetImg': sp.getString('user_headimg').toString(),
            'otherHeadNetImg': cb.avatar!,
            'add_time': DateTime.now().millisecondsSinceEpoch,
            'type': 1,
            'number': 0,
            'status': 1,
            'readStatus': 1,
            'liveStatus': 0,
            'loginStatus': 0,
            'weight': cb.toUids!.toString() == '1' ? 1 : 0,
            'msgId': '',
            'msgRead': 2,
            'msgJson': textMsg.msgId,
          };
          // 插入数据
          await databaseHelper.insertData('messageSLTable', params);
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
      }
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  List<DataTJ> listPH = [];

  /// 厅内侧滑推荐房间
  Future<void> doPostShowRoomList() async {
    try {
      // Loading.show();
      roomTJBean bean = await DataUtils.postShowRoomList();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            if (bean.data!.isNotEmpty) {
              listPH.clear();
              listPH = bean.data!;
            }
          });
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
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 切换至后台，然后重新回到这个前台页面使用
  Future<void> doPostRoomUserMikeInfo() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomId,
    };
    try {
      userMaiInfoBean bean = await DataUtils.postRoomUserMikeInfo(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            LogE('状态=== ${bean.data!.uid}');
            if (bean.data!.uid != null) {
              if (sp.getString('user_id').toString() ==
                  bean.data!.uid.toString()) {
                try {
                  if (sp.getString('roomID').toString() ==
                      widget.roomId.toString()) {
                    final chatRoomId = sp.getString('chatRoomId').toString();
                    if (chatRoomId.isNotEmpty) {
                      EMClient.getInstance.chatRoomManager
                          .joinChatRoom(chatRoomId);
                    }
                  }
                } catch (e) {
                  LogE(e.toString());
                }
                isMeUp = true;
                mxIndex = bean.data!.serialNumber.toString();
                if (bean.data!.isClose == 0) {
                  //闭麦 0 否 1是
                  isMeStatus = true;
                  isJinyiin = false;
                  // 启用音频模块
                  _engine!.enableAudio();
                  // 发声音发音频流
                  _engine!.enableLocalAudio(false);
                  _engine!.enableLocalAudio(true);
                  //设置成主播
                  _engine!.setClientRole(
                      role: ClientRoleType.clientRoleBroadcaster);
                  // 发布本地音频流
                  _engine!.muteLocalAudioStream(false);
                } else {
                  isMeStatus = false;
                  isJinyiin = true;
                  // 启用音频模块
                  _engine!.enableAudio();
                  // 设置成观众
                  _engine!
                      .setClientRole(role: ClientRoleType.clientRoleAudience);
                  // 取消发布本地音频流
                  _engine!.muteLocalAudioStream(true);
                  // 适用只听声音，不发声音流
                  _engine!.enableLocalAudio(true);
                  _engine!.enableLocalAudio(false);
                }
              }
            }
            if(sp.getString('roomAudio').toString() == 'null' || sp.getString('roomAudio').toString().isEmpty){
              sp.setString('roomAudio', '1');
            }else{
              setState(() {
                if(sp.getString('roomAudio').toString() == '0'){
                  //取消订阅所有远端用户的音频流。
                  _engine!.muteAllRemoteAudioStreams(true);
                }else{
                  //开启订阅所有远端用户的音频流。
                  _engine!.muteAllRemoteAudioStreams(false);
                }
              });
            }
          });
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
    if (sp.getString('roomID') == null ||
        sp.getString('roomID').toString().isEmpty) {
      return;
      return;
    } else {
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
      Loading.show2();
      joinRoomBean bean = await DataUtils.postBeforeJoin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          doPostRoomJoin(roomID, '', bean.data!.rtc!);
          break;
        case MyHttpConfig.errorRoomCode: //需要密码
          MyToastUtils.showToastBottom('此房间已被密码锁定');
          // // ignore: use_build_context_synchronously
          // MyUtils.goTransparentPageCom(
          //     context,
          //     RoomTSMiMaPage(
          //         roomID: roomID, roomToken: bean.data!.rtc!, anchorUid: ''));
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
  Future<void> doPostRoomJoin(roomID, password, roomToken) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
      'password': password
    };
    try {
      Loading.show2();
      CommonBean bean = await DataUtils.postRoomJoin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          //取消订阅所有远端用户的音频流。
          _engine!.muteAllRemoteAudioStreams(true);
          // 取消发布本地音频流
          _engine!.muteLocalAudioStream(true);
          _engine!.disableAudio();
          await _dispose();
          // 清空存储信息
          deleteChatInfo();
          deleteGifInfo();
          // ignore: use_build_context_synchronously
          Navigator.pop(context);
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

  /// 保存本房间消息
  Future<void> saveChatInfo(Map<dynamic, dynamic> map, String type,
      String chatInfos, String contenInfo, String uid) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    Map<String, dynamic> params = <String, dynamic>{
      'roomID': widget.roomId,
      'info': chatInfos,
      'uid': uid,
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
      'newLv': map!['gr_lv'].toString(),
      'bubble_img': map!['bubble_img'].toString(),
      'by1': '',
      'by2': '',
      'by3': '',
    };
    // 插入数据
    await databaseHelper.insertData('roomInfoTable', params);
  }

  /// 查询本房间消息
  Future<void> searchChatInfo() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    // 获取所有数据
    List<Map<String, dynamic>> allData =
        await databaseHelper.getAllData('roomInfoTable');
    if (allData.isNotEmpty) {
      setState(() {
        list.addAll(allData); // 使用addAll一次性添加所有数据
        scrollToEnd();
      });
    }
  }

  void scrollToEnd() {
    try {
      if (list.isNotEmpty) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
        );
      }
    } catch (e) {
      LogE(e.toString());
    }
  }

  /// 保存本房间送礼
  Future<void> saveGiftInfo(
    String headImage,
    String uid,
    String nickeName,
    String otherNickName,
    String otherUid,
    String giftImage,
    String number,
    String giftName,
    String price,
  ) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    Map<String, dynamic> params = <String, dynamic>{
      'roomID': widget.roomId,
      'headImage': headImage,
      'uid': uid,
      'nickeName': nickeName,
      'otherNickName': otherNickName,
      'otherUid': otherUid,
      'giftImage': giftImage,
      'number': number,
      'giftName': giftName,
      'price': price,
      'sum': (int.parse(price) * int.parse(number)).toString(),
      'by1': '',
      'by2': '',
      'by3': '',
    };
    // 插入数据
    await databaseHelper.insertData('roomGiftTable', params);
  }

  /// 删除本房间消息本房间消息
  Future<void> deleteChatInfo() async {
    LogE('清空表数据');
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    //删除
    db.delete('roomInfoTable');
    // 防止用户被顶号时没有清空表
    if (sp.getString('sqRoomID').toString().isNotEmpty) {
      sp.setString('sqRoomID', '');
    }
  }

  /// 删除本房间消息本房间送礼信息消息
  Future<void> deleteGifInfo() async {
    LogE('清空表数据');
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    //删除
    db.delete('roomGiftTable');
  }

  /// 查询本房间是否有送礼物信息
  Future<void> searchHaveGiftInfo() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    // 获取所有数据
    // 执行查询操作
    String queryM = 'select * from roomGiftTable order by id desc';
    List<Map<String, dynamic>>? result = await db.rawQuery(queryM);
    if (result.isNotEmpty) {
      setState(() {
        giftName = result[0]['giftName'];
        nickName = result[0]['nickeName'];
        otherNickName = result[0]['otherNickName'];
      });
    }
  }

  /// 爆灯
  Future<void> doPostBurstLight(String serial_number) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomId,
      'serial_number': serial_number,
    };
    try {
      CommonBean bean = await DataUtils.postBurstLight(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {});
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

  /// 提前结束pk
  Future<void> dopPostAheadOver() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomId,
    };
    try {
      CommonBean bean = await DataUtils.postAheadOver(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {});
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

  /// 提前结束惩罚
  Future<void> doPostAheadPunish() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': widget.roomId,
    };
    try {
      CommonBean bean = await DataUtils.postAheadPunish(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {});
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

  Widget _lunbotu() {
    final hasGame = (sp.getInt('user_grLevel')! >= 4);
    final isSc = sp.getString('scIsOk').toString() == '1';
    final list1 = [
      if (!isSc)
        {"url": "assets/svga/gp/l_sc.svga", "type": "svga", "content": "sc"},
      {
        "url": "assets/images/room_play_banner.png",
        "type": "image",
        "content": "wf"
      },
    ];
    final list2 = [
      {"url": "assets/svga/gp/l_zp.svga"},
      {"url": "assets/svga/mofang_jin_show.svga"},
      {"url": "assets/svga/gp/l_maliao.svga"},
    ];
    return Expanded(
      child: Transform.translate(
        offset: Offset(0, -180.h),
        child: Container(
          width: double.infinity,
          color: Colors.transparent,
          child: Stack(
            children: [
              RoomItems.lunbotu1(context, list1),
              if (hasGame) RoomItems.lunbotu2(context, list2, widget.roomId),
            ],
          ),
        ),
      ),
    );
  }

  Widget _itemOtherRoom(BuildContext context, int i){
    return Container(
      height: 90.h,
      width: 100.h,
      color: Colors.transparent,
      child: Column(
        children: [
          WidgetUtils.showImages('assets/images/room_mai.png', 50.h, 50.h),
          WidgetUtils.onlyTextCenter(
              '${(i+1)}号麦',
              StyleUtils.getCommonTextStyle(
                  color: MyColors.roomMaiWZ,
                  fontSize: ScreenUtil().setSp(14)))
        ],
      ),
    );
  }

  // 展开房间
  Widget zkPeople(int i){
    return Row(
      children: [
        const Spacer(),
        Container(
          height: 90.h,
          width: 50.h,
          color: Colors.transparent,
          child: Column(
            children: [
              WidgetUtils.showImages('assets/images/room_mai.png', 50.h, 50.h),
              WidgetUtils.onlyTextCenter(
                  '${(i+1)}号麦',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.roomMaiWZ,
                      fontSize: ScreenUtil().setSp(14)))
            ],
          ),
        ),
        const Spacer(),
        Container(
          height: 90.h,
          width: 50.h,
          color: Colors.transparent,
          child: Column(
            children: [
              WidgetUtils.showImages('assets/images/room_mai.png', 50.h, 50.h),
              WidgetUtils.onlyTextCenter(
                  '${(i+2)}号麦',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.roomMaiWZ,
                      fontSize: ScreenUtil().setSp(14)))
            ],
          ),
        ),
        const Spacer(),
        Container(
          height: 90.h,
          width: 50.h,
          color: Colors.transparent,
          child: Column(
            children: [
              WidgetUtils.showImages('assets/images/room_mai.png', 50.h, 50.h),
              WidgetUtils.onlyTextCenter(
                  '${(i+2)}号麦',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.roomMaiWZ,
                      fontSize: ScreenUtil().setSp(14)))
            ],
          ),
        ),
        const Spacer(),
        Container(
          height: 90.h,
          width: 50.h,
          color: Colors.transparent,
          child: Column(
            children: [
              WidgetUtils.showImages('assets/images/room_mai.png', 50.h, 50.h),
              WidgetUtils.onlyTextCenter(
                  '${(i+2)}号麦',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.roomMaiWZ,
                      fontSize: ScreenUtil().setSp(14)))
            ],
          ),
        ),
        const Spacer(),
      ],
    );
  }
}
