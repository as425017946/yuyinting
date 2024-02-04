import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:flutter_sound/public/flutter_sound_player.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../bean/labelListBean.dart';
import '../../../colors/my_colors.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/event_utils.dart';
import '../../../utils/loading.dart';
import '../../../utils/log_util.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import '../../../widget/SVGASimpleImage.dart';

enum RecordPlayState {
  record,
  recording,
  play,
  playing,
}


/// 声音录制
class EditAudioPage extends StatefulWidget {
  String audioUrl;

  EditAudioPage({Key? key, required this.audioUrl}) : super(key: key);

  @override
  State<EditAudioPage> createState() => _EditAudioPageState();
}

class _EditAudioPageState extends State<EditAudioPage> {
  var appBar;
  List<Data> list = [];
  List<bool> list_b = [];
  int length = 1;

  Codec _codec = Codec.aacADTS;
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();

  bool _mPlayerIsInited = false;
  bool mediaRecord = true;
  bool playRecord = false; //音频文件播放状态
  bool hasRecord = false; //是否有音频文件可播放
  int isPlay = 0; //0录制按钮未点击，1点了录制了，2录制结束或者点击暂停
  int djNum = 15; // 录音时长
  int audioNum = 0; // 记录录了多久
  String recordText = '点击录音';
  String audioUrl = '';
  // 设备是安卓还是ios
  String isDevices = 'android';

  FlutterSoundRecorder recorderModule = FlutterSoundRecorder();
  FlutterSoundPlayer playerModule = FlutterSoundPlayer();
  late StreamSubscription _recorderSubscription;
  late StreamSubscription _playerSubscription;
  RecordPlayState _state = RecordPlayState.record;
  var _path = "";
  var _duration = 0.0;
  var _maxLength = 15.0;
  // 是否有麦克风权限
  bool isMAI = false;
  @override
  void initState() {
    // TODO: implement initState
    if (Platform.isAndroid) {
      getPermissionStatus();
      setState(() {
        isDevices = 'android';
      });
    }else if (Platform.isIOS){
      getPermissionStatus();
      init();
      setState(() {
        isDevices = 'ios';
      });
    }
    _mPlayer!.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
    super.initState();
    appBar = WidgetUtils.getAppBar('声音录制', true, context, false, 0);
    // doPostLabelList();
    setState(() {
      audioUrl = widget.audioUrl;
    });
  }


  @override
  void dispose() {
    _mPlayer!.closePlayer();
    _mPlayer = null;
    _cancelRecorderSubscriptions();
    _releaseFlauto();
    super.dispose();
  }

  Future<void> init() async {
    //开启录音
    await recorderModule.openRecorder();
    //设置订阅计时器
    await recorderModule
        .setSubscriptionDuration(const Duration(milliseconds: 10));
    //设置音频
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
    await playerModule.closePlayer();
    await playerModule.openPlayer();
    await playerModule
        .setSubscriptionDuration(const Duration(milliseconds: 10));
  }

