import 'dart:io';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/login/login_page.dart';
import 'package:yuyinting/routes/routes.dart';
//定义一个全局的存储对象
late SharedPreferences sp;
void main() async{

  //加入后可正常使用
  WidgetsFlutterBinding.ensureInitialized();
  //初始化存储
  sp = await SharedPreferences.getInstance();

  // 透明状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(statusBarColor: Colors.transparent,statusBarIconBrightness: Brightness.dark,);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
  // 强制竖屏
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);

  runApp(const MyApp());
}
MaterialColor my_green = const MaterialColor(
  0xFF5B46B9,
  <int, Color>{
    50: Color(0xFF5B46B9),
    100: Color(0xFF5B46B9),
    200: Color(0xFF5B46B9),
    300: Color(0xFF5B46B9),
    400: Color(0xFF5B46B9),
    500: Color(0xFF5B46B9),
    600: Color(0xFF5B46B9),
    700: Color(0xFF5B46B9),
    800: Color(0xFF5B46B9),
    900: Color(0xFF5B46B9),
  },
);

// 应用类
class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}


// 定义 App ID、Token 和 Channel
const appId = "6d4c7c47c5c040a2a51829ed564a2697";
const token = "007eJxTYPjIcvWjZ+f9C9UfciSn7X3XaNR55zNP+m8BFuHk2doGz3UUGMxSTJLNk03Mk02TDUwMEo0STQ0tjCxTU0zNTBKNzCzNuz70pzQEMjLYFyYyMEIhiM/GkFsZlJ+fy8AAAO2JIMw=";
const channel = "myRoom";

// 应用状态类
class _MyAppState extends State<MyApp> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;



  @override
  void initState() {
    super.initState();
    initAgora();
  }

  // 初始化应用
  Future<void> initAgora() async {
    // 获取权限
    await [Permission.microphone, Permission.camera].request();

    // 创建 RtcEngine
    _engine = await createAgoraRtcEngine();


    // 初始化 RtcEngine，设置频道场景为直播场景
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          debugPrint("local user ${connection.localUid} joined");
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          debugPrint("remote user $remoteUid joined");
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          debugPrint("remote user $remoteUid left channel");
          setState(() {
            _remoteUid = null;
          });
        },
      ),
    );
    // 开启视频
    await _engine.enableVideo();
    await _engine.startPreview();
    // 加入频道，设置用户角色为主播
    await _engine.joinChannel(
      token: token,
      channelId: channel,
      options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster),
      uid: 0,
    );
  }

  // 构建 UI，显示本地视图和远端视图
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Agora Video Call'),
          ),
          body: Stack(
            children: [
              Center(
                child: _remoteVideo(),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: SizedBox(
                  width: 100,
                  height: 150,
                  child: Center(
                    child: _localUserJoined
                        ? AgoraVideoView(
                      controller: VideoViewController(
                        rtcEngine: _engine,
                        canvas: const VideoCanvas(uid: 0),
                      ),
                    )
                        : const CircularProgressIndicator(),
                  ),
                ),
              ),
            ],
          ),
        )
    );
  }

  // 生成远端视频
  Widget _remoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: const RtcConnection(channelId: channel),
        ),
      );
    } else {
      return const Text(
        'Please wait for remote user to join',
        textAlign: TextAlign.center,
      );
    }
  }
}

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//
//
//   @override
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: '语音厅',
//       theme: ThemeData(
//         primarySwatch: my_green,
//       ),
//       debugShowCheckedModeBanner: false,
//       home: const LoginPage(),
//       builder: EasyLoading.init(),
//       //配置路由  -- map格式
//       routes: staticRoutes,
//     );
//   }
// }

