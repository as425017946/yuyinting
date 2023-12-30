import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yuyinting/config/my_config.dart';
import 'package:yuyinting/pages/room/room_back_page.dart';
import 'package:yuyinting/pages/room/room_bq_page.dart';
import 'package:yuyinting/pages/room/room_send_info_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import '../../bean/CommonMyIntBean.dart';
import '../../bean/Common_bean.dart';
import '../../bean/charmAllBean.dart';
import '../../bean/hengFuBean.dart';
import '../../bean/roomInfoBean.dart';
import '../../bean/zjgpBean.dart';
import '../../colors/my_colors.dart';
import '../../db/DatabaseHelper.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/SlideAnimationController.dart';
import '../../utils/log_util.dart';
import '../../widget/Marquee.dart';
import '../../widget/SVGASimpleImage.dart';
import '../../widget/SVGASimpleImage3.dart';
import '../../widget/SVGASimpleImage4.dart';
import '../../widget/SVGASimpleImage5.dart';
import '../../widget/SVGASimpleImage6.dart';
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
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin {
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
      listenZdy,
      listenSGJ;

  // 是否展示礼物动效
  bool isLWShow = false;

  /// 声网使用
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool isShow = false;
  late final Gradient gradient;
  FocusNode? _focusNode;

  // 判断自己是不是在麦上使用
  bool isMeUp = false;

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
  String name = ''; // 要展示公屏的名称
  bool isShowHF = false; // 是否显示横幅
  String msg = ''; // 拼接显示数据
  Map<String, String>? map; //存放接收自定义的数据使用
  List<hengFuBean> listMP = []; // 存放每个进来的公屏，按顺序播放
  late hengFuBean myhf; //出现第一个横幅使用
  ///爆出大礼物使用
  bool isBig = false;
  int bigType = 0;//大礼物默认是爆出 0爆出1送出

  // 送礼物显示SVGA
  bool isShowSVGA = false;

  // 是否贵族进场
  bool isGuZu = false;
  String tequanzhuangban = '';

  // 赠送全部礼物使用
  List<String> listurl = [];
  var listenSVGA, listenSVGAOK, listenGZOK,listenMessage;

  // 每2分钟请求一下热度接口
  Timer? _timerHot;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //页面渲染完成
    WidgetsBinding.instance!.addPostFrameCallback((_) {
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
      //初始化声网的音频插件
      initAgora();
      //初始化声卡采集
      if (Platform.isWindows || Platform.isMacOS) {
        starSK();
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
        } else if (event.title == '老板位0') {
          setState(() {
            isBoss = false;
          });
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
        } else if (event.title == '房间声音已开启') {
          setState(() {
            roomSY = true;
            //默认订阅所有远端用户的音频流。
            _engine.muteAllRemoteAudioStreams(false);
          });
        } else if (event.title == '房间声音已关闭') {
          setState(() {
            roomSY = false;
            //取消订阅所有远端用户的音频流。
            _engine.muteAllRemoteAudioStreams(true);
          });
        } else if (event.title.contains('退出房间')) {
          LogE('退出房间 ==  ${event.title}');
          // 调用离开房间接口
          doPostLeave();
          List<String> listD = event.title.split(',');
          if (listD[1] == widget.roomId) {
            if (_timerHot != null) {
              _timerHot!.cancel();
            }
            Navigator.pop(context);
          }
        } else if (event.title == '收起房间') {
          if (_timerHot != null) {
            _timerHot!.cancel();
          }
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
          LogE('我的身份 1==$noble_id');
          LogE('我的身份 2==$_timeCount');
          LogE('我的身份 3==$isForbation');
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
        }else if (event.title == '清空红点') {
          LogE('清空');
          setState(() {
            isRed = false;
          });
        }
      });
      // 厅内操作监听
      listenRoomback = eventBus.on<RoomBack>().listen((event) {
        switch (event.title) {
          case '关闭声音':
            setState(() {
              isJinyiin = !isJinyiin;
              // 自己上麦了
              if (isMeUp) {
                //点击了静音
                if (isJinyiin) {
                  // // 通过此方法设置为观众
                  _engine.setClientRole(
                      role: ClientRoleType.clientRoleAudience);
                } else {
                  // 设置成主播
                  _engine.setClientRole(
                      role: ClientRoleType.clientRoleBroadcaster);
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
              // 取消发布本地音频流
              _engine.muteLocalAudioStream(true);
              listM[int.parse(event.index!)].isClose = 1;
              for (int i = 0; i < 9; i++) {
                upOrDown[i] = false;
              }
            });
            break;
          case '开麦':
            setState(() {
              // 开启发布本地音频流
              _engine.muteLocalAudioStream(false);
              listM[int.parse(event.index!)].isClose = 0;
              for (int i = 0; i < 9; i++) {
                upOrDown[i] = false;
              }
            });
            break;
          case '闭麦1':
            setState(() {
              // 取消发布本地音频流
              _engine.muteLocalAudioStream(true);
              listM[int.parse(event.index!)].isClose = 1;
              for (int i = 0; i < 9; i++) {
                upOrDown[i] = false;
              }
            });
            doPostSetClose(event.index!, 'no');
            break;
          case '开麦1':
            setState(() {
              // 开启发布本地音频流
              _engine.muteLocalAudioStream(false);
              listM[int.parse(event.index!)].isClose = 0;
              for (int i = 0; i < 9; i++) {
                upOrDown[i] = false;
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
            }
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
            case 'room_forbation': //禁言
              //判断被禁言的人是不是自己
              if (event.map!['uid'].toString() == sp.getString('user_id')) {
                setState(() {
                  isForbation = 1;
                });
              }
              break;
            case 'cancel_room_forbation': //取消禁言
              //判断被取消禁言的人是不是自己
              if (event.map!['uid'].toString() == sp.getString('user_id')) {
                setState(() {
                  isForbation = 0;
                });
              }
              break;
            case 'room_black': //设置黑名单
            //判断被拉黑的人是不是自己
              if (event.map!['uid'].toString() == sp.getString('user_id')) {
                MyToastUtils.showToastBottom('你已被房间设置为黑名单用户！');
                if (_timerHot != null) {
                  _timerHot!.cancel();
                }
                Navigator.pop(context);
              }
              break;
            case 'room_admin': //设置管理员
            //判断被设置管理员的人是不是自己
              if (event.map!['uid'].toString() == sp.getString('user_id')) {
                MyToastUtils.showToastBottom('您已被提升为本房间的管理员身份！');
                role = 'adminer';
                sp.setString('role', 'adminer');
              }
              break;
            case 'cancel_room_admin': //取消管理员
            //判断被取消管理员的人是不是自己
              if (event.map!['uid'].toString() == sp.getString('user_id')) {
                MyToastUtils.showToastBottom('您已被取消本房间的管理员身份！');
                role = 'adminer';
                sp.setString('role', 'adminer');
              }
              break;
          }
        }
      });
      // 加入房间监听
      listJoin = eventBus.on<JoinRoomYBack>().listen((event) {
        LogE('哪个厅 = ${event.map!['room_id'].toString() == widget.roomId}');
        LogE('哪个厅** ${event.map!['type']}');
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
          } else if (event.map!['type'] == 'clean_charm') {
            // 清除魅力值
            setState(() {
              for (int i = 0; i < listM.length; i++) {
                listM[i].charm = 0;
              }
            });
          } else if (event.map!['type'] == 'clean_public_screen') {
            // 清除公屏
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
          } else if (event.map!['type'] == 'send_gift') {
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
            //厅内发送的送礼物消息
            Map<dynamic, dynamic> map = {};
            map['info'] = event.map!['nickname'];
            map['uid'] = event.map!['from_uid'];
            map['type'] = '5';
            // 发送的信息
            map['content'] =
                '${event.map!['from_nickname']};向;${event.map!['to_nickname']};送出${cb.giftInfo![0].giftName!}(${cb.giftInfo![0].giftPrice.toString()}); x${cb.giftInfo![0].giftNumber.toString()}';
            setState(() {
              list.add(map);
              // 判断如果不是自己，则可以加入播放队列
              if (event.map!['from_uid'].toString() !=
                  sp.getString('user_id')) {
                // 这个是为了让别人也能看见自己送出的礼物
                listurl.add(cb.giftInfo![0].giftImg!);
                Future.delayed(const Duration(milliseconds: 200),((){
                  isShowSVGA = true;
                }));
              }
            });
          } else if (event.map!['type'] == 'one_click_gift') {
            //赠送全部背包礼物
            String infos = ''; // 这个是拼接用户送的礼物信息使用
            charmAllBean cb = charmAllBean.fromJson(event.map);
            //判断一键赠送给的谁加入本地数据库里面
            saveImages(cb);
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
                // 判断如果不是自己，则可以加入播放队列
                if (event.map!['from_uid'].toString() !=
                    sp.getString('user_id').toString()) {
                  // 这个是为了让别人也能看见自己送出的礼物
                  listurl.add(cb.giftInfo![i].giftImg!);
                }
              });
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
              list.add(map);
              // 这个是为了让别人也能看见自己送出的礼物
              Future.delayed(const Duration(milliseconds: 200),((){
                isShowSVGA = true;
              }));
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
            // 跟随主播进入房间
            Map<dynamic, dynamic> map = {};
            map['type'] = '8';
            map['info'] = event.map!['nickname'];
            // 发送的信息
            map['content'] = event.map!['follow_info'];
            setState(() {
              list.add(map);
            });
          } else if (event.map!['type'] == 'play_win_gift') {
            // 厅内小礼物不在显示
          } else if (event.map!['type'] == 'send_screen_gift') {
            // 这个是本房间收到了在其他房间送出的3w8礼物
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
            map['content'] = '${cb.nickName};在${event.map!['room_name']}向;${event.map!['to_nickname']};送出;$info';
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
            //厅内发送的送礼物消息
            Map<dynamic, dynamic> map = {};
            map['info'] = event.map!['nickname'];
            map['uid'] = event.map!['uid'];
            map['type'] = '9';
            // 发送的信息
            map['content'] = '${cb.nickName};在;${cb.gameName};中赢得;$info';
            setState(() {
              list.add(map);
            });
          } else if (event.map!['type'] == 'send_all_user') {
            // 是这个厅，并送了带横幅的礼物不做操作
          } else {
            // 正常进入房间使用
            bool isHave = false;
            for (int i = 0; i < list.length; i++) {
              if (list[i]['type'] == '1') {
                setState(() {
                  isHave = true;
                });
              }
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
            LogE('特权== ${event.map!['noble_id']}');
            // if(event.map!['noble_id'].toString() != '0'){
            //   setState(() {
            //     isGuZu = true;
            //   });
            // }
            // 是否点击了欢迎 0未欢迎 1已欢迎
            map['isWelcome'] = '0';
            setState(() {
              list.add(map);
            });
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
            map['content'] = '${cb.nickName};在;${cb.gameName};中赢得;$info';
            setState(() {
              list.add(map);
            });

            WidgetsBinding.instance!.addPostFrameCallback((_) {
              scrollToLastItem(); // 在widget构建完成后滚动到底部
            });
          }else if (event.map!['type'] == 'send_screen_all') {
            // 厅内抽奖使用
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
            map['content'] = '${cb.fromNickname};向;${cb.toNickname};赠送了;$info';
            setState(() {
              list.add(map);
            });

            WidgetsBinding.instance!.addPostFrameCallback((_) {
              scrollToLastItem(); // 在widget构建完成后滚动到底部
            });
          } else if (event.map!['type'] == 'send_all_user') {
            // 厅内出现横幅使用
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
            map['content'] = '${cb.nickName};在${event.map!['room_name']}向;${event.map!['to_nickname']};送出;$info';
            setState(() {
              list.add(map);
            });
          }
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

      listenBig = eventBus.on<ResidentBack>().listen((event) {
        setState(() {
          isBig = false;
        });
      });

      // 在页面中使用自定义时间和图片地址
      slideAnimationController = SlideAnimationController(
        vsync: this,
        duration: const Duration(seconds: 30), // 自定义时间
      );
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        slideAnimationController.playAnimation();
      });

      // 接受播放礼物
      listenSVGA = eventBus.on<SVGABack>().listen((event) {
        // 赠送了全部
        if (event.isAll) {
          setState(() {
            // 虽然赠送了全部礼物，但是之前有人送了，还没结束
            if (listurl.isNotEmpty) {
              for (int i = 0; i < event.listurl.length; i++) {
                listurl.add(event.listurl[i]);
              }
            } else {
              listurl = event.listurl;
            }
            Future.delayed(const Duration(milliseconds: 200),((){
              isShowSVGA = true;
            }));
          });
        } else {
          setState(() {
            listurl.add(event.url);
            Future.delayed(const Duration(milliseconds: 200),((){
              isShowSVGA = true;
            }));
          });
        }
      });
      // svga礼物播放完成
      listenSVGAOK = eventBus.on<RoomSVGABack>().listen((event) {
        LogE('动画播放完成回调');
        LogE('动画播放完成回调 ${listurl.length}');
        // 隔0.5s后移除，在判断里面有没有剩余动画要播放
        Future.delayed(
            const Duration(
              milliseconds: 500,
            ), (() {
          setState(() {
            if (listurl.isNotEmpty) {
              listurl.removeAt(0);
              if (listurl.isEmpty) {
                isShowSVGA = false;
              }
            } else {
              isShowSVGA = false;
            }
          });
        }));
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
      _timerHot = Timer.periodic(const Duration(seconds: 60), (timer) {
        doPostHotDegree();
      });

      // 水果机播放完成
      listenSGJ = eventBus.on<RoomSGJBack>().listen((event) {
        if (event.isOK) {
          setState(() {
            list[event.index!]['isOk'] = 'true';
          });
        }
      });

      listenMessage = eventBus.on<SendMessageBack>().listen((event) {
        setState(() {
          isRed = true;
        });
        doPostSystemMsgList();
      });
    });
  }


  Timer? _timerhf;

  // 18秒后请求一遍
  void hpTimer() {
    _timerhf = Timer.periodic(const Duration(seconds: 18), (timer) {
      if(listMP.isNotEmpty) {
        setState(() {
          listMP.removeAt(0);
        });
        if (listMP.isEmpty) {
          _timerhf!.cancel();
        } else {
          setState(() {
            isShowHF = true;
          });
          // 判断数据显示使用
          showInfo(listMP[0]);
        }
      }else{
        _timerhf!.cancel();
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
      // // 在这里处理滚动事件
      // if (_scrollController.position.atEdge) {
      //   LogE('移动距离 == ${_scrollController.offset}');
      //   if (_scrollController.offset > 200) {
      //     for (int i = 0; i < list2.length; i++) {
      //       list[i]['isOk'] = 'true';
      //     }
      //   }
      // }
    });

    _scrollController2.animateTo(
      _scrollController2.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );

    _scrollController2.addListener(() {
      // 在这里处理滚动事件
      // if (_scrollController2.position.atEdge) {
      //   if (_scrollController2.position.pixels == 0) {
      //     // ListView已经滚动到顶部
      //     print('ListView已经滚动到顶部');
      //     for (int i = 0; i < list2.length; i++) {
      //       list2[i]['isOk'] = 'true';
      //     }
      //     // 执行你的操作
      //   } else {
      //     // ListView已经滚动到底部
      //     print('ListView已经滚动到底部');
      //     // 执行你的操作
      //     for (int i = 0; i < list2.length; i++) {
      //       list2[i]['isOk'] = 'true';
      //     }
      //   }
      // }
    });
  }

  @override
  void dispose() {
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
    listenBig.cancel();
    listenZdy.cancel();
    listenSVGA.cancel();
    listenGZOK.cancel();
    listenMessage.cancel();
    if (_timerHot != null) {
      _timerHot!.cancel();
    }
    listenSGJ.cancel();
    // TODO: implement dispose
    super.dispose();
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
          // 设置用户角色为主播
          // 如果要将用户角色设置为观众，则修改 clientRoleBroadcaster 为 clientRoleAudience
          clientRoleType: ClientRoleType.clientRoleAudience),
      uid: 0,
    );
    // // 通过此方法设置为观众
    // _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    _engine.enableLocalAudio(true);
    // 设置音质
    _engine.setAudioProfile(
        profile: AudioProfileType.audioProfileMusicHighQuality,
        scenario: AudioScenarioType.audioScenarioGameStreaming);
    // 开启降噪
    _engine.setAINSMode(
        enabled: true, mode: AudioAinsMode.ainsModeUltralowlatency);
    //默认订阅所有远端用户的音频流。
    _engine.muteAllRemoteAudioStreams(false);
  }

  /// 开启声卡
  Future<void> starSK() async {
    _engine.enableLoopbackRecording(enabled: true);
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
                  color: Colors.white,
                  child: Stack(
                    children: [
                      BgType == '1'
                          ? SizedBox(
                              height: double.infinity,
                              width: double.infinity,
                              child: WidgetUtils.showImagesNet(
                                  bgImage, double.infinity, double.infinity),
                            )
                          : BgType == '2'
                              ? (bgSVGA.contains('gif') ||
                                      bgSVGA.contains('GIF'))
                                  ? SizedBox(
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: WidgetUtils.showImagesNet(bgSVGA,
                                          double.infinity, double.infinity),
                                    )
                                  : SizedBox(
                                      height: double.infinity,
                                      width: double.infinity,
                                      child: SVGASimpleImage4(
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
                                  RoomItems.lunbotu2(
                                      context, imgList2, widget.roomId),
                                ],
                              ),
                            ),
                          ),

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
                              isRed),
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
                        bottom: 100.h,
                        child:

                            /// 消息列表最外层
                            SizedBox(
                          height: 590.h,
                          width: 420.h,
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
                                      child: WidgetUtils.showImages(
                                          leixing == 0
                                              ? 'assets/images/room_gp1.png'
                                              : 'assets/images/room_gp2.png',
                                          25.h,
                                          60.h),
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
                                      child: WidgetUtils.showImages(
                                          leixing == 1
                                              ? 'assets/images/room_lt1.png'
                                              : 'assets/images/room_lt2.png',
                                          25.h,
                                          60.h),
                                    ),
                                    WidgetUtils.commonSizedBox(0, 10),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: leixing == 0
                                      ? ListView.builder(
                                          padding: EdgeInsets.only(
                                            left: 20.h,
                                          ),
                                          itemBuilder: itemMessages,
                                          controller: _scrollController,
                                          itemCount: list.length,
                                        )
                                      : ListView.builder(
                                          padding: EdgeInsets.only(
                                            top: ScreenUtil().setHeight(10),
                                            left: 20.h,
                                          ),
                                          itemBuilder: itemMessages2,
                                          controller: _scrollController,
                                          itemCount: list2.length,
                                        ))
                            ],
                          ),
                        ),
                      ),

                      /// 公屏推送使用
                      isShowHF
                          ? HomeItems.itemAnimation(
                              path,
                              slideAnimationController.controller,
                              slideAnimationController.animation,
                              name,
                              myhf)
                          : const Text(''),

                      /// 爆出5w2的礼物横幅推送使用
                      isBig ? HomeItems.itemBig(myhf,bigType) : const Text(''),
                      (isShowSVGA == true && roomDX == true)
                          ? IgnorePointer(
                              ignoring: true,
                              child: SizedBox(
                                height: double.infinity,
                                width: double.infinity,
                                child: SVGASimpleImage5(
                                  resUrl: listurl[0],
                                ),
                              ),
                            )
                          : const Text(''),

                      /// 贵族进场动画
                      isGuZu
                          ? IgnorePointer(
                              ignoring: true,
                              child: SizedBox(
                                height: double.infinity,
                                width: double.infinity,
                                child: SVGASimpleImage6(
                                  resUrl: tequanzhuangban,
                                ),
                              ),
                            )
                          : const Text(''),
                    ],
                  ),
                ),
              )
            : Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black87,
              ),
        onWillPop: () async {
          //这里可以响应物理返回键
          MyUtils.goTransparentPageCom(
              context,
              RoomBackPage(
                roomID: widget.roomId,
              ));
          return false;
        },
      ),
    );
  }

  /// 房间信息
  Future<void> doPostRoomInfo() async {
    LogE('userToken ${sp.getString('user_id')}');
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
            // 如果身份变了
            if(sp.getString('user_identity').toString() != role){
              eventBus.fire(SubmitButtonBack(title: '更换了身份'));
              sp.setString('user_identity', role);
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

            // 判断麦上有没有自己
            for (int i = 0; i < bean.data!.roomInfo!.mikeList!.length; i++) {
              if (sp.getString('user_id').toString() ==
                  bean.data!.roomInfo!.mikeList![i].uid.toString()) {
                isMeUp = true;
                break;
              }
            }
            // 判断有没有座驾
            if (bean.data!.userInfo!.carDressGifImg!.isNotEmpty) {
              isGuZu = true;
              tequanzhuangban = bean.data!.userInfo!.carDressGifImg!;
            } else {
              isGuZu = false;
              tequanzhuangban = '';
            }

            // 有房间公告消息
            Map<dynamic, dynamic> mapg = {};
            mapg['info'] = notice;
            mapg['type'] = '1';
            list.add(mapg);
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
          setState(() {
            if (action == 'up') {
              // 设置成主播
              _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
            } else {
              // 设置成观众
              _engine.setClientRole(role: ClientRoleType.clientRoleAudience);
            }
          });
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
            // 判断麦上有没有自己
            for (int i = 0; i < bean.data!.roomInfo!.mikeList!.length; i++) {
              listM[i] = bean.data!.roomInfo!.mikeList![i];
              switch (i.toString()) {
                case '0':
                  m1 =
                      bean.data!.roomInfo!.mikeList![0].uid == 0 ? false : true;
                  break;
                case '1':
                  m2 =
                      bean.data!.roomInfo!.mikeList![1].uid == 0 ? false : true;
                  break;
                case '2':
                  m3 =
                      bean.data!.roomInfo!.mikeList![2].uid == 0 ? false : true;
                  break;
                case '3':
                  m4 =
                      bean.data!.roomInfo!.mikeList![3].uid == 0 ? false : true;
                  break;
                case '4':
                  m5 =
                      bean.data!.roomInfo!.mikeList![4].uid == 0 ? false : true;
                  break;
                case '5':
                  m6 =
                      bean.data!.roomInfo!.mikeList![5].uid == 0 ? false : true;
                  break;
                case '6':
                  m7 =
                      bean.data!.roomInfo!.mikeList![6].uid == 0 ? false : true;
                  break;
                case '7':
                  m8 =
                      bean.data!.roomInfo!.mikeList![7].uid == 0 ? false : true;
                  break;
                case '8':
                  m0 =
                      bean.data!.roomInfo!.mikeList![8].uid == 0 ? false : true;
                  break;
              }
              if (sp.getString('user_id').toString() ==
                  bean.data!.roomInfo!.mikeList![i].uid.toString()) {
                isMeUp = true;
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


  /// 厅内发消息
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
        'SELECT * FROM messageSLTable WHERE id IN ($placeholders) order by add_time desc';
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
    if(cb.fromUid.toString() == sp.getString('user_id').toString()){
      //保存头像
      MyUtils.saveImgTemp(sp.getString('user_headimg').toString(),
          sp.getString('user_id').toString());
      MyUtils.saveImgTemp(cb.avatar!, cb.toUids!);
      // 保存路径
      Directory? directory = await getTemporaryDirectory();
      //保存自己头像
      if (sp.getString('user_headimg').toString().contains('.gif') || sp.getString('user_headimg').toString().contains('.GIF')) {
        myHeadImg = '${directory!.path}/${sp.getString('user_id')}.gif';
      } else if (sp.getString('user_headimg').toString().contains('.jpg') ||
          sp.getString('user_headimg').toString().contains('.GPG')) {
        myHeadImg = '${directory!.path}/${sp.getString('user_id')}.gif';
      } else if (sp.getString('user_headimg').toString().contains('.jpeg') ||
          sp.getString('user_headimg').toString().contains('.GPEG')) {
        myHeadImg = '${directory!.path}/${sp.getString('user_id')}.jpeg';
      } else {
        myHeadImg = '${directory!.path}/${sp.getString('user_id')}.png';
      }
      // 保存他人头像
      if (cb.avatar!.contains('.gif') || cb.avatar!.contains('.GIF')) {
        otherHeadImg = '${directory!.path}/${cb.toUids!}.gif';
      } else if (cb.avatar!.contains('.jpg') ||
          cb.avatar!.contains('.GPG')) {
        otherHeadImg = '${directory!.path}/${cb.toUids!}.jpg';
      } else if (cb.avatar!.contains('.jpeg') ||
          cb.avatar!.contains('.GPEG')) {
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
      String content = '我向你赠送了全部背包礼物：\n$infos\n总额为：${cb.amount!}V豆';
      //请求发消息的接口
      doPostSendUserMsg(content,cb);
    }
  }
  // 一键赠送背包礼物发送消息
  Future<void> doPostSendUserMsg(String content,charmAllBean cb) async {
    LogE('发送时间===${cb.toUids!}');
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    Map<String, dynamic> params = <String, dynamic>{
      'uid': cb.toUids!,
      'type': '1',
      'content': content
    };
    try {
      CommonBean bean = await DataUtils.postSendUserMsg(params);
      String combineID = '';
      if (int.parse(sp.getString('user_id').toString()) >
          int.parse(cb.toUids!)) {
        combineID = '${cb.toUids!}-${sp.getString('user_id').toString()}';
      } else {
        combineID = '${sp.getString('user_id').toString()}-${cb.toUids!}';
      }
      switch (bean.code) {
        case MyHttpConfig.successCode:
          LogE('发送时间===${DateTime.now()}');
          Map<String, dynamic> params = <String, dynamic>{
            'uid': sp.getString('user_id').toString(),
            'otherUid': cb.toUids!,
            'whoUid': sp.getString('user_id').toString(),
            'combineID': combineID,
            'nickName': cb.avatar!,
            'content': content,
            'headImg': myHeadImg,
            'otherHeadImg': otherHeadImg,
            'add_time': DateTime.now().millisecondsSinceEpoch,
            'type': 1,
            'number': 0,
            'status': 1,
            'readStatus': 1,
            'liveStatus': 0,
            'loginStatus': 0,
          };
          // 插入数据
          await databaseHelper.insertData('messageSLTable', params);
          break;
        case MyHttpConfig.errorloginCode:
        // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
      }
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