  Future<bool> getPermissionStatus() async {
    Permission permission = Permission.microphone;
    //granted 通过，denied 被拒绝，permanentlyDenied 拒绝且不在提示
    PermissionStatus status = await permission.status;
    if (status.isGranted) {
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
  /// 开始录音
  _startRecorder() async {
    try {
      Directory tempDir = await getTemporaryDirectory();
      var time = DateTime.now().millisecondsSinceEpoch;
      String path =
          '${tempDir.path}}-$time${ext[Codec.aacADTS.index]}' ;

      print('===>  准备开始录音');
      await recorderModule.startRecorder(
          toFile: path,
          codec: Codec.aacADTS,
          bitRate: 8000,
          sampleRate: 8000,
          audioSource: AudioSource.microphone);
      print('===>  开始录音');

      /// 监听录音
      _recorderSubscription = recorderModule.onProgress!.listen((e) {
        if (e != null && e.duration != null) {
          DateTime date = DateTime.fromMillisecondsSinceEpoch(
              e.duration.inMilliseconds,
              isUtc: true);

          if (date.second >= _maxLength) {
            print('===>  到达时常停止录音');
            setState(() {
              recordText = '已完成录制${date.second}s';
              isPlay = 2;
            });
            _stopRecorder();
          }
          setState(() {
            recordText = '已录制${date.second}s';
            print("名称：$recordText");
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

//播放录音
  void play() async{
    LogE('录音地址$_path');
    LogE('录音地址**$audioUrl');
    await _mPlayer!
        .startPlayer(
            fromURI: _path == "" ? audioUrl : _path,
            codec: _codec,
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
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// 头部
          Stack(
            children: [
              WidgetUtils.showImagesFill('assets/images/mine_audio_bg.jpg',
                  ScreenUtil().setHeight(280), double.infinity),
              Container(
                height: ScreenUtil().setHeight(280),
                width: double.infinity,
                padding: const EdgeInsets.only(left: 20, right: 20),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    WidgetUtils.commonSizedBox(20, 0),
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 5, //边框设置
                          decoration: const BoxDecoration(
                            //背景
                            color: Colors.white,
                            //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                            borderRadius:
                                BorderRadius.all(Radius.circular(10.0)),
                          ),
                        ),
                        WidgetUtils.commonSizedBox(0, 5),
                        WidgetUtils.onlyText(
                            '我的声音',
                            StyleUtils.getCommonTextStyle(
                                color: Colors.white,
                                fontSize: ScreenUtil().setSp(36),
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                    WidgetUtils.commonSizedBox(20, 0),
                    WidgetUtils.onlyTextCenter(
                        audioUrl.isEmpty ? '你还没有录制声音哦~' : '已录制声音',
                        StyleUtils.getCommonTextStyle(
                            color: Colors.white,
                            fontSize: ScreenUtil().setSp(28),
                            fontWeight: FontWeight.w600)),
                    WidgetUtils.commonSizedBox(10, 0),
                    GestureDetector(
                      onTap: (() {
                        if (MyUtils.checkClick()) {
                          play();
                        }
                      }),
                      child: Container(
                        height: ScreenUtil().setHeight(50),
                        width: ScreenUtil().setWidth(220),
                        padding: const EdgeInsets.only(left: 8),
                        alignment: Alignment.topLeft,
                        //边框设置
                        decoration: const BoxDecoration(
                          //背景
                          color: MyColors.peopleYellow,
                          //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                                child: SVGASimpleImage(
                                  assetsName:
                                  'assets/svga/audio_xindiaotu.svga',
                                )),
                            WidgetUtils.commonSizedBox(0, 10.h),
                            WidgetUtils.showImages(
                                'assets/images/people_bofang.png',
                                ScreenUtil().setHeight(35),
                                ScreenUtil().setWidth(35)),
                            WidgetUtils.commonSizedBox(0, 10.h),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),

          /// 语音录制
          Transform.translate(
            offset: const Offset(0, -20),
            child: Container(
              padding: const EdgeInsets.only(left: 20, right: 20),
              //边框设置
              decoration: const BoxDecoration(
                //背景
                color: Colors.white,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25.0),
                    topRight: Radius.circular(25.0)),
              ),
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(20, 0),
                  SizedBox(
                    height: ScreenUtil().setHeight(178),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        isPlay == 2
                            ? GestureDetector(
                                onTap: (() {
                                  if (MyUtils.checkClick()) {
                                    setState(() {
                                      audioNum = 0; // 记录录了多久
                                      recordText = '开始录音';
                                      isPlay = 0;
                                    });
                                  }
                                }),
                                child: WidgetUtils.showImages(
                                    'assets/images/mine_audio_cuo.png',
                                    ScreenUtil().setHeight(67),
                                    ScreenUtil().setHeight(67)),
                              )
                            : const Text(''),
                        WidgetUtils.commonSizedBox(10, 30),
                        GestureDetector(
                          onTap: (() {
                            if (MyUtils.checkClick()) {
                              if (isPlay == 2) {
                                play();
                              } else {
                                LogE('录音权限  $isMAI');
                                //有录音权限
                                if(isMAI == true) {
                                  setState(() {
                                    if (isPlay == 0) {
                                      //开始录音
                                      _startRecorder();
                                      isPlay = 1;
                                    } else if (isPlay == 1) {
                                      //停止录音
                                      _stopRecorder();
                                      isPlay = 2;
                                    }
                                  });
                                }else{
                                  MyToastUtils.showToastBottom('请在设置里面开启录音权限！');
                                }
                              }
                            }
                          }),
                          child: WidgetUtils.showImages(
                              isPlay == 0
                                  ? 'assets/images/mine_audio_star.png'
                                  : isPlay == 1
                                      ? 'assets/images/mine_audio_play.png'
                                      : 'assets/images/mine_audio_over.png',
                              ScreenUtil().setHeight(178),
                              ScreenUtil().setHeight(178)),
                        ),
                        WidgetUtils.commonSizedBox(10, 30),
                        isPlay == 2
                            ? GestureDetector(
                                onTap: (() {
                                  if (MyUtils.checkClick()) {
                                    if (length == 0) {
                                      MyToastUtils.showToastBottom(
                                          '请先选择一个声音标签');
                                    } else {
                                      doPostPostFileUpload(_path);
                                    }
                                  }
                                }),
                                child: WidgetUtils.showImages(
                                    'assets/images/mine_audio_dui.png',
                                    ScreenUtil().setHeight(67),
                                    ScreenUtil().setHeight(67)),
                              )
                            : const Text(''),
                      ],
                    ),
                  ),
                  WidgetUtils.commonSizedBox(10, 0),
                  WidgetUtils.onlyTextCenter(
                      recordText,
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.g6,
                          fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.commonSizedBox(20, 0),
                  // WidgetUtils.onlyText(
                  //     '声音标签（$length/1）',
                  //     StyleUtils.getCommonTextStyle(
                  //         color: Colors.black,
                  //         fontWeight: FontWeight.w600,
                  //         fontSize: ScreenUtil().setSp(32))),
                  // WidgetUtils.commonSizedBox(10, 0),
                  // Wrap(
                  //   spacing: ScreenUtil().setHeight(30),
                  //   runSpacing: ScreenUtil().setHeight(20),
                  //   children: List.generate(
                  //       list.length,
                  //       (index) => GestureDetector(
                  //             onTap: (() {
                  //               if (length < 1) {
                  //                 setState(() {
                  //                   list_b[index] = !list_b[index];
                  //                   if (list_b[index]) {
                  //                     length++;
                  //                   } else {
                  //                     length--;
                  //                   }
                  //                 });
                  //               } else {
                  //                 if (list_b[index]) {
                  //                   setState(() {
                  //                     list_b[index] = !list_b[index];
                  //                     length--;
                  //                   });
                  //                 }
                  //               }
                  //             }),
                  //             child: WidgetUtils.myContainerZishiying2(
                  //                 list_b[index]
                  //                     ? MyColors.homeTopBG
                  //                     : Colors.white,
                  //                 list_b[index]
                  //                     ? MyColors.homeTopBG
                  //                     : MyColors.f2,
                  //                 list[index].name!,
                  //                 StyleUtils.getCommonTextStyle(
                  //                     color: list_b[index] == false
                  //                         ? Colors.black
                  //                         : Colors.white,
                  //                     fontSize: ScreenUtil().setSp(28))),
                  //           )),
                  // ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  /// 获取标签
  Future<void> doPostLabelList() async {
    Loading.show(MyConfig.successTitle);
    Map<String, dynamic> params = <String, dynamic>{'type': '3'};
    try {
      labelListBean bean = await DataUtils.postLabelList(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          list.clear();
          setState(() {
            list = bean.data!;
            List<String> list_id =
                sp.getString('label_id').toString().split(',');
            for (int i = 0; i < list.length; i++) {
              for (int k = 0; k < list_id.length; k++) {
                if (list_id[k] == list[i].id.toString()) {
                  list_b.add(true);
                  length++;
                } else {
                  list_b.add(false);
                }
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
      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

  /// 获取文件url
  Future<void> doPostPostFileUpload(path) async {
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
    File f = File(path);
    int fileSizeInBytes = f.lengthSync();
    double fileSizeInKB = fileSizeInBytes / 1024; // 文件大小转换为KB
    LogE('音频上传///$fileSizeInBytes');
    LogE('音频上传大小///$fileSizeInKB KB}');
    if(await f.exists()){
      LogE('存在!');
    }else{
      MyToastUtils.showToastBottom('文件不存在！');
      return;
    }
    Loading.show("音频上传中...");
    FormData formdata = FormData.fromMap(
      {
        'type': 'audio',
        "file": await MultipartFile.fromFile(
          path,
          filename: name,
        )
      },
    );
    LogE('音频上传**$formdata');
    BaseOptions option = BaseOptions(
        contentType: 'multipart/form-data', responseType: ResponseType.plain);
    option.headers["Authorization"] = sp.getString('user_token') ?? '';
    Dio dio = Dio(option);
    //application/json
    try {
      var respone = await dio.post(MyHttpConfig.fileUpload, data: formdata);
      Map jsonResponse = json.decode(respone.data.toString());
      LogE('音频上传$jsonResponse');
      if (jsonResponse['code'] == 200) {
        eventBus.fire(
            FileBack(info: path, id: jsonResponse['data'].toString(), type: 1));
        MyToastUtils.showToastBottom('音频上传成功');
        Loading.dismiss();
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else if (jsonResponse['code'] == 401) {
        // ignore: use_build_context_synchronously
        MyUtils.jumpLogin(context);
      } else {
        MyToastUtils.showToastBottom(jsonResponse['msg']);
      }

      Loading.dismiss();
    } catch (e) {
      Loading.dismiss();
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }
}
