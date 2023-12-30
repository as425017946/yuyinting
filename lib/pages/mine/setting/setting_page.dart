import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/pages/login/login_page.dart';
import 'package:yuyinting/utils/event_utils.dart';
import 'package:yuyinting/utils/line_painter.dart';
import 'package:yuyinting/utils/log_util.dart';
import 'package:yuyinting/utils/my_toast_utils.dart';

import '../../../config/config_screen_util.dart';
import '../../../main.dart';
import '../../../utils/custom_dialog.dart';
import '../../../utils/my_utils.dart';
import '../../../utils/style_utils.dart';
import '../../../utils/widget_utils.dart';

/// 设置页面
class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  var appBar;
  var _switchValue = true;
  var listen;
  String shiming = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('设置', true, context, false, 0);
    ///是否认证 0待审核1已审核 2已驳回 3未认证
    if(sp.getString('shimingzhi').toString() == '0'){
      shiming = '待审核';
    }else if(sp.getString('shimingzhi').toString() == '1'){
      shiming = '已认证';
    }else if(sp.getString('shimingzhi').toString() == '2'){
      shiming = '已驳回';
    }else{
      shiming = '未认证';
    }
    eventBus.on<SubmitButtonBack>().listen((event) {
      if(event.title == '实名制提交'){
        setState(() {
          if(sp.getString('shimingzhi').toString() == '0'){
            shiming = '待审核';
          }else if(sp.getString('shimingzhi').toString() == '1'){
            shiming = '已认证';
          }else if(sp.getString('shimingzhi').toString() == '2'){
            shiming = '已驳回';
          }else{
            shiming = '未认证';
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: MyColors.homeBG,
      body: Column(
        children: [
          WidgetUtils.commonSizedBox(10, 0),
          Container(
            width: double.infinity,
            height: ScreenUtil().setHeight(90),
            color: Colors.white,
            padding: EdgeInsets.only(
                left: ConfigScreenUtil.autoHeight20,
                right: ConfigScreenUtil.autoHeight20),
            child: Row(
              children: [
                WidgetUtils.onlyText(
                    '消息通知',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.black, fontSize: ScreenUtil().setSp(29))),
                const Expanded(child: Text('')),
                Transform.scale(
                  scale: 0.8,
                  child: CupertinoSwitch(
                    value: _switchValue,
                    onChanged: (value) {
                      setState(() {
                        _switchValue = value;
                      });
                    },
                    activeColor: MyColors.homeTopBG,
                  ),
                ),
              ],
            ),
          ),
          WidgetUtils.commonSizedBox(1, 0),
          GestureDetector(
            onTap: (() {
              Navigator.pushNamed(context, 'ZhanghaoShezhipage');
            }),
            child: WidgetUtils.onlyTextLeftRightImg(
                '账号设置',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black, fontSize: ScreenUtil().setSp(29)),
                'assets/images/mine_more.png'),
          ),
          WidgetUtils.commonSizedBox(1, 0),
          GestureDetector(
            onTap: (() {
              Navigator.pushNamed(context, 'PasswordPayPage');
            }),
            child: WidgetUtils.onlyTextLeftRightImg(
                '交易密码',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black, fontSize: ScreenUtil().setSp(29)),
                'assets/images/mine_more.png'),
          ),
          WidgetUtils.commonSizedBox(10, 0),
          GestureDetector(
            onTap: (() {
              if(sp.getString('shimingzhi').toString() == '2' || sp.getString('shimingzhi').toString() == '3'){
                Navigator.pushNamed(context, 'ShimingzhiPage');
              }else if(sp.getString('shimingzhi').toString() == '1'){
                MyToastUtils.showToastBottom('已认证');
              }else if(sp.getString('shimingzhi').toString() == '0'){
                MyToastUtils.showToastBottom('实名审核中，无需重复提交');
              }

            }),
            child: Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(90),
              color: Colors.white,
              padding: EdgeInsets.only(
                  left: ScreenUtil().setHeight(20),
                  right: ScreenUtil().setHeight(20)),
              child: Row(
                children: [
                  WidgetUtils.onlyText(
                      '实名制认证',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(29))),
                  const Expanded(child: Text('')),
                  WidgetUtils.commonSizedBox(0, 10),
                  WidgetUtils.onlyText(
                      shiming,
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.g9,
                          fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.showImages('assets/images/mine_more.png', 15, 20)
                ],
              ),
            ),
          ),
          WidgetUtils.commonSizedBox(1, 0),
          GestureDetector(
            onTap: (() {
              Navigator.pushNamed(context, 'BlackPage');
            }),
            child: WidgetUtils.onlyTextLeftRightImg(
                '黑名单',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black, fontSize: ScreenUtil().setSp(29)),
                'assets/images/mine_more.png'),
          ),
          WidgetUtils.commonSizedBox(10, 0),
          GestureDetector(
            onTap: (() {}),
            child: Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(90),
              color: Colors.white,
              padding: EdgeInsets.only(
                  left: ScreenUtil().setHeight(20),
                  right: ScreenUtil().setHeight(20)),
              child: Row(
                children: [
                  WidgetUtils.onlyText(
                      '清除缓存',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(29))),
                  const Expanded(child: Text('')),
                  WidgetUtils.onlyText(
                      '0MB',
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.g9,
                          fontSize: ScreenUtil().setSp(25))),
                ],
              ),
            ),
          ),
          WidgetUtils.commonSizedBox(10, 0),
          GestureDetector(
            onTap: (() {
              Navigator.pushNamed(context, 'AboutPage');
            }),
            child: Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(90),
              color: Colors.white,
              padding: EdgeInsets.only(
                  left: ScreenUtil().setHeight(20),
                  right: ScreenUtil().setHeight(20)),
              child: Row(
                children: [
                  WidgetUtils.onlyText(
                      '关于',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black,
                          fontSize: ScreenUtil().setSp(29))),
                  const Expanded(child: Text('')),
                  // ignore: unrelated_type_equality_checks
                  sp.getString('versionStatus').toString() == '1'
                      ? CustomPaint(
                          painter: LinePainter(colors: Colors.red),
                        )
                      : const Text(''),
                  WidgetUtils.commonSizedBox(0, 10),
                  WidgetUtils.onlyText(
                      sp.getString('myVersion2').toString(),
                      StyleUtils.getCommonTextStyle(
                          color: MyColors.g9,
                          fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.showImages('assets/images/mine_more.png', 15, 20)
                ],
              ),
            ),
          ),
          WidgetUtils.commonSizedBox(10, 0),
          GestureDetector(
            onTap: (() {
              Navigator.pushNamed(context, 'QiehuanAccountPage');
            }),
            child: Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(90),
              color: Colors.white,
              padding: EdgeInsets.only(
                  left: ScreenUtil().setHeight(20),
                  right: ScreenUtil().setHeight(20)),
              child: WidgetUtils.onlyTextCenter(
                  '切换账号',
                  StyleUtils.getCommonTextStyle(
                      color: Colors.black,
                      fontSize: ScreenUtil().setSp(29),
                      fontWeight: FontWeight.w600)),
            ),
          ),
          WidgetUtils.commonSizedBox(10, 0),
          GestureDetector(
            onTap: (() {
              if (MyUtils.checkClick()) {
                exitLogin(context);
              }
            }),
            child: Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(90),
              color: Colors.white,
              padding: EdgeInsets.only(
                  left: ScreenUtil().setHeight(20),
                  right: ScreenUtil().setHeight(20)),
              child: WidgetUtils.onlyTextCenter(
                  '退出当前账号',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.homeTopBG,
                      fontSize: ScreenUtil().setSp(29),
                      fontWeight: FontWeight.w600)),
            ),
          ),
          const Expanded(child: Text('')),
        ],
      ),
    );
  }

  /// 退出登录
  Future<void> exitLogin(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return CustomDialog(
            title: '是否确认退出登录？',
            callback: (res) {
              setState(() {
                sp.setString('user_token', '');
                sp.setString("user_account", '');
                sp.setString("user_id", '');
                sp.setString("em_pwd", '');
                sp.setString("em_token", '');
                sp.setString("user_password", '');
                sp.setString('user_phone', '');
                sp.setString('nickname', '');
                sp.setString("user_headimg", '');
                sp.setString("user_headimg_id", '');
                // 保存身份
                sp.setString("user_identity", '');
              });
              MyUtils.signOut();
              Future.delayed(Duration.zero, () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  // ignore: unnecessary_null_comparison
                  (route) => route == null,
                );
              });
            },
            content: '',
          );
        });
  }
}
