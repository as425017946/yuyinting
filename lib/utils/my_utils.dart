import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:pull_to_refresh_flutter3/pull_to_refresh_flutter3.dart';
import 'package:sqflite/sqflite.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import '../config/online_config.dart';
import '../db/DatabaseHelper.dart';
import '../main.dart';
import '../pages/login/login_page.dart';
import 'loading.dart';
import 'log_util.dart';
import 'my_toast_utils.dart';
import 'package:http/http.dart' as http;

class MyUtils {
  ///字符串比较,返回0相等，返回1不想等
  static int compare(String str1, String str2) {
    return Comparable.compare(str1, str2);
  }

  /// 防重复提交
  // ignore: prefer_typing_uninitialized_variables
  static var lastPopTime;

  static bool checkClick({int needTime = 1}) {
    if (lastPopTime == null ||
        DateTime.now().difference(lastPopTime) > Duration(seconds: needTime)) {
      lastPopTime = DateTime.now();
      return true;
    }
    return false;
  }

  ///禁止输入空格
  static const String regexFirstNotNull = r'^(\S){1}';

  ///手机正则验证
  static bool chinaPhoneNumber(String input) {
    if (input == null || input.isEmpty) return false;
    String regexPhoneNumber =
        "^1\\d{10}\$";
    return RegExp(regexPhoneNumber).hasMatch(input);
  }

  /// 检查邮箱格式
  static bool email(String input) {
    if (input == null || input.isEmpty) return false;
    // 邮箱正则
    String regexEmail = "^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*\$";
    return RegExp(regexEmail).hasMatch(input);
  }

  /// 点击任意位置关闭键盘
  static void hideKeyboard(BuildContext context) {
    FocusScopeNode currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus!.unfocus();
    }
  }

  // 校验身份证合法性
  static bool verifyCardId(String cardId) {
    const Map city = {
      11: "北京",
      12: "天津",
      13: "河北",
      14: "山西",
      15: "内蒙古",
      21: "辽宁",
      22: "吉林",
      23: "黑龙江 ",
      31: "上海",
      32: "江苏",
      33: "浙江",
      34: "安徽",
      35: "福建",
      36: "江西",
      37: "山东",
      41: "河南",
      42: "湖北 ",
      43: "湖南",
      44: "广东",
      45: "广西",
      46: "海南",
      50: "重庆",
      51: "四川",
      52: "贵州",
      53: "云南",
      54: "西藏 ",
      61: "陕西",
      62: "甘肃",
      63: "青海",
      64: "宁夏",
      65: "新疆",
      71: "台湾",
      81: "香港",
      82: "澳门",
      91: "国外 "
    };
    String tip = '';
    bool pass = true;

    RegExp cardReg = RegExp(
        r'^\d{6}(18|19|20)?\d{2}(0[1-9]|1[012])(0[1-9]|[12]\d|3[01])\d{3}(\d|X)$');
    if (cardId == null || cardId.isEmpty || !cardReg.hasMatch(cardId)) {
      tip = '身份证号格式错误';
      print(tip);
      pass = false;
      return pass;
    }
    if (city[int.parse(cardId.substring(0, 2))] == null) {
      tip = '地址编码错误';
      print(tip);
      pass = false;
      return pass;
    }
    // 18位身份证需要验证最后一位校验位，15位不检测了，现在也没15位的了
    if (cardId.length == 18) {
      List numList = cardId.split('');
      //∑(ai×Wi)(mod 11)
      //加权因子
      List factor = [7, 9, 10, 5, 8, 4, 2, 1, 6, 3, 7, 9, 10, 5, 8, 4, 2];
      //校验位
      List parity = [1, 0, 'X', 9, 8, 7, 6, 5, 4, 3, 2];
      int sum = 0;
      int ai = 0;
      int wi = 0;
      for (var i = 0; i < 17; i++) {
        ai = int.parse(numList[i]);
        wi = factor[i];
        sum += ai * wi;
      }
      var last = parity[sum % 11];
      if (parity[sum % 11].toString() != numList[17]) {
        tip = "校验位错误";
        print(tip);
        pass = false;
      }
    } else {
      tip = '身份证号不是18位';
      print(tip);
      pass = false;
    }
//  print('证件格式$pass');
    return pass;
  }

