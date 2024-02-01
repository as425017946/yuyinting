import 'dart:async';
import 'dart:io';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:audio_session/audio_session.dart';
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
import '../../bean/joinRoomBean.dart';
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
import 'package:flutter/foundation.dart' show kIsWeb;

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
  // 记录按下的时间，如果不够1s，不发音频
  int downTime =0;
  // 如果按下和抬起的时间接口还未反应，则直接取消发送音频
  bool isSendYY = true;
  int isBlack = 0, length = 0;
  String roomName = '', noteId = '', roomId = '';
  List<String> listImg = [];
  List<String> imgList = [];
  TextEditingController controller = TextEditingController();
  ScrollController _scrollController = ScrollController();
  var listen, listenHB,listenYY;

  // 录音使用
  Codec _codec = Codec.aacADTS;
  String _mPath = ''; //录音文件路径
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  //录制权限
  bool _voiceRecorderIsInitialized = false;
  bool mediaRecord = true;
  bool playRecord = false; //音频文件播放状态
  bool hasRecord = false; //是否有音频文件可播放
  int isPlay = 0; //0录制按钮未点击，1点了录制了，2录制结束或者点击暂停
  int djNum = 60; // 录音时长
  int audioNum = 0; // 记录录了多久
  bool isCancel = false, isLuZhi = false;

  bool _isEmojiPickerVisible = false;
  FocusNode? _focusNode;
  // 是否有录音权限
  bool isQuanxian = false;

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

  // 设备是安卓还是ios
  String isDevices = 'android';
  @override
  void initState() {
    // TODO: implement initState
    if (Platform.isAndroid) {
      getPermissionStatus();
      setState(() {
        isDevices = 'android';
      });
    }else if (Platform.isIOS){
      setState(() {
        isDevices = 'ios';
      });
      //获取权限
      initAgora();
    }
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
    listenYY = eventBus.on<SubmitButtonBack>().listen((event) {
      if(event.title == '语音发送成功'){
        successAudio();
      }else if(event.title == '语音发送失败'){
        MyToastUtils.showToastBottom('语音发送失败');
      }
    });

    _focusNode = FocusNode();
    _focusNode!.addListener(_onFocusChange);
  }

  // 初始化应用
  Future<void> initAgora() async {
    // 获取权限
    await [Permission.microphone].request();
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
      'headNetImg': sp.getString('user_headimg').toString(),
      'otherHeadNetImg': widget.otherImg,
      'add_time': DateTime.now().millisecondsSinceEpoch,
      'type': 6,
      'number': 0,
      'status': 1,
      'readStatus': 1,
      'liveStatus': 0,
      'loginStatus': 0,
      'weight': widget.otherUid.toString() == '1' ? 1 : 0,
    };
    // 插入数据
    await databaseHelper.insertData('messageSLTable', params);
    // 获取所有数据
    List<Map<String, dynamic>> result = await db.query('messageSLTable',
        columns: null,
        whereArgs: [combineID, sp.getString('user_id')],
        where: 'combineID = ? and uid = ?');

    setState(() {
      allData2 = result;
      length = allData2.length;
    });
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      scrollToLastItem(); // 在widget构建完成后滚动到底部
    });
  }


  void _initialize() async {
    await _mPlayer!.closePlayer();
    await _mPlayer!.openPlayer();
    await _mRecorder!.openRecorder().then((value) {
      setState(() {
        _voiceRecorderIsInitialized = true;
      });
    });
    openTheRecorder();
  }


  @override
  void dispose() {
    listen.cancel();
    listenHB.cancel();
    listenYY.cancel();
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
      if(hour < 10 && minute < 10){
        addTime = '0$hour:0$minute';
      }else if(hour < 10 && minute > 10){
        addTime = '0$hour:$minute';
      }else if(hour > 10 && minute < 10){
        addTime = '$hour:0$minute';
      }
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
              WidgetUtils.CircleImageNet(
                  ScreenUtil().setHeight(80),
                  ScreenUtil().setHeight(80),
                  40.h,
                  allData2[i]['otherHeadNetImg']),
              WidgetUtils.commonSizedBox(0, ScreenUtil().setHeight(10)),
              // 6v豆红包
              allData2[i]['type'] == 6
                  ? SizedBox(
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
                                  WidgetUtils.commonSizedBox(0, 50.h),
                                  WidgetUtils.onlyText(
                                      allData2[i]['content'],
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize: 25.sp)),
                                ],
                              ))
                        ],
                      ),
                    )
                  : Flexible(
                      child: Container(
                        constraints: BoxConstraints(
                            minWidth: ScreenUtil().setHeight(60)),
                        padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                        //边框设置
                        decoration: BoxDecoration(
                          //背景
                          color: allData2[i]['type'] == 2
                              ? Colors.transparent
                              : Colors.white,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(0),
                              topRight: Radius.circular(20.0),
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0)),
                          boxShadow: allData2[i]['type'] == 2
                              ? []
                              : [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset:
                                        const Offset(0, 1), // 阴影的偏移量，向右下方偏移3像素
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
                                      MyUtils.goTransparentPageCom(context,
                                          SwiperPage(imgList: imgList));
                                    }),
                                    child: (allData2[i]['content']
                                                .toString()
                                                .contains(
                                                    'com.leimu.yuyinting') ||
                                            allData2[i]['content']
                                                .toString()
                                                .contains('storage'))
                                        ? Image(
                                            image: FileImage(
                                                File(allData2[i]['content'])),
                                            width: 160.h,
                                            height: 200.h,
                                            fit: BoxFit.cover,
                                            errorBuilder: (BuildContext context,
                                                Object error,
                                                StackTrace? stackTrace) {
                                              return WidgetUtils.showImages(
                                                  'assets/images/img_placeholder.png',
                                                  200.h,
                                                  160.h);
                                            },
                                          )
                                        : WidgetUtils.showImagesNet(
                                            allData2[i]['content'].toString(),
                                            200.h,
                                            160.h),
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
                                    child: Container(
                                      color: Colors.transparent,
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
              allData2[i]['type'] == 6
                  ? SizedBox(
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
                                  WidgetUtils.commonSizedBox(0, 50.h),
                                  WidgetUtils.onlyText(
                                      allData2[i]['content'],
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize: 25.sp)),
                                ],
                              ))
                        ],
                      ),
                    )
                  : Flexible(
                      child: Container(
                        constraints: BoxConstraints(
                            minWidth: ScreenUtil().setHeight(60)),
                        padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                        //边框设置
                        decoration: BoxDecoration(
                          //背景
                          color: allData2[i]['type'] == 2
                              ? Colors.transparent
                              : Colors.white,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20.0),
                              topRight: Radius.circular(0),
                              bottomLeft: Radius.circular(20.0),
                              bottomRight: Radius.circular(20.0)),
                          boxShadow: allData2[i]['type'] == 2
                              ? []
                              : [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset:
                                        const Offset(0, 1), // 阴影的偏移量，向右下方偏移3像素
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
                                      MyUtils.goTransparentPageCom(context,
                                          SwiperPage(imgList: imgList));
                                    }),
                                    child: Image(
                                      image: FileImage(
                                          File(allData2[i]['content'])),
                                      width: 160.h,
                                      height: 200.h,
                                      fit: BoxFit.cover,
                                      errorBuilder: (BuildContext context,
                                          Object error,
                                          StackTrace? stackTrace) {
                                        return WidgetUtils.showImages(
                                            'assets/images/img_placeholder.png',
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
                                        child: Container(
                                          color: Colors.transparent,
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
                                      )
                                    : const Text(''),
                      ),
                    ),
              WidgetUtils.commonSizedBox(0, ScreenUtil().setHeight(10)),
              WidgetUtils.CircleImageNet(
                  ScreenUtil().setHeight(80),
                  ScreenUtil().setHeight(80),
                  40.h,
                  allData2[i]['headNetImg']),
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
      setState(() {
        isQuanxian = true;
      });
      return true;
    } else if (status.isDenied) {
      requestPermission(permission);
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else if (status.isRestricted) {
      requestPermission(permission);
    } else {}
    setState(() {
      isQuanxian = false;
    });
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
    try{
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
    }catch(e){
      MyToastUtils.showToastBottom('录音出错 $e');
    }
  }

  Future<void> openTheRecorder() async {
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await _mRecorder!.openRecorder();
    if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _mPath = 'tau_file.webm';
      if (!await _mRecorder!.isEncoderSupported(_codec) && kIsWeb) {
        return;
      }
    }
    final session = await AudioSession.instance;
    await session.configure(AudioSessionConfiguration(
      avAudioSessionCategory: AVAudioSessionCategory.playAndRecord,
      avAudioSessionCategoryOptions:
      AVAudioSessionCategoryOptions.allowBluetooth |
      AVAudioSessionCategoryOptions.defaultToSpeaker,
      avAudioSessionMode: AVAudioSessionMode.spokenAudio,
      avAudioSessionRouteSharingPolicy:
      AVAudioSessionRouteSharingPolicy.defaultPolicy,
      avAudioSessionSetActiveOptions: AVAudioSessionSetActiveOptions.none,
      androidAudioAttributes: const AndroidAudioAttributes(
        contentType: AndroidAudioContentType.speech,
        flags: AndroidAudioFlags.none,
        usage: AndroidAudioUsage.voiceCommunication,
      ),
      androidAudioFocusGainType: AndroidAudioFocusGainType.gain,
      androidWillPauseWhenDucked: true,
    ));
  }
