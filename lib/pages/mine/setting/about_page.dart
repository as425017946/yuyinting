import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../bean/CheckoutBean.dart';
import '../../../bean/aboutUsBean.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/line_painter.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/widget_utils.dart';
import '../../home/update_app_page.dart';

/// 关于
class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  var appBar;
  String gzh = '', gs = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('关于', true, context, false, 0);
    doPostUserAbout();
    doCheck();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          WidgetUtils.commonSizedBox(20, 10),
          Row(
            children: [
              const Expanded(child: Text('')),
              WidgetUtils.showImagesFill(
                'assets/images/ic_launcher.png',
                ScreenUtil().setHeight(150),
                ScreenUtil().setHeight(150),
              ),
              const Expanded(child: Text('')),
            ],
          ),
          WidgetUtils.commonSizedBox(10, 10),
          Row(
            children: [
              const Expanded(child: Text('')),
              WidgetUtils.onlyText(
                  '当前版本${sp.getString('myVersion2')}（${sp.getString('buildNumber')}） ',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.g6, fontSize: ScreenUtil().setSp(28))),
              const Expanded(child: Text('')),
            ],
          ),
          WidgetUtils.commonSizedBox(50, 10),
          Container(
            height: ScreenUtil().setHeight(80),
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.center,
            child: Row(
              children: [
                WidgetUtils.onlyText(
                    '版本检查',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g6, fontSize: ScreenUtil().setSp(28))),
                const Expanded(child: Text('')),
                // ignore: unrelated_type_equality_checks
                sp.getString('versionStatus').toString() == '1'
                    ? Column(
                        children: [
                          WidgetUtils.commonSizedBox(24, 10),
                          CustomPaint(
                            painter: LinePainter(colors: Colors.red),
                          )
                        ],
                      )
                    : const Text(''),
                WidgetUtils.commonSizedBox(10, 10),
                WidgetUtils.onlyText(
                    sp.getString('myVersion2').toString(),
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g9, fontSize: ScreenUtil().setSp(24))),
                WidgetUtils.commonSizedBox(10, 10),
                Image(
                  image: const AssetImage('assets/images/mine_more.png'),
                  width: ScreenUtil().setHeight(10),
                  height: ScreenUtil().setHeight(17),
                ),
              ],
            ),
          ),
          WidgetUtils.myLine(),
          Container(
            height: ScreenUtil().setHeight(80),
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.center,
            child: Row(
              children: [
                WidgetUtils.onlyText(
                    '官方公众号',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g6, fontSize: ScreenUtil().setSp(28))),
                const Expanded(child: Text('')),
                WidgetUtils.onlyText(
                    gzh,
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g9, fontSize: ScreenUtil().setSp(24))),
                WidgetUtils.commonSizedBox(10, 10),
                GestureDetector(
                  onTap: (() {
                    Clipboard.setData(ClipboardData(
                      text: gzh,
                    ));
                    MyToastUtils.showToastBottom('已成功复制到剪切板');
                  }),
                  child: WidgetUtils.showImages('assets/images/mine_fuzhi.png',
                      ScreenUtil().setHeight(15), ScreenUtil().setHeight(15)),
                ),
              ],
            ),
          ),
          WidgetUtils.myLine(),
          Container(
            height: ScreenUtil().setHeight(80),
            width: double.infinity,
            padding: const EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.center,
            child: Row(
              children: [
                WidgetUtils.onlyText(
                    '版权所属',
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g6, fontSize: ScreenUtil().setSp(28))),
                const Expanded(child: Text('')),
                WidgetUtils.onlyText(
                    gs,
                    StyleUtils.getCommonTextStyle(
                        color: MyColors.g9, fontSize: ScreenUtil().setSp(24))),
              ],
            ),
          ),
          WidgetUtils.myLine(),
          const Expanded(child: Text('')),
          // Row(
          //   children: [
          //     const Expanded(child: Text('')),
          //     WidgetUtils.onlyText('《用户协议》', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: 14)),
          //     WidgetUtils.commonSizedBox(0, 20),
          //     WidgetUtils.onlyText('《隐私协议》', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: 14)),
          //     const Expanded(child: Text('')),
          //   ],
          // ),
          WidgetUtils.commonSizedBox(20, 10),
        ],
      ),
    );
  }

  /// 关于我们
  Future<void> doPostUserAbout() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String versions = packageInfo.version;
    var type;
    // 透明状态栏
    if (Platform.isAndroid) {
      type = '2';
    }
    if (Platform.isIOS) {
      type = '1';
    }

    Map<String, dynamic> params = <String, dynamic>{
      'system': type,
    };
    try {
      Loading.show(MyConfig.successTitle);
      AboutUsBean bean = await DataUtils.postUserAbout(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          setState(() {
            gzh = bean.data!.wechatPublic!;
            gs = bean.data!.copyright!;
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
    try {
      CheckoutBean bean = await DataUtils.checkVersion(params);
      switch (bean.code) {
        case MyHttpConfig.successCode:
          if (int.parse(buildNumber) < int.parse(bean.data!.customUpdateNum!)) {
            if (Platform.isAndroid) {
              if(sp.getString('isEmulation') == '0'){
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
              }else{
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
}