// 根据身份证号获取年龄
  static int getAgeFromCardId(String cardId) {
    bool isRight = verifyCardId(cardId);
    if (!isRight) {
      return 0;
    }
    int len = (cardId).length;
    String strBirthday = "";
    if (len == 18) {
      //处理18位的身份证号码从号码中得到生日和性别代码
      strBirthday =
          "${cardId.substring(6, 10)}-${cardId.substring(10, 12)}-${cardId.substring(12, 14)}";
    }
    if (len == 15) {
      strBirthday =
          "19${cardId.substring(6, 8)}-${cardId.substring(8, 10)}-${cardId.substring(10, 12)}";
    }
    int age = getAgeFromBirthday(strBirthday);
    return age;
  }

// 根据出生日期获取年龄
  static int getAgeFromBirthday(String strBirthday) {
    if (strBirthday == null || strBirthday.isEmpty) {
      print('生日错误');
      return 0;
    }
    DateTime birth = DateTime.parse(strBirthday);
    DateTime now = DateTime.now();

    int age = now.year - birth.year;
    //再考虑月、天的因素
    if (now.month < birth.month ||
        (now.month == birth.month && now.day < birth.day)) {
      age--;
    }
    return age;
  }

// 根据身份证获取性别
  static String getSexFromCardId(String cardId) {
    String sex = "";
    bool isRight = verifyCardId(cardId);
    if (!isRight) {
      return sex;
    }
    if (cardId.length == 18) {
      if (int.parse(cardId.substring(16, 17)) % 2 == 1) {
        sex = "男";
      } else {
        sex = "女";
      }
    }
    if (cardId.length == 15) {
      if (int.parse(cardId.substring(14, 15)) % 2 == 1) {
        sex = "男";
      } else {
        sex = "女";
      }
    }
    return sex;
  }

  ///跳转到登录页面
  static void jumpLogin(BuildContext context) {
    sp.setString('user_token', '');
    MyToastUtils.showToastBottom('登录超时，请重新登录！');
    Future.delayed(Duration.zero, () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        // ignore: unnecessary_null_comparison
        (route) => route == null,
      );
    });
  }

  /// 通用跳转到一个透明页面，从右到左滚出的方法
  static void goTransparentRFPage(BuildContext context, Widget page) {
    Future.delayed(const Duration(seconds: 0), () {
      Navigator.push(
        context,
        PageRouteBuilder(
          //自定义路由
          opaque: false,
          pageBuilder: (context, a, _) => page, //需要跳转的页面
          transitionsBuilder: (context, a, _, child) {
            const begin = Offset(1,
                0); //Offset是一个2D小部件，他将记录坐标轴的x,y前者为宽，后者为高 如果将begin =Offset(1,0)为从右到左 改为(0,1),效果则会变成从下到上
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
  }

  /// 通用跳转到一个透明页面，从底部向上滚出的方法
  static void goTransparentPage(BuildContext context, Widget page) {
    Future.delayed(const Duration(seconds: 0), () {
      Navigator.push(
        context,
        PageRouteBuilder(
          //自定义路由
          opaque: false,
          pageBuilder: (context, a, _) => page, //需要跳转的页面
          transitionsBuilder: (context, a, _, child) {
            const begin = Offset(0,
                1); //Offset是一个2D小部件，他将记录坐标轴的x,y前者为宽，后者为高 如果将begin =Offset(1,0)为从右到左 改为(0,1),效果则会变成从下到上
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
  }

  /// 通用跳转到一个透明页面
  static void goTransparentPageCom(BuildContext context, Widget page) {
    Future.delayed(const Duration(seconds: 0), () {
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, animation, secondaryAnimation) {
            return page;
          }));
    });
  }

  /// 这个是弹出有人跟你打招呼或者邀请你进入房间使用
  static void goTransparentPageRoom(BuildContext context, Widget page) {
    Future.delayed(const Duration(seconds: 0), () {
      Navigator.of(context).push(PageRouteBuilder(
          opaque: false,
          pageBuilder: (context, animation, secondaryAnimation) {
            return page;
          }));
    });
  }

  static Widget myHeader() {
    return CustomHeader(
      builder: (BuildContext context, RefreshStatus? mode) {
        Widget headerBody;
        if (mode == RefreshStatus.idle) {
          headerBody = const Text('下拉刷新');
        } else if (mode == RefreshStatus.refreshing) {
          // headerBody = Text('刷新中...');
          // headerBody = WidgetUtils.showImagesFill('assets/images/a1.gif',
          // ScreenUtil().setHeight(100), ScreenUtil().setHeight(100));
          headerBody =
              WidgetUtils.showImagesFill('assets/images/cy/GO.gif', 50, 50);
        } else if (mode == RefreshStatus.failed) {
          headerBody = const Text('刷新失败');
        } else if (mode == RefreshStatus.completed) {
          headerBody = const Text('刷新完成');
        } else if (mode == RefreshStatus.canRefresh) {
          headerBody = const Text('松手刷新');
        } else {
          headerBody = const Text("完成");
        }
        return SizedBox(
          // height: ScreenUtil().setHeight(100),
          height: 50,
          child: Center(child: headerBody),
        );
      },
    );
  }

  static Widget myFotter() {
    return CustomFooter(
      builder: (BuildContext context, LoadStatus? mode) {
        Widget body;
        if (mode == LoadStatus.idle) {
          body = const Text("上拉加载");
        } else if (mode == LoadStatus.loading) {
          body = const Text("加载中");
        } else if (mode == LoadStatus.failed) {
          body = const Text("加载更多失败");
        } else if (mode == LoadStatus.canLoading) {
          body = const Text("松手加载更多");
        } else {
          body = const Text("没有更多");
        }
        return SizedBox(
          height: ScreenUtil().setHeight(50),
          child: Center(child: body),
        );
      },
    );
  }

  // 保存网络图片到包下
  static void saveImg(String imgUrl, String name) async {
    if (await Permission.storage.request().isGranted) {
      var response = await Dio()
          .get(imgUrl, options: Options(responseType: ResponseType.bytes));
      // 生成新的文件名
      String fileName = "$name.jpg";

      // 获取保存路径
      Directory? directory = await getExternalStorageDirectory();
      String savePath = "${directory!.path}/$fileName";

      // 保存图片
      File file = File(savePath);
      await file.writeAsBytes(Uint8List.fromList(response.data));
      if (await file.exists()) {
        MyToastUtils.showToastBottom("下载成功");
        print("保存路径：$savePath");
      } else {
        MyToastUtils.showToastBottom("下载失败");
      }
    } else {
      MyToastUtils.showToastBottom("未获取存储权限");
    }
  }

  // 保存网络图片到相册额
  static void saveNetworkImageToGallery(String imageUrl) async {
    Loading.show('保存中...');
    try {
      var response = await http.get(Uri.parse(imageUrl));
      final result = await ImageGallerySaver.saveImage(
          Uint8List.fromList(response.bodyBytes));
      MyToastUtils.showToastBottom("保存成功");
      print("保存路径：$result");
    } finally {
      Loading.dismiss();
    }
  }

  static void saveLocalImageToGallery(String imageUrl) async {
    Loading.show('保存中...');
    try {
      final file = File(imageUrl);
      final Uint8List imgBytes = await file.readAsBytes();
      final result = await ImageGallerySaver.saveImage(imgBytes);
      MyToastUtils.showToastBottom("保存成功");
      print("保存路径：$result");
    } finally {
      Loading.dismiss();
    }
  }

  // 保存网络图片到缓存目录
  static void saveImgTemp(String imgUrl, String name) async {
    var response = await http.get(Uri.parse(imgUrl));
    // 生成新的文件名
    String fileName = '';
    if (imgUrl.contains('.gif') || imgUrl.contains('.GIF')) {
      fileName = "$name.gif";
    } else if (imgUrl.contains('.jpg') || imgUrl.contains('.GPG')) {
      fileName = "$name.jpg";
    } else if (imgUrl.contains('.jpeg') || imgUrl.contains('.GPEG')) {
      fileName = "$name.jpeg";
    } else {
      fileName = "$name.png";
    }
    // 获取保存路径
    var tempDir = await getTemporaryDirectory();
    String savePath = "${tempDir!.path}/$fileName";
    // 保存图片
    File file = File(savePath);
    await file.writeAsBytes(response.bodyBytes);
    if (await file.exists()) {
      // MyToastUtils.showToastBottom("下载成功");
    } else {
      // MyToastUtils.showToastBottom("下载失败");
    }
  }

  //初始化sdk
  static Future<void> initSDK() async {
    // // 本地测试环境
    // EMOptions options = EMOptions(
    //     appKey: "1199230605161000#demo",
    //     autoLogin: false,
    //     debugModel: true,
    //     isAutoDownloadThumbnail: true);
    // // 测试环境
    // EMOptions options = EMOptions(
    //     appKey: "1129240201157233#demo",
    //     autoLogin: false,
    //     debugModel: true,
    //     isAutoDownloadThumbnail: true);
    // 正式环境
    // EMOptions options = EMOptions(
    //     appKey: "1129240201157233#cc",
    //     autoLogin: false,
    //     debugModel: true,
    //     isAutoDownloadThumbnail: true);
    // EMOptions options = EMOptions(
    //     appKey: "1109240124169584#777",
    //     autoLogin: false,
    //     debugModel: true,
    //     isAutoDownloadThumbnail: true);
    EMOptions options = OnlineConfig.getEMOptions();
    await EMClient.getInstance.init(options);
    // 通知 SDK UI 已准备好。该方法执行后才会收到 `EMChatRoomEventHandler`、`EMContactEventHandler` 和 `EMGroupEventHandler` 回调。
    await EMClient.getInstance.startCallback();
  }

  //添加监听
  static void addChatListener() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    await databaseHelper.database;
    // 注册连接状态监听
    EMClient.getInstance.addConnectionEventHandler(
      "UNIQUE_HANDLER_ID",
      EMConnectionEventHandler(
        // sdk 连接成功;
        onConnected: (() {
          LogE('IM 登录成功');
          eventBus.fire(SubmitButtonBack(title: 'im重连'));
          // MyToastUtils.showToastBottom('IM登录成功');
        }),
        // 由于网络问题导致的断开，sdk会尝试自动重连，连接成功后会回调 "onConnected";
        onDisconnected: (() {
          LogE('IM 断开连接');
        }),
        // 用户 token 鉴权失败;
        onUserAuthenticationFailed: (() {
          LogE('IM 登鉴权失败');
          // MyToastUtils.showToastBottom('IM登鉴权失败');
        }),
        // 由于密码变更被踢下线;
        onUserDidChangePassword: (() {
          LogE('IM 登由于密码变更被踢下线');
          // MyToastUtils.showToastBottom('IM登由于密码变更被踢下线');
        }),
        // 用户被连接被服务器禁止;
        onUserDidForbidByServer: (() {
          LogE('IM 登用户被连接被服务器禁止');
          // MyToastUtils.showToastBottom('IM登用户被连接被服务器禁止');
        }),
        // 用户登录设备超出数量限制;
        onUserDidLoginTooManyDevice: (() {
          LogE('IM 登用户登录设备超出数量限制');
          // MyToastUtils.showToastBottom('IM登用户登录设备超出数量限制');
        }),
        // 用户从服务器删除;
        onUserDidRemoveFromServer: (() {
          LogE('IM 登用户从服务器删除');
          // MyToastUtils.showToastBottom('IM登用户从服务器删除');
        }),
        // 调用 `kickDevice` 方法将设备踢下线，被踢设备会收到该回调；
        onUserKickedByOtherDevice: (() {
          LogE('IM 登将设备踢下线');
        }),
        // 登录新设备时因达到了登录设备数量限制而导致当前设备被踢下线，被踢设备收到该回调；
        onUserDidLoginFromOtherDevice: ((String deviceName) {
          LogE('IM 登登录设备数量限制而导致当前设备被踢下线');
        }),
        // Token 过期;
        onTokenDidExpire: (() {
          LogE('IM 登过期');
          // MyToastUtils.showToastBottom('IM登过期');
        }),
        // Token 即将过期，需要调用 renewToken;
        onTokenWillExpire: (() {
          LogE('IM 登即将过期');
          // MyToastUtils.showToastBottom('IM登即将过期');
        }),
      ),
    );

    EMClient.getInstance.chatRoomManager.addEventHandler('123',
        EMChatRoomEventHandler(onRemovedFromChatRoom:
            (roomId, roomName, participantreason, reason) {
      // ignore: unrelated_type_equality_checks
      if (reason == LeaveReason.Kicked) {
        LogE('客户主动离开聊天室 $roomId 房间名称 $roomName == $participantreason ** $reason');
        // if (sp.getString('roomID').toString() == roomId.toString()) {
        //   EMClient.getInstance.chatRoomManager.joinChatRoom(roomId);
        // }
      } else {
        //非客户主动离开聊天室 并且判断是否为当前登录的房间
        if(sp.getString('roomID').toString().isNotEmpty) {
          if (sp.getString('chatRoomId').toString() == roomId.toString()) {
            EMClient.getInstance.chatRoomManager.joinChatRoom(roomId);
          }
        }
        LogE('非客户主动离开聊天室 $roomId 房间名称 $roomName == $participantreason ** $reason');
      }
    }));

    // 添加收消息监听
    EMClient.getInstance.chatManager.addEventHandler(
      // EMChatEventHandler 对应的 key。
      "UNIQUE_HANDLER_ID",
      EMChatEventHandler(onMessagesReceived: (messages) async {
        for (var msg in messages) {
          LogE('接收数据${msg.body.type}');
          switch (msg.body.type) {
            case MessageType.TXT:
              {
                EMTextMessageBody body = msg.body as EMTextMessageBody;
                LogE('接收文本信息$msg');
                if(msg.attributes!.toString() != 'null'){
                  Map info = msg.attributes!;
                  LogE('接收文本信息类型 ${info['type']}');
                  LogE('接收文本信息$info');
                  if (body.content == '赛车押注') {
                    eventBus.fire(JoinRoomYBack(map: info, type: '赛车押注'));
                  } else if (body.content == '清除魅力值') {
                    eventBus.fire(
                        JoinRoomYBack(map: info, type: 'clean_charm_single'));
                  } else if (body.content == '离开房间') {
                    eventBus
                        .fire(JoinRoomYBack(map: info, type: 'user_leave_room'));
                  } else if (body.content == '充值成功') {
                    eventBus.fire(SubmitButtonBack(title: '充值成功'));
                  } else if (body.content == '下麦') {
                    eventBus
                        .fire(JoinRoomYBack(map: info, type: 'user_down_mic'));
                  } else if (body.content == '开麦') {
                    eventBus.fire(
                        JoinRoomYBack(map: info, type: 'user_un_close_mic'));
                  } else if (body.content == '闭麦') {
                    eventBus
                        .fire(JoinRoomYBack(map: info, type: 'user_close_mic'));
                  } else if (body.content == '抱麦') {
                    eventBus.fire(JoinRoomYBack(map: info, type: 'bao_mic'));
                  } else if (body.content == '爆灯') {
                    eventBus.fire(JoinRoomYBack(map: info, type: 'burstlight'));
                  } else if (body.content == '盲盒礼物') {
                    eventBus.fire(JoinRoomYBack(map: info, type: 'blind_box'));
                  } else if (body.content == '盲盒礼物横幅') {
                    eventBus.fire(JoinRoomYBack(map: info, type: 'blind_box_all'));
                  } else if (body.content == '邀请上麦') {
                    eventBus.fire(JoinRoomYBack(map: info, type: 'yq_up_mic'));
                  }  else if (body.content == '邀请开麦') {
                    eventBus.fire(JoinRoomYBack(map: info, type: 'yq_open_mic'));
                  } else {
                    if (info['lv'] == '' || info['lv'] == null) {
                      if (info['type'] == 'clean_charm') {
                        // 厅内清空魅力值
                        eventBus.fire(JoinRoomYBack(map: info, type: '0'));
                      } else if (info['type'] == 'clean_public_screen') {
                        // 清除公屏
                        eventBus.fire(JoinRoomYBack(map: info, type: '0'));
                      } else if (info['type'] == 'one_click_gift') {
                        eventBus.fire(JoinRoomYBack(map: info, type: '0'));
                      } else {
                        String nickName = info['nickname'];
                        String headImg = info['avatar'];
                        String combineID = '';
                        if (int.parse(sp.getString('user_id').toString()) >
                            int.parse(msg.from!)) {
                          combineID =
                          '${msg.from}-${sp.getString('user_id').toString()}';
                        } else {
                          combineID =
                          '${sp.getString('user_id').toString()}-${msg.from}';
                        }

                        // 接收别人发来的消息
                        Map<String, dynamic> params = <String, dynamic>{
                          'uid': sp.getString('user_id').toString(),
                          'otherUid': msg.from,
                          'whoUid': msg.from,
                          'combineID': combineID,
                          'nickName': nickName,
                          'content': body.content,
                          'bigImg': '',
                          'headNetImg': sp.getString('user_headimg').toString(),
                          'otherHeadNetImg': headImg,
                          'add_time': msg.serverTime,
                          'type': 1,
                          'number': 0,
                          'status': 1,
                          'readStatus': 0,
                          'liveStatus': 0,
                          'loginStatus': 0,
                          'weight': info['weight'],
                          'msgId': msg.msgId,
                          'msgRead': 2,
                          'msgJson': jsonEncode(msg.toJson()),
                        };
                        // 插入数据
                        await databaseHelper.insertData('messageSLTable', params);
                        eventBus.fire(SendMessageBack(type: 1, msgID: '0', uid: '1'));
                      }
                    } else {
                      eventBus.fire(JoinRoomYBack(map: info, type: '0'));
                    }
                  }
                }
              }
              break;
            case MessageType.IMAGE:
              {
                // 下载附件
                EMClient.getInstance.chatManager.downloadAttachment(msg);
                EMImageMessageBody body = msg.body as EMImageMessageBody;
                LogE('接受图片信息==$body');
                LogE('接受图片信息**${msg.attributes}');
                Map? info = msg.attributes;
                String nickName = info!['nickname'];
                String headImg = info!['avatar'];
                String combineID = '';
                if (int.parse(sp.getString('user_id').toString()) >
                    int.parse(msg.from!)) {
                  combineID =
                      '${msg.from}-${sp.getString('user_id').toString()}';
                } else {
                  combineID =
                      '${sp.getString('user_id').toString()}-${msg.from}';
                }

                Map<String, dynamic> params = <String, dynamic>{
                  'uid': sp.getString('user_id').toString(),
                  'otherUid': msg.from,
                  'whoUid': msg.from,
                  'combineID': combineID,
                  'nickName': nickName,
                  'content': body.remotePath,
                  'bigImg': body.remotePath,
                  'headNetImg': sp.getString('user_headimg').toString(),
                  'otherHeadNetImg': headImg,
                  'add_time': msg.serverTime,
                  'type': 2,
                  'number': 0,
                  'status': 1,
                  'readStatus': 0,
                  'liveStatus': 0,
                  'loginStatus': 0,
                  'weight': msg.from.toString() == '1' ? 1 : 0,
                  'msgId': msg.msgId,
                  'msgRead': 2,
                  'msgJson': jsonEncode(msg.toJson()),
                };
                // 插入数据
                await databaseHelper.insertData('messageSLTable', params);
                eventBus.fire(SendMessageBack(type: 2, msgID: '2', uid: '1'));
              }
              break;
            case MessageType.VIDEO:
              {
                LogE('VIDEO消息${msg.from}');
                // addLogToConsole(
                //   "receive video message, from: ${msg.from}",
                // );
              }
              break;
            case MessageType.LOCATION:
              {
                LogE('LOCATION消息${msg.from}');
                addLogToConsole(
                  "receive location message, from: ${msg.from}",
                );
              }
              break;
            case MessageType.VOICE:
              {
                LogE('VOICE消息${msg}');
                EMVoiceMessageBody body = msg.body as EMVoiceMessageBody;
                Map? info = msg.attributes;
                String nickName = info!['nickname'];
                String headImg = info!['avatar'];
                String combineID = '';
                if (int.parse(sp.getString('user_id').toString()) >
                    int.parse(msg.from!)) {
                  combineID =
                      '${msg.from}-${sp.getString('user_id').toString()}';
                } else {
                  combineID =
                      '${sp.getString('user_id').toString()}-${msg.from}';
                }
                Map<String, dynamic> params = <String, dynamic>{
                  'uid': sp.getString('user_id').toString(),
                  'otherUid': msg.from,
                  'whoUid': msg.from,
                  'combineID': combineID,
                  'nickName': nickName,
                  'content': body.remotePath,
                  'bigImg': body.remotePath,
                  'headNetImg': sp.getString('user_headimg').toString(),
                  'otherHeadNetImg': headImg,
                  'add_time': msg.serverTime,
                  'type': 3,
                  'number': body.duration,
                  'status': 1,
                  'readStatus': 0,
                  'liveStatus': 0,
                  'loginStatus': 0,
                  'weight': msg.from.toString() == '1' ? 1 : 0,
                  'msgId': msg.msgId,
                  'msgRead': 3,
                  'msgJson': jsonEncode(msg.toJson()),
                };
                // 插入数据
                await databaseHelper.insertData('messageSLTable', params);

                eventBus.fire(SendMessageBack(type: 3, msgID: '3', uid: '1'));
              }
              break;
            case MessageType.FILE:
              {
                LogE('FILE消息${msg.from}');
                addLogToConsole(
                  "receive image message, from: ${msg.from}",
                );
              }
              break;
            case MessageType.CUSTOM: //自定义消息
              {
                LogE('CUSTOM消息****${msg}');
                EMCustomMessageBody body = msg.body as EMCustomMessageBody;
                if (body.event == 'red_package') {
                  //接受到红包
                  Map info = body.params!;
                  String nickName = info['nickname'];
                  String headImg = info['avatar'];
                  String combineID = '';
                  if (int.parse(sp.getString('user_id').toString()) >
                      int.parse(msg.from!)) {
                    combineID =
                        '${msg.from}-${sp.getString('user_id').toString()}';
                  } else {
                    combineID =
                        '${sp.getString('user_id').toString()}-${msg.from}';
                  }

                  Map<String, dynamic> params = <String, dynamic>{
                    'uid': sp.getString('user_id').toString(),
                    'otherUid': msg.from,
                    'whoUid': msg.from,
                    'combineID': combineID,
                    'nickName': nickName,
                    'content': '收到${info['value']}个金豆',
                    'bigImg': '',
                    'headNetImg': sp.getString('user_headimg').toString(),
                    'otherHeadNetImg': headImg,
                    'add_time': msg.serverTime,
                    'type': 6,
                    'number': 0,
                    'status': 1,
                    'readStatus': 0,
                    'liveStatus': 0,
                    'loginStatus': 0,
                    'weight': msg.from.toString() == '1' ? 1 : 0,
                    'msgId': msg.msgId,
                    'msgRead': 0,
                    'msgJson': jsonEncode(msg.toJson()),
                  };
                  // 插入数据
                  await databaseHelper.insertData('messageSLTable', params);
                  eventBus.fire(SendMessageBack(type: 1, msgID: '0', uid: '1'));
                } else if (body.event == 'game_turntable_luck') {
                  eventBus.fire(ZDYBack(map: body.params, type: body.event));
                } else if (body.event == 'user_room_black') {
                  eventBus.fire(ZDYBack(map: body.params, type: body.event));
                } else if (body.event == 'room_pk_start') {
                  // 开启房间pk
                  eventBus.fire(ZDYBack(map: body.params, type: body.event));
                } else if (body.event == 'room_pk_result') {
                  // 房间pk关闭了
                  eventBus.fire(ZDYBack(map: body.params, type: body.event));
                } else if (body.event == 'room_pk_ahead_punish') {
                  // 提前结束惩罚
                  eventBus.fire(ZDYBack(map: body.params, type: body.event));
                } else {
                  eventBus.fire(ZDYBack(map: body.params, type: body.event));
                }
              }
              break;
            case MessageType.CMD:
              {
                LogE('文本消息cmd');
                // 当前回调中不会有 CMD 类型消息，CMD 类型消息通过 `EMChatEventHandler#onCmdMessagesReceived` 回调接收
              }
              break;
          }
        }
      }, onMessagesRead: (messages) async {
        Database? db = await databaseHelper.database;
        for (EMMessage msg in messages) {
          int count = await db.update(
            'messageSLTable',
            {'msgRead': (msg.hasReadAck ? 1 : 2)},
            whereArgs: [msg.msgId],
            where: 'msgId = ?',
          );
          // eventBus.fire(SendMessageBack(type: 1, msgID: msg.msgId));
          LogE('消息已读回执: from = ${msg.from}, msgId = ${msg.msgId}, db = $count');
        }
        eventBus.fire(SendMessageBack(type: 1, msgID: '0', uid: ''));
      }, onMessagesRecalled: (messages) async {
        Database? db = await databaseHelper.database;
        for (EMMessage msg in messages) {
          int count = await db.delete(
            'messageSLTable',
            whereArgs: [msg.msgId],
            where: 'msgId = ?',
          );
          LogE('消息撤回: from = ${msg.from}, msgId = ${msg.msgId}, db = $count');
        }
        eventBus.fire(SendMessageBack(type: 1, msgID: '0', uid: ''));
      }),
    );
    // 添加消息状态变更监听
    EMClient.getInstance.chatManager.addMessageEvent(
        // ChatMessageEvent 对应的 key。
        "UNIQUE_HANDLER_ID",
        ChatMessageEvent(
          onSuccess: (msgId, msg) async {
            Database? db = await databaseHelper.database;
            await db.update(
              'messageSLTable',
              {'msgId': msg.msgId, 'msgJson': jsonEncode(msg.toJson())},
              whereArgs: [msgId],
              where: 'msgJson = ?',
            );
            switch (msg.body.type) {
              case MessageType.TXT:
                break;
              case MessageType.IMAGE:
                eventBus.fire(SendMessageBack(type: 2, msgID: msgId, uid: ''));
                break;
              case MessageType.VIDEO:
                break;
              case MessageType.VOICE:
                LogE('语音发送成功 $msg');
                eventBus.fire(SubmitButtonBack(title: '语音发送成功', msg: msg));
                break;
            }
            addLogToConsole("send message succeed");
          },
          onProgress: (msgId, progress) {
            LogE('语音发送进度');
            addLogToConsole("send message succeed");
          },
          onError: (msgId, msg, error) async {
            LogE('语音发送失败2');
            if(msg.body.type == MessageType.VIDEO){
              eventBus.fire(SubmitButtonBack(title: '语音发送失败'));
            } else {
              Database? db = await databaseHelper.database;
              await db.delete(
                'messageSLTable',
                whereArgs: [msgId],
                where: 'msgJson = ?',
              );
              eventBus.fire(SendMessageBack(type: 1, msgID: msgId, uid: ''));
              MyToastUtils.showToastBottom('消息发送失败');
            }
            addLogToConsole(
              "send message failed, code: ${error.code}, desc: ${error.description}",
            );
          },
        ));
  }

  //添加登录
  static void signIn() async {
    try {
      LogE('初始化UID ${sp.getString('user_id').toString()}');
      LogE('初始化UID ${sp.getString('em_pwd').toString()}');
      await EMClient.getInstance.login(sp.getString('user_id').toString(),
          sp.getString('em_pwd').toString());
    } on EMError catch (e) {
      addLogToConsole("sign in failed, e: ${e.code} , ${e.description}");
    }
  }

  //退出登录
  static void signOut() async {
    try {
      await EMClient.getInstance.logout(true);
      addLogToConsole("sign out succeed");
    } on EMError catch (e) {
      addLogToConsole(
          "sign out failed, code: ${e.code}, desc: ${e.description}");
    }
  }

  //退出登录后在进行登录
  static void signOutLogin() async {
    try {
      await EMClient.getInstance.logout(true);
      signIn();
      addLogToConsole("sign out succeed");
    } on EMError catch (e) {
      addLogToConsole(
          "sign out failed, code: ${e.code}, desc: ${e.description}");
    }
  }

  //注册环信 IM 用户
  static void signUp() async {
    // try {
    //   await EMClient.getInstance.createAccount(_username, _password);
    //   _addLogToConsole("sign up succeed, username: $_username");
    // } on EMError catch (e) {
    //   _addLogToConsole("sign up failed, e: ${e.code} , ${e.description}");
    // }
  }

  //发送消息
  static void sendMessage(String conversationId, String content) async {
    // 创建一条文本消息，`content` 为消息文字内容，`conversationId` 为会话 ID，在单聊时为对端用户 ID、群聊时为群组 ID，聊天室时为聊天室 ID。
    final msg = EMMessage.createTxtSendMessage(
      targetId: conversationId,
      content: content,
    );

// 发送消息。
    EMClient.getInstance.chatManager.sendMessage(msg);
  }

  static void addLogToConsole(String log) {}

  // 消息已读回执
  static void didMsgRead(params, {int index = 2}) async {
    if (params['msgRead'] == index) {
      try {
        String json = params['msgJson'];
        final msg = EMMessage.fromJson(jsonDecode(json));
        LogE("消息已读回执: to = ${msg.from}, msgId = ${msg.msgId}");
        if (await EMClient.getInstance.chatManager.sendMessageReadAck(msg)) {
          // params['msgRead'] = 1;
          DatabaseHelper databaseHelper = DatabaseHelper();
          await databaseHelper.database;
          Database? db = await databaseHelper.database;
          await db.update(
            'messageSLTable',
            {'msgRead': 1},
            whereArgs: [params['msgId']],
            where: 'msgId = ?',
          );
          eventBus
              .fire(SendMessageBack(type: params['type'], msgID: msg.msgId, uid: ''));
        }
      } on EMError catch (e) {
        LogE(e.description);
      } catch (e) {
        LogE(e.toString());
      }
    }
  }

  static void recallMessage(params) async {
    try {
      String msgId = params['msgId'];
      if (msgId.isEmpty) {
        return;
      }
      await EMClient.getInstance.chatManager.recallMessage(msgId);

      DatabaseHelper databaseHelper = DatabaseHelper();
      await databaseHelper.database;
      Database? db = await databaseHelper.database;
      await db.delete(
        'messageSLTable',
        where: 'msgId = ?',
        whereArgs: [msgId],
      );
      LogE('消息撤回: to = ${params['otherUid']}, msgId = $msgId');
      eventBus.fire(SendMessageBack(type: 2, msgID: msgId, uid: ''));
    } on EMError catch (e) {
      if (e.code == 504) {
        // 消息撤回超时错误：消息撤回超过时间限制时会提示该错误。
        MyToastUtils.showToastBottom('撤回超过时间限制');
      }
    } catch (e) {
      LogE(e.toString());
    }
  }
}
