import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:im_flutter_sdk/im_flutter_sdk.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';
import 'package:svgaplayer_flutter/player.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/widget/SwiperPage.dart';

import '../../bean/Common_bean.dart';
import '../../bean/chatUserInfoBean.dart';
import '../../bean/isPayBean.dart';
import '../../config/my_config.dart';
import '../../config/smile_utils.dart';
import '../../db/DatabaseHelper.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/loading.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/regex_formatter.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../mine/setting/password_pay_page.dart';
import '../room/room_page.dart';
import '../room/room_ts_mima_page.dart';
import '../trends/trends_more_page.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/foundation.dart' as foundation;

import 'hongbao_page.dart';

/// 聊天页面
class ChatPage extends StatefulWidget {
  String nickName;
  String otherUid;
  String otherImg;

  ChatPage(
      {super.key,
      required this.nickName,
      required this.otherUid,
      required this.otherImg});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  bool isShow = false, isRoomShow = false, isAudio = false;
  int isBlack = 0, length = 0;
  String roomName = '', noteId = '', roomId = '';
  List<String> listImg = [];
  List<String> imgList = [];
  TextEditingController controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  var listen, listenHB;

  // 录音使用
  Codec _codec = Codec.aacADTS;
  String _mPath = ''; //录音文件路径
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool mediaRecord = true;
  bool playRecord = false; //音频文件播放状态
  bool hasRecord = false; //是否有音频文件可播放
  int isPlay = 0; //0录制按钮未点击，1点了录制了，2录制结束或者点击暂停
  int djNum = 60; // 录音时长
  int audioNum = 0; // 记录录了多久
  bool isCancel = false, isLuZhi = false;

  bool _isEmojiPickerVisible = false;
  FocusNode? _focusNode;

  void _onFocusChange() {
    if (_focusNode!.hasFocus) {
      // 获取焦点事件处理逻辑
      print('TextField获取焦点');
      setState(() {
        _isEmojiPickerVisible = false;
      });
    } else {
      // 失去焦点事件处理逻辑
      print('TextField失去焦点');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    _initialize();
    super.initState();
    eventBus.fire(SubmitButtonBack(title: '清空红点'));
    doPostChatUserInfo();
    doLocationInfo();
    // _addChatListener();
    MyUtils.addChatListener();
    listen = eventBus.on<SendMessageBack>().listen((event) {
      doLocationInfo();
    });
    listenHB = eventBus.on<HongBaoBack>().listen((event) {
      LogE('发送了===');
      saveHBinfo(event.info);
    });

    _focusNode = FocusNode();
    _focusNode!.addListener(_onFocusChange);
    saveImages();
  }

  // 保存发红包的信息 type 1自己给别人发，2收到别人发的红包
  saveHBinfo(String info) async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    String combineID = '';
    if (int.parse(sp.getString('user_id').toString()) >
        int.parse(widget.otherUid)) {
      combineID = '${widget.otherUid}-${sp.getString('user_id').toString()}';
    } else {
      combineID = '${sp.getString('user_id').toString()}-${widget.otherUid}';
    }
    Map<String, dynamic> params = <String, dynamic>{
      'uid': sp.getString('user_id').toString(),
      'otherUid': widget.otherUid,
      'whoUid': sp.getString('user_id').toString(),
      'combineID': combineID,
      'nickName': widget.nickName,
      'content': '送出$info个V豆',
      'headImg': myHeadImg,
      'otherHeadImg': otherHeadImg,
      'add_time': DateTime.now().millisecondsSinceEpoch,
      'type': 6,
      'number': 0,
      'status': 1,
      'readStatus': 1,
      'liveStatus': 0,
      'loginStatus': 0,
    };
    // 插入数据
    await databaseHelper.insertData('messageSLTable', params);
    // 获取所有数据
    List<Map<String, dynamic>> result = await db.query('messageSLTable',
        columns: null, whereArgs: [combineID], where: 'combineID = ?');
    setState(() {
      allData2 = result;
      length = allData2.length;
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scrollToLastItem(); // 在widget构建完成后滚动到底部
    });
  }

  // 自己头像和他人头像
  String myHeadImg = '', otherHeadImg = '';

  saveImages() async {
    //保存头像
    MyUtils.saveImgTemp(sp.getString('user_headimg').toString(),
        sp.getString('user_id').toString());
    MyUtils.saveImgTemp(widget.otherImg, widget.otherUid);
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
    if (widget.otherImg.contains('.gif') || widget.otherImg.contains('.GIF')) {
      otherHeadImg = '${directory!.path}/${widget.otherUid}.gif';
    } else if (widget.otherImg.contains('.jpg') ||
        widget.otherImg.contains('.GPG')) {
      otherHeadImg = '${directory!.path}/${widget.otherUid}.jpg';
    } else if (widget.otherImg.contains('.jpeg') ||
        widget.otherImg.contains('.GPEG')) {
      otherHeadImg = '${directory!.path}/${widget.otherUid}.jpeg';
    } else {
      otherHeadImg = '${directory!.path}/${widget.otherUid}.png';
    }

  }

  void _initialize() async {
    await _mPlayer!.closePlayer();
    await _mPlayer!.openPlayer();
    await _mRecorder!.openRecorder();
  }

  @override
  void dispose() {
    _focusNode!.removeListener(_onFocusChange);
    _focusNode!.dispose();
    _scrollController.dispose(); // 释放ScrollController资源
    _mPlayer!.closePlayer();
    _mPlayer = null;
    _mRecorder!.closeRecorder();
    _mRecorder = null;
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
    listen.cancel();
    listenHB.cancel();
    super.dispose();
  }

