import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/colors/my_colors.dart';
import 'package:yuyinting/utils/line_painter.dart';
import 'package:yuyinting/utils/log_util.dart';

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
  var _switchValue = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('设置', true, context, false, 0);
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
            height: ScreenUtil().setHeight(110),
            color: Colors.white,
            padding: const EdgeInsets.only(left: 20, right: 20),
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
              Navigator.pushNamed(context, 'ShimingzhiPage');
            }),
            child: WidgetUtils.onlyTextLeftRightImg(
                '实名制认证',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black, fontSize: ScreenUtil().setSp(29)),
                'assets/images/mine_more.png'),
          ),
          WidgetUtils.commonSizedBox(1, 0),
          GestureDetector(
            onTap: (() {}),
            child: WidgetUtils.onlyTextLeftRightImg(
                '黑名单',
                StyleUtils.getCommonTextStyle(
                    color: Colors.black, fontSize: ScreenUtil().setSp(29)),
                'assets/images/mine_more.png'),
          ),
          WidgetUtils.commonSizedBox(10, 0),
          GestureDetector(
            onTap: ((){
              
            }),
            child: Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(110),
              color: Colors.white,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  WidgetUtils.onlyText(
                      '清除缓存',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black, fontSize: ScreenUtil().setSp(29))),
                  const Expanded(child: Text('')),
                  WidgetUtils.onlyText('0MB', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(25))),
                ],
              ),
            ),
          ),
          WidgetUtils.commonSizedBox(10, 0),
          GestureDetector(
            onTap: ((){

            }),
            child: Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(110),
              color: Colors.white,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Row(
                children: [
                  WidgetUtils.onlyText(
                      '关于',
                      StyleUtils.getCommonTextStyle(
                          color: Colors.black, fontSize: ScreenUtil().setSp(29))),
                  const Expanded(child: Text('')),
                  CustomPaint(
                    painter: LinePainter(colors: Colors.red),
                  ),
                  WidgetUtils.commonSizedBox(0, 10),
                  WidgetUtils.onlyText('1.0.0', StyleUtils.getCommonTextStyle(color: MyColors.g9, fontSize: ScreenUtil().setSp(25))),
                  WidgetUtils.showImages('assets/images/mine_more.png', 15, 20)
                ],
              ),
            ),
          ),
          const Expanded(child: Text('')),
          GestureDetector(
            onTap: ((){

            }),
            child: Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(100),
              color: Colors.white,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: WidgetUtils.onlyTextCenter(
                  '切换账号',
                  StyleUtils.getCommonTextStyle(
                      color: Colors.black, fontSize: ScreenUtil().setSp(29), fontWeight: FontWeight.bold)),
            ),
          ),
          WidgetUtils.commonSizedBox(10, 0),
          GestureDetector(
            onTap: ((){

            }),
            child: Container(
              width: double.infinity,
              height: ScreenUtil().setHeight(100),
              color: Colors.white,
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: WidgetUtils.onlyTextCenter(
                  '退出当前账号',
                  StyleUtils.getCommonTextStyle(
                      color: MyColors.homeTopBG, fontSize: ScreenUtil().setSp(29), fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}
