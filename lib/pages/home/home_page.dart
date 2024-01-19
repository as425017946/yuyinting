import 'dart:io';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:device_info_plus/device_info_plus.dart';
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
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/gongping/gp_hi_page.dart';
import 'package:yuyinting/pages/home/paidui_page.dart';
import 'package:yuyinting/pages/home/shoucang_page.dart';
import 'package:yuyinting/pages/home/ts/ts_car_page.dart';
import 'package:yuyinting/pages/home/tuijian_page.dart';
import 'package:yuyinting/pages/home/youxi_page.dart';
import 'package:yuyinting/pages/home/zaixian_page.dart';
import 'package:yuyinting/pages/login/edit_info_page.dart';
import 'package:yuyinting/utils/style_utils.dart';
import 'package:yuyinting/utils/widget_utils.dart';
import '../../bean/CheckoutBean.dart';
import '../../http/data_utils.dart';
import '../../http/my_http_config.dart';
import '../../main.dart';
import '../../utils/event_utils.dart';
import '../../utils/my_toast_utils.dart';
import '../../utils/my_utils.dart';
import '../gongping/gp_dwon_page.dart';

///首页
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int _currentIndex = 1;
  late final PageController _controller;
  bool isFirst = true;
  var listen;

  // 用户身份
  String identity = 'user';

  @override
  void initState() {
    // TODO: implement initState
    doCheck();
    //更新身份
    setState(() {
      identity = sp.getString('user_identity').toString();
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

    // 马里奥
    MyUtils.goTransparentPageCom(context, const TSCarPage());

    ///首次打开app进入的，弹出编辑页面
    if (sp.getBool('isFirst') == true) {
      MyUtils.goTransparentPageCom(context, const EditInfoPage());
    }

    quanxian();

    listen = eventBus.on<SubmitButtonBack>().listen((event) {
      if (event.title == '更换了身份') {
        //更新身份
        setState(() {
          identity = sp.getString('user_identity').toString();
        });
      }
    });


    if(sp.getString('isFirstDown').toString() == '1' || sp.getString('isFirstDown').toString() == 'null'){
      MyUtils.goTransparentPageCom(context, const GPDownPage());
    }else{
      eventBus.fire(SubmitButtonBack(title: '资源开始下载'));
    }
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
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ///头部
          Container(
            color: MyColors.homeTopBG,
            height: ScreenUtil().setHeight(152),
            width: double.infinity,
            child: Column(
              children: [
                WidgetUtils.commonSizedBox(35, 0),
                Row(
                  children: [
                    WidgetUtils.commonSizedBox(0, 20),
                    Expanded(
                        child: Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(67),
                      alignment: Alignment.bottomLeft,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Expanded(
                              child: GestureDetector(
                            onTap: (() {
                              setState(() {
                                _currentIndex = 0;
                                _controller.jumpToPage(0);
                              });
                            }),
                            child: WidgetUtils.onlyTextBottom(
                                '收藏',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontSize: _currentIndex == 0
                                        ? ScreenUtil().setSp(38)
                                        : ScreenUtil().setSp(32),
                                    fontWeight: _currentIndex == 0
                                        ? FontWeight.w600
                                        : FontWeight.normal)),
                          )),
                          Expanded(
                              child: GestureDetector(
                            onTap: (() {
                              setState(() {
                                _currentIndex = 1;
                                _controller.jumpToPage(1);
                              });
                            }),
                            child: WidgetUtils.onlyTextBottom(
                                '推荐',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontSize: _currentIndex == 1
                                        ? ScreenUtil().setSp(38)
                                        : ScreenUtil().setSp(32),
                                    fontWeight: _currentIndex == 1
                                        ? FontWeight.w600
                                        : FontWeight.normal)),
                          )),
                          Expanded(
                              child: GestureDetector(
                            onTap: (() {
                              setState(() {
                                _currentIndex = 2;
                                _controller.jumpToPage(2);
                              });
                            }),
                            child: WidgetUtils.onlyTextBottom(
                                '派对',
                                StyleUtils.getCommonTextStyle(
                                    color: Colors.white,
                                    fontSize: _currentIndex == 2
                                        ? ScreenUtil().setSp(38)
                                        : ScreenUtil().setSp(32),
                                    fontWeight: _currentIndex == 2
                                        ? FontWeight.w600
                                        : FontWeight.normal)),
                          )),
                          Expanded(
                              child: GestureDetector(
                            onTap: (() {
                              setState(() {
                                _currentIndex = 3;
                                _controller.jumpToPage(3);
                              });
                            }),
                            child: Column(
                              children: [
                                const Spacer(),
                                _currentIndex == 3
                                    ? WidgetUtils.showImages(
                                        'assets/images/home_yx2.png',
                                        ScreenUtil().setHeight(40),
                                        ScreenUtil().setHeight(75))
                                    : WidgetUtils.showImagesFill(
                                        'assets/images/home_yx1.png',
                                        ScreenUtil().setHeight(25),
                                        ScreenUtil().setHeight(62)),
                                _currentIndex != 3
                                    ? WidgetUtils.commonSizedBox(3, 0)
                                    : WidgetUtils.commonSizedBox(0, 0)
                              ],
                            ),
                          )),
                          identity != 'user'
                              ? Expanded(
                                  child: GestureDetector(
                                  onTap: (() {
                                    setState(() {
                                      _currentIndex = 4;
                                      _controller.jumpToPage(4);
                                    });
                                  }),
                                  child: WidgetUtils.onlyTextBottom(
                                      '在线',
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize: _currentIndex == 4
                                              ? ScreenUtil().setSp(38)
                                              : ScreenUtil().setSp(32),
                                          fontWeight: _currentIndex == 4
                                              ? FontWeight.w600
                                              : FontWeight.normal)),
                                ))
                              : Expanded(
                                  child: Opacity(
                                  opacity: 0,
                                  child: WidgetUtils.onlyTextBottom(
                                      '在线',
                                      StyleUtils.getCommonTextStyle(
                                          color: Colors.white,
                                          fontSize: _currentIndex == 4
                                              ? ScreenUtil().setSp(38)
                                              : ScreenUtil().setSp(32),
                                          fontWeight: _currentIndex == 4
                                              ? FontWeight.w600
                                              : FontWeight.normal)),
                                )),
                        ],
                      ),
                    )),
                    Container(
                      width: ScreenUtil().setHeight(140),
                      height: ScreenUtil().setHeight(67),
                      padding: const EdgeInsets.only(right: 20),
                      alignment: Alignment.bottomRight,
                      child: GestureDetector(
                        onTap: (() {
                          Navigator.pushNamed(context, 'RankingPage');
                        }),
                        child: WidgetUtils.showImages(
                            "assets/images/b7y.png", 26, 30),
                      ),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  height: ScreenUtil().setHeight(5),
                  margin: EdgeInsets.only(
                      left: 20, right: ScreenUtil().setHeight(140)),
                  child: Row(
                    children: [
                      _currentIndex == 0
                          ? Expanded(
                              child: SizedBox(
                              width: ScreenUtil().setHeight(68),
                              height: ScreenUtil().setHeight(10),
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  Container(
                                    width: ScreenUtil().setHeight(20),
                                    height: ScreenUtil().setHeight(4),
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: Colors.white,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                  ),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            ))
                          : const Expanded(child: Text('')),
                      _currentIndex == 1
                          ? Expanded(
                              child: SizedBox(
                              width: ScreenUtil().setHeight(68),
                              height: ScreenUtil().setHeight(10),
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  Container(
                                    width: ScreenUtil().setHeight(20),
                                    height: ScreenUtil().setHeight(4),
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: Colors.white,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                  ),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            ))
                          : const Expanded(child: Text('')),
                      _currentIndex == 2
                          ? Expanded(
                              child: SizedBox(
                              width: ScreenUtil().setHeight(68),
                              height: ScreenUtil().setHeight(10),
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  Container(
                                    width: ScreenUtil().setHeight(20),
                                    height: ScreenUtil().setHeight(4),
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: Colors.white,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                  ),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            ))
                          : const Expanded(child: Text('')),
                      _currentIndex == 3
                          ? Expanded(
                              child: SizedBox(
                              width: ScreenUtil().setHeight(68),
                              height: ScreenUtil().setHeight(10),
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  Container(
                                    width: ScreenUtil().setHeight(20),
                                    height: ScreenUtil().setHeight(4),
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: Colors.white,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                  ),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            ))
                          : const Expanded(child: Text('')),
                      (_currentIndex == 4 && identity != 'user')
                          ? Expanded(
                              child: SizedBox(
                              width: ScreenUtil().setHeight(68),
                              height: ScreenUtil().setHeight(10),
                              child: Row(
                                children: [
                                  const Expanded(child: Text('')),
                                  Container(
                                    width: ScreenUtil().setHeight(20),
                                    height: ScreenUtil().setHeight(4),
                                    //边框设置
                                    decoration: const BoxDecoration(
                                      //背景
                                      color: Colors.white,
                                      //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(10.0)),
                                    ),
                                  ),
                                  const Expanded(child: Text('')),
                                ],
                              ),
                            ))
                          : const Expanded(child: Text('')),
                    ],
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: Transform.translate(
              offset: Offset(0, -2.h),
              child: PageView(
                controller: _controller,
                onPageChanged: (index) {
                  setState(() {
                    // 更新当前的索引值
                    _currentIndex = index;
                  });
                },
                children: identity != 'user'
                    ? const [
                        ShoucangPage(),
                        TuijianPage(),
                        PaiduiPage(),
                        YouxiPage(),
                        ZaixianPage()
                      ]
                    : const [
                        ShoucangPage(),
                        TuijianPage(),
                        PaiduiPage(),
                        YouxiPage(),
                      ],
              ),
            ),
          )
        ],
      ),
    );
  }


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
    try {
      CheckoutBean bean = await DataUtils.checkVersion(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          if (int.parse(buildNumber) <
              int.parse(bean.data!.customUpdateNum!)) {
            if (Platform.isAndroid) {
              // ignore: use_build_context_synchronously
              showUpdate(
                  context,
                  bean.data!.version!,
                  bean.data!.downloadUrl!,
                  bean.data!.summary!);
            } else {
              // const url =
              //     "https://itunes.apple.com/cn/app/id1380512641"; // id 后面的数字换成自己的应用 id 就行了
              // if (await canLaunch(url)) {
              //   await launch(url, forceSafariVC: false);
              // } else {
              //   throw 'Could not launch $url';
              // }
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

  /// 显示更新内容
  Future<void> showUpdate(
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
              child: Text('下次在说'),
              onPressed: () {
                // 在这里放置取消操作的代码
                Navigator.of(context).pop(); // 关闭对话框
              },
            ),
            CupertinoDialogAction(
              child: Text('立即更新'),
              onPressed: () {
                // 在这里放置确认操作的代码
                doUpdate(context, version, url);
              },
            ),
          ],
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
}