  // 在数据变化后将滚动位置设置为最后一个item的位置
  void scrollToLastItem() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeInOut,
    );
  }

  Widget showImage() {
    if (listImg.length == 1) {
      return Row(
        children: [
          WidgetUtils.CircleImageNet(
              ScreenUtil().setHeight(160),
              ScreenUtil().setHeight(160),
              ScreenUtil().setHeight(10),
              listImg[0]),
          const Spacer(),
          Opacity(
            opacity: 0,
            child: WidgetUtils.CircleImageNet(
                ScreenUtil().setHeight(160),
                ScreenUtil().setHeight(160),
                ScreenUtil().setHeight(10),
                listImg[0]),
          ),
          const Spacer(),
          Opacity(
            opacity: 0,
            child: WidgetUtils.CircleImageNet(
                ScreenUtil().setHeight(160),
                ScreenUtil().setHeight(160),
                ScreenUtil().setHeight(10),
                listImg[0]),
          ),
        ],
      );
    } else if (listImg.length == 2) {
      return Row(
        children: [
          WidgetUtils.CircleImageNet(
              ScreenUtil().setHeight(160),
              ScreenUtil().setHeight(160),
              ScreenUtil().setHeight(10),
              listImg[0]),
          const Spacer(),
          Opacity(
            opacity: 1,
            child: WidgetUtils.CircleImageNet(
                ScreenUtil().setHeight(160),
                ScreenUtil().setHeight(160),
                ScreenUtil().setHeight(10),
                listImg[1]),
          ),
          const Spacer(),
          Opacity(
            opacity: 0,
            child: WidgetUtils.CircleImageNet(
                ScreenUtil().setHeight(160),
                ScreenUtil().setHeight(160),
                ScreenUtil().setHeight(10),
                listImg[0]),
          ),
        ],
      );
    } else if (listImg.length == 3) {
      return Row(
        children: [
          WidgetUtils.CircleImageNet(
              ScreenUtil().setHeight(160),
              ScreenUtil().setHeight(160),
              ScreenUtil().setHeight(10),
              listImg[0]),
          const Spacer(),
          Opacity(
            opacity: 1,
            child: WidgetUtils.CircleImageNet(
                ScreenUtil().setHeight(160),
                ScreenUtil().setHeight(160),
                ScreenUtil().setHeight(10),
                listImg[1]),
          ),
          const Spacer(),
          Opacity(
            opacity: 1,
            child: WidgetUtils.CircleImageNet(
                ScreenUtil().setHeight(160),
                ScreenUtil().setHeight(160),
                ScreenUtil().setHeight(10),
                listImg[2]),
          ),
        ],
      );
    } else {
      return const Text('');
    }
  }

  // 显示聊天信息
  Widget chatWidget(BuildContext context, int i) {
    LogE('头像框 == ${allData2[i]['headImg']}');
    double widthAudio = 0;
    if (allData2[i]['type'] == 3) {
      widthAudio = ScreenUtil().setHeight(60 + allData2[i]['number'] * 4);
    }

    String addTime = '';
    DateTime date = DateTime.parse(
        DateTime.fromMillisecondsSinceEpoch(int.parse(allData2[i]['add_time']))
            .toString());
    //获取当前时间的月
    int month = date.month;
    //获取当前时间的日
    int day = date.day;
    //获取当前时间的时
    int hour = date.hour;
    //获取当前时间的分
    int minute = date.minute;
    // 获取当前时间对象
    DateTime now = DateTime.now();
    int month2 = now.month;
    //获取当前时间的日
    int day2 = now.day;
    if (month == month2 && day == day2) {
      addTime = '$hour:$minute';
    } else if (month == month2 && day2 - day == 1) {
      addTime = '昨天 $hour:$minute';
    } else if (month == month2 && day2 - day > 1) {
      addTime = '$month月$day日 $hour:$minute';
    } else if (month != month2) {
      addTime = '$month月$day日 $hour:$minute';
    }

    // 判断不是第一个，并且中间时间差距大于10分钟才显示时间
    if (i > 0 &&
        ((int.parse(allData2[i]['add_time']) -
                    int.parse(allData2[i - 1]['add_time'])) /
                1000 <=
            600)) {
      addTime = '';
    }

    if (allData2[i]['whoUid'] != sp.getString('user_id')) {
      // 左侧显示
      return Column(
        children: [
          //左侧显示
          WidgetUtils.onlyTextCenter(
              addTime,
              StyleUtils.getCommonTextStyle(
                  color: MyColors.g9, fontSize: ScreenUtil().setSp(20))),
          WidgetUtils.commonSizedBox(
              ScreenUtil().setHeight(10), ScreenUtil().setHeight(10)),
          Row(
            children: [
              WidgetUtils.CircleImageAss(
                  ScreenUtil().setHeight(80),
                  ScreenUtil().setHeight(80),
                  40.h,
                  allData2[i]['otherHeadImg']),
              WidgetUtils.commonSizedBox(0, ScreenUtil().setHeight(10)),
              // 6v豆红包
              allData2[i]['type'] == 6 ? SizedBox(
                height: 130.h,
                width: 300.h,
                child: Stack(
                  children: [
                    WidgetUtils.showImages(
                        'assets/images/chat_hongbao_bg.png',
                        130.h,
                        300.h),
                    Positioned(
                        top: 40.h,
                        left: 60.w,
                        child: Row(
                          children: [
                            WidgetUtils.commonSizedBox(
                                0, 50.h),
                            WidgetUtils.onlyText(
                                allData2[i]['content'],
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontSize: 25.sp)),
                          ],
                        ))
                  ],
                ),
              ): Flexible(
                child: Container(
                  constraints:
                      BoxConstraints(minWidth: ScreenUtil().setHeight(60)),
                  padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                  //边框设置
                  decoration: BoxDecoration(
                    //背景
                    color: allData2[i]['type'] == 2 ? Colors.transparent : Colors.white,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(0),
                        topRight: Radius.circular(20.0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                    boxShadow: allData2[i]['type'] == 2 ? [] : [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 1), // 阴影的偏移量，向右下方偏移3像素
                      ),
                    ],
                  ),
                  child: allData2[i]['type'] == 1
                      ? Text(
                          allData2[i]['content'],
                          style: TextStyle(
                            fontSize: 30.sp,
                            color: Colors.black,
                          ),
                        )
                      : allData2[i]['type'] == 2
                          ? GestureDetector(
                              onTap: (() {
                                setState(() {
                                  imgList.clear();
                                  imgList.add(allData2[i]['content']);
                                });
                                MyUtils.goTransparentPageCom(
                                    context, SwiperPage(imgList: imgList));
                              }),
                              child: Image(
                                image: FileImage(File(allData2[i]['content'])),
                                width: 160.h,
                                height: 200.h,
                                errorBuilder: (BuildContext context,
                                    Object error, StackTrace? stackTrace) {
                                  return WidgetUtils.showImages(
                                      'assets/images/img_error.png',
                                      200.h,
                                      160.h);
                                },
                              ),
                            )
                          : GestureDetector(
                              onTap: (() {
                                LogD('************');
                                if (playRecord) {
                                  stopPlayer();
                                } else {
                                  play(allData2[i]['content']);
                                }
                              }),
                              child: SizedBox(
                                width: widthAudio,
                                child: Row(
                                  children: [
                                    WidgetUtils.showImages(
                                        'assets/images/chat_huatong.png',
                                        20.h,
                                        20.h),
                                    WidgetUtils.onlyText(
                                        "${allData2[i]['number']}''",
                                        StyleUtils.textStyleb1),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ),
                ),
              ),
            ],
          ),
          WidgetUtils.commonSizedBox(
              ScreenUtil().setHeight(20), ScreenUtil().setHeight(10)),
        ],
      );
    } else {
      return Column(
        children: [
          //右侧显示
          WidgetUtils.onlyTextCenter(
              addTime,
              StyleUtils.getCommonTextStyle(
                  color: MyColors.g9, fontSize: ScreenUtil().setSp(20))),
          WidgetUtils.commonSizedBox(
              ScreenUtil().setHeight(10), ScreenUtil().setHeight(10)),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              WidgetUtils.commonSizedBox(0, ScreenUtil().setHeight(100)),
              // 6v豆红包
              allData2[i]['type'] == 6 ? SizedBox(
                height: 130.h,
                width: 300.h,
                child: Stack(
                  children: [
                    WidgetUtils.showImages(
                        'assets/images/chat_hongbao_bg.png',
                        130.h,
                        300.h),
                    Positioned(
                        top: 40.h,
                        left: 60.w,
                        child: Row(
                          children: [
                            WidgetUtils.commonSizedBox(
                                0, 50.h),
                            WidgetUtils.onlyText(
                                allData2[i]['content'],
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontSize: 25.sp)),
                          ],
                        ))
                  ],
                ),
              ): Flexible(
                child: Container(
                  constraints:
                  BoxConstraints(minWidth: ScreenUtil().setHeight(60)),
                  padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                  //边框设置
                  decoration: BoxDecoration(
                    //背景
                    color: allData2[i]['type'] == 2 ? Colors.transparent : Colors.white,
                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20.0),
                        topRight: Radius.circular(0),
                        bottomLeft: Radius.circular(20.0),
                        bottomRight: Radius.circular(20.0)),
                    boxShadow: allData2[i]['type'] == 2 ? [] : [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 1), // 阴影的偏移量，向右下方偏移3像素
                      ),
                    ],
                  ),
                  child: allData2[i]['type'] == 1
                      ? Text(
                    allData2[i]['content'],
                    style: TextStyle(
                      fontSize: 30.sp,
                      color: Colors.black,
                    ),
                  )
                      : allData2[i]['type'] == 2
                      ? GestureDetector(
                    onTap: (() {
                      setState(() {
                        imgList.clear();
                        imgList.add(allData2[i]['content']);
                      });
                      MyUtils.goTransparentPageCom(
                          context, SwiperPage(imgList: imgList));
                    }),
                    child: Image(
                      image: FileImage(File(allData2[i]['content'])),
                      width: 160.h,
                      height: 200.h,
                      errorBuilder: (BuildContext context,
                          Object error, StackTrace? stackTrace) {
                        return WidgetUtils.showImages(
                            'assets/images/img_error.png',
                            200.h,
                            160.h);
                      },
                    ),
                  )
                      : allData2[i]['type'] == 3
                      ? GestureDetector(
                    onTap: (() {
                      LogD('************');
                      if (playRecord) {
                        stopPlayer();
                      } else {
                        play(allData2[i]['content']);
                      }
                    }),
                    child: SizedBox(
                      width: widthAudio,
                      child: Row(
                        children: [
                          const Spacer(),
                          WidgetUtils.onlyText(
                              "${allData2[i]['number']}''",
                              StyleUtils.textStyleb1),
                          WidgetUtils.showImages(
                              'assets/images/chat_huatong.png',
                              20.h,
                              20.h),
                        ],
                      ),
                    ),
                  ) : const Text(''),
                ),
              ),
              WidgetUtils.commonSizedBox(0, ScreenUtil().setHeight(10)),
              WidgetUtils.CircleImageAss(ScreenUtil().setHeight(80),
                  ScreenUtil().setHeight(80), 40.h, allData2[i]['headImg']),
            ],
          ),
          WidgetUtils.commonSizedBox(20.h, ScreenUtil().setHeight(10)),
        ],
      );
    }
  }

  Future<bool> getPermissionStatus() async {
    Permission permission = Permission.microphone;
    //granted 通过，denied 被拒绝，permanentlyDenied 拒绝且不在提示
    PermissionStatus status = await permission.status;
    if (status.isGranted) {
      return true;
    } else if (status.isDenied) {
      requestPermission(permission);
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else if (status.isRestricted) {
      requestPermission(permission);
    } else {}
    return false;
  }

  ///申请权限
  void requestPermission(Permission permission) async {
    PermissionStatus status = await permission.request();
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  late Timer _timer;

//点击开始录音
  startRecord() {
    record();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        djNum--;
        audioNum++;
      });
      if (djNum == 0) {
        timer.cancel();
        stopRecorder();
      }
    });
  }

