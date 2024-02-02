import 'dart:async';
import 'dart:convert';
import 'dart:io';
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
  String _mPath = ''; //录音文件路径
  FlutterSoundPlayer? _mPlayer = FlutterSoundPlayer();
  FlutterSoundRecorder? _mRecorder = FlutterSoundRecorder();
  bool _mPlayerIsInited = false;
  bool mediaRecord = true;
  bool playRecord = false; //音频文件播放状态
  bool hasRecord = false; //是否有音频文件可播放
  int isPlay = 0; //0录制按钮未点击，1点了录制了，2录制结束或者点击暂停
  int djNum = 15; // 录音时长
  int audioNum = 0; // 记录录了多久
  String recordText = '开始录音';
  String audioUrl = '';
  // 设备是安卓还是ios
  String isDevices = 'android';
  @override
  void initState() {
    // TODO: implement initState
    if (Platform.isAndroid) {
      setState(() {
        isDevices = 'android';
      });
    }else if (Platform.isIOS){
      setState(() {
        isDevices = 'ios';
      });
    }
    _initialize();
    _mPlayer!.openPlayer().then((value) {
      setState(() {
        _mPlayerIsInited = true;
      });
    });
    openTheRecorder();
    super.initState();
    appBar = WidgetUtils.getAppBar('声音录制', true, context, false, 0);
    doPostLabelList();
    setState(() {
      audioUrl = widget.audioUrl;
    });
  }

  void _initialize() async {
    await _mPlayer!.closePlayer();
    await _mPlayer!.openPlayer();
  }

  @override
  void dispose() {
    _mPlayer!.closePlayer();
    _mPlayer = null;
    _mRecorder!.closeRecorder();
    _mRecorder = null;
    _timer.cancel();
    super.dispose();
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

  late Timer _timer;

//点击开始录音
  startRecord() {
    record();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isPlay == 2) {
        setState(() {
          isPlay = 2;
        });
        timer.cancel();
        stopRecorder();
      } else {
        setState(() {
          djNum--;
          audioNum++;
          recordText = '已录制${audioNum}s';
        });
      }
      if (djNum == 0) {
        setState(() {
          isPlay = 2;
        });
        timer.cancel();
        stopRecorder();
      }
    });
  }

//开始录音
  void record() async {
    if (playRecord) {
      stopPlayer();
      setState(() {
        playRecord = false;
      });
    }
    if(isDevices == 'ios'){
      var directory = await getApplicationDocumentsDirectory(); // iOS上的默认存储位置为App Documents目录
      var time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      String path = '${directory.path}/$time${ext[Codec.aacADTS.index]}';
      LogE('录音地址 == $path');
      _mRecorder!
          .startRecorder(
        toFile: path,
        codec: _codec,
        audioSource: AudioSource.microphone,
      )
          .then((value) {
        setState(() {
          audioUrl = '';
          mediaRecord = false;
          hasRecord = false;
          _mPath = path;
        });
      });
    }else{
      Directory tempDir = await getTemporaryDirectory();
      var time = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      String path = '${tempDir.path}/$time${ext[Codec.aacADTS.index]}';
      LogE('录音地址 == $path');
      _mRecorder!
          .startRecorder(
        toFile: path,
        codec: _codec,
        audioSource: AudioSource.microphone,
      )
          .then((value) {
        setState(() {
          audioUrl = '';
          mediaRecord = false;
          hasRecord = false;
          _mPath = path;
        });
      });
    }
  }

//停止录音
  void stopRecorder() async {
    await _mRecorder!.stopRecorder().then((value) {
      _timer.cancel();
      setState(() {
        mediaRecord = true;
        hasRecord = true;
        djNum = 15;
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
      audioUrl = '';
      hasRecord = false;
    });
  }

//播放录音
  void play() {
    LogE('录音地址$_mPath');
    LogE('录音地址**$audioUrl');
    assert(_mPlayerIsInited && hasRecord);
    _mPlayer!
        .startPlayer(
            fromURI: _mPath == "" ? audioUrl : _mPath,
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

  //播放录音
  void play2() {
    _mPlayer!
        .startPlayer(
            fromURI: audioUrl,
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
                          play2();
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
                        child: playRecord == false
                            ? Row(
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
                              )
                            : const Expanded(
                                child: SVGASimpleImage(
                                assetsName: 'assets/svga/audio_bolang.svga',
                              )),
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
                                    stopPlayer();
                                    delRecorder();
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
                                startRecord();
                                setState(() {
                                  if (isPlay == 0) {
                                    isPlay = 1;
                                  } else if (isPlay == 1) {
                                    isPlay = 2;
                                  }
                                });
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
                                      doPostPostFileUpload(
                                          _mPath == "" ? audioUrl : _mPath);
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
    LogE('音频上传///$path');
    Loading.show("音频上传中...");
    var name = path.substring(path.lastIndexOf("/") + 1, path.length);
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
      if (respone.statusCode == 200) {
        eventBus.fire(
            FileBack(info: path, id: jsonResponse['data'].toString(), type: 1));
        MyToastUtils.showToastBottom('音频上传成功');
        Loading.dismiss();
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else if (respone.statusCode == 401) {
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
