import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/main.dart';
import 'package:yuyinting/utils/my_utils.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../bean/aboutUsBean.dart';
import '../../../config/my_config.dart';
import '../../../http/data_utils.dart';
import '../../../http/my_http_config.dart';
import '../../../utils/line_painter.dart';
import '../../../utils/loading.dart';
import '../../../utils/my_toast_utils.dart';
import '../../../utils/widget_utils.dart';
/// 关于
class AboutPage extends StatefulWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {
  var appBar;
  String  gzh = '', gs = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('关于', true, context, false, 0);
    doPostUserAbout();
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
                WidgetUtils.showImagesFill( 'assets/images/people_bg.jpg', ScreenUtil().setHeight(150), ScreenUtil().setHeight(150), ),
                const Expanded(child: Text('')),
              ],
            ),
          WidgetUtils.commonSizedBox(10, 10),
          Row(
            children: [
              const Expanded(child: Text('')),
              WidgetUtils.onlyText('当前版本（9） ${sp.getString('myVersion1')}', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: 14)),
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
                WidgetUtils.onlyText('版本检查', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: 14)),
                const Expanded(child: Text('')),
                // ignore: unrelated_type_equality_checks
                sp.getString('versionStatus').toString() == '1' ? Column(
                  children: [
                    WidgetUtils.commonSizedBox(24, 10),
                    CustomPaint(
                      painter: LinePainter(colors: Colors.red),
                    )
                  ],
                ): const Text(''),
                WidgetUtils.commonSizedBox(10, 10),
                WidgetUtils.onlyText(sp.getString('myVersion2').toString(), StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: 12)),
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
                WidgetUtils.onlyText('官方公众号', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: 14)),
                const Expanded(child: Text('')),
                WidgetUtils.onlyText(gzh, StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: 12)),
                WidgetUtils.commonSizedBox(10, 10),
                GestureDetector(
                  onTap: ((){
                    Clipboard.setData( ClipboardData(text:gzh,));
                    MyToastUtils.showToastBottom('已成功复制到剪切板');
                  }),
                  child: WidgetUtils.showImages(
                      'assets/images/mine_fuzhi.png',
                      ScreenUtil().setHeight(15),
                      ScreenUtil().setHeight(15)),
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
                WidgetUtils.onlyText('版权所属', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: 14)),
                const Expanded(child: Text('')),
                WidgetUtils.onlyText(gs, StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: 12)),
              ],
            ),
          ),
          WidgetUtils.myLine(),
          const Expanded(child: Text('')),
          Row(
            children: [
              const Expanded(child: Text('')),
              WidgetUtils.onlyText('《用户协议》', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: 14)),
              WidgetUtils.commonSizedBox(0, 20),
              WidgetUtils.onlyText('《隐私协议》', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: 14)),
              const Expanded(child: Text('')),
            ],
          ),
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
      MyToastUtils.showToastBottom(MyConfig.errorTitle);
    }
  }

}
