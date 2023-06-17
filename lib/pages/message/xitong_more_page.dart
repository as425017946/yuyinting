import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../colors/my_colors.dart';
import '../../utils/style_utils.dart';
import '../../utils/widget_utils.dart';
/// 系统消息
class XitongMorePage extends StatefulWidget {
  const XitongMorePage({Key? key}) : super(key: key);

  @override
  State<XitongMorePage> createState() => _XitongMorePageState();
}

class _XitongMorePageState extends State<XitongMorePage> {
  var appBar;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    appBar = WidgetUtils.getAppBar('系统消息', true, context, false,0);
  }

  Widget message(BuildContext context, int i) {
    return GestureDetector(
      onTap: (() {}),
      child: i%2 == 0 ? Container(
        width: double.infinity,
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: [
            WidgetUtils.onlyTextCenter(
                '2023-06-15 10：10：10',
                StyleUtils.getCommonTextStyle(
                    color: MyColors.g9,
                    fontSize: ScreenUtil().setSp(25))),
            Row(
              children: [
                WidgetUtils.CircleHeadImage(
                    ScreenUtil().setHeight(100),
                    ScreenUtil().setWidth(100),
                    'https://img1.baidu.com/it/u=4159158149,2237302473&fm=253&fmt=auto&app=138&f=JPEG?w=800&h=500'),
                WidgetUtils.commonSizedBox(0, 10),
                WidgetUtils.onlyTextCenter(
                    '系统消息',
                    StyleUtils.getCommonTextStyle(
                        color: Colors.black,
                        fontSize: ScreenUtil().setSp(29))),
              ],
            ),
            Container(
              height: ScreenUtil().setHeight(110),
              width: double.infinity,
              margin: const EdgeInsets.only(top: 10,),
              padding: const EdgeInsets.only(left: 20, right: 20),
              //边框设置
              decoration: const BoxDecoration(
                //背景
                color: MyColors.messagePurple,
                //设置四周圆角 角度 这里的角度应该为 父Container height 的一半
                borderRadius: BorderRadius.all(Radius.circular(13.0)),
              ),
              child: WidgetUtils.onlyText('消息内容', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(29))),
            ),
            WidgetUtils.commonSizedBox(20, 0),
          ],
        ),
      )
      : Column(
        children: [
          WidgetUtils.onlyTextCenter(
            '2023-06-15 10：10：10',
            StyleUtils.getCommonTextStyle(
                color: MyColors.g9,
                fontSize: ScreenUtil().setSp(25))),
          WidgetUtils.commonSizedBox(20, 0),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
            padding: const EdgeInsets.all(10),
            color: Colors.white,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    WidgetUtils.showImagesNet('https://img-blog.csdnimg.cn/3d809148c83f4720b5e2a6567f816d89.jpeg', ScreenUtil().setHeight(330), double.infinity),
                    Container(
                      width: double.infinity,
                      height: ScreenUtil().setHeight(90),
                      padding: const EdgeInsets.only(left: 10),
                      color: Colors.black45,
                      child: WidgetUtils.onlyText('标题信息信息', StyleUtils.getCommonTextStyle(color: Colors.white, fontSize: ScreenUtil().setSp(29))),
                    )
                  ],
                ),
                WidgetUtils.commonSizedBox(10, 0),
                WidgetUtils.onlyText('内容信息信息信息', StyleUtils.getCommonTextStyle(color: MyColors.g6, fontSize: ScreenUtil().setSp(29)))
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      backgroundColor: MyColors.homeBG,
      body: ListView.builder(
        itemBuilder: message,
        itemCount: 15,
      ),
    );
  }
}
