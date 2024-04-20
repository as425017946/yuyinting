import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:audio_session/audio_session.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_sound_platform_interface/flutter_sound_recorder_platform_interface.dart';
import 'package:yuyinting/utils/widget_utils.dart';

import '../../../http/my_http_config.dart';
import '../../../main.dart';
import '../../../utils/loading.dart';
import '../../../utils/log_util.dart';
import '../../../utils/my_toast_utils.dart';

enum RecordPlayState {
  record,
  recording,
  play,
  playing,
}


class CeshiAudioPage extends StatefulWidget {
  const CeshiAudioPage({super.key});

  @override
  State<CeshiAudioPage> createState() => _CeshiAudioPageState();
}

class _CeshiAudioPageState extends State<CeshiAudioPage> {
  FlutterSoundRecorder recorderModule = FlutterSoundRecorder();
  FlutterSoundPlayer playerModule = FlutterSoundPlayer();
  late StreamSubscription _recorderSubscription;
  late StreamSubscription _playerSubscription;
  RecordPlayState _state = RecordPlayState.record;
  var _path = "";
  var _duration = 0.0;
  var _maxLength = 15.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getPermissionStatus();
    init();
  }

  ///销毁录音
  void dispose() {
    super.dispose();
    _cancelRecorderSubscriptions();
    _releaseFlauto();
  }

  Future<void> init() async {
    // 获取权限
    await [Permission.microphone].request();
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
  /// 开始录音
  _startRecorder() async {
    try {
      var status = await getPermissionStatus();

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
          DateTime date = new DateTime.fromMillisecondsSinceEpoch(
              e.duration.inMilliseconds,
              isUtc: true);

          if (date.second >= _maxLength) {
            print('===>  到达时常停止录音');
            _stopRecorder();
          }
          setState(() {
            print("时间：${date.second}");
            print("当前振幅：${e.decibels}");
          });
        }
      });
      this.setState(() {
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

  /// 取消播放监听
  void _cancelPlayerSubscriptions() {
    if (_playerSubscription != null) {
      _playerSubscription.cancel();
    }
  }

  /// 判断文件是否存在
  Future<bool> _fileExists(String path) async {
    return await File(path).exists();
  }

  ///开始播放，这里做了一个播放状态的回调
  void startPlayer(path, {Function(dynamic)? callBack}) async {
    try {
      if (path.contains('http')) {
        await playerModule.startPlayer(
            fromURI: path,
            codec: Codec.mp3,
            // sampleRate: 44000,
            whenFinished: () {
              stopPlayer();
              callBack!(0);
            });
      } else {
        //判断文件是否存在
        if (await _fileExists(path)) {
          if (playerModule.isPlaying) {
            playerModule.stopPlayer();
          }
          await playerModule.startPlayer(
              fromURI: path,
              codec: Codec.aacADTS,
              // sampleRate: 44000,
              whenFinished: () {
                stopPlayer();
                callBack!(0);
              });
        } else {}
      }
      //监听播放进度
      playerModule.onProgress!.listen((e) {});
      callBack!(1);
    } catch (err) {
      callBack!(0);
    }
  }

  /// 结束播放
  void stopPlayer() async {
    try {
      await playerModule.stopPlayer();
    } catch (err) {}
  }

  ///获取播放状态
  Future getPlayState() async {
    return await playerModule.getPlayerState();
  }

  /// 释放播放器
  void releaseFlauto() async {
    try {
      await playerModule.closePlayer();
    } catch (e) {
      print(e);
    }
  }

  /// 释放录音
  Future<void> _releaseFlauto() async {
    try {
      await recorderModule.closeRecorder();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          WidgetUtils.commonSizedBox(100, 0),
          GestureDetector(
            onTap: ((){
              _startRecorder();
            }),
            child: Container(
              height: 50.h,
              width: 100.h,
              color: Colors.red,
              child: Text(
                '录音'
              ),
            ),
          ),
          GestureDetector(
            onTap: ((){
              stopPlayer();
            }),
            child: Container(
              height: 50.h,
              width: 100.h,
              color: Colors.red,
              child: Text(
                  '暂停'
              ),
            ),
          ),
          GestureDetector(
            onTap: ((){
              doPostPostFileUpload();
            }),
            child: Container(
              height: 50.h,
              width: 100.h,
              color: Colors.red,
              child: Text(
                  '上传'
              ),
            ),
          )
        ],
      ),
    );
  }


  /// 获取文件url
  Future<void> doPostPostFileUpload() async {
    var name = _path.substring(_path.lastIndexOf("/") + 1, _path.length);
    File f = File(_path);
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
          _path,
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

        MyToastUtils.showToastBottom('音频上传成功');
        Loading.dismiss();
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } else if (jsonResponse['code'] == 401) {

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