//开始录音
  void record() async {
    try {
      await getPermissionStatus().then((value) async {
        if (!value) {
          return;
        }

        if (playRecord) {
          stopPlayer();
          setState(() {
            playRecord = false;
          });
        }
        // 缓存目录
        // Directory tempDir = await getTemporaryDirectory();
        var time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
        Directory appDir = await getApplicationDocumentsDirectory();
        // String folderName = 'myAudio'; // 指定文件夹名称
        // // Directory folderDir = Directory('$appDir/$folderName');
        // Directory folderDir = Directory(path);
        // if (!folderDir.existsSync()) {
        //   folderDir.createSync();
        // }
        String path = '${appDir.path}/$time${ext[Codec.aacADTS.index]}';
        setState(() {
          _mPath = path;
        });
        LogE('录音地址:$path');
        _mRecorder!
            .startRecorder(
          toFile: path,
          codec: _codec,
          audioSource: AudioSource.microphone,
        )
            .then((value) {
          setState(() {
            mediaRecord = false;
            hasRecord = false;
            _mPath = path;
          });
        });
      });
    } catch (err) {}
  }

//停止录音
  void stopRecorder() async {
    LogE('停止录音');
    await _mRecorder!.stopRecorder().then((value) {
      _timer.cancel();
      setState(() {
        mediaRecord = true;
        hasRecord = true;
        djNum = 60;
      });
    });
  }