//开始录音
  void record() async {
    try {
      if(isDevices != 'ios' && !isQuanxian) {
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
      // 文件名称
      String path = '${appDir.path}/$time${ext[Codec.aacADTS.index]}';
      // // Directory folderDir = Directory('$appDir/$folderName');
      // Directory folderDir = Directory(path);
      // if (!folderDir.existsSync()) {
      //   folderDir.createSync();
      // }
      setState(() {
        _mPath = path;
      });
      await _mRecorder!.openRecorder();
      LogE('录音地址:$path');
      _mRecorder!
          .startRecorder(
        toFile: path,
        codec:  _codec,
        audioSource: AudioSource.microphone,
      )
          .then((value) {
        setState(() {
          mediaRecord = false;
          hasRecord = false;
          _mPath = path;
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
    await _mRecorder!.closeRecorder();
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
          listen.cancel();
          listenHB.cancel();
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
                            listen.cancel();
                            listenHB.cancel();
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
                          width: ScreenUtil().setWidth(120),
                          height: 50.h,
                          color: Colors.transparent,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(right: 15),
                          child: WidgetUtils.showImages(
                              'assets/images/chat_dian.png',
                              ScreenUtil().setHeight(30),
                              ScreenUtil().setHeight(50)),
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
                    MyUtils.goTransparentRFPage(context,
                        TrendsMorePage(note_id: noteId, index: 999));
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
                      ? GestureDetector(
                    onTap: () {
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus &&
                          currentFocus.focusedChild != null) {
                        FocusManager.instance.primaryFocus?.unfocus();
                      }
                    },
                        child: ListView.builder(
                    padding: EdgeInsets.only(
                          left: ScreenUtil().setHeight(20),
                          right: ScreenUtil().setHeight(20)),
                    controller: _scrollController,
                    itemBuilder: chatWidget,
                    itemCount: allData2.length,
                  ),
                      )
                      : const Text(''),
                ),
                // 底部键盘
                Container(
                  height: isDevices == 'ios' ? 140.h : 120.h,
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
                      // 发送音频
                      isAudio
                          ? Expanded(
                        child: GestureDetector(
                          onVerticalDragStart: (details) async {
                            //判断发送音频
                            if (MyUtils.checkClick()) {
                              setState(() {
                                downTime = DateTime.now().millisecondsSinceEpoch;
                                isSendYY = false;
                              });
                              doPostCanSendUser(3);
                            }
                          },
                          onVerticalDragUpdate: (details) async {
                            LogE('上滑== $isQuanxian');
                            if(isLuZhi) {
                              if (isDevices != 'ios' && isQuanxian) {
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
                              }else{
                                ///ios
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
                            }
                          },
                          onVerticalDragEnd: (details) async {
                            LogE('时间差 == ${(DateTime.now().millisecondsSinceEpoch - downTime)}');
                            if((DateTime.now().millisecondsSinceEpoch - downTime) >=1000){
                              // 停止录音
                              stopRecorder();
                              if(isLuZhi) {
                                if (isDevices != 'ios' && isQuanxian) {
                                  // 取消录音后抬起手指
                                  if (isCancel) {
                                    LogE('发送录音 1');
                                    //重新初始化音频信息
                                    setState(() {
                                      isCancel = false;
                                      mediaRecord = true;
                                      playRecord = false; //音频文件播放状态
                                      hasRecord = false; //是否有音频文件可播放
                                      isLuZhi = false;
                                      isPlay =
                                      0; //0录制按钮未点击，1点了录制了，2录制结束或者点击暂停
                                      djNum = 60; // 录音时长
                                      audioNum = 0; // 记录录了多久
                                    });
                                  }else{
                                    LogE('发送录音 2');
                                    //发送录音
                                    doSendAudio();
                                  }
                                }else{
                                  /// ios
                                  // 取消录音后抬起手指
                                  if (isCancel) {
                                    LogE('发送录音 1');
                                    //重新初始化音频信息
                                    setState(() {
                                      isCancel = false;
                                      mediaRecord = true;
                                      playRecord = false; //音频文件播放状态
                                      hasRecord = false; //是否有音频文件可播放
                                      isLuZhi = false;
                                      isPlay =
                                      0; //0录制按钮未点击，1点了录制了，2录制结束或者点击暂停
                                      djNum = 60; // 录音时长
                                      audioNum = 0; // 记录录了多久
                                    });
                                  }else{
                                    LogE('发送录音 2');
                                    //发送录音
                                    doSendAudio();
                                  }
                                }
                              }
                            }else{
                              setState(() {
                                isSendYY = true;
                              });
                              // 停止录音
                              stopRecorder();
                              MyToastUtils.showToastBottom(
                                  '录音时长过短！');
                              //重新初始化音频信息
                              setState(() {
                                mediaRecord = true;
                                playRecord = false; //音频文件播放状态
                                hasRecord = false; //是否有音频文件可播放
                                isLuZhi = false;
                                isPlay =
                                0; //0录制按钮未点击，1点了录制了，2录制结束或者点击暂停
                                djNum = 60; // 录音时长
                                audioNum = 0; // 记录录了多久
                              });
                            }
                          },
                          child: Container(
                            width: double.infinity,
                            height: ScreenUtil().setHeight(60),
                            padding: const EdgeInsets.only(
                                left: 10, right: 10),
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
                              LengthLimitingTextInputFormatter(
                                  25) //限制输入长度
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

                              contentPadding: const EdgeInsets.only(
                                  top: 0, bottom: 0),
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
                          //判断表情发送
                          if (MyUtils.checkClick()) {
                            if(controller.text.length > 25){
                              MyToastUtils.showToastBottom('单条消息要小于25个字呦~');
                            }else{
                              doPostCanSendUser(1);
                            }
                          }
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
                          //判断图片发送
                          if (MyUtils.checkClick()) {
                            doPostCanSendUser(2);
                          }
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
                          //判断红包发送
                          if (MyUtils.checkClick()) {
                            doPostCanSendUser(4);
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
                      onEmojiSelected: (Category? category, Emoji emoji) {

                      },
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
                                color: MyColors.g9,
                                fontSize: 25.sp)))
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
        columns: null,
        whereArgs: [combineID, sp.getString('user_id')],
        where: 'combineID = ? and uid = ?');

    await db.update('messageSLTable', {'readStatus': 1},
        whereArgs: [combineID], where: 'combineID = ?');

    setState(() {
      allData2 = result;
      length = allData2.length;
    });
    for(int i =0; i < allData2.length; i++){
      // 更新头像和昵称
      await db.update(
          'messageSLTable',
          {
            'headNetImg': sp.getString('user_headimg').toString(),
          },
          whereArgs: [allData2[i]['uid']],
          where: 'uid = ?');
    }
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
            'headNetImg': sp.getString('user_headimg').toString(),
            'otherHeadNetImg': widget.otherImg,
            'add_time': DateTime.now().millisecondsSinceEpoch,
            'type': 1,
            'number': 0,
            'status': 1,
            'readStatus': 1,
            'liveStatus': 0,
            'loginStatus': 0,
            'weight': widget.otherUid.toString() == '1' ? 1 : 0,
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
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
      // 获取所有数据
      List<Map<String, dynamic>> result = await db.query('messageSLTable',
          columns: null,
          whereArgs: [combineID, sp.getString('user_id')],
          where: 'combineID = ? and uid = ?');

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
      'headNetImg': sp.getString('user_headimg').toString(),
      'otherHeadNetImg': widget.otherImg,
      'add_time': DateTime.now().millisecondsSinceEpoch,
      'type': 2,
      'number': 0,
      'status': 0,
      'readStatus': 1,
      'liveStatus': 0,
      'loginStatus': 0,
      'weight': widget.otherUid.toString() == '1' ? 1 : 0,
    };
    // 插入数据
    await databaseHelper.insertData('messageSLTable', params);
    // 获取所有数据
    List<Map<String, dynamic>> result = await db.query('messageSLTable',
        columns: null,
        whereArgs: [combineID, sp.getString('user_id')],
        where: 'combineID = ? and uid = ?');

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
    LogE('录音地址==  $_mPath');
    File file = File(_mPath);
    if(await file.exists()){
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
    }else{
      MyToastUtils.showToastBottom('录音失败，请重新录制');
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
  }

  /// 发送成功音频记录到本地
  successAudio() async{
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
      'headNetImg': sp.getString('user_headimg').toString(),
      'otherHeadNetImg': widget.otherImg,
      'add_time': DateTime.now().millisecondsSinceEpoch,
      'type': 3,
      'number': audioNum,
      'status': 0,
      'readStatus': 1,
      'liveStatus': 0,
      'loginStatus': 0,
      'weight': widget.otherUid.toString() == '1' ? 1 : 0,
    };
    // 插入数据
    await databaseHelper.insertData('messageSLTable', params);
    // 获取所有数据
    List<Map<String, dynamic>> result = await db.query('messageSLTable',
        columns: null,
        whereArgs: [combineID, sp.getString('user_id')],
        where: 'combineID = ? and uid = ?');

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
    //判断房间id是否为空的
    if (sp.getString('roomID') == null || sp.getString('').toString().isEmpty) {
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

  /// 是否设置了支付密码
  Future<void> doPostPayPwd() async {
    try {
      isPayBean bean = await DataUtils.postPayPwd();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          //1已设置  0未设置
          if (bean.data!.isSet == 1) {
            // ignore: use_build_context_synchronously
            MyUtils.goTransparentPageCom(
                context,
                HongBaoPage(
                  uid: widget.otherUid,
                ));
          } else {
            MyToastUtils.showToastBottom('请先设置支付密码！');
            // ignore: use_build_context_synchronously
            MyUtils.goTransparentPageCom(context, const PasswordPayPage());
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

  /// 能否发私聊
  Future<void> doPostCanSendUser(int type) async {
    Map<String, dynamic> params = <String, dynamic>{'uid': widget.otherUid};
    try {
      CommonBean bean = await DataUtils.postCanSendUser(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
        //可以发私聊跳转 type 1发表情 2图片 3录音 4红包
          if(type == 1){
            setState(() {
              _isEmojiPickerVisible = false;
            });
            doPostSendUserMsg(controller.text);
          }else if(type == 2){
            onTapPickFromGallery();
          }else if(type == 3){
            if(isSendYY == false) {
              if (isDevices != 'ios' && isQuanxian) {
                // 开始录音
                startRecord();
                setState(() {
                  audioNum = 0; // 记录录了多久
                  isLuZhi = true;
                });
              }else{
                /// ios
                // 开始录音
                startRecord();
                setState(() {
                  audioNum = 0; // 记录录了多久
                  isLuZhi = true;
                });
              }
            }
          }else if(type == 4){
            doPostPayPwd();
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
