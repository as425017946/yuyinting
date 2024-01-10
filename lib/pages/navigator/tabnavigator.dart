import 'dart:async';
import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/pages/message/message_page.dart';
import 'package:yuyinting/pages/trends/trends_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/widget/SVGASimpleImage.dart';
import '../../bean/Common_bean.dart';
import '../../bean/hengFuBean.dart';
import '../../bean/joinRoomBean.dart';
import '../../colors/my_colors.dart';
import '../../config/my_config.dart';
import '../../db/DatabaseHelper.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/SlideAnimationController.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/widget_utils.dart';
import '../gongping/gp_hi_page.dart';
import '../home/home_items.dart';
import '../home/home_page.dart';
import '../mine/mine_page.dart';
import '../room/room_page.dart';
import '../room/room_ts_mima_page.dart';

class Tab_Navigator extends StatefulWidget {
  const Tab_Navigator({Key? key}) : super(key: key);

  @override
  State<Tab_Navigator> createState() => _Tab_NavigatorState();
}

class _Tab_NavigatorState extends State<Tab_Navigator>
    with TickerProviderStateMixin {
  final _defaultColor = MyColors.btn_d;
  final _activetColor = MyColors.btn_a;
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

  /// 会重复播放的控制器
  late AnimationController _repeatController;

  /// 线性动画
  late Animation<double> _animation;

  /// 公屏使用
  late SlideAnimationController slideAnimationController;
  String path = ''; // 图片地址
  String name = ''; // 要展示公屏的名称
  bool isShowHF = false; // 是否显示横幅
  String msg = ''; // 拼接显示数据
  List<hengFuBean> listMP = []; // 存放每个进来的公屏，按顺序播放
  late hengFuBean myhf; //出现第一个横幅使用
  ///爆出大礼物使用
  bool isBig = false;
  int bigType = 0; //大礼物默认是爆出 0爆出1送出

  var listen, listenZdy, listenRoomBack, listenMessage, listenZDY,listenShouQi;
  bool isSDKInit = false;

  @override
  void initState() {
    MyUtils.initSDK();
    MyUtils.addChatListener();
    //先退出然后在登录
    MyUtils.signOutLogin();

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
      if (event.map!['type'] == 'send_all_user') {
        hengFuBean hf = hengFuBean.fromJson(event.map!);
        myhf = hf;
        if (listMP.isEmpty) {
          //显示横幅、map赋值
          setState(() {
            isShowHF = true;
            listMP.add(hf);
          });
          // 判断数据显示使用
          showInfo(hf);
        } else {
          setState(() {
            listMP.add(hf);
          });
        }
        // 看看集合里面有几个，10s一执行
        hpTimer();
      }
    });
    // 收起房间使用
    listenRoomBack = eventBus.on<SubmitButtonBack>().listen((event) {
      if (event.title == '收起房间') {
        setState(() {
          isJoinRoom = true;
        });
      }else if(event.title == '加入其他房间'){
        // 判断加入过其他房间，并且现在是收起的状态
        if(isJoinRoom){
          setState(() {
            isJoinRoom = false;
            // 取消发布本地音频流
            _engine.muteLocalAudioStream(true);
            _engine.disableAudio();
            _dispose();
            // 调用离开房间接口
            doPostLeave();
          });

        }
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
      }
    });

    //收起房间后加入了其他房间
    listenShouQi = eventBus.on<shouqiRoomBack>().listen((event) {
      if(event.title == '收起房间'){
        _engine = event.engine;
      }
    });
  }

  late RtcEngine _engine;
  //初始化
  void initE() async{
    // 创建 RtcEngine
    _engine = await createAgoraRtcEngine();
  }

  Future<void> _dispose() async {
    await _engine.leaveChannel(); // 离开频道
    await _engine.release(); // 释放资源
  }


  Timer? _timer;

  // 18秒后请求一遍
  void hpTimer() {
    _timer = Timer.periodic(const Duration(seconds: 18), (timer) {
      if (listMP.isNotEmpty) {
        setState(() {
          listMP.removeAt(0);
        });
        if (listMP.isEmpty) {
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
          isBig = true;
          isShowHF = false;
          bigType = 0;
        });
        break;
      case '送出388800转盘礼物':
        setState(() {
          isBig = true;
          isShowHF = false;
          bigType = 1;
        });
        break;
    }
    // 在页面中使用自定义时间和图片地址
    slideAnimationController = SlideAnimationController(
      vsync: this,
      duration: const Duration(seconds: 15), // 自定义时间
    );
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      slideAnimationController.playAnimation();
    });
  }

  @override
  void dispose() {
    _repeatController.dispose();
    slideAnimationController.dispose();
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
                currentIndex: _currentIndex,
                onTap: (index) {
                  _controller.jumpToPage(index);
                  setState(() {
                    _currentIndex = index;
                  });
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
                  bottom: 70.h,
                  right: 295.w,
                  child: Container(
                    width: 15.h,
                    height: 15.h,
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
                  slideAnimationController.controller,
                  slideAnimationController.animation,
                  name,
                  myhf)
              : const Text(''),

          /// 爆出5w2的礼物推送使用
          isBig ? HomeItems.itemBig(myhf, bigType) : const Text(''),

          /// 房间图标转动
          isJoinRoom
              ? Positioned(
                  bottom: 160,
                  right: 20,
                  child: GestureDetector(
                    onTap: (() {
                      doPostBeforeJoin(sp.getString('roomID'));
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
                          isJoinRoom = true;
                        });
                        return true;
                      },
                      // 当一条可接受的数据被拖放到这个拖动目标上时调用
                      onAccept: (data) {
                        setState(() {
                          _dispose();
                          // 调用离开房间接口
                          doPostLeave();
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
    if(sp.getString('roomID') == null || sp.getString('').toString().isEmpty){
    }else{
      // 不是空的，并且不是之前进入的房间
      if(sp.getString('roomID').toString() != roomID){
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
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
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
          setState(() {
            isJoinRoom = false;
          });
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
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 获取系统消息
  List<Map<String, dynamic>> listMessage = [];
  bool isRed = false;

  Future<void> doPostSystemMsgList() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    try {
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }


  /// 离开房间下麦
  Future<void> doPostLeave() async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': sp.getString('roomID'),
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
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

}