//删除录音
  delRecorder() {
    if (_mPath != '') {
      var dir = Directory(_mPath);
      dir.deleteSync(recursive: true);
    }
    setState(() {
      _mPath = '';
      hasRecord = false;
    });
  }

//播放录音
  void play(String audioUrls) {
    LogE('录音地址**$audioUrls');
    _mPlayer!
        .startPlayer(
            fromURI: audioUrls,
            whenFinished: () {
              setState(() {
                playRecord = false;
              });
            })
        .then((value) {
      setState(() {
        playRecord = true;
      });
    });
  }

//停止播放录音
  void stopPlayer() {
    _mPlayer!.stopPlayer().then((value) {
      setState(() {
        playRecord = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.homeBG,
      body: WillPopScope(
        onWillPop: () async {
          //这里可以响应物理返回键
          eventBus.fire(SubmitButtonBack(title: '聊天返回'));
          Navigator.of(context).pop();
          return false;
        },
        child: Stack(
          children: [
            Column(
              children: [
                WidgetUtils.commonSizedBox(35, 0),

                ///头部信息
                Container(
                  height: ScreenUtil().setHeight(60),
                  width: double.infinity,
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      Container(
                        width: ScreenUtil().setWidth(100),
                        padding: const EdgeInsets.only(left: 15),
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back_ios),
                          color: Colors.black,
                          onPressed: (() {
                            eventBus.fire(SubmitButtonBack(title: '聊天返回'));
                            Navigator.of(context).pop();
                          }),
                        ),
                      ),
                      const Expanded(child: Text('')),

                      /// 关注被关注切换按钮
                      Container(
                          width: ScreenUtil().setHeight(200),
                          height: ScreenUtil().setHeight(80),
                          alignment: Alignment.center,
                          child: Text(
                            widget.nickName,
                            style: TextStyle(
                                overflow: TextOverflow.ellipsis,
                                color: Colors.black,
                                fontSize: ScreenUtil().setSp(30),
                                fontWeight: FontWeight.w600),
                          )),
                      const Expanded(child: Text('')),
                      GestureDetector(
                        onTap: (() {
                          setState(() {
                            isShow = true;
                          });
                        }),
                        child: Container(
                          width: ScreenUtil().setWidth(100),
                          padding: const EdgeInsets.only(right: 15),
                          child: WidgetUtils.showImages(
                              'assets/images/chat_dian.png',
                              ScreenUtil().setHeight(10),
                              ScreenUtil().setHeight(7)),
                        ),
                      ),
                    ],
                  ),
                ),
                // 在房间
                isRoomShow
                    ? Container(
                        height: ScreenUtil().setHeight(90),
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            left: ScreenUtil().setHeight(20),
                            right: ScreenUtil().setHeight(20),
                            top: ScreenUtil().setHeight(10)),
                        //边框设置
                        decoration: const BoxDecoration(
                          //背景
                          color: MyColors.chatBlue,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        ),
                        child: Row(
                          children: [
                            WidgetUtils.commonSizedBox(
                                0, ScreenUtil().setHeight(20)),
                            WidgetUtils.onlyText(
                                'Ta在$roomName房间',
                                StyleUtils.getCommonTextStyle(
                                    color: MyColors.btn_d,
                                    fontSize: ScreenUtil().setSp(28),
                                    fontWeight: FontWeight.w600)),
                            const Spacer(),
                            GestureDetector(
                              onTap: (() {
                                doPostBeforeJoin(roomId);
                              }),
                              child: Container(
                                width: ScreenUtil().setHeight(130),
                                height: ScreenUtil().setHeight(50),
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.btn_d,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30.0)),
                                ),
                                child: Row(
                                  children: [
                                    const Spacer(),
                                    WidgetUtils.showImages(
                                        'assets/images/zhibo2.webp',
                                        ScreenUtil().setHeight(20),
                                        ScreenUtil().setHeight(20)),
                                    WidgetUtils.commonSizedBox(
                                        0, ScreenUtil().setHeight(5)),
                                    WidgetUtils.onlyText(
                                        '踩房间',
                                        StyleUtils.getCommonTextStyle(
                                            color: Colors.white,
                                            fontSize: ScreenUtil().setSp(28),
                                            fontWeight: FontWeight.w600)),
                                    const Spacer(),
                                  ],
                                ),
                              ),
                            ),
                            WidgetUtils.commonSizedBox(
                                0, ScreenUtil().setHeight(20)),
                            GestureDetector(
                              onTap: (() {
                                setState(() {
                                  isRoomShow = false;
                                });
                              }),
                              child: WidgetUtils.showImages(
                                  'assets/images/chat_close.png',
                                  ScreenUtil().setHeight(15),
                                  ScreenUtil().setHeight(15)),
                            ),
                            WidgetUtils.commonSizedBox(
                                0, ScreenUtil().setHeight(20)),
                          ],
                        ),
                      )
                    : const Text(''),
                // 最新动态
                listImg.isNotEmpty
                    ? GestureDetector(
                        onTap: (() {
                          MyUtils.goTransparentRFPage(
                              context,
                              TrendsMorePage(
                                note_id: noteId,
                              ));
                        }),
                        child: Container(
                          height: ScreenUtil().setHeight(260),
                          width: double.infinity,
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setHeight(20),
                              right: ScreenUtil().setHeight(20),
                              top: ScreenUtil().setHeight(20)),
                          margin: EdgeInsets.only(
                              left: ScreenUtil().setHeight(20),
                              right: ScreenUtil().setHeight(20),
                              top: ScreenUtil().setHeight(10),
                              bottom: ScreenUtil().setHeight(20)),
                          //边框设置
                          decoration: BoxDecoration(
                            //背景
                            color: Colors.white,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: const Offset(0, 1), // 阴影的偏移量，向右下方偏移3像素
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              WidgetUtils.commonSizedBox(
                                  0, ScreenUtil().setHeight(20)),
                              WidgetUtils.onlyText(
                                  '最新动态',
                                  StyleUtils.getCommonTextStyle(
                                      color: Colors.black,
                                      fontSize: ScreenUtil().setSp(30),
                                      fontWeight: FontWeight.w600)),
                              SizedBox(
                                height: ScreenUtil().setHeight(200),
                                child: showImage(),
                              )
                            ],
                          ),
                        ),
                      )
                    : const Text(''),
                Expanded(
                  child: length > 0
                      ? ListView.builder(
                          padding: EdgeInsets.only(
                              left: ScreenUtil().setHeight(20),
                              right: ScreenUtil().setHeight(20)),
                          controller: _scrollController,
                          itemBuilder: chatWidget,
                          itemCount: allData2.length,
                        )
                      : const Text(''),
                ),
                // 底部键盘
                Container(
                  height: ScreenUtil().setHeight(120),
                  color: Colors.white,
                  child: Row(
                    children: [
                      WidgetUtils.commonSizedBox(0, 20),
                      GestureDetector(
                        onTap: (() {
                          setState(() {
                            isAudio = !isAudio;
                          });
                        }),
                        child: isAudio
                            ? WidgetUtils.showImages(
                                'assets/images/chat_jianpan.png',
                                ScreenUtil().setHeight(45),
                                ScreenUtil().setHeight(45))
                            : WidgetUtils.showImages(
                                'assets/images/chat_huatong.png',
                                ScreenUtil().setHeight(45),
                                ScreenUtil().setHeight(45)),
                      ),
                      WidgetUtils.commonSizedBox(0, 10),
                      isAudio
                          ? Expanded(
                              child: GestureDetector(
                                onVerticalDragStart: (details) async {
                                  if (await getPermissionStatus()) {
                                    // 开始录音
                                    startRecord();
                                    setState(() {
                                      audioNum = 0; // 记录录了多久
                                      isLuZhi = true;
                                    });
                                  }
                                },
                                onVerticalDragUpdate: (details) async {
                                  if (await getPermissionStatus()) {
                                    if (details.delta.dy < -1) {
                                      if (_timer.isActive) {
                                        _timer.cancel();
                                      }
                                      // 停止录音
                                      stopRecorder();
                                      setState(() {
                                        isCancel = true;
                                      });
                                    }
                                  }
                                },
                                onVerticalDragEnd: (details) async {
                                  if (await getPermissionStatus()) {
                                    // 取消录音后抬起手指
                                    if (isCancel) {
                                      //重新初始化音频信息
                                      setState(() {
                                        isCancel = false;

                                        mediaRecord = true;
                                        playRecord = false; //音频文件播放状态
                                        hasRecord = false; //是否有音频文件可播放
                                        isLuZhi = false;
                                        isPlay = 0; //0录制按钮未点击，1点了录制了，2录制结束或者点击暂停
                                        djNum = 60; // 录音时长
                                        audioNum = 0; // 记录录了多久
                                      });
                                    } else {
                                      // 停止录音
                                      stopRecorder();
                                      if(audioNum == 0){
                                        MyToastUtils.showToastBottom('录音时长过短！');
                                        //重新初始化音频信息
                                        setState(() {
                                          mediaRecord = true;
                                          playRecord = false; //音频文件播放状态
                                          hasRecord = false; //是否有音频文件可播放
                                          isLuZhi = false;
                                          isPlay = 0; //0录制按钮未点击，1点了录制了，2录制结束或者点击暂停
                                          djNum = 60; // 录音时长
                                          audioNum = 0; // 记录录了多久
                                        });
                                      }else{
                                        //发送录音
                                        doSendAudio();
                                      }
                                    }
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: ScreenUtil().setHeight(60),
                                  padding:
                                      const EdgeInsets.only(left: 10, right: 10),
                                  alignment: Alignment.center,
                                  //边框设置
                                  decoration: const BoxDecoration(
                                    //背景
                                    color: MyColors.f2,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                  ),
                                  child: WidgetUtils.onlyTextCenter(
                                      '按住 说话',
                                      StyleUtils.getCommonTextStyle(
                                          color: MyColors.g6,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 25.sp)),
                                ),
                              ),
                            )
                          : Expanded(
                              child: Container(
                                width: double.infinity,
                                height: ScreenUtil().setHeight(60),
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                alignment: Alignment.center,
                                //边框设置
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.f2,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: TextField(
                                  focusNode: _focusNode,
                                  textInputAction: TextInputAction.send,
                                  // 设置为发送按钮
                                  controller: controller,
                                  inputFormatters: [
                                    RegexFormatter(
                                        regex: MyUtils.regexFirstNotNull),
                                    LengthLimitingTextInputFormatter(25)//限制输入长度
                                  ],
                                  style: StyleUtils.loginTextStyle,
                                  onSubmitted: (value) {
                                    MyUtils.sendMessage(widget.otherUid, value);
                                    doPostSendUserMsg(value);
                                  },
                                  decoration: InputDecoration(
                                    // border: InputBorder.none,
                                    // labelText: "请输入用户名",
                                    // icon: Icon(Icons.people), //前面的图标
                                    hintText: '请输入文字信息',
                                    hintStyle: StyleUtils.loginHintTextStyle,

                                    contentPadding:
                                        const EdgeInsets.only(top: 0, bottom: 0),
                                    border: const OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.transparent),
                                    ),
                                    enabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    disabledBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    // prefixIcon: Icon(Icons.people_alt_rounded)//和文字一起的图标
                                  ),
                                ),
                              ),
                            ),
                      WidgetUtils.commonSizedBox(0, 10),
                      GestureDetector(
                        onTap: (() {
                          setState(() {
                            isAudio = false;
                            MyUtils.hideKeyboard(context);
                            _isEmojiPickerVisible = !_isEmojiPickerVisible;
                          });
                        }),
                        child: WidgetUtils.showImages(
                            'assets/images/trends_biaoqing.png',
                            ScreenUtil().setHeight(45),
                            ScreenUtil().setHeight(45)),
                      ),
                      WidgetUtils.commonSizedBox(0, 10),
                      _isEmojiPickerVisible
                          ? GestureDetector(
                              onTap: (() {
                                setState(() {
                                  _isEmojiPickerVisible = false;
                                });
                                doPostSendUserMsg(controller.text);
                              }),
                              child: Container(
                                width: 90.h,
                                height: 50.h,
                                //边框设置
                                decoration: const BoxDecoration(
                                  //背景
                                  color: MyColors.riBangBg,
                                  //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20.0)),
                                ),
                                child: WidgetUtils.onlyTextCenter(
                                    '发送',
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.white, fontSize: 28.sp)),
                              ),
                            )
                          : const Text(''),
                      _isEmojiPickerVisible == false
                          ? GestureDetector(
                              onTap: (() {
                                onTapPickFromGallery();
                              }),
                              child: WidgetUtils.showImages(
                                  'assets/images/chat_img.png',
                                  ScreenUtil().setHeight(45),
                                  ScreenUtil().setHeight(45)),
                            )
                          : const Text(''),
                      _isEmojiPickerVisible == false
                          ? WidgetUtils.commonSizedBox(0, 10)
                          : const Text(''),
                      _isEmojiPickerVisible == false
                          ? GestureDetector(
                              onTap: (() {
                                if(MyUtils.checkClick()){
                                  doPostPayPwd();
                                }
                              }),
                              child: WidgetUtils.showImages(
                                  'assets/images/chat_hongbao.png',
                                  ScreenUtil().setHeight(45),
                                  ScreenUtil().setHeight(45)),
                            )
                          : const Text(''),
                      WidgetUtils.commonSizedBox(0, 20),
                    ],
                  ),
                ),
                Visibility(
                  visible: _isEmojiPickerVisible,
                  child: SizedBox(
                    height: 450.h,
                    child: EmojiPicker(
                      onEmojiSelected: (Category? category, Emoji emoji) {},
                      onBackspacePressed: () {
                        // Do something when the user taps the backspace button (optional)
                        // Set it to null to hide the Backspace-Button
                      },
                      textEditingController: controller,
                      // pass here the same [TextEditingController] that is connected to your input field, usually a [TextFormField]
                      config: Config(
                        columns: 7,
                        emojiSizeMax: 32 *
                            (foundation.defaultTargetPlatform ==
                                    TargetPlatform.iOS
                                ? 1.30
                                : 1.0),
                        // Issue: https://github.com/flutter/flutter/issues/28894
                        verticalSpacing: 0,
                        horizontalSpacing: 0,
                        gridPadding: EdgeInsets.zero,
                        initCategory: Category.RECENT,
                        bgColor: const Color(0xFFF2F2F2),
                        indicatorColor: Colors.blue,
                        iconColor: Colors.grey,
                        iconColorSelected: Colors.blue,
                        backspaceColor: Colors.blue,
                        skinToneDialogBgColor: Colors.white,
                        skinToneIndicatorColor: Colors.grey,
                        enableSkinTones: false,
                        replaceEmojiOnLimitExceed: false,
                        recentTabBehavior: RecentTabBehavior.RECENT,
                        recentsLimit: 28,
                        noRecents: const Text(
                          'No Recents',
                          style: TextStyle(fontSize: 20, color: Colors.black26),
                          textAlign: TextAlign.center,
                        ),
                        // Needs to be const Widget
                        loadingIndicator: const SizedBox.shrink(),
                        // Needs to be const Widget
                        tabIndicatorAnimDuration: kTabScrollDuration,
                        emojiSet: defaultEmojiSets,
                        buttonMode: ButtonMode.MATERIAL,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // 头部黑名单
            isShow
                ? GestureDetector(
                    onTap: (() {
                      setState(() {
                        isShow = false;
                      });
                    }),
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      alignment: Alignment.topRight,
                      color: Colors.transparent,
                      child: Row(
                        children: [
                          const Spacer(),
                          GestureDetector(
                            onTap: (() {
                              setState(() {
                                isShow = false;
                              });
                              doPostFollow();
                              doPostUpdateBlack();
                            }),
                            child: Container(
                              height: ScreenUtil().setHeight(80),
                              width: ScreenUtil().setHeight(220),
                              margin: EdgeInsets.only(
                                  top: ScreenUtil().setHeight(100), right: 15),
                              //边框设置
                              decoration: const BoxDecoration(
                                //背景
                                color: Colors.white,
                                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10.0)),
                              ),
                              child: Row(
                                children: [
                                  const Spacer(),
                                  WidgetUtils.showImages(
                                      'assets/images/chat_black_p.png',
                                      ScreenUtil().setHeight(42),
                                      ScreenUtil().setHeight(38)),
                                  WidgetUtils.commonSizedBox(
                                      0, ScreenUtil().setHeight(10)),
                                  WidgetUtils.onlyText(
                                      isBlack == 0 ? '加入黑名单' : '移除黑名单',
                                      StyleUtils.loginHintTextStyle),
                                  const Spacer(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                : const Text(''),

            isLuZhi
                ? Center(
                    child: Container(
                      width: 300.h,
                      height: 200.h,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.black54),
                      child: isCancel == false
                          ? Stack(
                              alignment: Alignment.center,
                              children: [
                                const SVGASimpleImage(
                                  assetsName: 'assets/svga/audio_luzhi.svga',
                                ),
                                Positioned(
                                    bottom: 0,
                                    child: WidgetUtils.onlyTextCenter(
                                        '手指上滑，取消发送',
                                        StyleUtils.getCommonTextStyle(
                                            color: MyColors.g9, fontSize: 25.sp)))
                              ],
                            )
                          : Row(
                              children: [
                                const Spacer(),
                                WidgetUtils.showImages(
                                    'assets/images/chat_back.png', 50.h, 50.h),
                                WidgetUtils.commonSizedBox(0, 10.w),
                                WidgetUtils.onlyText(
                                    '松开手指，取消发送',
                                    StyleUtils.getCommonTextStyle(
                                        color: Colors.red,
                                        fontSize: 28.sp,
                                        fontWeight: FontWeight.w600)),
                                const Spacer(),
                              ],
                            ),
                    ),
                  )
                : const Text('')
          ],
        ),
      ),
    );
  }

  /// 取消关注
  Future<void> doPostFollow() async {
    Map<String, dynamic> params = <String, dynamic>{
      'type': '1',
      'status': isBlack == 0 ? '1' : '0',
      'follow_id': widget.otherUid,
    };
    try {
      CommonBean bean = await DataUtils.postFollow(params);
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

  /// 加入/取消黑名单
  Future<void> doPostUpdateBlack() async {
    //0解除 1拉黑
    Map<String, dynamic> params = <String, dynamic>{
      'type': isBlack == 0 ? '1' : '0',
      'black_uid': widget.otherUid,
    };
    try {
      CommonBean bean = await DataUtils.postUpdateBlack(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          if (isBlack == 0) {
            setState(() {
              isBlack = 1;
            });
          } else {
            setState(() {
              isBlack = 0;
            });
          }
          if (isBlack == 0) {
            MyToastUtils.showToastBottom("移除黑名单！");
          } else {
            MyToastUtils.showToastBottom("成功加入黑名单！");
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

  /// 聊天获取用户动态信息
  Future<void> doPostChatUserInfo() async {
    Map<String, dynamic> params = <String, dynamic>{
      'uid': widget.otherUid,
    };
    try {
      chatUserInfoBean bean = await DataUtils.postChatUserInfo(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          doLocationInfo();
          setState(() {
            noteId = bean.data!.noteId.toString();
            isBlack = bean.data!.black as int;
            if (bean.data!.roomInfo!.id == 0) {
              isRoomShow = false;
            } else {
              roomId = bean.data!.roomInfo!.id.toString();
              isRoomShow = true;
            }
            listImg = bean.data!.note!;
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

  /// 获取本地数据信息
  Future<void> doLocationInfo() async {
    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    // 展示聊天信息
    String combineID = '';
    if (int.parse(sp.getString('user_id').toString()) >
        int.parse(widget.otherUid)) {
      combineID = '${widget.otherUid}-${sp.getString('user_id').toString()}';
    } else {
      combineID = '${sp.getString('user_id').toString()}-${widget.otherUid}';
    }
    List<Map<String, dynamic>> result = await db.query('messageSLTable',
        columns: null, whereArgs: [combineID], where: 'combineID = ?');

    await db.update('messageSLTable', {'readStatus': 1},
        where: 'combineID = ?', whereArgs: [combineID]);

    setState(() {
      allData2 = result;
      length = allData2.length;
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scrollToLastItem(); // 在widget构建完成后滚动到底部
    });
  }

  /// 发送消息
  late List<Map<String, dynamic>> allData2;

  Future<void> doPostSendUserMsg(String content) async {
    if (content.trim().isEmpty) {
      return;
    }

    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    Map<String, dynamic> params = <String, dynamic>{
      'uid': widget.otherUid,
      'type': '1',
      'content': content
    };
    try {
      CommonBean bean = await DataUtils.postSendUserMsg(params);
      String combineID = '';
      if (int.parse(sp.getString('user_id').toString()) >
          int.parse(widget.otherUid)) {
        combineID = '${widget.otherUid}-${sp.getString('user_id').toString()}';
      } else {
        combineID = '${sp.getString('user_id').toString()}-${widget.otherUid}';
      }
      switch (bean.code) {
        case MyHttpConfig.successCode:
          LogE('===${DateTime.now()}');
          Map<String, dynamic> params = <String, dynamic>{
            'uid': sp.getString('user_id').toString(),
            'otherUid': widget.otherUid,
            'whoUid': sp.getString('user_id').toString(),
            'combineID': combineID,
            'nickName': widget.nickName,
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
          setState(() {
            controller.text = '';
          });
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
          Map<String, dynamic> params = <String, dynamic>{
            'uid': sp.getString('user_id').toString(),
            'otherUid': widget.otherUid,
            'whoUid': sp.getString('user_id').toString(),
            'combineID': combineID,
            'nickName': widget.nickName,
            'content': content,
            'headImg': myHeadImg,
            'otherHeadImg': otherHeadImg,
            'add_time': DateTime.now().millisecondsSinceEpoch,
            'type': 1,
            'number': 0,
            'status': 0,
            'readStatus': 1,
            'liveStatus': 0,
            'loginStatus': 0,
          };
          // 插入数据
          await databaseHelper.insertData('messageSLTable', params);
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      // 获取所有数据
      List<Map<String, dynamic>> result = await db.query('messageSLTable',
          columns: null, whereArgs: [combineID], where: 'combineID = ?');
      setState(() {
        allData2 = result;
        length = allData2.length;
      });
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        scrollToLastItem(); // 在widget构建完成后滚动到底部
      });
    } catch (e) {
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  onTapPickFromGallery() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    print('选择照片路径:${image?.path}');
    String? path = image?.path.toString();
    if (path!.isNotEmpty) {
      doSendFile(path);
    }
  }

  /// 发送图片
  Future<void> doSendFile(String filePath) async {
    final imgMsg = EMMessage.createImageSendMessage(
      targetId: widget.otherUid,
      filePath: filePath,
    );
    imgMsg.attributes = {
      'nickname': sp.getString('nickname'),
      'avatar': sp.getString('user_headimg'),
      'weight': 50
    };
    EMClient.getInstance.chatManager.sendMessage(imgMsg);

    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    String combineID = '';
    if (int.parse(sp.getString('user_id').toString()) >
        int.parse(widget.otherUid)) {
      combineID = '${widget.otherUid}-${sp.getString('user_id').toString()}';
    } else {
      combineID = '${sp.getString('user_id').toString()}-${widget.otherUid}';
    }
    Map<String, dynamic> params = <String, dynamic>{
      'uid': sp.getString('user_id').toString(),
      'otherUid': widget.otherUid,
      'whoUid': sp.getString('user_id').toString(),
      'combineID': combineID,
      'nickName': widget.nickName,
      'content': filePath,
      'headImg': myHeadImg,
      'otherHeadImg': otherHeadImg,
      'add_time': DateTime.now().millisecondsSinceEpoch,
      'type': 2,
      'number': 0,
      'status': 0,
      'readStatus': 1,
      'liveStatus': 0,
      'loginStatus': 0,
    };
    // 插入数据
    await databaseHelper.insertData('messageSLTable', params);
    // 获取所有数据
    List<Map<String, dynamic>> result = await db.query('messageSLTable',
        columns: null, whereArgs: [combineID], where: 'combineID = ?');
    setState(() {
      allData2 = result;
      length = allData2.length;
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scrollToLastItem(); // 在widget构建完成后滚动到底部
    });
  }

  /// 发送音频
  Future<void> doSendAudio() async {
    final voiceMsg = EMMessage.createVoiceSendMessage(
      targetId: widget.otherUid,
      filePath: _mPath,
      duration: audioNum,
    );
    voiceMsg.attributes = {
      'nickname': sp.getString('nickname'),
      'avatar': sp.getString('user_headimg'),
      'weight': 50
    };
    EMClient.getInstance.chatManager.sendMessage(voiceMsg);

    DatabaseHelper databaseHelper = DatabaseHelper();
    Database? db = await databaseHelper.database;
    String combineID = '';
    if (int.parse(sp.getString('user_id').toString()) >
        int.parse(widget.otherUid)) {
      combineID = '${widget.otherUid}-${sp.getString('user_id').toString()}';
    } else {
      combineID = '${sp.getString('user_id').toString()}-${widget.otherUid}';
    }
    Map<String, dynamic> params = <String, dynamic>{
      'uid': sp.getString('user_id').toString(),
      'otherUid': widget.otherUid,
      'whoUid': sp.getString('user_id').toString(),
      'combineID': combineID,
      'nickName': widget.nickName,
      'content': _mPath,
      'headImg': myHeadImg,
      'otherHeadImg': otherHeadImg,
      'add_time': DateTime.now().millisecondsSinceEpoch,
      'type': 3,
      'number': audioNum,
      'status': 0,
      'readStatus': 1,
      'liveStatus': 0,
      'loginStatus': 0,
    };
    // 插入数据
    await databaseHelper.insertData('messageSLTable', params);
    // 获取所有数据
    List<Map<String, dynamic>> result = await db.query('messageSLTable',
        columns: null, whereArgs: [combineID], where: 'combineID = ?');
    setState(() {
      allData2 = result;
      length = allData2.length;
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scrollToLastItem(); // 在widget构建完成后滚动到底部
    });

    //重新初始化音频信息
    setState(() {
      mediaRecord = true;
      playRecord = false; //音频文件播放状态
      hasRecord = false; //是否有音频文件可播放
      isLuZhi = false;
      isPlay = 0; //0录制按钮未点击，1点了录制了，2录制结束或者点击暂停
      djNum = 60; // 录音时长
      audioNum = 0; // 记录录了多久
    });
  }


  /// 加入房间前
  Future<void> doPostBeforeJoin(roomID) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
    };
    try {
      Loading.show();
      CommonBean bean = await DataUtils.postBeforeJoin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          doPostRoomJoin(roomID, '');
          break;
        case MyHttpConfig.errorRoomCode: //需要密码
        // ignore: use_build_context_synchronously
          MyUtils.goTransparentPageCom(
              context, RoomTSMiMaPage(roomID: roomID,));
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
  Future<void> doPostRoomJoin(roomID, password) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
      'password': password
    };
    try {
      Loading.show();
      CommonBean bean = await DataUtils.postRoomJoin(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
        // ignore: use_build_context_synchronously
          MyUtils.goTransparentRFPage(context, RoomPage(roomId: roomID,));
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

  /// 是否设置了支付密码
  Future<void> doPostPayPwd() async {
    try {
      isPayBean bean = await DataUtils.postPayPwd();
      switch (bean.code) {
        case MyHttpConfig.successCode:
        //1已设置  0未设置
          if(bean.data!.isSet == 1){
            // ignore: use_build_context_synchronously
            MyUtils.goTransparentPageCom(
                context,
                HongBaoPage(
                  uid: widget.otherUid,
                ));
          }else{
            MyToastUtils.showToastBottom('请先设置支付密码！');
            // ignore: use_build_context_synchronously
            MyUtils.goTransparentPageCom(
                context,
                const PasswordPayPage());
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
}
