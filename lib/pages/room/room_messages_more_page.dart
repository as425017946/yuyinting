import 'dart:async';
import 'dart:io';
import 'dart:convert';
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
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/pages/message/chat_recall_page.dart';
import 'package:yuyinting/pages/room/room_send_info_sl_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/widget/SwiperPage.dart';
import '../../bean/Common_bean.dart';
import '../../bean/commonStringBean.dart';
import '../../bean/isPayBean.dart';
import '../../db/DatabaseHelper.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
import '../message/geren/people_info_page.dart';
import '../message/hongbao_page.dart';
import '../mine/my/my_info_page.dart';
import '../mine/setting/password_pay_page.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

enum RecordPlayState {
  record,
  recording,
  play,
  playing,
}

/// 厅内消息详情
class RoomMessagesMorePage extends StatefulWidget {
  String otherUid;
  String otherImg;
  String nickName;

  RoomMessagesMorePage(
      {super.key,
      required this.otherUid,
      required this.otherImg,
      required this.nickName});

  @override
  State<RoomMessagesMorePage> createState() => _RoomMessagesMorePageState();
}

class _RoomMessagesMorePageState extends State<RoomMessagesMorePage>
    with MsgReadText {
  ScrollController _scrollController = ScrollController();
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  bool playRecord = false; //音频文件播放状态
  List<String> imgList = [];
  var listen, listenHB, listenSL, listenYY;
  int length = 0;
  String isGZ = '0';

  // 录音使用
  Codec _codec = Codec.aacADTS;
  bool mediaRecord = true;
  bool hasRecord = false; //是否有音频文件可播放
  int isPlay = 0; //0录制按钮未点击，1点了录制了，2录制结束或者点击暂停
  int audioNum = 0; // 记录录了多久
  bool isCancel = false, isLuZhi = false;
  FlutterSoundRecorder recorderModule = FlutterSoundRecorder();
  FlutterSoundPlayer playerModule = FlutterSoundPlayer();
  late StreamSubscription _recorderSubscription;
  RecordPlayState _state = RecordPlayState.record;
  var _path = "";
  var _maxLength = 60.0;

  // 是否有麦克风权限
  bool isMAI = false;

  // 设备是安卓还是ios
  String isDevices = 'android';
  bool isAudio = false;

  // 记录按下的时间，如果不够1s，不发音频
  int downTime = 0;

  // 如果按下和抬起的时间接口还未反应，则直接取消发送音频
  bool isSendYY = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) {
      getPermissionStatus();
      setState(() {
        isDevices = 'android';
      });
    } else if (Platform.isIOS) {
      init();
      setState(() {
        isDevices = 'ios';
      });
    }
    MyUtils.addChatListener();
    doPostUserFollowStatus();
    doLocationInfo();
    doPostCanSendRedPacket();
    _mPlayer!.openPlayer().then((value) {});
    listen = eventBus.on<SendMessageBack>().listen((event) {
      doLocationInfo();
    });
    listenHB = eventBus.on<HongBaoBack>().listen((event) {
      LogE('发送了===');
      saveHBinfo(event.info);
    });

    listenSL = eventBus.on<siliaoBack>().listen((event) {
      if (event.title == '私聊消息') {
        //判断表情发送
        if (event.info.trim().length > 50) {
          MyToastUtils.showToastBottom('单条消息要小于50个字呦~');
        } else {
          if (event.info.trim().isEmpty) {
            MyToastUtils.showToastBottom('请输入要发送的信息');
          } else {
            doPostCanSendUser(1, event.info.trim());
          }
        }
      }
    });

    listenYY = eventBus.on<SubmitButtonBack>().listen((event) {
      if (event.title == '语音发送成功') {
        successAudio(event.msg!);
      } else if (event.title == '语音发送失败') {
        //重新初始化音频信息
        setState(() {
          mediaRecord = true;
          playRecord = false; //音频文件播放状态
          hasRecord = false; //是否有音频文件可播放
          isLuZhi = false;
          isPlay = 0; //0录制按钮未点击，1点了录制了，2录制结束或者点击暂停
          _maxLength = 60.0; // 录音时长
          audioNum = 0; // 记录录了多久
        });
        MyToastUtils.showToastBottom('语音发送失败');
      }
    });
  }

  @override
  void dispose() {
    listen.cancel();
    listenHB.cancel();
    listenSL.cancel();
    listenYY.cancel();
    _mPlayer!.closePlayer();
    _mPlayer = null;
    _releaseFlauto();
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> init() async {
    // 获取权限
    await [Permission.microphone].request();
    //开启录音
    await recorderModule.openRecorder();
    var status = await Permission.storage.request();
    if (status.isGranted) {
      setState(() {
        isMAI = true;
      });
      // 用户已授予权限，可以访问文件
      // 在这里执行打开文件等操作
      LogE('权限同意');
    } else {
      setState(() {
        isMAI = false;
      });
      // 用户拒绝了权限请求，需要处理此情况
      LogE('权限拒绝');
    }
  }

  Future<bool> getPermissionStatus() async {
    Permission permission = Permission.microphone;
    //granted 通过，denied 被拒绝，permanentlyDenied 拒绝且不在提示
    PermissionStatus status = await permission.status;
    if (status.isGranted) {
      openTheRecorder();
      setState(() {
        isMAI = true;
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
      isMAI = false;
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

  Future<void> openTheRecorder() async {
    var status = await Permission.storage.request();
    if (status.isGranted) {
      // 用户已授予权限，可以访问文件
      // 在这里执行打开文件等操作
      LogE('权限同意');
    } else {
      // 用户拒绝了权限请求，需要处理此情况
      LogE('权限拒绝');
    }
    if (!kIsWeb) {
      var status = await Permission.microphone.request();
      if (status != PermissionStatus.granted) {
        throw RecordingPermissionException('Microphone permission not granted');
      }
    }
    await recorderModule!.openRecorder();
    if (!await recorderModule!.isEncoderSupported(_codec) && kIsWeb) {
      _codec = Codec.opusWebM;
      _path = 'tau_file.webm';
      if (!await recorderModule!.isEncoderSupported(_codec) && kIsWeb) {
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

  /// 开始录音
  late Timer _timer;

  /// 开始录音
  _startRecorder() async {
    try {
      Directory tempDir = await getApplicationSupportDirectory();
      var time = DateTime.now().millisecondsSinceEpoch;
      String path = '${tempDir.path}}-$time${ext[Codec.aacADTS.index]}';

      print('===>  准备开始录音');
      await recorderModule.startRecorder(
          toFile: path,
          codec: Codec.aacADTS,
          // bitRate: 128000,
          // sampleRate: 44000,
          audioSource: AudioSource.microphone);
      print('===>  开始录音');
      if (isDevices == 'ios') {
        /// 监听录音
        _recorderSubscription = recorderModule.onProgress!.listen((e) {
          if (e != null && e.duration != null) {
            DateTime date = DateTime.fromMillisecondsSinceEpoch(
                e.duration.inMilliseconds,
                isUtc: true);

            if (date.second >= _maxLength) {
              print('===>  到达时常停止录音');
              setState(() {
                audioNum = 60;
                isPlay = 2;
              });
              _stopRecorder();
              //发送录音
              doSendAudio();
            }
            setState(() {
              audioNum = date.second;
              print("录制声音：$audioNum");
              print("时间：${date.second}");
              print("当前振幅：${e.decibels}");
            });
          }
        });
        setState(() {
          _state = RecordPlayState.recording;
          _path = path;
          print("path == $path");
        });
      } else {
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (isPlay == 2) {
            LogE('停止了==');
            setState(() {
              isLuZhi = false;
            });
            _stopRecorder(); // 确保录音器停止并保存数据到文件
            timer.cancel();
          } else {
            setState(() {
              _maxLength--;
              audioNum++;
            });
          }
          if (_maxLength == 0) {
            setState(() {
              isPlay = 2;
              isLuZhi = false;
            });
            timer.cancel();
            _stopRecorder();
            //发送录音
            doSendAudio();
          }
        });
      }
      setState(() {
        _state = RecordPlayState.recording;
        _path = path;
        print("path == $path");
      });
    } catch (err) {
      setState(() {
        print(err.toString());
        _stopRecorder();
        _state = RecordPlayState.record;
      });
    }
  }

  /// 结束录音
  _stopRecorder() async {
    try {
      await recorderModule.stopRecorder();
      if (isDevices != 'ios') {
        _timer.cancel();
      }
      print('stopRecorder===> fliePath:$_path');
      _cancelRecorderSubscriptions();
    } catch (err) {
      print('stopRecorder error: $err');
    }
    setState(() {
      _state = RecordPlayState.play;
    });
  }

  /// 取消录音监听
  void _cancelRecorderSubscriptions() {
    if (_recorderSubscription != null) {
      _recorderSubscription.cancel();
    }
  }

  /// 释放录音
  Future<void> _releaseFlauto() async {
    try {
      await recorderModule.closeRecorder();
    } catch (e) {}
  }

  // 在数据变化后将滚动位置设置为最后一个item的位置
  void scrollToLastItem() {
    // _scrollController.animateTo(
    //   _scrollController.position.maxScrollExtent,
    //   duration: const Duration(milliseconds: 100),
    //   curve: Curves.easeInOut,
    // );
    _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
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
      MyUtils.didMsgRead(allData2[i]);
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
              WidgetUtils.commonSizedBox(0, 15.w),
              GestureDetector(
                onTap: (() {
                  if (MyUtils.checkClick()) {
                    // 如果点击的是自己，进入自己的主页
                    if (allData2[i]['whoUid'] != sp.getString('user_id')) {
                      sp.setString(
                          'other_id', allData2[i]['otherUid'].toString());
                      MyUtils.goTransparentRFPage(
                          context,
                          PeopleInfoPage(
                            otherId: allData2[i]['otherUid'].toString(),
                            title: '小主页',
                          ));
                    } else {
                      MyUtils.goTransparentRFPage(context, const MyInfoPage());
                    }
                  }
                }),
                child: WidgetUtils.CircleImageNet(
                    ScreenUtil().setHeight(80),
                    ScreenUtil().setHeight(80),
                    40.h,
                    allData2[i]['otherHeadNetImg']),
              ),
              WidgetUtils.commonSizedBox(0, ScreenUtil().setHeight(10)),
              // 6金豆红包
              allData2[i]['type'] == 6
                  ? hbCard(allData2[i]['content'])
                  : Flexible(
                      child: GestureDetector(
                        onLongPress: (() {
                          if (allData2[i]['type'] == 1) {
                            Clipboard.setData(ClipboardData(
                              text: allData2[i]['content'],
                            ));
                            MyToastUtils.showToastBottom('成功复制文字');
                          }
                        }),
                        child: Container(
                          constraints: BoxConstraints(
                              minWidth: ScreenUtil().setHeight(60)),
                          padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                          //边框设置
                          decoration: BoxDecoration(
                            //背景
                            color: allData2[i]['type'] == 2
                                ? Colors.transparent
                                : playColor(playRecord, i),//Colors.white,
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
                                      offset: const Offset(
                                          0, 1), // 阴影的偏移量，向右下方偏移3像素
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
                                                      'com.littledog.yyt') ||
                                              allData2[i]['content']
                                                  .toString()
                                                  .contains('storage'))
                                          ? Image(
                                              image: FileImage(
                                                  File(allData2[i]['content'])),
                                              width: 160.h,
                                              height: 200.h,
                                              errorBuilder:
                                                  (BuildContext context,
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
                                          setState(() {
                                            onPlay(i);
                                          });
                                          play(allData2[i]['content']);
                                          MyUtils.didMsgRead(allData2[i],
                                              index: 3);
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
                                                allData2[i]['number'].toString()== '0' ? "1''" : "${allData2[i]['number']}''",
                                                StyleUtils.textStyleb1),
                                            const Spacer(),
                                          ],
                                        ),
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
              // WidgetUtils.commonSizedBox(0, ScreenUtil().setHeight(100)),
              Container(
                width: ScreenUtil().setHeight(100),
                alignment: Alignment.bottomRight,
                padding: EdgeInsets.only(right: 10.h),
                child: msgReadText(allData2[i]['msgRead']),
              ),
              // 6金豆红包
              allData2[i]['type'] == 6
                  ? hbCard(allData2[i]['content'])
                  : Flexible(
                      child: GestureDetector(
                        onLongPress: (() {
                          if (allData2[i]['type'] == 1) {
                            Clipboard.setData(ClipboardData(
                              text: allData2[i]['content'],
                            ));
                            MyToastUtils.showToastBottom('成功复制文字');
                          }
                        }),
                        child: Container(
                          constraints: BoxConstraints(
                              minWidth: ScreenUtil().setHeight(60)),
                          padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
                          //边框设置
                          decoration: BoxDecoration(
                            //背景
                            color: allData2[i]['type'] == 2
                                ? Colors.transparent
                                : playColor(playRecord, i),//Colors.white,
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
                                      offset: const Offset(
                                          0, 1), // 阴影的偏移量，向右下方偏移3像素
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
                                      onLongPress:
                                          onImgLongPress(context, allData2[i]),
                                      child: Image(
                                        image: FileImage(
                                            File(allData2[i]['content'])),
                                        width: 160.h,
                                        height: 200.h,
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
                                              setState(() {
                                                onPlay(i);
                                              });
                                              play(allData2[i]['content']);
                                            }
                                          }),
                                          onLongPress: onImgLongPress(
                                              context, allData2[i]),
                                          child: Container(
                                            color: Colors.transparent,
                                            width: widthAudio,
                                            child: Row(
                                              children: [
                                                const Spacer(),
                                                WidgetUtils.onlyText(
                                                    allData2[i]['number'].toString() == '0' ? "1''" : "${allData2[i]['number']}''",
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
                    ),
              WidgetUtils.commonSizedBox(0, ScreenUtil().setHeight(10)),
              GestureDetector(
                onTap: (() {
                  if (MyUtils.checkClick()) {
                    // 如果点击的是自己，进入自己的主页
                    if (allData2[i]['whoUid'] != sp.getString('user_id')) {
                      sp.setString(
                          'other_id', allData2[i]['otherUid'].toString());
                      MyUtils.goTransparentRFPage(
                          context,
                          PeopleInfoPage(
                            otherId: allData2[i]['otherUid'].toString(),
                            title: '小主页',
                          ));
                    } else {
                      MyUtils.goTransparentRFPage(context, const MyInfoPage());
                    }
                  }
                }),
                child: WidgetUtils.CircleImageNet(
                    ScreenUtil().setHeight(80),
                    ScreenUtil().setHeight(80),
                    40.h,
                    allData2[i]['headNetImg']),
              ),
              WidgetUtils.commonSizedBox(0, 15.w),
            ],
          ),
          WidgetUtils.commonSizedBox(20.h, ScreenUtil().setHeight(10)),
        ],
      );
    }
  }

//播放录音
  void play(String audioUrls) {
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
      resizeToAvoidBottomInset: false, // 解决键盘顶起页面
      backgroundColor: Colors.transparent,
      body: WillPopScope(
        onWillPop: () async {
          //这里可以响应物理返回键
          listen.cancel();
          listenHB.cancel();
          eventBus.fire(SubmitButtonBack(title: '厅内聊天返回'));
          Navigator.of(context).pop();
          return false;
        },
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: (() {
                      if (MyUtils.checkClick()) {
                        FocusScopeNode currentFocus = FocusScope.of(context);
                        if (!currentFocus.hasPrimaryFocus &&
                            currentFocus.focusedChild != null) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                        //这里可以响应物理返回键
                        listen.cancel();
                        listenHB.cancel();
                        eventBus.fire(SubmitButtonBack(title: '厅内聊天返回'));
                        Navigator.of(context).pop();
                      }
                    }),
                    child: Container(
                      height: double.infinity,
                      width: double.infinity,
                      color: Colors.transparent,
                    ),
                  ),
                ),
                Container(
                  height: ScreenUtil().setHeight(856),
                  decoration: const BoxDecoration(
                    //设置Container修饰
                    image: DecorationImage(
                      //背景图片修饰
                      image: AssetImage("assets/images/room_tc1.png"),
                      fit: BoxFit.fill, //覆盖
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      Column(
                        children: [
                          /// 头部展示
                          SizedBox(
                            height: ScreenUtil().setHeight(80),
                            child: Row(
                              children: [
                                GestureDetector(
                                  onTap: (() {
                                    if (MyUtils.checkClick()) {
                                      //这里可以响应物理返回键
                                      eventBus.fire(
                                          SubmitButtonBack(title: '厅内聊天返回'));
                                      Navigator.of(context).pop();
                                    }
                                  }),
                                  child: Container(
                                    width: 80.h,
                                    height: 80.h,
                                    color: Colors.transparent,
                                    alignment: Alignment.center,
                                    child: WidgetUtils.showImages(
                                        'assets/images/room_message_left.png',
                                        ScreenUtil().setHeight(22),
                                        ScreenUtil().setHeight(13)),
                                  ),
                                ),
                                WidgetUtils.onlyText(
                                    widget.nickName,
                                    StyleUtils.getCommonTextStyle(
                                        color: MyColors.roomTCWZ2,
                                        fontSize: ScreenUtil().setSp(28))),
                                const Expanded(child: Text('')),
                                GestureDetector(
                                  onTap: (() {
                                    if (MyUtils.checkClick()) {
                                      doPostFollow();
                                    }
                                  }),
                                  child: SizedBox(
                                    width: ScreenUtil().setHeight(80),
                                    height: ScreenUtil().setHeight(38),
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        WidgetUtils.showImagesFill(
                                            'assets/images/room_shoucang.png',
                                            double.infinity,
                                            double.infinity),
                                        Container(
                                          width: ScreenUtil().setHeight(80),
                                          height: ScreenUtil().setHeight(38),
                                          alignment: Alignment.center,
                                          child: Text(
                                            isGZ == '0' ? '关注' : '已关注',
                                            style: StyleUtils.getCommonTextStyle(
                                                color: Colors.white,
                                                fontSize: ScreenUtil().setSp(21)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                WidgetUtils.commonSizedBox(0, 20),
                              ],
                            ),
                          ),
                          length != 0
                              ? Expanded(
                            child: Container(
                              height: double.infinity,
                              color: MyColors.roomMessageBlackBG,
                              margin: EdgeInsets.only(bottom: 140.h),
                              child: ListView.builder(
                                itemBuilder: chatWidget,
                                controller: _scrollController,
                                itemCount: allData2.length,
                              ),
                            ),
                          )
                              : const Text('')
                        ],
                      ),
                      Container(
                        height: 122.h,
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          //背景
                          color: MyColors.roomXZ1,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(35),
                              topRight: Radius.circular(35)),
                        ),
                        alignment: Alignment.center,
                        child: Row(
                          children: [
                            WidgetUtils.commonSizedBox(0, 20.h),

                            /// 音频模块先注释
                            GestureDetector(
                              onTap: (() {
                                setState(() {
                                  isAudio = !isAudio;
                                });
                              }),
                              child: isAudio
                                  ? WidgetUtils.showImages(
                                  'assets/images/chat_jianpan_white.png',
                                  ScreenUtil().setHeight(45),
                                  ScreenUtil().setHeight(45))
                                  : WidgetUtils.showImages(
                                  'assets/images/chat_huatong_white.png',
                                  ScreenUtil().setHeight(45),
                                  ScreenUtil().setHeight(45)),
                            ),
                            isAudio
                                ? Expanded(
                              child: GestureDetector(
                                onVerticalDragStart: (details) async {
                                  LogE('点击了==');
                                  //判断发送音频
                                  if (MyUtils.checkClick()) {
                                    setState(() {
                                      downTime = DateTime.now()
                                          .millisecondsSinceEpoch;
                                      isSendYY = false;
                                    });
                                    doPostCanSendUser(3, '');
                                  }
                                },
                                onVerticalDragUpdate: (details) async {
                                  LogE('上滑== ${details.delta.dy}');
                                  if (isLuZhi) {
                                    if (isDevices != 'ios' && isMAI) {
                                      if (details.delta.dy < -1) {
                                        // 停止录音
                                        _stopRecorder();
                                        setState(() {
                                          isCancel = true;
                                        });
                                      }
                                    } else {
                                      ///ios
                                      if (details.delta.dy < -1) {
                                        // 停止录音
                                        _stopRecorder();
                                        setState(() {
                                          isCancel = true;
                                        });
                                      }
                                    }
                                  }
                                },
                                onVerticalDragEnd: (details) async {
                                  LogE(
                                      '时间差 == ${(DateTime.now().millisecondsSinceEpoch - downTime)}');
                                  if ((DateTime.now()
                                      .millisecondsSinceEpoch -
                                      downTime) >=
                                      1000) {
                                    // 停止录音
                                    _stopRecorder();
                                    if (isLuZhi) {
                                      if (isDevices != 'ios' && isMAI) {
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
                                            _maxLength = 60; // 录音时长
                                            audioNum = 0; // 记录录了多久
                                          });
                                        } else {
                                          LogE('发送录音 2');
                                          //发送录音
                                          doSendAudio();
                                        }
                                      } else {
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
                                            _maxLength = 60; // 录音时长
                                            audioNum = 0; // 记录录了多久
                                          });
                                        } else {
                                          LogE('发送录音 2');
                                          //发送录音
                                          doSendAudio();
                                        }
                                      }
                                    }
                                  } else {
                                    setState(() {
                                      isSendYY = true;
                                    });
                                    // 停止录音
                                    _stopRecorder();
                                    MyToastUtils.showToastBottom('录音时长过短！');
                                    //重新初始化音频信息
                                    setState(() {
                                      mediaRecord = true;
                                      playRecord = false; //音频文件播放状态
                                      hasRecord = false; //是否有音频文件可播放
                                      isLuZhi = false;
                                      isPlay =
                                      0; //0录制按钮未点击，1点了录制了，2录制结束或者点击暂停
                                      _maxLength = 60; // 录音时长
                                      audioNum = 0; // 记录录了多久
                                    });
                                  }
                                },
                                child: Container(
                                  width: double.infinity,
                                  height: ScreenUtil().setHeight(80),
                                  margin: EdgeInsets.only(
                                      left: 20.h, right: 20.h),
                                  padding: EdgeInsets.only(
                                      left: 20.h, right: 20.h),
                                  alignment: Alignment.center,
                                  //边框设置
                                  decoration: const BoxDecoration(
                                    //背景
                                    color: MyColors.f2,
                                    //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(30.0)),
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
                                child: GestureDetector(
                                  onTap: (() {
                                    if (MyUtils.checkClick()) {
                                      MyUtils.goTransparentPage(
                                          context, const RoomSendInfoSLPage());
                                    }
                                  }),
                                  child: Container(
                                    height: 78.h,
                                    width: double.infinity,
                                    margin: EdgeInsets.only(
                                        left: 20.h, right: 20.h),
                                    padding: EdgeInsets.only(
                                        left: 20.h, right: 20.h),
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: MyColors.roomXZ2,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius:
                                      BorderRadius.all(Radius.circular(38)),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      '请输入信息...',
                                      style: StyleUtils.loginHintTextStyle,
                                    ),
                                  ),
                                )),
                            GestureDetector(
                              onTap: (() {
                                //判断图片发送
                                if (MyUtils.checkClick()) {
                                  doPostCanSendUser(2, '');
                                }
                              }),
                              child: WidgetUtils.showImages(
                                  'assets/images/chat_img_white.png',
                                  ScreenUtil().setHeight(45),
                                  ScreenUtil().setHeight(45)),
                            ),
                            WidgetUtils.commonSizedBox(0, 10.h),
                            isHB ? GestureDetector(
                              onTap: (() {
                                if (MyUtils.checkClick()) {
                                  doPostCanSendUser(4, '');
                                }
                              }),
                              child: WidgetUtils.showImages(
                                  'assets/images/chat_hongbao.png',
                                  ScreenUtil().setHeight(45),
                                  ScreenUtil().setHeight(45)),
                            ) : const Text(''),
                            WidgetUtils.commonSizedBox(0, 20.h),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
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
        whereArgs: [combineID, sp.getString('user_id')],
        where: 'combineID = ? and uid = ?');

    setState(() {
      allData2 = result;
      length = allData2.length;
    });
    for (int i = 0; i < allData2.length; i++) {
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
      // CommonBean bean = await DataUtils.postSendUserMsg(params);
      CommonBean bean = await DataUtils.postCanSendUser(params);
      String combineID = '';
      if (int.parse(sp.getString('user_id').toString()) >
          int.parse(widget.otherUid)) {
        combineID = '${widget.otherUid}-${sp.getString('user_id').toString()}';
      } else {
        combineID = '${sp.getString('user_id').toString()}-${widget.otherUid}';
      }
      switch (bean.code) {
        case MyHttpConfig.successCode:
          final textMsg = EMMessage.createTxtSendMessage(
            targetId: widget.otherUid,
            content: content,
          );
          textMsg.attributes = {
            'nickname': sp.getString('nickname'),
            'avatar': sp.getString('user_headimg'),
            'weight': 50,
          };
          EMClient.getInstance.chatManager.sendMessage(textMsg);

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
            'msgId': '',
            'msgRead': 2,
            'msgJson': textMsg.msgId,
          };
          // 插入数据
          await databaseHelper.insertData('messageSLTable', params);
          break;
        case MyHttpConfig.errorloginCode:
          // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 查询关注状态
  Future<void> doPostUserFollowStatus() async {
    Map<String, dynamic> params = <String, dynamic>{
      'follow_id': widget.otherUid,
      'type': '1',
    };
    try {
      CommonStringBean bean = await DataUtils.postUserFollowStatus(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            isGZ = bean.data!.status!;
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 关注还是取关
  Future<void> doPostFollow() async {
    Map<String, dynamic> params = <String, dynamic>{
      'type': '1',
      'status': isGZ == '0' ? '1' : '0',
      'follow_id': widget.otherUid,
    };
    try {
      CommonBean bean = await DataUtils.postFollow(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          if (isGZ == '0') {
            setState(() {
              isGZ = '1';
            });
            MyToastUtils.showToastBottom("关注成功！");
          } else {
            setState(() {
              isGZ = '0';
            });
            MyToastUtils.showToastBottom("取消关注成功！");
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
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
                  nickName: widget.nickName,
                  otherImg: widget.otherImg,
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 能否发私聊
  Future<void> doPostCanSendUser(int type, String info) async {
    Map<String, dynamic> params = <String, dynamic>{'uid': widget.otherUid};
    try {
      CommonBean bean = await DataUtils.postCanSendUser(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          //可以发私聊跳转 type 1发表情 2图片 3录音 4红包
          if (type == 1) {
            MyUtils.sendMessage(widget.otherUid, info);
            doPostSendUserMsg(info);
          } else if (type == 2) {
            onTapPickFromGallery();
          } else if (type == 3) {
            if (isSendYY == false) {
              if (isDevices != 'ios' && isMAI) {
                setState(() {
                  // 开始录音
                  _startRecorder();
                  audioNum = 0; // 记录录了多久
                  isLuZhi = true;
                });
              } else {
                /// ios
                setState(() {
                  // 开始录音
                  _startRecorder();
                  audioNum = 0; // 记录录了多久
                  isLuZhi = true;
                });
              }
            }
          } else if (type == 4) {
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
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
      'msgId': '',
      'msgRead': 2,
      'msgJson': imgMsg.msgId,
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
    LogE('录音地址==  $_path');
    LogE('录音地址==  $audioNum');
    File file = File(_path);
    if (await file.exists()) {
      final voiceMsg = EMMessage.createVoiceSendMessage(
        targetId: widget.otherUid,
        filePath: _path,
        duration: audioNum,
      );
      voiceMsg.attributes = {
        'nickname': sp.getString('nickname'),
        'avatar': sp.getString('user_headimg'),
        'weight': 50
      };
      EMClient.getInstance.chatManager.sendMessage(voiceMsg);
    } else {
      MyToastUtils.showToastBottom('录音失败，请重新录制');
      //重新初始化音频信息
      setState(() {
        mediaRecord = true;
        playRecord = false; //音频文件播放状态
        hasRecord = false; //是否有音频文件可播放
        isLuZhi = false;
        isPlay = 0; //0录制按钮未点击，1点了录制了，2录制结束或者点击暂停
        _maxLength = 60; // 录音时长
        audioNum = 0; // 记录录了多久
      });
    }
  }

  /// 发送成功音频记录到本地
  successAudio(EMMessage msg) async {
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
      'content': _path,
      'headNetImg': sp.getString('user_headimg').toString(),
      'otherHeadNetImg': widget.otherImg,
      'add_time': DateTime.now().millisecondsSinceEpoch,
      'type': 3,
      'number': (msg.body as EMVoiceMessageBody).duration, //audioNum,
      'status': 0,
      'readStatus': 1,
      'liveStatus': 0,
      'loginStatus': 0,
      'weight': widget.otherUid.toString() == '1' ? 1 : 0,
      'msgId': msg.msgId,
      'msgRead': 2,
      'msgJson': jsonEncode(msg.toJson()),
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
      _maxLength = 60; // 录音时长
      audioNum = 0; // 记录录了多久
    });
  }


  bool isHB = false;
  /// 是否有发红包权限
  Future<void> doPostCanSendRedPacket() async {
    try {
      CommonBean bean = await DataUtils.postCanSendRedPacket();
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            isHB = true;
          });
          break;
        case MyHttpConfig.errorloginCode:
        // ignore: use_build_context_synchronously
          MyUtils.jumpLogin(context);
          break;
        default:
        // MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
