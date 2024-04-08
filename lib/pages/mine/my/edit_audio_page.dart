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
import 'package:svgaplayer_flutter/svgaplayer_flutter.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../bean/CommonMyIntBean.dart';
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
  RecordPlayState _state = RecordPlayState.record;
  var _path = "";
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
  _startRecorder() async {
    try {
      Directory tempDir = await getApplicationSupportDirectory();
      var time = DateTime.now().millisecondsSinceEpoch;
      String path =
          '${tempDir.path}-$time${ext[Codec.aacADTS.index]}' ;

      print('===>  准备开始录音');
      await recorderModule.startRecorder(
          toFile: path,
          codec: Codec.aacADTS,
          bitRate: 128000,
          sampleRate: 44000,
          audioSource: AudioSource.microphone);
      print('===>  开始录音');

      if(isDevices == 'ios'){
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
              recordText = '录制中';
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
      }else{
        _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
          if (isPlay == 2) {
            LogE('停止了==');
            timer.cancel();
          } else {
            setState(() {
              djNum--;
              audioNum++;
              recordText = '录制中';
            });
          }
          if (djNum == 0) {
            setState(() {
              isPlay = 2;
            });
            timer.cancel();
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
                                      doUpAudio(_path);
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
      // MyToastUtils.showToastBottom(MyConfig.errorTitle);
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

  doUpAudio(String path) async{
    Map<String, dynamic> directTransferData;
    try {
      directTransferData = await _getStsDirectSign(path);
    } catch (err) {
      print(err);
      throw Exception("getStsDirectSign fail");
    }
    Loading.show('上传中...');
    String cosHost = directTransferData['cosHost'];
    String cosKey = directTransferData['cosKey'];
    String authorization = directTransferData['authorization'];
    String securityToken = directTransferData['sessionToken'];
    String url = 'https://$cosHost/$cosKey';
    File file = File(path);
    int fileSize = await file.length();
    HttpClient httpClient = HttpClient();
    HttpClientRequest request = await httpClient.putUrl(Uri.parse(url));
    request.headers.set('Content-Type', 'application/octet-stream');
    request.headers.set('Content-Length', fileSize.toString());
    request.headers.set('Authorization', authorization);
    request.headers.set('x-cos-security-token', securityToken);
    request.headers.set('Host', cosHost);
    request.contentLength = fileSize;
    Stream<List<int>> stream = file.openRead();
    int bytesSent = 0;
    stream.listen(
          (List<int> chunk) {
        bytesSent += chunk.length;
        double progress = bytesSent / fileSize;
        print('Progress: ${progress.toStringAsFixed(2)}');
        request.add(chunk);
      },
      onDone: () async {
        HttpClientResponse response = await request.close();
        LogE('上传状态 ${response.statusCode}');
        if (response.statusCode == 200) {
          doPostRoomJoin(cosKey);
          print('上传成功');
        } else {
          Loading.dismiss();
          throw Exception("上传失败 $response");
        }
      },
      onError: (error) {
        Loading.dismiss();
        print('Error: $error');
        throw Exception("上传失败 ${error.toString()}");
      },
      cancelOnError: true,
    );
  }

  /// 腾讯云id
  Future<void> doPostRoomJoin(String filePath) async {
    String fileType = '';
    if (filePath.contains('.gif') ||
        filePath.contains('.GIF') ||
        filePath.contains('.jpg') ||
        filePath.contains('.JPG') ||
        filePath.contains('.jpeg') ||
        filePath.contains('.GPEG') ||
        filePath.contains('.webp') ||
        filePath.contains('.WEBP') ||
        filePath.contains('.png') ||
        filePath.contains('.png')) {
      fileType = 'image';
    }else if(filePath.contains('.avi') ||
        filePath.contains('.AVI') ||
        filePath.contains('.wmv') ||
        filePath.contains('.WMV') ||
        filePath.contains('.mpeg') ||
        filePath.contains('.MPEG') ||
        filePath.contains('.mp4') ||
        filePath.contains('.MP4') ||
        filePath.contains('.m4v') ||
        filePath.contains('.M4V')||
        filePath.contains('.mov') ||
        filePath.contains('.MOV') ||
        filePath.contains('.asf') ||
        filePath.contains('.ASF') ||
        filePath.contains('.flv') ||
        filePath.contains('.FLV') ||
        filePath.contains('.f4v') ||
        filePath.contains('.F4V')||
        filePath.contains('.rmvb') ||
        filePath.contains('.RMVB') ||
        filePath.contains('.rm') ||
        filePath.contains('.RM') ||
        filePath.contains('.3gp')||
        filePath.contains('.3GP') ||
        filePath.contains('.vob') ||
        filePath.contains('.VOB')){
      fileType = 'video';
    }else if(filePath.contains('.mp3') ||
        filePath.contains('.MP3') ||
        filePath.contains('.wma') ||
        filePath.contains('.WMA') ||
        filePath.contains('.wav') ||
        filePath.contains('.WAV') ||
        filePath.contains('.flac') ||
        filePath.contains('.FLAC') ||
        filePath.contains('.ogg') ||
        filePath.contains('.OGG')||
        filePath.contains('.aac') ||
        filePath.contains('.AAC') ||
        filePath.contains('.mp4') ||
        filePath.contains('.MP4') ){
      fileType = 'audio';
    }
    Map<String, dynamic> params = <String, dynamic>{
      'file_type': fileType,
      'file_path': filePath,
    };
    try {
      CommonMyIntBean bean = await DataUtils.postTencentID(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            eventBus.fire(
                FileBack(info: filePath, id: bean.data.toString(), type: 1));
            MyToastUtils.showToastBottom('音频上传成功');
            Loading.dismiss();
            // ignore: use_build_context_synchronously
            Navigator.pop(context);
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

  /// 获取直传的url和签名等
  /// @param ext 文件后缀 直传后端会根据后缀生成cos key
  /// @return 直传url和签名等
  static Future<Map<String, dynamic>> _getStsDirectSign(String ext) async {
    HttpClient httpClient = HttpClient();
    //直传签名业务服务端url（正式环境 请替换成正式的直传签名业务url）
    //直传签名业务服务端代码示例可以参考：https://github.com/tencentyun/cos-demo/blob/main/server/direct-sign/nodejs/app.js
    //10.91.22.16为直传签名业务服务器的地址 例如上述node服务，总之就是访问到直传签名业务服务器的url
    HttpClientRequest request = await httpClient
        .getUrl(Uri.parse("${MyHttpConfig.baseURL}/upload/uploadCos?type=audio&ext=$ext"));
    // 添加 header 头信息
    request.headers.add("Content-Type", "application/json"); // 例如，设置 Content-Type 为 application/json
    request.headers.add("Authorization", sp.getString('user_token') ?? ''); // 例如，设置 Authorization 头
    HttpClientResponse response = await request.close();
    String responseBody = await response.transform(utf8.decoder).join();
    if (response.statusCode == 200) {
      Map<String, dynamic> json = jsonDecode(responseBody);
      print(json);
      // LogE('上传地址== ${json['data']['cosKey']}');
      // LogE('上传地址request_id== ${json['data']['request_id']}');
      // LogE('上传地址cosHost== ${json['data']['cosHost']}');
      // LogE('上传地址cosKey== ${json['data']['cosKey']}');
      httpClient.close();
      if (json['code'] == 200) {
        return json['data'];
      } else {
        throw Exception(
            'getStsDirectSign error code: ${json['code']}, error message: ${json['message']}');
      }
    } else {
      httpClient.close();
      throw Exception(
          'getStsDirectSign HTTP error code: ${response.statusCode}');
    }
  }
}
