import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yuyinting/utils/style_utils.dart';

import '../../../colors/my_colors.dart';
import '../../../utils/widget_utils.dart';
/// 注销账号
class ZhuxiaoPage extends StatefulWidget {
  const ZhuxiaoPage({Key? key}) : super(key: key);

  @override
  State<ZhuxiaoPage> createState() => _ZhuxiaoPageState();
}

class _ZhuxiaoPageState extends State<ZhuxiaoPage> {
  var appBar;
  bool gz = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('注销账户', true, context, false, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            WidgetUtils.commonSizedBox(10, 0),
            Row(
              children: [
                const Expanded(child: Text('')),
                WidgetUtils.showImages('assets/images/zhuxiao.jpg', ScreenUtil().setHeight(150), ScreenUtil().setHeight(200)),
                const Expanded(child: Text('')),
              ],
            ),
            WidgetUtils.commonSizedBox(10, 0),
            WidgetUtils.onlyText('对于您将要注销账号的决定，我们感到非常遗憾。', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(30))),
            WidgetUtils.onlyText('在进行注销前，您需要了解一下重要信息：', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(30))),
            WidgetUtils.commonSizedBox(10, 0),
            WidgetUtils.onlyText('1.注销账号后，当前账号将自动退出登录。', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(30))),
            WidgetUtils.onlyText('2.账号中的信息将无法进行恢复，包括但不限于：', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(30))),
            WidgetUtils.onlyText('·账号的个人资料和历史信息（如实名制认证信息、', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(30))),
            WidgetUtils.onlyText('关注信息、收藏信息、账单、礼物墙等）', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(30))),
            WidgetUtils.onlyText('·账号内所有资产，包括豆、币、各类收益、道具卡、等级、装扮等', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(30))),
            WidgetUtils.onlyText('·自主发布的内容，包括动态、点赞等', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(30))),
            WidgetUtils.onlyText('·账号绑定的手机号以及所有第三方账号将被解绑', StyleUtils.getCommonTextStyle(color: Colors.black, fontSize: ScreenUtil().setSp(30))),
            const Expanded(child: Text('')),
            GestureDetector(
              onTap: ((){
                setState(() {
                  gz = !gz;
                });
              }),
              child: Row(
                children: [
                  const Expanded(child: Text('')),
                  WidgetUtils.showImages( gz == false ? 'assets/images/trends_r1.png' : 'assets/images/trends_r2.png', 15, 15),
                  WidgetUtils.commonSizedBox(0, 10),
                  const Text('我已阅读并同意以上信息',style: TextStyle(fontSize: 13,color: MyColors.g9, ),),
                  const Expanded(child: Text('')),
                ],
              ),
            ),
            WidgetUtils.commonSizedBox(10, 0),
            GestureDetector(
              onTap: (() {
              }),
              child: WidgetUtils.myContainer(ScreenUtil().setHeight(80), double.infinity, MyColors.homeTopBG, MyColors.homeTopBG, '我再想想', ScreenUtil().setSp(33), Colors.white),
            ),
            WidgetUtils.commonSizedBox(10, 0),
            GestureDetector(
              onTap: (() {
              }),
              child: WidgetUtils.myContainer(ScreenUtil().setHeight(80), double.infinity, MyColors.d8, MyColors.f7, '确认注销', ScreenUtil().setSp(33), MyColors.homeTopBG),
            ),
          ],
        ),
      ),
    );
  }
}
