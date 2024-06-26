import 'dart:convert';
import 'dart:io';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:open_file/open_file.dart';
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog_null_safe/progress_dialog_null_safe.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/home/paidui/paidui_page.dart';
import 'package:yuyinting/pages/home/search_page.dart';
import 'package:yuyinting/pages/home/shoucang_page.dart';
import 'package:yuyinting/pages/home/tuijian_page.dart';
import 'package:yuyinting/pages/home/update_app_page.dart';
import 'package:yuyinting/pages/home/zaixian_page.dart';
import 'package:yuyinting/pages/login/edit_info_page.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import '../../bean/CheckoutBean.dart';
import '../../bean/Common_bean.dart';
import '../../bean/joinRoomBean.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/event_utils.dart';
import '../../utils/loading.dart';
import '../../utils/log_util.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../room/room_page.dart';
import '../room/room_ts_mima_page.dart';

///首页
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _currentIndex = 1;
  late final PageController _controller;
  bool isFirst = true;
  var listen;

  // 用户身份
  String identity = 'user';
  // 用户身份
  int level = 0, grLevel = 0;

  @override
  void initState() {
    // TODO: implement initState
    doCheck();
    // doPostPdAddress();
    //更新身份
    setState(() {
      identity = sp.getString('user_identity').toString();
      // level = sp.getInt('user_level') as int;
      // grLevel = sp.getInt('user_grLevel') as int;
      LogE('用户等级 == $level');
    });

    /// 如果是全屏就切换竖屏
    AutoOrientation.portraitAutoMode();

    ///显示状态栏，与底部虚拟操作按钮
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);

    super.initState();
    _currentIndex = 1;
    _controller = PageController(
      initialPage: 1,
    );

    quanxian();

    listen = eventBus.on<SubmitButtonBack>().listen((event) {
      if (event.title == '更换了身份') {
        //更新身份
        setState(() {
          identity = sp.getString('user_identity').toString();
        });
      }else if(event.title == '等级大于3级'){
        // setState(() {
        //   level = sp.getInt('user_level') as int;
        // });
      }else if(event.title == '财富等级大于3级'){
        // setState(() {
        //   grLevel = sp.getInt('user_grLevel') as int;
        // });
      }
    });

    if (sp.getString("isFirstDownZB").toString() == 'null') {
      sp.setString("isFirstDownZB", '1');
    }
    //直接不显示弹窗了，直接下载
    eventBus.fire(SubmitButtonBack(title: '资源开始下载'));

    ///首次打开app进入的，弹出编辑页面
    if (sp.getBool('isFirst') == true) {
      MyUtils.goTransparentPageCom(context, const EditInfoPage());
    }
    // //判断有无代理房间
    // if(sp.getString('daili_roomid').toString() != 'null' && sp.getString('daili_roomid').toString().isNotEmpty){
    //   MyToastUtils.showToastBottom('获取到的房间id为 ${sp.getString('daili_roomid').toString()}');
    //   //有房间直接进入
    //   doPostBeforeJoin(sp.getString('daili_roomid').toString(),'');
    // }else{
    //   MyToastUtils.showToastBottom('未获取到房间id ${sp.getString('daili_roomid').toString()}');
    // }

  }

  @override
  void dispose() {
    listen.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> quanxian() async {
    if (Platform.isAndroid) {
      var androidInfo = await DeviceInfoPlugin().androidInfo;
      var release = androidInfo.version.release;
      // 判断android版本是否大于13
      if (int.parse(release) >= 13) {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.audio,
          Permission.videos,
          Permission.camera,
          Permission.photos,
          Permission.microphone,
        ].request();
        // 检查权限状态
        if (statuses[Permission.audio] == PermissionStatus.granted &&
            statuses[Permission.videos] == PermissionStatus.granted &&
            statuses[Permission.camera] == PermissionStatus.granted &&
            statuses[Permission.photos] == PermissionStatus.granted &&
            statuses[Permission.microphone] == PermissionStatus.granted) {
          // 所有权限都已授予，执行你的操作
        } else {
          // 用户拒绝了某些权限，后弹提示语
          MyToastUtils.showToastBottom(
              '您拒绝了一些权限申请，后续使用app需要在app设置权限里面打开后才能正常使用！');
        }
      } else {
        Map<Permission, PermissionStatus> statuses = await [
          Permission.storage,
          Permission.camera,
          Permission.microphone,
        ].request();
        // 检查权限状态
        if (statuses[Permission.storage] == PermissionStatus.granted &&
            statuses[Permission.camera] == PermissionStatus.granted &&
            statuses[Permission.microphone] == PermissionStatus.granted) {
          // 所有权限都已授予，执行你的操作
        } else {
          // 用户拒绝了某些权限，后弹提示语
          MyToastUtils.showToastBottom(
              '您拒绝了一些权限申请，后续使用app需要在app设置权限里面打开后才能正常使用！');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          //设置Container修饰
          image: DecorationImage(
            //背景图片修饰
            image: AssetImage("assets/images/all_bg.png"),
            fit: BoxFit.fill, //覆盖
          ),
        ),
        child: Column(
          children: [
            ///头部
            Container(
              color: Colors.transparent,
              height: ScreenUtil().setHeight(152),
              width: double.infinity,
              child: Column(
                children: [
                  WidgetUtils.commonSizedBox(35, 0),
                  Row(
                    children: [
                      WidgetUtils.commonSizedBox(0, 10),
                      _titleTab(),
                      WidgetUtils.commonSizedBox(0, 10),
                      Container(
                        width: ScreenUtil().setHeight(160),
                        height: ScreenUtil().setHeight(75),
                        color: Colors.transparent,
                        alignment: Alignment.bottomRight,
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: (() {
                                if (MyUtils.checkClick()) {
                                  MyUtils.goTransparentPageCom(
                                      context, const SearchPage());
                                }
                              }),
                              child: WidgetUtils.showImages(
                                  "assets/images/home_search.png", 40.h, 40.h),
                            ),
                            WidgetUtils.commonSizedBox(0, (25 *1.3).w),
                            GestureDetector(
                              onTap: (() {
                                if (MyUtils.checkClick()) {
                                  Navigator.pushNamed(context, 'RankingPage');
                                }
                              }),
                              child: WidgetUtils.showImages(
                                  "assets/images/b7y.png", 80.h, 80.h),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Transform.translate(
                offset: Offset(0, -2.h),
                child: PageView(
                  controller: _controller,
                  physics: const ClampingScrollPhysics(),
                  onPageChanged: (index) {
                    setState(() {
                      // 更新当前的索引值
                      _currentIndex = index;
                    });
                    if (index == 1) {
                      eventBus.fire(SubmitButtonBack(title: '回到首页'));
                    }else if (index == 3) {
                      eventBus.fire(SubmitButtonBack(title: '在线'));
                    }else{
                      eventBus.fire(SubmitButtonBack(title: '首页其他页面'));
                    }
                  },
                  children: identity != 'user'
                      ? const [
                          ShoucangPage(),
                          TuijianPage(),
                          PaiduiPage(),
                          ZaixianPage()
                        ]
                      : const [
                          ShoucangPage(),
                          TuijianPage(),
                          PaiduiPage(),
                        ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  /// 上传声网日志
  Future<void> doPostFilelog(int type) async {
    File file;
    String path = '';
    if (Platform.isAndroid) {
      if (type == 1) {
        path = '/sdcard/Android/data/com.littledog.yyt/files/agorasdk.log';
      } else {
        path = '/sdcard/Android/data/com.littledog.yyt/files/agoraapi.log';
      }
      file = File(path);
      if (file.existsSync()) {
        FormData formdata = FormData.fromMap(
          {
            'uid': sp.getString('user_id'),
            'type': type,
            "file": await MultipartFile.fromFile(
              path,
              filename: type == 1 ? 'agorasdk.log' : 'agoraapi.log',
            )
          },
        );
        BaseOptions option = BaseOptions(
            contentType: 'multipart/form-data',
            responseType: ResponseType.plain);
        option.headers["Authorization"] = sp.getString('user_token') ?? '';
        Dio dio = Dio(option);
        //application/json
        var respone = await dio.post(MyHttpConfig.filelog, data: formdata);
        LogE('上传返回== $formdata');
        LogE('上传返回== $respone');
        Map jsonResponse = json.decode(respone.data.toString());
        if (jsonResponse['code'] == 200) {
          LogE('上传成功');
        }
      } else {
        print('文件不存在');
      }
    } else if (Platform.isIOS) {
      Directory tempDir = await getTemporaryDirectory();
      if (type == 1) {
        path = '${tempDir.path}/agorasdk.log';
      } else {
        path = '${tempDir.path}/agoraapi.log';
      }
      LogE('ios地址 ${tempDir.path}');
      LogE('ios文件地址 $path');
      file = File(path);
      if (file.existsSync()) {
        FormData formdata = FormData.fromMap(
          {
            'uid': sp.getString('user_id'),
            'type': type,
            "file": await MultipartFile.fromFile(
              path,
              filename: type == 1 ? 'agorasdk.log' : 'agoraapi.log',
            )
          },
        );
        BaseOptions option = BaseOptions(
            contentType: 'multipart/form-data',
            responseType: ResponseType.plain);
        option.headers["Authorization"] = sp.getString('user_token') ?? '';
        Dio dio = Dio(option);
        //application/json
        var respone = await dio.post(MyHttpConfig.filelog, data: formdata);
        Map jsonResponse = json.decode(respone.data.toString());
        if (jsonResponse['code'] == 200) {
          LogE('上传成功');
        }
      } else {
        print('文件不存在');
      }
    }
  }

  // /// 判断当前网络，然后给返回适配的网络地址
  // Future<void> doPostPdAddress() async {
  //   try {
  //     // Map<String, dynamic> params = <String, dynamic>{'type': 'test'};
  //     // Map<String, dynamic> params = <String, dynamic>{'type': 'go'};
  //     var respons = await DataUtils.postPdAddress(OnlineConfig.pingParams);
  //     if (respons.code == 200) {
  //       setState(() {
  //         sp.setString('userIP', respons.address);
  //       });
  //       MyPing.checkIp(
  //         respons.ips,
  //         (ip) {
  //           setState(() {
  //             // sp.setString('isDian', ip);
  //             // LogE('Ping 设置: ${sp.getString('isDian')}');
  //             // // MyHttpConfig.baseURL =
  //             // // "http://${sp.getString('isDian').toString()}:8081/api";
  //             // MyHttpConfig.baseURL =
  //             // "http://${sp.getString('isDian').toString()}:8080/api";
  //             OnlineConfig.updateIp(ip);
  //           });
  //         },
  //       );
  //     } else if (respons.code == 401) {
  //       // ignore: use_build_context_synchronously
  //       MyUtils.jumpLogin(context);
  //     } else {
  //       MyToastUtils.showToastBottom('IP获取失败~');
  //       Map<String, dynamic> paramsa = <String, dynamic>{
  //         'title': '获取IP',
  //         'msg': 'ip获取失败',
  //       };
  //       CommonBean bean = await DataUtils.postIpLog(paramsa);
  //     }
  //   } catch (e) {
  //     // MyToastUtils.showToastBottom(MyConfig.errorTitle);
  //     // MyToastUtils.showToastBottom(MyConfig.errorTitleFile);
  //   }
  // }

  /// 检查更新
  //定义apk的名称，与下载进度dialog
  String apkName = 'flutterApp.apk';
  String progress = "";
  late ProgressDialog pr;

  Future<void> doCheck() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;
    String deviceType = '';
    sp.setString('myVersion2', version.toString());
    sp.setString('buildNumber', buildNumber);
    // 应用名称
    print("appName:${appName}");
// 包名称
    print("packageName:${packageName}");
// 版本号
    print("version:${version}");

    sp.setString('myVersion2', version);
// 构建编号
    print("buildNumber:${buildNumber}");

    sp.setString('versionStatus', buildNumber);

    sp.setString('app_version', version);

    if (Platform.isAndroid) {
      deviceType = "Android";
    } else {
      deviceType = "ios";
    }
    var params = <String, dynamic>{
      'system': deviceType,
    };
    // LogE('手机登录登录===${androidInfo.isPhysicalDevice}');
    try {
      CheckoutBean bean = await DataUtils.checkVersion(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          // LogE('版本信息=== ${int.parse(buildNumber) < int.parse(bean.data!.customUpdateNum!)}');
          // LogE('版本信息=== ${bean.data!.customUpdateNum!}');
          if (int.parse(buildNumber) < int.parse(bean.data!.customUpdateNum!)) {
            if (Platform.isAndroid) {
              if (sp.getString('isEmulation') == '0') {
                /// 手机登录
                // ignore: use_build_context_synchronously
                MyUtils.goTransparentPageCom(
                    context,
                    UpdateAppPage(
                      version: bean.data!.version!,
                      url: bean.data!.downloadUrl!,
                      info: bean.data!.summary!,
                      forceUpdate: bean.data!.forceUpdate!,
                      title: 'android',
                    ));
              } else {
                /// 模拟器登录
                // ignore: use_build_context_synchronously
                MyUtils.goTransparentPageCom(
                    context,
                    UpdateAppPage(
                      version: bean.data!.version!,
                      url: bean.data!.moniDownloadUrl!,
                      info: bean.data!.summary!,
                      forceUpdate: bean.data!.forceUpdate!,
                      title: 'android',
                    ));
              }
            } else {
              // ignore: use_build_context_synchronously
              MyUtils.goTransparentPageCom(
                  context,
                  UpdateAppPage(
                    version: bean.data!.version!,
                    url: bean.data!.downloadUrl!,
                    info: bean.data!.summary!,
                    forceUpdate: bean.data!.forceUpdate!,
                    title: 'ios',
                  ));
            }
          }
          break;
        default:
          MyToastUtils.showToastBottom(bean.msg!);
          break;
      }
    } catch (e) {
      // MyToastUtils.showToastBottom("网络异常");
    }
  }

  /// ios更新调整h5页面
  Future<void> showUpdateIOS(
      BuildContext context, String version, String url, String info) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, //设置为false，点击空白处弹窗不关
      builder: (BuildContext context) {
        return CupertinoAlertDialog(
          title: Text('检测到新版本 v$version'),
          content: Text(
            info,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              child: Text('立即更新'),
              onPressed: () async {
                await launch(url, forceSafariVC: false);
              },
            ),
          ],
        );
      },
    );
  }

  /// 显示更新内容
  Future<void> showUpdate(BuildContext context, String version, String url,
      String info, String forceUpdate) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, //设置为false，点击空白处弹窗不关
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async {
            // 返回键按下时的操作
            return false; // 如果希望按下返回键时关闭弹窗，返回true；如果希望阻止关闭弹窗，返回false
          },
          child: CupertinoAlertDialog(
            title: Text('检测到新版本 v$version'),
            content: Text(
              info,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            actions: forceUpdate == '1'
                ? [
                    CupertinoDialogAction(
                      child: const Text('立即更新'),
                      onPressed: () {
                        // 在这里放置确认操作的代码
                        doUpdate(context, version, url);
                      },
                    ),
                  ]
                : [
                    CupertinoDialogAction(
                      child: const Text('下次在说'),
                      onPressed: () {
                        // 在这里放置取消操作的代码
                        Navigator.of(context).pop(); // 关闭对话框
                      },
                    ),
                    CupertinoDialogAction(
                      child: const Text('立即更新'),
                      onPressed: () {
                        // 在这里放置确认操作的代码
                        doUpdate(context, version, url);
                      },
                    ),
                  ],
          ),
        );
      },
    );
  }

  ///3.执行更新操作
  doUpdate(BuildContext context, String version, String url) async {
    //关闭更新内容提示框
    Navigator.pop(context);
    // downloadAndroid(url);
    _updateVersion(url);
  }

  /// android app更新
  void _updateVersion(String url) async {
    pr = ProgressDialog(
      context,
      showLogs: true,
      type: ProgressDialogType.download, //下载类型带下载进度
      isDismissible: false, //点击外层不消失
    );
    if (!pr.isShowing()) {
      pr.show();
    }
    try {
      // 获取APP安装路径
      Directory appDocDir = await getApplicationDocumentsDirectory();
      String appDocPath = appDocDir.path;
      // destinationFilename 是对下载的apk进行重命名
      OtaUpdate().execute(url, destinationFilename: 'lmkj.apk').listen(
        (OtaEvent event) {
          print('status:${event.status},value:${event.value} }');
          switch (event.status) {
            case OtaStatus.DOWNLOADING: // 下载中
              setState(() {
                progress = event.value!;
                double d = double.parse(progress);
                pr.update(
                  progress: d,
                  message: "下载中，请稍后…",
                );
              });
              break;
            case OtaStatus.INSTALLING: //安装中
              if (pr.isShowing()) {
                OpenFile.open("${appDocPath}/lmkj.apk");
              }
              break;
            case OtaStatus.PERMISSION_NOT_GRANTED_ERROR: // 权限错误
              print('更新失败，请稍后再试');
              if (pr.isShowing()) {
                pr.hide();
              }
              break;
            default: // 其他问题
              break;
          }
        },
      );
    } catch (e) {
      print('更新失败，请稍后再试');
    }
  }

  /// 加入房间前
  Future<void> doPostBeforeJoin(roomID, String anchorUid) async {
    //判断房间id是否为空的
    if (roomID == null || roomID.toString().isEmpty) {
      return;
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
          doPostRoomJoin(roomID, '', anchorUid, bean.data!.rtc!);
          break;
        case MyHttpConfig.errorRoomCode: //需要密码
          // ignore: use_build_context_synchronously
          MyUtils.goTransparentPageCom(
              context,
              RoomTSMiMaPage(
                  roomID: roomID,
                  roomToken: bean.data!.rtc!,
                  anchorUid: anchorUid));
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
    }
  }

  /// 加入房间
  Future<void> doPostRoomJoin(
      roomID, password, String anchorUid, roomToken) async {
    Map<String, dynamic> params = <String, dynamic>{
      'room_id': roomID,
      'password': password,
      'anchor_uid': anchorUid
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
    }
  }

  Widget _titleTab() {
    return Expanded(
      child: Container(
        height: 55.h,
        color: Colors.transparent,
        alignment: Alignment.bottomCenter,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _titleItem('收藏', 0, true),
            _titleItem('推荐', 1, true),
            _titleItem('派对', 2, true),
            // (level >= 3 || grLevel >= 3) ? _titleItem('游戏', 3, true) : const Text(''),
            _titleItem('在线', 3, identity != 'user'),
          ],
        ),
      ),
    );
  }
  Widget _titleItem(String title, int index, bool isShow) { // 182x38
    if (!isShow) {
      return const Expanded(child: Text(''));
    }
    final isSelect = index == _currentIndex;
    return Expanded(
      child: GestureDetector(
        onTap: (() {
          setState(() {
            _currentIndex = index;
            _controller.jumpToPage(index);
          });
        }),
        child: title == '游戏'
            ? _gameItem(isSelect)
            : Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  if (isSelect)
                    Image(
                      width: 182.w*0.7,
                      height: 38.w*0.7,
                      image: const AssetImage('assets/images/paidui_title_bg.png'),
                    ),
                  Text(
                    title,
                    style: StyleUtils.getCommonFFTextStyle(
                      color: isSelect
                          ? MyColors.newHomeBlack
                          : MyColors.newHomeBlack2,
                      fontSize: isSelect
                          ? ScreenUtil().setSp(46)
                          : ScreenUtil().setSp(36),
                      fontWeight:
                          isSelect ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
  Widget _gameItem(bool isSelect) { // 148x60 222x88
    const sacle = 0.55;
    if (isSelect) {
      return Image(
        width: 222.w * sacle,
        height: 88.w * sacle,
        image: const AssetImage('assets/images/home_yx2.png'),
      );
    } else {
      return Image(
        width: 148.w * sacle,
        height: 60.w * sacle,
        image: const AssetImage('assets/images/home_yx1.png'),
      );
    }
  }

}
